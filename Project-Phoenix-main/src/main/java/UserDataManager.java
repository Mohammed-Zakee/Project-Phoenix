import java.io.*;
import java.util.LinkedList;

public class UserDataManager {
    private static final String USER_FILE = "/users.txt";
    private static final String USER_FILE_WRITABLE = "users.txt";

    public LinkedList<User> getUsers() throws IOException {
        LinkedList<User> users = new LinkedList<>();
        File writableFile = new File(USER_FILE_WRITABLE);
        System.out.println("Checking writable user file: " + writableFile.getAbsolutePath());

        if (writableFile.exists()) {
            System.out.println("Reading from writable file: " + writableFile.getAbsolutePath());
            try (BufferedReader reader = new BufferedReader(new FileReader(writableFile))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    processUserLine(line, users);
                }
            }
        } else {
            System.out.println("Writable file not found, trying classpath resource: " + USER_FILE);
            InputStream inputStream = getClass().getResourceAsStream(USER_FILE);
            if (inputStream == null) {
                System.err.println("User file not found in classpath: " + USER_FILE);
                return users; // Return empty list if file is not found
            }
            try (BufferedReader reader = new BufferedReader(new InputStreamReader(inputStream))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    processUserLine(line, users);
                }
            }
        }
        System.out.println("Loaded " + users.size() + " users from file.");
        return users;
    }

    private void processUserLine(String line, LinkedList<User> users) {
        String[] data = line.split(",");
        if (data.length != 3) {
            System.err.println("Invalid user data format: " + line);
            return;
        }
        String username = data[0].trim();
        String password = data[1].trim();
        String role = data[2].trim();
        try {
            if ("Admin".equalsIgnoreCase(role)) {
                users.add(new Admin(username, password));
                System.out.println("Added Admin user: " + username);
            } else if ("RegularUser".equalsIgnoreCase(role)) {
                users.add(new RegularUser(username, password));
                System.out.println("Added RegularUser: " + username);
            } else {
                System.err.println("Unknown user role: " + role);
            }
        } catch (Exception e) {
            System.err.println("Error creating user from line: " + line + " - " + e.getMessage());
        }
    }

    public User authenticate(String username, String password) throws IOException {
        LinkedList<User> users = getUsers();
        System.out.println("Attempting to authenticate username: " + username);
        for (User u : users) {
            System.out.println("Checking user: " + u.getUsername() + ", password: " + u.getPassword());
            if (u.getUsername().equalsIgnoreCase(username) && u.getPassword().equals(password)) {
                System.out.println("Authentication successful for: " + username);
                return u;
            }
        }
        System.out.println("No matching user found for: " + username);
        return null;
    }

    public void addUser(User user) throws IOException {
        File file = new File(USER_FILE_WRITABLE);
        boolean userExists = false;
        LinkedList<User> users = getUsers();

        for (User u : users) {
            if (u.getUsername().equalsIgnoreCase(user.getUsername())) {
                userExists = true;
                break;
            }
        }

        if (userExists) {
            throw new IOException("Username already exists: " + user.getUsername());
        }

        try (BufferedWriter writer = new BufferedWriter(new FileWriter(file, true))) {
            String role = user instanceof Admin ? "Admin" : "RegularUser";
            writer.write(user.getUsername() + "," + user.getPassword() + "," + role);
            writer.newLine();

        }
    }

    public User getUserByUsername(String username) throws IOException {
        LinkedList<User> users = getUsers();
        for (User u : users) {
            if (u.getUsername().equals(username)) {
                System.out.println("Successfully retrieved user: " + username);
                return u;
            }
        }
        System.out.println("User not found: " + username);
        return null;
    }
}