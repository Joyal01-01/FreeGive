package com.freegive.dao;

import com.freegive.model.Claim;
import com.freegive.util.DBConnection;

import java.sql.*;
import java.util.*;

/**
 * Data Access Object for Claim operations.
 * All queries use PreparedStatement to prevent SQL injection.
 */
public class ClaimDAO {

    /**
     * Create a new claim.
     */
    public boolean create(Claim claim) throws SQLException {
        String sql = "INSERT INTO claims (item_id, user_id) VALUES (?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, claim.getItemId());
            ps.setInt(2, claim.getUserId());

            int rows = ps.executeUpdate();
            if (rows > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    claim.setId(rs.getInt(1));
                }
                return true;
            }
            return false;
        }
    }

    /**
     * Find claim by item ID.
     */
    public Claim findByItemId(int itemId) throws SQLException {
        String sql = "SELECT c.*, i.name AS item_name, u.username AS claimer_username " +
                     "FROM claims c JOIN items i ON c.item_id = i.id " +
                     "JOIN users u ON c.user_id = u.id WHERE c.item_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, itemId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapResultSetToClaim(rs);
            }
            return null;
        }
    }

    /**
     * Find all claims by a user (receiver's claimed items).
     */
    public List<Claim> findByUserId(int userId) throws SQLException {
        String sql = "SELECT c.*, i.name AS item_name, u2.username AS donor_username " +
                     "FROM claims c JOIN items i ON c.item_id = i.id " +
                     "JOIN users u2 ON i.user_id = u2.id " +
                     "WHERE c.user_id = ? ORDER BY c.claimed_at DESC";
        List<Claim> claims = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Claim claim = new Claim();
                claim.setId(rs.getInt("id"));
                claim.setItemId(rs.getInt("item_id"));
                claim.setUserId(rs.getInt("user_id"));
                claim.setClaimedAt(rs.getTimestamp("claimed_at"));
                claim.setRating(rs.getObject("rating") != null ? rs.getInt("rating") : null);
                claim.setItemName(rs.getString("item_name"));
                claim.setDonorUsername(rs.getString("donor_username"));
                claims.add(claim);
            }
        }
        return claims;
    }

    /**
     * Update the rating for a claim.
     */
    public boolean updateRating(int claimId, int rating) throws SQLException {
        String sql = "UPDATE claims SET rating = ? WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, rating);
            ps.setInt(2, claimId);
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Get total claims count (for reports).
     */
    public int getClaimsCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM claims";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            rs.next();
            return rs.getInt(1);
        }
    }

    /**
     * Get top categories/tags by claim count (for reports).
     * Returns a map of tag -> claim count.
     */
    public List<Map<String, Object>> getTopCategories() throws SQLException {
        String sql = "SELECT i.tags, COUNT(c.id) AS claim_count " +
                     "FROM claims c JOIN items i ON c.item_id = i.id " +
                     "WHERE i.tags IS NOT NULL AND i.tags != '' " +
                     "GROUP BY i.tags ORDER BY claim_count DESC LIMIT 10";

        List<Map<String, Object>> categories = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> cat = new HashMap<>();
                cat.put("tags", rs.getString("tags"));
                cat.put("claimCount", rs.getInt("claim_count"));
                categories.add(cat);
            }
        }
        return categories;
    }

    /**
     * Get all claims (admin view).
     */
    public List<Claim> findAll() throws SQLException {
        String sql = "SELECT c.*, i.name AS item_name, u.username AS claimer_username " +
                     "FROM claims c JOIN items i ON c.item_id = i.id " +
                     "JOIN users u ON c.user_id = u.id ORDER BY c.claimed_at DESC";
        List<Claim> claims = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                claims.add(mapResultSetToClaim(rs));
            }
        }
        return claims;
    }

    /**
     * Check if a user already claimed an item.
     */
    public boolean hasUserClaimed(int itemId, int userId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM claims WHERE item_id = ? AND user_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, itemId);
            ps.setInt(2, userId);
            ResultSet rs = ps.executeQuery();
            rs.next();
            return rs.getInt(1) > 0;
        }
    }

    // ==================== HELPER ====================

    private Claim mapResultSetToClaim(ResultSet rs) throws SQLException {
        Claim claim = new Claim();
        claim.setId(rs.getInt("id"));
        claim.setItemId(rs.getInt("item_id"));
        claim.setUserId(rs.getInt("user_id"));
        claim.setClaimedAt(rs.getTimestamp("claimed_at"));
        claim.setRating(rs.getObject("rating") != null ? rs.getInt("rating") : null);
        try {
            claim.setItemName(rs.getString("item_name"));
        } catch (SQLException e) { /* might not be in query */ }
        try {
            claim.setClaimerUsername(rs.getString("claimer_username"));
        } catch (SQLException e) { /* might not be in query */ }
        return claim;
    }
}
