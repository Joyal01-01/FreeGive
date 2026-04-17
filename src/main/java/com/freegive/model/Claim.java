package com.freegive.model;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 * Claim model representing a receiver's claim on an item.
 */
public class Claim {

    private int id;
    private int itemId;
    private int userId;
    private Timestamp claimedAt;
    private Integer rating;     // nullable, 1-5

    // Transient fields for display
    private String itemName;
    private String claimerUsername;
    private String donorUsername;

    public Claim() {}

    public Claim(int itemId, int userId) {
        this.itemId = itemId;
        this.userId = userId;
    }

    // ==================== VALIDATION ====================

    /**
     * Validate claim fields. Returns list of error messages.
     */
    public List<String> validate() {
        List<String> errors = new ArrayList<>();

        if (itemId <= 0) {
            errors.add("Invalid item ID.");
        }
        if (userId <= 0) {
            errors.add("Invalid user ID.");
        }
        if (rating != null && (rating < 1 || rating > 5)) {
            errors.add("Rating must be between 1 and 5.");
        }

        return errors;
    }

    // ==================== GETTERS & SETTERS ====================

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getItemId() { return itemId; }
    public void setItemId(int itemId) { this.itemId = itemId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public Timestamp getClaimedAt() { return claimedAt; }
    public void setClaimedAt(Timestamp claimedAt) { this.claimedAt = claimedAt; }

    public Integer getRating() { return rating; }
    public void setRating(Integer rating) { this.rating = rating; }

    public String getItemName() { return itemName; }
    public void setItemName(String itemName) { this.itemName = itemName; }

    public String getClaimerUsername() { return claimerUsername; }
    public void setClaimerUsername(String claimerUsername) { this.claimerUsername = claimerUsername; }

    public String getDonorUsername() { return donorUsername; }
    public void setDonorUsername(String donorUsername) { this.donorUsername = donorUsername; }

    @Override
    public String toString() {
        return "Claim{id=" + id + ", itemId=" + itemId + ", userId=" + userId + ", rating=" + rating + "}";
    }
}
