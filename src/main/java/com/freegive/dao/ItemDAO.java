package com.freegive.dao;

import com.freegive.model.Item;
import com.freegive.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Item operations.
 * All queries use PreparedStatement to prevent SQL injection.
 */
public class ItemDAO {

    /**
     * Create a new item.
     */
    public boolean create(Item item) throws SQLException {
        String sql = "INSERT INTO items (user_id, name, description, tags, zipcode, photo_path, expiry, status) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, item.getUserId());
            ps.setString(2, item.getName());
            ps.setString(3, item.getDescription());
            ps.setString(4, item.getTags());
            ps.setString(5, item.getZipcode());
            ps.setString(6, item.getPhotoPath());
            ps.setDate(7, item.getExpiry());
            ps.setString(8, item.getStatus() != null ? item.getStatus() : "available");

            int rows = ps.executeUpdate();
            if (rows > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    item.setId(rs.getInt(1));
                }
                return true;
            }
            return false;
        }
    }

    /**
     * Find an item by ID.
     */
    public Item findById(int id) throws SQLException {
        String sql = "SELECT i.*, u.username AS donor_username FROM items i " +
                     "JOIN users u ON i.user_id = u.id WHERE i.id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapResultSetToItem(rs);
            }
            return null;
        }
    }

    /**
     * Find all items by a specific user (donor's items).
     */
    public List<Item> findByUserId(int userId) throws SQLException {
        String sql = "SELECT i.*, u.username AS donor_username FROM items i " +
                     "JOIN users u ON i.user_id = u.id WHERE i.user_id = ? ORDER BY i.posted_at DESC";
        List<Item> items = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                items.add(mapResultSetToItem(rs));
            }
        }
        return items;
    }

    /**
     * Find all available items (not expired, not claimed).
     */
    public List<Item> findAvailable() throws SQLException {
        String sql = "SELECT i.*, u.username AS donor_username FROM items i " +
                     "JOIN users u ON i.user_id = u.id " +
                     "WHERE i.status = 'available' AND (i.expiry IS NULL OR i.expiry >= CURDATE()) " +
                     "ORDER BY i.posted_at DESC";
        List<Item> items = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                items.add(mapResultSetToItem(rs));
            }
        }
        return items;
    }

    /**
     * Search items by keyword, tag, and/or zipcode proximity.
     */
    public List<Item> search(String keyword, String tag, String zipcode) throws SQLException {
        StringBuilder sql = new StringBuilder(
            "SELECT i.*, u.username AS donor_username FROM items i " +
            "JOIN users u ON i.user_id = u.id " +
            "WHERE i.status = 'available' AND (i.expiry IS NULL OR i.expiry >= CURDATE()) "
        );
        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (i.name LIKE ? OR i.description LIKE ?) ");
            String kw = "%" + keyword.trim() + "%";
            params.add(kw);
            params.add(kw);
        }

        if (tag != null && !tag.trim().isEmpty()) {
            sql.append("AND i.tags LIKE ? ");
            params.add("%" + tag.trim() + "%");
        }

        if (zipcode != null && !zipcode.trim().isEmpty()) {
            sql.append("AND i.zipcode = ? ");
            params.add(zipcode.trim());
        }

        sql.append("ORDER BY i.posted_at DESC");

        List<Item> items = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                items.add(mapResultSetToItem(rs));
            }
        }
        return items;
    }

    /**
     * Update an item.
     */
    public boolean update(Item item) throws SQLException {
        String sql = "UPDATE items SET name = ?, description = ?, tags = ?, zipcode = ?, " +
                     "photo_path = ?, expiry = ? WHERE id = ? AND user_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, item.getName());
            ps.setString(2, item.getDescription());
            ps.setString(3, item.getTags());
            ps.setString(4, item.getZipcode());
            ps.setString(5, item.getPhotoPath());
            ps.setDate(6, item.getExpiry());
            ps.setInt(7, item.getId());
            ps.setInt(8, item.getUserId());

            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Delete an item (only if owned by user or admin).
     */
    public boolean delete(int itemId) throws SQLException {
        String sql = "DELETE FROM items WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, itemId);
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Delete an item owned by specific user.
     */
    public boolean deleteByUserIdAndItemId(int itemId, int userId) throws SQLException {
        String sql = "DELETE FROM items WHERE id = ? AND user_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, itemId);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Update item status (available/claimed).
     */
    public boolean updateStatus(int itemId, String status) throws SQLException {
        String sql = "UPDATE items SET status = ? WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, itemId);
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Find all items (admin view).
     */
    public List<Item> findAll() throws SQLException {
        String sql = "SELECT i.*, u.username AS donor_username FROM items i " +
                     "JOIN users u ON i.user_id = u.id ORDER BY i.posted_at DESC";
        List<Item> items = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                items.add(mapResultSetToItem(rs));
            }
        }
        return items;
    }

    /**
     * Count all items (for reports).
     */
    public int countAll() throws SQLException {
        String sql = "SELECT COUNT(*) FROM items";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            rs.next();
            return rs.getInt(1);
        }
    }

    /**
     * Count items by status (for reports).
     */
    public int countByStatus(String status) throws SQLException {
        String sql = "SELECT COUNT(*) FROM items WHERE status = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            rs.next();
            return rs.getInt(1);
        }
    }

    // ==================== HELPER ====================

    private Item mapResultSetToItem(ResultSet rs) throws SQLException {
        Item item = new Item();
        item.setId(rs.getInt("id"));
        item.setUserId(rs.getInt("user_id"));
        item.setName(rs.getString("name"));
        item.setDescription(rs.getString("description"));
        item.setTags(rs.getString("tags"));
        item.setZipcode(rs.getString("zipcode"));
        item.setPhotoPath(rs.getString("photo_path"));
        item.setExpiry(rs.getDate("expiry"));
        item.setStatus(rs.getString("status"));
        item.setPostedAt(rs.getTimestamp("posted_at"));
        try {
            item.setDonorUsername(rs.getString("donor_username"));
        } catch (SQLException e) {
            // donor_username might not be in all queries
        }
        return item;
    }
}
