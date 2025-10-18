/**  exam-monitor.js
   Exposes initExam(options) to start monitoring on quiz page.
   Options: {courseId, level, durationSeconds, maxTabSwitches, formId, modelsUri}

async function loadModels() {
    await faceapi.nets.tinyFaceDetector.loadFromUri('models/');
    await faceapi.nets.ssdMobilenetv1.loadFromUri('models/');
    console.log("Models loaded");
}
loadModels();


window.initExam = async function(options) {
  const { courseId, level, durationSeconds = 300, maxTabSwitches = 3, formId, modelsUri } = options;

  // UI elements (create minimal UI if not present)
  let video = document.getElementById('monitorVideo');
  if (!video) {
    video = document.createElement('video');
    video.id = 'monitorVideo';
    video.autoplay = true;
    video.muted = true;
    video.playsInline = true;
    video.style.width = '160px';
    video.style.height = '120px';
    video.style.position = 'fixed';
    video.style.right = '10px';
    video.style.top = '10px';
    video.style.zIndex = '9999';
    document.body.appendChild(video);
  }

  const timerEl = document.getElementById('examTimer') || (() => { const s = document.createElement('div'); s.id='examTimer'; s.style.position='fixed'; s.style.left='10px'; s.style.top='10px'; s.style.zIndex='9999'; s.style.padding='6px 8px'; s.style.background='rgba(0,0,0,0.6)'; s.style.color='white'; document.body.appendChild(s); return s; })();
  const warningEl = document.getElementById('examWarning') || (() => { const w = document.createElement('div'); w.id='examWarning'; w.style.position='fixed'; w.style.left='50%'; w.style.top='50%'; w.style.transform='translate(-50%,-50%)'; w.style.zIndex='10000'; w.style.padding='12px 18px'; w.style.background='rgba(255,255,0,0.95)'; w.style.color='#000'; w.style.display='none'; document.body.appendChild(w); return w; })();

  // helper to show warnings
  function showWarning(text, timeout = 3000) {
    warningEl.innerText = text;
    warningEl.style.display = 'block';
    clearTimeout(warningEl._t);
    warningEl._t = setTimeout(() => { warningEl.style.display = 'none'; }, timeout);
  }
  // ---- add this inside initExam, after 'let running = true;' or near top of function ----
  function updateFormTabSwitch() {
    try {
      const f = document.getElementById(formId);
      if (!f) return;
      let inp = f.querySelector('input[name="tab_switches"]');
      if (!inp) {
        inp = document.createElement('input');
        inp.type = 'hidden';
        inp.name = 'tab_switches';
        inp.value = '0';
        f.appendChild(inp);
      }
      inp.value = tabSwitches;
    } catch (e) {
      // ignore
    }
  }

  // require fullscreen first
  async function ensureFullscreen() {
    if (!document.fullscreenElement) {
      try {
        await document.documentElement.requestFullscreen();
      } catch (e) {
        throw new Error('Fullscreen required to start quiz. Please allow fullscreen.');
      }
    }
  }

  // get camera permission and stream
  let stream;
  try {
    stream = await navigator.mediaDevices.getUserMedia({ video: { facingMode: 'user' }, audio: false });
  } catch (e) {
    throw new Error('Camera permission is required. Please allow camera access to continue.');
  }

  // attach stream to video
  video.srcObject = stream;
  await video.play();

  // load face-api models (modelsUri must point to the folder with model files)
  if (!window.faceapi) throw new Error('face-api.js not loaded. Include it in your JSP via CDN or local file.');
  await Promise.all([
    faceapi.nets.tinyFaceDetector.loadFromUri(modelsUri),
    faceapi.nets.ssdMobilenetv1.loadFromUri(modelsUri) // optional heavier detector
  ]);

  // load coco-ssd model (optional but recommended for phone/screen detection)
  let cocoModel = null;
  if (window.cocoSsd) {
    try { cocoModel = await cocoSsd.load(); } catch (e) { console.warn('coco-ssd load failed', e); }
  }

  // still require fullscreen at this point
  try {
    await ensureFullscreen();
  } catch (e) {
    // show message to user and stop
    alert(e.message);
    stream.getTracks().forEach(t => t.stop());
    return;
  }

  // monitoring variables
  let violations = 0;
  let tabSwitches = 0;
  let running = true;

  // visibility / blur / fullscreenchange handlers
  function handleVisibility() {
    if (document.hidden) {
		updateFormTabSwitch();
      tabSwitches++;
      showWarning('Tab switched / page hidden — this counts as a violation (' + tabSwitches + '/' + maxTabSwitches + ')');
      checkMax();
    }
  }
  document.addEventListener('visibilitychange', handleVisibility);

  window.addEventListener('blur', () => {
    tabSwitches++;
    showWarning('Window lost focus — counts as violation (' + tabSwitches + '/' + maxTabSwitches + ')');
    checkMax();
  });

  document.addEventListener('fullscreenchange', () => {
    if (!document.fullscreenElement) {
      tabSwitches++;
      showWarning('Exited fullscreen — counts as violation (' + tabSwitches + '/' + maxTabSwitches + ')');
      checkMax();
    }
  });

  function checkMax() {
    if (tabSwitches >= maxTabSwitches) {
      showWarning('Maximum violations reached — quiz will be auto-submitted', 5000);
      setTimeout(autoSubmit, 1200);
    }
  }

  // timer
  let remaining = durationSeconds;
  timerEl.innerText = formatTime(remaining);
  const timerInterval = setInterval(() => {
    remaining -= 1;
    if (remaining <= 0) {
      timerEl.innerText = '00:00';
      clearInterval(timerInterval);
      autoSubmit();
    } else {
      timerEl.innerText = formatTime(remaining);
    }
  }, 1000);

  function formatTime(s) {
    const m = Math.floor(s/60).toString().padStart(2,'0');
    const sec = (s%60).toString().padStart(2,'0');
    return m + ':' + sec;
  }

  // detection loop
  const detectionIntervalMs = 1000; // check every second
  const detectionLoop = setInterval(async () => {
    if (!running) return;

    // face detection
    let faces = [];
    try {
      faces = await faceapi.detectAllFaces(video, new faceapi.TinyFaceDetectorOptions());
    } catch (e) { console.warn('face-api error', e); }

    if (faces.length !== 1) {
      violations++;
      if (faces.length === 0) showWarning('No face detected — violation: ' + violations);
      else showWarning('Multiple faces detected (' + faces.length + ') — violation: ' + violations);
      tabSwitches++;
      checkMax();
    }

    // object detection (phone / screen -> treat as tab switch)
    if (cocoModel) {
      try {
        const objs = await cocoModel.detect(video);
        const suspicious = objs.filter(o => ['cell phone', 'tv', 'laptop', 'remote'].includes(o.class));
        if (suspicious.length > 0) {
          tabSwitches++;
          showWarning('Detected suspicious object: ' + suspicious.map(s=>s.class).join(', ') + ' — counts as violation (' + tabSwitches + '/' + maxTabSwitches + ')');
          checkMax();
        }
      } catch (e) { console.warn('coco error', e); }
    }

  }, detectionIntervalMs);

  // auto-submit function
  function autoSubmit() {
    running = false;
    // cleanup
    clearInterval(detectionLoop);
    clearInterval(timerInterval);
    document.removeEventListener('visibilitychange', handleVisibility);

    try {
      stream.getTracks().forEach(t => t.stop());
    } catch (e) {}

    // Submit the quiz form (formId)
    const form = document.getElementById(formId);
    if (form) {
      // add a hidden field to mark auto-submitted because of violations
      let h = document.createElement('input');
      h.type = 'hidden'; h.name = 'autoSubmitted'; h.value = 'true';
      form.appendChild(h);
      form.submit();
    } else {
      // fallback: POST to SubmitQuizServlet
      fetch('SubmitQuizServlet?courseId=' + encodeURIComponent(courseId) + '&level=' + encodeURIComponent(level), { method: 'POST' })
        .then(()=> { window.location.href = 'mycourses.jsp'; })
        .catch(()=> { window.location.href = 'mycourses.jsp'; });
    }
  }

  // Safety: in case the browser doesn't allow auto-submit, provide a visible button
  const leaveBtn = document.getElementById('forceSubmitBtn');
  if (leaveBtn) {
    leaveBtn.addEventListener('click', () => { autoSubmit(); });
  }

  // public info (optionally returned to caller)
  return {
    stop: () => { running = false; clearInterval(detectionLoop); stream.getTracks().forEach(t => t.stop()); }
  };
};/**
 * 
 */




