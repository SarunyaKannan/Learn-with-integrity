package Module4;




public class ProgressService {

    public String calculateOverallStatus(UserCourseProgress p) {
        boolean docsDone  = p.getDocProgress() >= 100;
        boolean videoDone = p.getVideoProgress() >= 100;
        boolean aiDone    = "COMPLETED".equals(p.getAiCheckProgress());
        boolean quizFull  = "FULL_COMPLETED".equals(p.getQuizProgress());

        if (docsDone && videoDone && aiDone && quizFull) return "COMPLETED";

        boolean anyStarted =
                p.getDocProgress() > 0 ||
                p.getVideoProgress() > 0 ||
                !"NOT_STARTED".equals(p.getAiCheckProgress()) ||
                !"NOT_STARTED".equals(p.getQuizProgress());

        return anyStarted ? "IN_PROGRESS" : "NOT_STARTED";
    }
}
