package com.devopsshack.projectops;

public class VulnerableDemo {

    // Fake secret for GitLeaks testing
    private static final String PASSWORD = "Admin123456";
    private static final String API_KEY = "FAKE_API_KEY_123456";

    public static void main(String[] args) {

        String userInput = "1";

        // Bad SQL query for Semgrep/Sonar practice
        String query =
            "SELECT * FROM users WHERE id=" + userInput;

        System.out.println(query);
        System.out.println(PASSWORD);
        System.out.println(API_KEY);
    }
}