/* exam-monitor.js
   Exposes initExam(options) to start monitoring on quiz page.
   Options: {courseId, level, durationSeconds, maxTabSwitches, formId, modelsUri}
   <head>
       ...
       <!-- Load face-api.js first -->
       <script defer src="https://cdn.jsdelivr.net/npm/face-api.js@0.22.2/dist/face-api.min.js"></script>
       <!-- Load your monitoring code -->
       <script defer src="exam-monitor.js"></script>
   </head>
   <body>
      ...
      <button id="startQuizBtn">Start Quiz</button>

      <script>
         document.getElementById("startQuizBtn").addEventListener("click", async () => {
             await initExam(); // now defined
         });
      </script>
   </body>

*//*
window.initExam = async function (options) {
  const { courseId, level, durationSeconds = 300, maxTabSwitches = 3, formId, modelsUri } = options;

  // ensure face-api is loaded
  if (!window.faceapi) {
    alert("face-api.js not loaded. Please include via CDN in quiz.jsp");
    return;
  }

  // require fullscreen first (must be triggered by button click!)
  async function ensureFullscreen() {
    if (!document.fullscreenElement) {
      try {
        await document.documentElement.requestFullscreen();
      } catch (e) {
        alert("Fullscreen required to start quiz. Please allow fullscreen.");
        throw e;
      }
    }
  }

  // ---- UI Setup ----
  let video = document.getElementById("monitorVideo");
  if (!video) {
    video = document.createElement("video");
    video.id = "monitorVideo";
    video.autoplay = true;
    video.muted = true;
    video.playsInline = true;
    video.style.width = "160px";
    video.style.height = "120px";
    video.style.position = "fixed";
    video.style.right = "10px";
    video.style.top = "10px";
    video.style.zIndex = "9999";
    document.body.appendChild(video);
  }

  const timerEl =
    document.getElementById("examTimer") ||
    (() => {
      const s = document.createElement("div");
      s.id = "examTimer";
      s.style.position = "fixed";
      s.style.left = "10px";
      s.style.top = "10px";
      s.style.zIndex = "9999";
      s.style.padding = "6px 8px";
      s.style.background = "rgba(0,0,0,0.6)";
      s.style.color = "white";
      document.body.appendChild(s);
      return s;
    })();

  const warningEl =
    document.getElementById("examWarning") ||
    (() => {
      const w = document.createElement("div");
      w.id = "examWarning";
      w.style.position = "fixed";
      w.style.left = "50%";
      w.style.top = "50%";
      w.style.transform = "translate(-50%,-50%)";
      w.style.zIndex = "10000";
      w.style.padding = "12px 18px";
      w.style.background = "rgba(255,255,0,0.95)";
      w.style.color = "#000";
      w.style.display = "none";
      document.body.appendChild(w);
      return w;
    })();

  function showWarning(text, timeout = 3000) {
    warningEl.innerText = text;
    warningEl.style.display = "block";
    clearTimeout(warningEl._t);
    warningEl._t = setTimeout(() => {
      warningEl.style.display = "none";
    }, timeout);
  }

  // ---- Camera Permission ----
  let stream;
  try {
    stream = await navigator.mediaDevices.getUserMedia({ video: { facingMode: "user" }, audio: false });
  } catch (e) {
    alert("Camera permission required to start quiz!");
    return;
  }
  video.srcObject = stream;
  await video.play();

  // ---- Load Models ----
  await Promise.all([
    faceapi.nets.tinyFaceDetector.loadFromUri(modelsUri),
    faceapi.nets.ssdMobilenetv1.loadFromUri(modelsUri),
  ]);

  // ---- Fullscreen Enforcement ----
  await ensureFullscreen();

  // ---- Monitoring Variables ----
  let tabSwitches = 0;
  let running = true;

  function checkMax() {
    if (tabSwitches >= maxTabSwitches) {
      showWarning("🚨 Max violations reached. Quiz will be auto-submitted.", 4000);
      setTimeout(autoSubmit, 1200);
    }
  }

  document.addEventListener("visibilitychange", () => {
    if (document.hidden) {
      tabSwitches++;
      showWarning(`Tab switched (${tabSwitches}/${maxTabSwitches})`);
      checkMax();
    }
  });

  window.addEventListener("blur", () => {
    tabSwitches++;
    showWarning(`Window lost focus (${tabSwitches}/${maxTabSwitches})`);
    checkMax();
  });

  document.addEventListener("fullscreenchange", () => {
    if (!document.fullscreenElement) {
      tabSwitches++;
      showWarning(`Exited fullscreen (${tabSwitches}/${maxTabSwitches})`);
      checkMax();
    }
  });

  // ---- Timer ----
  let remaining = durationSeconds;
  timerEl.innerText = formatTime(remaining);
  const timerInterval = setInterval(() => {
    remaining -= 1;
    if (remaining <= 0) {
      clearInterval(timerInterval);
      autoSubmit();
    } else {
      timerEl.innerText = formatTime(remaining);
    }
  }, 1000);

  function formatTime(s) {
    const m = Math.floor(s / 60).toString().padStart(2, "0");
    const sec = (s % 60).toString().padStart(2, "0");
    return m + ":" + sec;
  }

  // ---- Face Detection Loop ----
  setInterval(async () => {
    if (!running) return;

    let faces = [];
    try {
      faces = await faceapi.detectAllFaces(video, new faceapi.TinyFaceDetectorOptions());
    } catch (e) {
      console.warn("face-api error", e);
    }

    if (faces.length !== 1) {
      tabSwitches++;
      if (faces.length === 0) {
        showWarning("⚠️ No face detected");
      } else {
        showWarning("⚠️ Multiple faces detected");
      }
      checkMax();
    }
  }, 1000);

  // ---- Auto-Submit ----
  function autoSubmit() {
    running = false;
    try {
      stream.getTracks().forEach((t) => t.stop());
    } catch (e) {}
    const form = document.getElementById(formId);
    if (form) {
      form.submit();
    } else {
      window.location.href = "mycourses.jsp";
    }
  }
};  */



