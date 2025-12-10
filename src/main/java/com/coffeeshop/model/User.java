package com.coffeeshop.model;

public class User {
    private int id;
    private String username;
    private String fullName;
    private String phone;
    private String address; // <--- NEW FIELD
    private String role;

    // Constructor
    public User(int id, String username, String fullName, String phone, String address, String role) {
        this.id = id;
        this.username = username;
        this.fullName = fullName;
        this.phone = phone;
        this.address = address;
        this.role = role;
    }

    //Getter
    public int getId() { return id; }
    public String getUsername() { return username; }
    public String getFullName() { return fullName; }
    public String getPhone() { return phone; }
    public String getRole() { return role; }
    public boolean isAdmin() { return "admin".equalsIgnoreCase(role); }
    public String getAddress() { return address; }
}