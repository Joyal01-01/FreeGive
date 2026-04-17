package com.freegive.model;

import com.freegive.util.Validator;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 * User model representing a registered user.
 */
public class User {

    private int id;
    private String username;
    private String passwordHash;
    private String email;
    private String phone;
    private String zipcode;
    private String role;       // pending, donor, receiver, admin
    private boolean approved;
    private Timestamp createdAt;

    // Transient field for registration
    private String plainPassword;

    public User() {}

    public User(String username, String email, String phone, String zipcode, String role) {
        this.username = username;
        this.email = email;
        this.phone = phone;
        this.zipcode = zipcode;
        this.role = role;
    }

    // ==================== VALIDATION ====================

    /**
     * Validate user fields. Returns list of error messages.
     */
    public List<String> validate() {
        List<String> errors = new ArrayList<>();

        if (!Validator.isValidUsername(username)) {
            errors.add("Username must be 3-50 characters (letters, numbers, underscore).");
        }
        if (!Validator.isValidEmail(email)) {
            errors.add("Please enter a valid email address.");
        }
        if (!Validator.isValidPhone(phone)) {
            errors.add("Phone must be 10-15 digits.");
        }
        if (!Validator.isValidZipcode(zipcode)) {
            errors.add("Zipcode must be 4-10 digits.");
        }
        if (plainPassword != null && !Validator.isValidPassword(plainPassword)) {
            errors.add("Password must be at least 6 characters.");
        }

        return errors;
    }

    // ==================== GETTERS & SETTERS ====================

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getPasswordHash() { return passwordHash; }
    public void setPasswordHash(String passwordHash) { this.passwordHash = passwordHash; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getZipcode() { return zipcode; }
    public void setZipcode(String zipcode) { this.zipcode = zipcode; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public boolean isApproved() { return approved; }
    public void setApproved(boolean approved) { this.approved = approved; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public String getPlainPassword() { return plainPassword; }
    public void setPlainPassword(String plainPassword) { this.plainPassword = plainPassword; }

    @Override
    public String toString() {
        return "User{id=" + id + ", username='" + username + "', role='" + role + "', approved=" + approved + "}";
    }
}