/*  thursday now changing*/
// exam-monitor.js
// Exposes window.initExam(options) which returns a controller { stop() }

// exam-monitor.js
// Exposes window.initExam(options) which returns a controller { stop() }
/** *
window.initExam = async function (options) {
  const { courseId, level, durationSeconds = 300, maxTabSwitches = 3, formId, modelsUri } = options;

  // wait for face-api to be available (face-api.js loaded via <script defer>)
  let waited = 0;
  while (!window.faceapi && waited < 5000) {
    await new Promise(r => setTimeout(r, 100));
    waited += 100;
  }
  if (!window.faceapi) throw new Error("face-api.js not available in page. Ensure script loaded before exam-monitor.js");

  // ---- UI Setup ----
  let video = document.getElementById("monitorVideo");
  if (!video) {
    video = document.createElement("video");
    video.id = "monitorVideo";
    video.autoplay = true;
    video.muted = true;
    video.playsInline = true;
    video.style.width = "160px";
    video.style.height = "120px";
    video.style.position = "fixed";
    video.style.right = "10px";
    video.style.top = "10px";
    video.style.zIndex = "9999";
    document.body.appendChild(video);
  }

  const timerEl =
    document.getElementById("examTimer") ||
    (() => {
      const s = document.createElement("div");
      s.id = "examTimer";
      s.style.position = "fixed";
      s.style.left = "10px";
      s.style.top = "10px";
      s.style.zIndex = "9999";
      s.style.padding = "6px 8px";
      s.style.background = "rgba(0,0,0,0.6)";
      s.style.color = "white";
      document.body.appendChild(s);
      return s;
    })();

  const warningEl =
    document.getElementById("examWarning") ||
    (() => {
      const w = document.createElement("div");
      w.id = "examWarning";
      w.style.position = "fixed";
      w.style.left = "50%";
      w.style.top = "50%";
      w.style.transform = "translate(-50%,-50%)";
      w.style.zIndex = "10000";
      w.style.padding = "12px 18px";
      w.style.background = "rgba(255,255,0,0.95)";
      w.style.color = "#000";
      w.style.display = "none";
      document.body.appendChild(w);
      return w;
    })();

  function showWarning(text, timeout = 3000) {
    warningEl.innerText = text;
    warningEl.style.display = "block";
    clearTimeout(warningEl._t);
    warningEl._t = setTimeout(() => {
      warningEl.style.display = "none";
    }, timeout);
  }

  // ---- Camera Permission ----
  let stream;
  try {
    stream = await navigator.mediaDevices.getUserMedia({ video: { facingMode: "user" }, audio: false });
  } catch (e) {
    throw new Error("Camera permission required to start quiz!");
  }
  video.srcObject = stream;
  await video.play();

  // ---- Load Models (from provided modelsUri) ----
  try {
    await Promise.all([
      faceapi.nets.tinyFaceDetector.loadFromUri(modelsUri),
      faceapi.nets.ssdMobilenetv1.loadFromUri(modelsUri),
    ]);
  } catch (e) {
    console.warn("Model loading failed", e);
    throw new Error("Failed to load face-api models. Check models path: " + modelsUri);
  }

  // ---- Monitoring Variables ----
  let tabSwitches = 0;
  let running = true;

  function checkMax() {
    if (tabSwitches >= maxTabSwitches) {
      showWarning("🚨 Max violations reached. Quiz will be auto-submitted.", 4000);
      setTimeout(autoSubmit, 1200);
    }
  }

  document.addEventListener("visibilitychange", () => {
    if (!running) return;
    if (document.hidden) {
      tabSwitches++;
      showWarning(`Tab switched (${tabSwitches}/${maxTabSwitches})`);
      checkMax();
    }
  });

  window.addEventListener("blur", () => {
    if (!running) return;
    tabSwitches++;
    showWarning(`Window lost focus (${tabSwitches}/${maxTabSwitches})`);
    checkMax();
  });

  document.addEventListener("fullscreenchange", () => {
    if (!running) return;
    if (!document.fullscreenElement) {
      tabSwitches++;
      showWarning(`Exited fullscreen (${tabSwitches}/${maxTabSwitches})`);
      checkMax();
    }
  });

  // ---- Timer ----
  let remaining = durationSeconds;
  timerEl.innerText = formatTime(remaining);
  const timerInterval = setInterval(() => {
    if (!running) return;
    remaining -= 1;
    if (remaining <= 0) {
      clearInterval(timerInterval);
      autoSubmit();
    } else {
      timerEl.innerText = formatTime(remaining);
    }
  }, 1000);

  function formatTime(s) {
    const m = Math.floor(s / 60).toString().padStart(2, "0");
    const sec = (s % 60).toString().padStart(2, "0");
    return m + ":" + sec;
  }

  // ---- Face Detection Loop ----
  const faceInterval = setInterval(async () => {
    if (!running) return;

    let faces = [];
    try {
      faces = await faceapi.detectAllFaces(video, new faceapi.TinyFaceDetectorOptions());
    } catch (e) {
      console.warn("face-api error", e);
      return;
    }

    if (faces.length !== 1) {
      tabSwitches++;
      if (faces.length === 0) {
        showWarning("⚠️ No face detected");
      } else {
        showWarning("⚠️ Multiple faces detected");
      }
      checkMax();
    }
  }, 1000);

  // ---- Auto-Submit ----
  function autoSubmit() {
    if (!running) return;
    running = false;
    try {
      stream.getTracks().forEach((t) => t.stop());
    } catch (e) {}
    clearInterval(faceInterval);
    clearInterval(timerInterval);

    const form = document.getElementById(formId);
    if (form) {
      // append hidden info about tabSwitches
      const inp = document.createElement('input');
      inp.type = 'hidden';
      inp.name = 'tab_switches';
      inp.value = tabSwitches;
      form.appendChild(inp);
      form.submit();
    } else {
      window.location.href = 'MyCoursesServlet';
    }
  }

  // Return controller to caller
  return {
    stop: function() {
      running = false;
      try { stream.getTracks().forEach(t => t.stop()); } catch(e){}
      clearInterval(faceInterval);
      clearInterval(timerInterval);
    }
  };
};
*/
// exam-monitor.js
// Exposes initExam(options) to start monitoring on quiz page
// Options: {courseId, level, durationSeconds, maxTabSwitches, formId, modelsUri}


