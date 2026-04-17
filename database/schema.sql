-- ============================================
-- FreeGive Database Schema
-- CS5054 Coursework - Normalized (1NF+)
-- ============================================

DROP DATABASE IF EXISTS freegive;
CREATE DATABASE freegive CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE freegive;

-- ============================================
-- USERS TABLE
-- ============================================
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20) UNIQUE NOT NULL,
    zipcode VARCHAR(10) NOT NULL,
    role ENUM('pending', 'donor', 'receiver', 'admin') DEFAULT 'pending',
    approved BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ============================================
-- ITEMS TABLE
-- ============================================
CREATE TABLE items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    tags TEXT,
    zipcode VARCHAR(10),
    photo_path VARCHAR(255),
    expiry DATE,
    status ENUM('available', 'claimed') DEFAULT 'available',
    posted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_items_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ============================================
-- CLAIMS TABLE
-- ============================================
CREATE TABLE claims (
    id INT AUTO_INCREMENT PRIMARY KEY,
    item_id INT NOT NULL,
    user_id INT NOT NULL,
    claimed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    rating INT DEFAULT NULL,
    CONSTRAINT fk_claims_item FOREIGN KEY (item_id) REFERENCES items(id) ON DELETE CASCADE,
    CONSTRAINT fk_claims_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT chk_rating CHECK (rating IS NULL OR (rating >= 1 AND rating <= 5))
) ENGINE=InnoDB;

-- ============================================
-- INDEXES for query performance
-- ============================================
CREATE INDEX idx_items_zipcode ON items(zipcode);
CREATE INDEX idx_items_status ON items(status);
CREATE INDEX idx_items_user ON items(user_id);
CREATE INDEX idx_items_expiry ON items(expiry);
CREATE INDEX idx_users_role ON users(role);
CREATE INDEX idx_users_zipcode ON users(zipcode);
CREATE INDEX idx_claims_item ON claims(item_id);
CREATE INDEX idx_claims_user ON claims(user_id);

-- ============================================
-- Default admin user
-- Password: admin123 (BCrypt hash)
-- ============================================
INSERT INTO users (username, password_hash, email, phone, zipcode, role, approved)
VALUES (
    'admin',
    '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy',
    'admin@freegive.com',
    '0000000000',
    '00000',
    'admin',
    TRUE
);

-- ============================================
-- Sample data for testing
-- ============================================

-- Sample approved donor (password: donor123)
INSERT INTO users (username, password_hash, email, phone, zipcode, role, approved)
VALUES (
    'johndoe',
    '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy',
    'john@example.com',
    '1234567890',
    '10001',
    'donor',
    TRUE
);

-- Sample approved receiver (password: receiver123)
INSERT INTO users (username, password_hash, email, phone, zipcode, role, approved)
VALUES (
    'janedoe',
    '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy',
    'jane@example.com',
    '0987654321',
    '10002',
    'receiver',
    TRUE
);

-- Sample items
INSERT INTO items (user_id, name, description, tags, zipcode, expiry, status) VALUES
(2, 'Wooden Dining Table', 'Solid oak dining table, seats 6. Minor scratches on surface.', 'furniture,dining,wood', '10001', DATE_ADD(CURDATE(), INTERVAL 7 DAY), 'available'),
(2, 'Kids Bicycle', 'Blue bicycle suitable for ages 6-10. Good condition.', 'kids,bicycle,outdoor', '10001', DATE_ADD(CURDATE(), INTERVAL 14 DAY), 'available'),
(2, 'Box of Books', 'Collection of 20+ fiction and non-fiction books.', 'books,reading,education', '10001', DATE_ADD(CURDATE(), INTERVAL 5 DAY), 'available');
