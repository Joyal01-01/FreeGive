package com.freegive.model;

import com.freegive.util.Validator;
import java.sql.Date;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 * Item model representing a donated item.
 */
public class Item {

    private int id;
    private int userId;
    private String name;
    private String description;
    private String tags;
    private String zipcode;
    private String photoPath;
    private Date expiry;
    private String status;      // available, claimed
    private Timestamp postedAt;

    // Transient fields for display
    private String donorUsername;

    public Item() {}

    public Item(int userId, String name, String description, String tags, String zipcode) {
        this.userId = userId;
        this.name = name;
        this.description = description;
        this.tags = tags;
        this.zipcode = zipcode;
        this.status = "available";
    }

    // ==================== VALIDATION ====================

    /**
     * Validate item fields. Returns list of error messages.
     */
    public List<String> validate() {
        List<String> errors = new ArrayList<>();

        if (Validator.isEmpty(name)) {
            errors.add("Item name is required.");
        } else if (name.length() > 100) {
            errors.add("Item name must be 100 characters or less.");
        }

        if (description != null && description.length() > 2000) {
            errors.add("Description must be 2000 characters or less.");
        }

        if (!Validator.isValidTags(tags)) {
            errors.add("Tags must be comma-separated words.");
        }

        if (!Validator.isEmpty(zipcode) && !Validator.isValidZipcode(zipcode)) {
            errors.add("Invalid zipcode format.");
        }

        if (expiry != null && expiry.before(new Date(System.currentTimeMillis()))) {
            errors.add("Expiry date must be in the future.");
        }

        return errors;
    }

    /**
     * Get tags as an array.
     */
    public String[] getTagsArray() {
        if (tags == null || tags.trim().isEmpty()) return new String[0];
        String[] result = tags.split(",");
        for (int i = 0; i < result.length; i++) {
            result[i] = result[i].trim();
        }
        return result;
    }

    // ==================== GETTERS & SETTERS ====================

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getTags() { return tags; }
    public void setTags(String tags) { this.tags = tags; }

    public String getZipcode() { return zipcode; }
    public void setZipcode(String zipcode) { this.zipcode = zipcode; }

    public String getPhotoPath() { return photoPath; }
    public void setPhotoPath(String photoPath) { this.photoPath = photoPath; }

    public Date getExpiry() { return expiry; }
    public void setExpiry(Date expiry) { this.expiry = expiry; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Timestamp getPostedAt() { return postedAt; }
    public void setPostedAt(Timestamp postedAt) { this.postedAt = postedAt; }

    public String getDonorUsername() { return donorUsername; }
    public void setDonorUsername(String donorUsername) { this.donorUsername = donorUsername; }

    @Override
    public String toString() {
        return "Item{id=" + id + ", name='" + name + "', status='" + status + "'}";
    }
}
