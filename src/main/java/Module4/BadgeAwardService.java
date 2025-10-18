package Module4;



public class BadgeAwardService {

    private final BadgeDAO badgeDAO = new BadgeDAO();

    public void maybeAwardCompletionBadge(UserCourseProgress p) throws Exception {
        if (!"COMPLETED".equals(p.getOverallStatus())) return;

        String badgeName = "Course Mastery";
        if (!badgeDAO.hasBadge(p.getUsername(), p.getCourseId(), badgeName)) {
            UserBadge b = new UserBadge();
            b.setUsername(p.getUsername());
            b.setCourseId(p.getCourseId());
            b.setBadgeName(badgeName);
            badgeDAO.awardBadge(b);
        }
    }
}