/**   14.9.25  
window.initExam = async function(options) {
  const { courseId, level, durationSeconds = 300, maxTabSwitches = 3, formId, modelsUri } = options;

  // Wait for face-api.js to be loaded
  let waited = 0;
  while (!window.faceapi && waited < 5000) {
    await new Promise(r => setTimeout(r, 100));
    waited += 100;
  }
  if (!window.faceapi) throw new Error("face-api.js not loaded. Include script before exam-monitor.js");

  // ---- UI Setup ----
  let video = document.getElementById("monitorVideo");
  if (!video) {
    video = document.createElement("video");
    video.id = "monitorVideo";
    video.autoplay = true;
    video.muted = true;
    video.playsInline = true;
    video.style.width = "160px";
    video.style.height = "120px";
    video.style.position = "fixed";
    video.style.right = "10px";
    video.style.top = "10px";
    video.style.zIndex = "9999";
    document.body.appendChild(video);
  }

  const timerEl =
    document.getElementById("examTimer") ||
    (() => {
      const s = document.createElement("div");
      s.id = "examTimer";
      s.style.position = "fixed";
      s.style.left = "10px";
      s.style.top = "10px";
      s.style.zIndex = "9999";
      s.style.padding = "6px 8px";
      s.style.background = "rgba(0,0,0,0.6)";
      s.style.color = "white";
      document.body.appendChild(s);
      return s;
    })();

  const warningEl =
    document.getElementById("examWarning") ||
    (() => {
      const w = document.createElement("div");
      w.id = "examWarning";
      w.style.position = "fixed";
      w.style.left = "50%";
      w.style.top = "50%";
      w.style.transform = "translate(-50%,-50%)";
      w.style.zIndex = "10000";
      w.style.padding = "12px 18px";
      w.style.background = "rgba(255,255,0,0.95)";
      w.style.color = "#000";
      w.style.display = "none";
      document.body.appendChild(w);
      return w;
    })();

  function showWarning(text, timeout = 3000) {
    warningEl.innerText = text;
    warningEl.style.display = "block";
    clearTimeout(warningEl._t);
    warningEl._t = setTimeout(() => {
      warningEl.style.display = "none";
    }, timeout);
  }

  // ---- Camera Permission ----
  let stream;
  try {
    stream = await navigator.mediaDevices.getUserMedia({ video: { facingMode: "user" }, audio: false });
  } catch (e) {
    throw new Error("Camera permission required to start quiz!");
  }
  video.srcObject = stream;
  await video.play();

  // ---- Load Models ----
  try {
    await Promise.all([
      faceapi.nets.tinyFaceDetector.loadFromUri(modelsUri),
      faceapi.nets.ssdMobilenetv1.loadFromUri(modelsUri),
    ]);
  } catch (e) {
    console.warn("Model loading failed", e);
    throw new Error("Failed to load face-api models. Check models path: " + modelsUri);
  }

  // ---- Monitoring Variables ----
  let tabSwitches = 0;
  let running = true;

  function checkMax() {
    if (tabSwitches >= maxTabSwitches) {
      showWarning("🚨 Max violations reached. Quiz will be auto-submitted.", 4000);
      setTimeout(autoSubmit, 1200);
    }
  }

  document.addEventListener("visibilitychange", () => {
    if (!running) return;
    if (document.hidden) {
      tabSwitches++;
      showWarning(`Tab switched (${tabSwitches}/${maxTabSwitches})`);
      checkMax();
    }
  });

  window.addEventListener("blur", () => {
    if (!running) return;
    tabSwitches++;
    showWarning(`Window lost focus (${tabSwitches}/${maxTabSwitches})`);
    checkMax();
  });

  document.addEventListener("fullscreenchange", () => {
    if (!running) return;
    if (!document.fullscreenElement) {
      tabSwitches++;
      showWarning(`Exited fullscreen (${tabSwitches}/${maxTabSwitches})`);
      checkMax();
    }
  });

  // ---- Timer ----
  let remaining = durationSeconds;
  timerEl.innerText = formatTime(remaining);
  const timerInterval = setInterval(() => {
    if (!running) return;
    remaining--;
    if (remaining <= 0) {
      clearInterval(timerInterval);
      autoSubmit();
    } else {
      timerEl.innerText = formatTime(remaining);
    }
  }, 1000);

  function formatTime(s) {
    const m = Math.floor(s / 60).toString().padStart(2, "0");
    const sec = (s % 60).toString().padStart(2, "0");
    return m + ":" + sec;
  }

  // ---- Face Detection Loop ----
  const faceInterval = setInterval(async () => {
    if (!running) return;
    if (!video || video.readyState !== 4) return;

    let faces = [];
    try {
      faces = await faceapi.detectAllFaces(video, new faceapi.TinyFaceDetectorOptions());
    } catch (e) {
      console.warn("face-api error", e);
      return;
    }

    if (faces.length !== 1) {
      tabSwitches++;
      showWarning(faces.length === 0 ? "⚠️ No face detected" : "⚠️ Multiple faces detected");
      checkMax();
    }
  }, 1000);

  // ---- Auto-Submit ----
  function autoSubmit() {
    if (!running) return;
    running = false;
    try { stream.getTracks().forEach(t => t.stop()); } catch (e) {}
    clearInterval(faceInterval);
    clearInterval(timerInterval);

    const form = document.getElementById(formId);
    if (form) {
      const inp = document.createElement('input');
      inp.type = 'hidden';
      inp.name = 'tab_switches';
      inp.value = tabSwitches;
      form.appendChild(inp);
      form.submit();
    } else {
      window.location.href = 'MyCoursesServlet';
    }
  }

  return {
    stop: function() {
      running = false;
      try { stream.getTracks().forEach(t => t.stop()); } catch(e){}
      clearInterval(faceInterval);
      clearInterval(timerInterval);
    }
  };
};
  */  /*  updating to auto submit if three violations are there okay  its giving the warning but not returning to full screen */
