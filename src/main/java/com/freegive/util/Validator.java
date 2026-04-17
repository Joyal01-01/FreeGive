package com.freegive.util;

import java.util.regex.Pattern;

/**
 * Input validation utility class.
 * Provides server-side validation for all user inputs.
 */
public class Validator {

    private static final Pattern EMAIL_PATTERN =
            Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");

    private static final Pattern PHONE_PATTERN =
            Pattern.compile("^\\d{10,15}$");

    private static final Pattern ZIPCODE_PATTERN =
            Pattern.compile("^\\d{4,10}$");

    private static final Pattern USERNAME_PATTERN =
            Pattern.compile("^[A-Za-z0-9_]{3,50}$");

    /**
     * Check if a string is null or empty after trimming.
     */
    public static boolean isEmpty(String value) {
        return value == null || value.trim().isEmpty();
    }

    /**
     * Validate email format.
     */
    public static boolean isValidEmail(String email) {
        return !isEmpty(email) && EMAIL_PATTERN.matcher(email.trim()).matches();
    }

    /**
     * Validate phone number (10-15 digits).
     */
    public static boolean isValidPhone(String phone) {
        return !isEmpty(phone) && PHONE_PATTERN.matcher(phone.trim()).matches();
    }

    /**
     * Validate zipcode (4-10 digits).
     */
    public static boolean isValidZipcode(String zipcode) {
        return !isEmpty(zipcode) && ZIPCODE_PATTERN.matcher(zipcode.trim()).matches();
    }

    /**
     * Validate username (3-50 chars, alphanumeric + underscore).
     */
    public static boolean isValidUsername(String username) {
        return !isEmpty(username) && USERNAME_PATTERN.matcher(username.trim()).matches();
    }

    /**
     * Validate password strength (min 6 chars).
     */
    public static boolean isValidPassword(String password) {
        return !isEmpty(password) && password.length() >= 6;
    }

    /**
     * Sanitize input to prevent XSS attacks.
     * Escapes HTML special characters.
     */
    public static String sanitize(String input) {
        if (input == null) return null;
        return input.replace("&", "&amp;")
                     .replace("<", "&lt;")
                     .replace(">", "&gt;")
                     .replace("\"", "&quot;")
                     .replace("'", "&#x27;");
    }

    /**
     * Calculate simple distance between two zipcodes.
     * Uses numeric difference as a rough proximity metric.
     * @return the absolute numeric difference, or Integer.MAX_VALUE if invalid
     */
    public static int calculateZipDistance(String zip1, String zip2) {
        try {
            int z1 = Integer.parseInt(zip1.trim());
            int z2 = Integer.parseInt(zip2.trim());
            return Math.abs(z1 - z2);
        } catch (NumberFormatException e) {
            return Integer.MAX_VALUE;
        }
    }

    /**
     * Validate tags (comma-separated, not empty).
     */
    public static boolean isValidTags(String tags) {
        if (isEmpty(tags)) return true; // tags are optional
        String[] tagArray = tags.split(",");
        for (String tag : tagArray) {
            if (tag.trim().isEmpty()) return false;
        }
        return true;
    }

    /**
     * Validate a role value.
     */
    public static boolean isValidRole(String role) {
        if (isEmpty(role)) return false;
        return role.equals("pending") || role.equals("donor") ||
               role.equals("receiver") || role.equals("admin");
    }
}
