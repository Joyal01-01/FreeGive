package com.freegive.util;

import org.mindrot.jbcrypt.BCrypt;

/**
 * Password hashing utility using BCrypt.
 */
public class PasswordUtil {

    private static final int BCRYPT_ROUNDS = 10;

    /**
     * Hash a plaintext password using BCrypt.
     * @param plainPassword the plaintext password
     * @return the BCrypt hash
     */
    public static String hashPassword(String plainPassword) {
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt(BCRYPT_ROUNDS));
    }

    /**
     * Check a plaintext password against a BCrypt hash.
     * @param plainPassword the plaintext password
     * @param hashedPassword the BCrypt hash
     * @return true if matches
     */
    public static boolean checkPassword(String plainPassword, String hashedPassword) {
        try {
            return BCrypt.checkpw(plainPassword, hashedPassword);
        } catch (Exception e) {
            return false;
        }
    }
}
