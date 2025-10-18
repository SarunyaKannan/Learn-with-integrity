/**
 * 
 */let totalSeconds = 5 * 60; // Set timer: 5 minutes

window.onload = function () {
    const timer = document.getElementById("timer");

    const interval = setInterval(function () {
        let minutes = Math.floor(totalSeconds / 60);
        let seconds = totalSeconds % 60;

        timer.textContent = `${minutes}:${seconds < 10 ? '0' + seconds : seconds}`;
        totalSeconds--;

        if (totalSeconds < 0) {
            clearInterval(interval);
            alert("Time's up!");
            document.getElementById("quizForm").submit(); // Auto-submit form
        }
    }, 1000);
};
