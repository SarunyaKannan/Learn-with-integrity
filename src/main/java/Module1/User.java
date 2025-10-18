package Module1;

public class User {
    private int id;
    private String name;
    private String email;
    private String username;
    private String gender;
    private String role;

    // Constructor
    public User(int id, String name, String email, String username, String gender, String role) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.username = username;
        this.gender = gender;
        this.role = role;
    }

    // Getters and Setters
    public int getId() { return id; }
    public String getName() { return name; }
    public String getEmail() { return email; }
    public String getUsername() { return username; }
    public String getGender() { return gender; }
    public String getRole() { return role; }
}