/*window.initExam = async function (options) {
  const { courseId, level, durationSeconds = 300, maxTabSwitches = 3, formId, modelsUri } = options;

  // ---- Wait for face-api.js ----
  let waited = 0;
  while (!window.faceapi && waited < 5000) {
    await new Promise(r => setTimeout(r, 100));
    waited += 100;
  }
  if (!window.faceapi) throw new Error("face-api.js not loaded. Include script before exam-monitor.js");

  // ---- UI Setup ----
  let video = document.getElementById("monitorVideo");
  if (!video) {
    video = document.createElement("video");
    video.id = "monitorVideo";
    video.autoplay = true;
    video.muted = true;
    video.playsInline = true;
    video.style.width = "160px";
    video.style.height = "120px";
    video.style.position = "fixed";
    video.style.right = "10px";
    video.style.top = "10px";
    video.style.zIndex = "9999";
    document.body.appendChild(video);
  }

  const timerEl =
    document.getElementById("examTimer") ||
    (() => {
      const s = document.createElement("div");
      s.id = "examTimer";
      s.style.position = "fixed";
      s.style.left = "10px";
      s.style.top = "10px";
      s.style.zIndex = "9999";
      s.style.padding = "6px 8px";
      s.style.background = "rgba(0,0,0,0.6)";
      s.style.color = "white";
      document.body.appendChild(s);
      return s;
    })();

  const warningEl =
    document.getElementById("examWarning") ||
    (() => {
      const w = document.createElement("div");
      w.id = "examWarning";
      w.style.position = "fixed";
      w.style.left = "50%";
      w.style.top = "50%";
      w.style.transform = "translate(-50%,-50%)";
      w.style.zIndex = "10000";
      w.style.padding = "12px 18px";
      w.style.background = "rgba(255,255,0,0.95)";
      w.style.color = "#000";
      w.style.display = "none";
      document.body.appendChild(w);
      return w;
    })();

  function showWarning(text, timeout = 3000) {
    console.warn("[VIOLATION]", text); // ✅ log to console
    warningEl.innerText = text;
    warningEl.style.display = "block";
    clearTimeout(warningEl._t);
    warningEl._t = setTimeout(() => {
      warningEl.style.display = "none";
    }, timeout);
  }

  // ---- Camera Permission ----
  let stream;
  try {
    stream = await navigator.mediaDevices.getUserMedia({ video: { facingMode: "user" }, audio: false });
  } catch (e) {
    throw new Error("Camera permission required to start quiz!");
  }
  video.srcObject = stream;
  await video.play();

  // ---- Load Models ----
  try {
    await Promise.all([
      faceapi.nets.tinyFaceDetector.loadFromUri(modelsUri),
      faceapi.nets.ssdMobilenetv1.loadFromUri(modelsUri),
    ]);
  } catch (e) {
    console.warn("Model loading failed", e);
    throw new Error("Failed to load face-api models. Check models path: " + modelsUri);
  }

  // ---- Monitoring Variables ----
  let tabSwitches = 0;
  let running = true;

  function checkMax() {
    if (tabSwitches >= maxTabSwitches) {
      showWarning("🚨 Max violations reached. Quiz will be auto-submitted.", 4000);
      setTimeout(autoSubmit, 1200);
    }
  }

  document.addEventListener("visibilitychange", () => {
    if (!running) return;
    if (document.hidden) {
      tabSwitches++;
      showWarning(`Tab switched (${tabSwitches}/${maxTabSwitches})`);
      checkMax();
    }
  });

  window.addEventListener("blur", () => {
    if (!running) return;
    tabSwitches++;
    showWarning(`Window lost focus (${tabSwitches}/${maxTabSwitches})`);
    checkMax();
  });

  document.addEventListener("fullscreenchange", () => {
    if (!running) return;

    if (!document.fullscreenElement) {
      tabSwitches++;
      console.log(`Violation #${tabSwitches}: Exited fullscreen`);
      showWarning(`⚠️ Exited fullscreen (${tabSwitches}/${maxTabSwitches})`);

      // Force back into fullscreen automatically
      setTimeout(() => {
        if (!document.fullscreenElement) {
          document.documentElement.requestFullscreen()
            .then(() => {
              console.log("✅ Returned to fullscreen mode");
            })
            .catch(err => {
              console.warn("⚠️ Could not re-enter fullscreen:", err);
              showWarning("Please return to fullscreen to continue the quiz!");
            });
        }
      }, 300); // short delay to avoid conflict
      checkMax();
    }
  });

  document.addEventListener("fullscreenchange", () => {
    if (!running) return;
    if (!document.fullscreenElement) {
      tabSwitches++;
      showWarning(`Exited fullscreen (${tabSwitches}/${maxTabSwitches})`);
      checkMax();
    }
  });

  // ---- Timer ----
  let remaining = durationSeconds;
  timerEl.innerText = formatTime(remaining);
  const timerInterval = setInterval(() => {
    if (!running) return;
    remaining--;
    if (remaining <= 0) {
      clearInterval(timerInterval);
      autoSubmit();
    } else {
      timerEl.innerText = formatTime(remaining);
    }
  }, 1000);

  function formatTime(s) {
    const m = Math.floor(s / 60).toString().padStart(2, "0");
    const sec = (s % 60).toString().padStart(2, "0");
    return m + ":" + sec;
  }

  // ---- Face Detection Loop ----
  // ---- Face Detection Loop ----
   faceInterval = setInterval(async () => {
    if (!running) return;
    if (!video || video.readyState !== 4) return;

    let faces = [];
    try {
      faces = await faceapi.detectAllFaces(
        video,
        new faceapi.TinyFaceDetectorOptions({ inputSize: 224, scoreThreshold: 0.5 })
      );
    } catch (e) {
      console.warn("face-api error", e);
      return;
    }

    if (faces.length === 0) {
      console.log("⚠️ No face detected");
      showWarning("⚠️ No face detected");
      // ❌ If you want this to be a violation, uncomment:
      // tabSwitches++;
      // checkMax();
    } else if (faces.length > 1) {
      tabSwitches++;
      console.log(`Violation #${tabSwitches}: Multiple faces detected`);
      showWarning("⚠️ Multiple faces detected");
      checkMax();
    }
  }, 1000);

  
   faceInterval = setInterval(async () => {
    if (!running) return;
    if (!video || video.readyState !== 4) return;

    let faces = [];
    try {
      faces = await faceapi.detectAllFaces(
        video,
        new faceapi.TinyFaceDetectorOptions({ inputSize: 224, scoreThreshold: 0.5 })
      );
    } catch (e) {
      console.warn("face-api error", e);
      return;
    }

    if (faces.length > 1) {
      tabSwitches++;
      console.log(`Violation #${tabSwitches}: Multiple faces detected`);
      showWarning("⚠️ Multiple faces detected");
      checkMax();
    }
    // ✅ No face = allowed (ignore)
  }, 1000);

  
  
  
  const faceInterval = setInterval(async () => {
    if (!running) return;
    if (!video || video.readyState !== 4) return;

    let faces = [];
    try {
      faces = await faceapi.detectAllFaces(video, new faceapi.TinyFaceDetectorOptions());
    } catch (e) {
      console.warn("face-api error", e);
      return;
    }

    if (faces.length !== 1) {
      tabSwitches++;
      if (faces.length === 0) {
        showWarning("⚠️ No face detected");
      } else {
        showWarning("⚠️ Multiple faces detected");
      }
      checkMax();
    }
  }, 1000);

  // ---- Auto-Submit ----
  function autoSubmit() {
    if (!running) return;
    running = false;
    try { stream.getTracks().forEach(t => t.stop()); } catch (e) {}
    clearInterval(faceInterval);
    clearInterval(timerInterval);

    const form = document.getElementById(formId);
    if (form) {
      const inp = document.createElement("input");
      inp.type = "hidden";
      inp.name = "tab_switches";
      inp.value = tabSwitches;
      form.appendChild(inp);

      console.log("📤 Auto-submitting form with violations:", tabSwitches); // ✅ log before submit
      form.submit();
    } else {
      console.log("📤 Auto-submitting redirect with violations:", tabSwitches);
      window.location.href = "MyCoursesServlet";
    }
  }

  return {
    stop: function () {
      running = false;
      try { stream.getTracks().forEach(t => t.stop()); } catch (e) {}
      clearInterval(faceInterval);
      clearInterval(timerInterval);
    },
  };
};/*
window.initExam = async function (options) {
  const { courseId, level, durationSeconds = 300, maxTabSwitches = 3, formId, modelsUri } = options;

  // ---- Wait for face-api.js ----
  let waited = 0;
  while (!window.faceapi && waited < 5000) {
    await new Promise(r => setTimeout(r, 100));
    waited += 100;
  }
  if (!window.faceapi) throw new Error("face-api.js not loaded!");

  const video = document.getElementById("monitorVideo");
  const timerEl = document.getElementById("examTimer");
  const warningEl = document.getElementById("examWarning");
  const form = document.getElementById(formId);

  function showWarning(msg, timeout = 3000) {
    warningEl.innerText = msg;
    warningEl.style.display = "block";
    clearTimeout(warningEl._t);
    warningEl._t = setTimeout(() => warningEl.style.display = "none", timeout);
  }

  // Camera
  let stream = await navigator.mediaDevices.getUserMedia({ video: true });
  video.srcObject = stream;
  await video.play();

  // Models
  await Promise.all([
    faceapi.nets.tinyFaceDetector.loadFromUri(modelsUri),
    faceapi.nets.ssdMobilenetv1.loadFromUri(modelsUri),
  ]);

  // ---- Monitoring ----
  let tabSwitches = 0;
  let running = true;

  function disableForm() {
    form.style.pointerEvents = "none";
    form.style.opacity = "0.6";
  }
  function enableForm() {
    form.style.pointerEvents = "auto";
    form.style.opacity = "1";
  }

  disableForm(); // initially

  function checkMax() {
    if (tabSwitches >= maxTabSwitches) {
      showWarning("🚨 Max violations reached. Auto submitting...");
      setTimeout(autoSubmit, 1000);
    }
  }

  // Tab / Focus monitoring
  document.addEventListener("visibilitychange", () => {
    if (document.hidden && running) {
      tabSwitches++;
      showWarning(`Tab switch (${tabSwitches}/${maxTabSwitches})`);
      checkMax();
    }
  });
  window.addEventListener("blur", () => {
    if (running) {
      tabSwitches++;
      showWarning(`Window lost focus (${tabSwitches}/${maxTabSwitches})`);
      checkMax();
    }
  });

  // Fullscreen monitoring
  document.addEventListener("fullscreenchange", () => {
    if (!running) return;
    if (!document.fullscreenElement) {
      tabSwitches++;
      disableForm();
      showWarning(`⚠️ Exited fullscreen. Click back to fullscreen to continue.`);
      checkMax();
    } else {
      enableForm();
      showWarning("✅ Back to fullscreen. You can continue.");
    }
  });

  // Timer
  let remaining = durationSeconds;
  timerEl.innerText = formatTime(remaining);
  const timerInterval = setInterval(() => {
    if (!running) return;
    remaining--;
    if (remaining <= 0) {
      clearInterval(timerInterval);
      autoSubmit();
    } else {
      timerEl.innerText = formatTime(remaining);
    }
  }, 1000);

  function formatTime(s) {
    const m = Math.floor(s / 60).toString().padStart(2, "0");
    const sec = (s % 60).toString().padStart(2, "0");
    return `${m}:${sec}`;
  }

  // Face check loop
  const faceInterval = setInterval(async () => {
    if (!running || !video.readyState === 4) return;
    let faces = [];
    try {
      faces = await faceapi.detectAllFaces(video, new faceapi.TinyFaceDetectorOptions());
    } catch {}
    if (faces.length === 0) {
      showWarning("⚠️ No face detected");
    } else if (faces.length > 1) {
      tabSwitches++;
      showWarning(`⚠️ Multiple faces detected (${tabSwitches}/${maxTabSwitches})`);
      checkMax();
    }
  }, 2000);

  function autoSubmit() {
    if (!running) return;
    running = false;
    try { stream.getTracks().forEach(t => t.stop()); } catch {}
    clearInterval(faceInterval);
    clearInterval(timerInterval);

    if (form) {
      const inp = document.createElement("input");
      inp.type = "hidden";
      inp.name = "tab_switches";
      inp.value = tabSwitches;
      form.appendChild(inp);
      form.submit();
    } else {
      window.location.href = "MyCoursesServlet";
    }
  }

  return {
    stop: () => {
      running = false;
      try { stream.getTracks().forEach(t => t.stop()); } catch {}
      clearInterval(faceInterval);
      clearInterval(timerInterval);
    }
  };
};  */
window.initExam = async function (options) {
  const { courseId, level, durationSeconds = 300, maxTabSwitches = 3, formId, modelsUri } = options;

  // ---- Wait for face-api.js ----
  let waited = 0;
  while (!window.faceapi && waited < 5000) {
    await new Promise(r => setTimeout(r, 100));
    waited += 100;
  }
  if (!window.faceapi) throw new Error("face-api.js not loaded. Include script before exam-monitor.js");

  // ---- UI Setup ----
  let video = document.getElementById("monitorVideo");
  if (!video) {
    video = document.createElement("video");
    video.id = "monitorVideo";
    video.autoplay = true;
    video.muted = true;
    video.playsInline = true;
    video.style.width = "160px";
    video.style.height = "120px";
    video.style.position = "fixed";
    video.style.right = "10px";
    video.style.top = "10px";
    video.style.zIndex = "9999";
    document.body.appendChild(video);
  }

  const timerEl = document.getElementById("examTimer");
  const warningEl = document.createElement("div");
  warningEl.id = "examWarning";
  warningEl.style.cssText = "position:fixed;left:50%;top:50%;transform:translate(-50%,-50%);z-index:10000;padding:12px 18px;background:rgba(255,255,0,0.95);color:#000;display:none";
  document.body.appendChild(warningEl);

  function showWarning(text, timeout = 3000) {
    console.warn("[VIOLATION]", text);
    warningEl.innerText = text;
    warningEl.style.display = "block";
    clearTimeout(warningEl._t);
    warningEl._t = setTimeout(() => {
      warningEl.style.display = "none";
    }, timeout);
  }

  // ---- Camera ----
  let stream;
  try {
    stream = await navigator.mediaDevices.getUserMedia({ video: { facingMode: "user" }, audio: false });
  } catch (e) {
    throw new Error("Camera permission required to start quiz!");
  }
  video.srcObject = stream;
  await video.play();

  // ---- Load Models ----
  await Promise.all([
    faceapi.nets.tinyFaceDetector.loadFromUri(modelsUri),
    faceapi.nets.ssdMobilenetv1.loadFromUri(modelsUri),
  ]);

  // ---- Monitoring ----
  let tabSwitches = 0;
  let running = true;

  function checkMax() {
    if (tabSwitches >= maxTabSwitches) {
      showWarning("🚨 Max violations reached. Quiz will be auto-submitted.", 4000);
      setTimeout(autoSubmit, 1200);
    }
  }

  document.addEventListener("visibilitychange", () => {
    if (running && document.hidden) {
      tabSwitches++;
      showWarning(`Tab switched (${tabSwitches}/${maxTabSwitches})`);
      checkMax();
    }
  });

  window.addEventListener("blur", () => {
    if (running) {
      tabSwitches++;
      showWarning(`Window lost focus (${tabSwitches}/${maxTabSwitches})`);
      checkMax();
    }
  });

  document.addEventListener("fullscreenchange", () => {
    if (!running) return;
    if (!document.fullscreenElement) {
      tabSwitches++;
      showWarning(`Exited fullscreen (${tabSwitches}/${maxTabSwitches})`);
      checkMax();
      setTimeout(() => {
        if (!document.fullscreenElement) {
          document.documentElement.requestFullscreen().catch(() => {
            showWarning("Please return to fullscreen to continue the quiz!");
          });
        }
      }, 300);
    }
  });

  // ---- Timer ----
  let remaining = durationSeconds;
  timerEl.innerText = formatTime(remaining);
  const timerInterval = setInterval(() => {
    if (!running) return;
    remaining--;
    if (remaining <= 0) {
      clearInterval(timerInterval);
      autoSubmit();
    } else {
      timerEl.innerText = formatTime(remaining);
    }
  }, 1000);

  function formatTime(s) {
    const m = Math.floor(s / 60).toString().padStart(2, "0");
    const sec = (s % 60).toString().padStart(2, "0");
    return m + ":" + sec;
  }

  // ---- Face Detection (single loop) ----
  const faceInterval = setInterval(async () => {
    if (!running || !video || video.readyState !== 4) return;

    let faces = [];
    try {
      faces = await faceapi.detectAllFaces(video, new faceapi.TinyFaceDetectorOptions({ inputSize: 224, scoreThreshold: 0.5 }));
    } catch (e) {
      console.warn("face-api error", e);
      return;
    }

    if (faces.length !== 1) {
      tabSwitches++;
      if (faces.length === 0) showWarning("⚠️ No face detected");
      else showWarning("⚠️ Multiple faces detected");
      checkMax();
    }
  }, 1000);

  // ---- Auto Submit ----
  function autoSubmit() {
    if (!running) return;
    running = false;
    try { stream.getTracks().forEach(t => t.stop()); } catch (e) {}
    clearInterval(faceInterval);
    clearInterval(timerInterval);

    const form = document.getElementById(formId);
    if (form) {
      const inp = document.createElement("input");
      inp.type = "hidden";
      inp.name = "tab_switches";
      inp.value = tabSwitches;
      form.appendChild(inp);
      form.submit();
    } else {
      window.location.href = "MyCoursesServlet";
    }
  }

  return {
    stop: function () {
      running = false;
      try { stream.getTracks().forEach(t => t.stop()); } catch (e) {}
      clearInterval(faceInterval);
      clearInterval(timerInterval);
    },
  };
};


