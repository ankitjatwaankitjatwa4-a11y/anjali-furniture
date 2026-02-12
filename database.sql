-- ------------------------------------------------------------
-- Anjali Furniture Works – Complete Database Schema
-- Compatible with MySQL / MariaDB / PostgreSQL (with minor adjustments)
-- ------------------------------------------------------------

-- ============================================================
-- Table: admin_credentials
-- Stores admin login details (email + password)
-- ============================================================
CREATE TABLE IF NOT EXISTS admin_credentials (
    id INT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,          -- store hashed password (bcrypt/sha256)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- ============================================================
-- Table: products
-- Stores all furniture products with multiple image support
-- ============================================================
CREATE TABLE IF NOT EXISTS products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(200) NOT NULL,
    category ENUM('bed', 'wardrobe', 'almirah', 'rack', 'other') NOT NULL,
    wood_type VARCHAR(100),                       -- Sheesham, Teak, Mango, Sal, Mixed, etc.
    price VARCHAR(100),                           -- can store "25,000" or "Contact for Price"
    description TEXT,
    images JSON,                                  -- stores array of base64 strings or image URLs
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_category (category),
    INDEX idx_created (created_at)
);

-- ============================================================
-- Table: inquiries
-- Stores customer inquiries from the "Get Free Quote" form
-- ============================================================
CREATE TABLE IF NOT EXISTS inquiries (
    id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(100) NOT NULL,
    customer_phone VARCHAR(20) NOT NULL,
    requirement_category VARCHAR(50),              -- Bed, Wardrobe, Almirah, Rack, Sofa, Table, Other
    customer_message TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_phone (customer_phone),
    INDEX idx_created (created_at)
);

-- ============================================================
-- Table: config
-- Stores shop configuration (shop name, tagline, owner name, colors, etc.)
-- ============================================================
CREATE TABLE IF NOT EXISTS config (
    id INT PRIMARY KEY DEFAULT 1,
    shop_name VARCHAR(100) NOT NULL DEFAULT 'Anjali Furniture Works',
    tagline VARCHAR(200) NOT NULL DEFAULT 'Quality Handcrafted Wooden Furniture Since 1995',
    owner_name VARCHAR(100) NOT NULL DEFAULT 'Dhanraj Jagid',
    primary_phone VARCHAR(20) NOT NULL DEFAULT '8386076107',
    secondary_phone VARCHAR(20) NOT NULL DEFAULT '8386020815',
    whatsapp_number VARCHAR(20) NOT NULL DEFAULT '918386076107',
    address TEXT,
    delivery_note_hindi VARCHAR(200) DEFAULT 'डिलीवरी केवल जयपुर में',
    delivery_note_english VARCHAR(200) DEFAULT 'Delivery only in Jaipur',
    primary_color VARCHAR(20) DEFAULT '#92400e',
    secondary_color VARCHAR(20) DEFAULT '#78350f',
    accent_color VARCHAR(20) DEFAULT '#d97706',
    text_color VARCHAR(20) DEFAULT '#1f2937',
    bg_color VARCHAR(20) DEFAULT '#fffbeb',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- ============================================================
-- Table: security_code
-- Stores the fixed security code for admin sign-in (phone + code)
-- ============================================================
CREATE TABLE IF NOT EXISTS security_code (
    id INT PRIMARY KEY DEFAULT 1,
    admin_phone VARCHAR(20) NOT NULL DEFAULT '8386076107',
    security_code VARCHAR(50) NOT NULL DEFAULT 'ANKITJATWA@123',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- ============================================================
-- Insert default configuration (run once after table creation)
-- ============================================================
INSERT INTO config (id) VALUES (1) ON DUPLICATE KEY UPDATE id=1;
INSERT INTO security_code (id) VALUES (1) ON DUPLICATE KEY UPDATE id=1;

-- ============================================================
-- Optional: Sample products for testing
-- ============================================================
INSERT INTO products (name, category, wood_type, price, description, images) VALUES
('Sheesham Double Bed', 'bed', 'Sheesham', '32,000', 'King size bed with storage, termite resistant', '[]'),
('4-Door Wardrobe', 'wardrobe', 'Teak', '45,000', 'Premium teak wood wardrobe with mirrors', '[]'),
('Steel Almirah', 'almirah', 'Sal', '28,500', 'Heavy duty sal wood frame, 3 drawers', '[]');

-- ============================================================
-- Example queries for your Node.js / PHP backend
-- ============================================================

/* --- Get all products --- */
-- SELECT * FROM products ORDER BY created_at DESC;

/* --- Get products by category --- */
-- SELECT * FROM products WHERE category = 'bed' ORDER BY created_at DESC;

/* --- Add a new product (with images as JSON array) --- */
-- INSERT INTO products (name, category, wood_type, price, description, images) 
-- VALUES (?, ?, ?, ?, ?, ?);

/* --- Delete a product --- */
-- DELETE FROM products WHERE id = ?;

/* --- Get all inquiries (latest first) --- */
-- SELECT * FROM inquiries ORDER BY created_at DESC;

/* --- Add a new inquiry --- */
-- INSERT INTO inquiries (customer_name, customer_phone, requirement_category, customer_message) 
-- VALUES (?, ?, ?, ?);

/* --- Verify admin login --- */
-- SELECT * FROM admin_credentials WHERE email = ?;

/* --- Get security code for sign-in --- */
-- SELECT security_code FROM security_code WHERE id = 1;

/* --- Get shop configuration --- */
-- SELECT * FROM config WHERE id = 1;

/* --- Update shop configuration --- */
-- UPDATE config SET shop_name = ?, tagline = ?, owner_name = ?, primary_phone = ?, whatsapp_number = ? WHERE id = 1;

-- ============================================================
-- Notes for integration:
-- 1. For images: Store either base64 strings or image URLs in JSON array.
--    Example: '["data:image/jpeg;base64,...", "data:image/png;base64,..."]'
-- 2. Passwords must be hashed using bcrypt or similar before storing.
-- 3. Use parameterized queries to prevent SQL injection.
-- 4. For PostgreSQL: replace AUTO_INCREMENT with SERIAL, 
--    ENUM with CHECK constraint, and ON DUPLICATE KEY with appropriate upsert.
-- ============================================================
