-- ============================================================
-- CYPHER Watch Database Script
-- SQL Server LocalDB | Run in VS 2022 > SQL Server Object Explorer
-- ============================================================

USE master;
GO
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'CypherWatchDB')
    DROP DATABASE CypherWatchDB;
GO
CREATE DATABASE CypherWatchDB;
GO
USE CypherWatchDB;
GO

-- ==================== TABLES ====================

CREATE TABLE Users (
    UserID      INT PRIMARY KEY IDENTITY(1,1),
    FullName    NVARCHAR(100) NOT NULL,
    Email       NVARCHAR(100) UNIQUE NOT NULL,
    Phone       NVARCHAR(20),
    PasswordHash NVARCHAR(256) NOT NULL,
    Address     NVARCHAR(300),
    City        NVARCHAR(100),
    State       NVARCHAR(100),
    ZipCode     NVARCHAR(20),
    Country     NVARCHAR(100) DEFAULT 'India',
    IsActive    BIT DEFAULT 1,
    CreatedAt   DATETIME DEFAULT GETDATE()
);

CREATE TABLE Admin (
    AdminID     INT PRIMARY KEY IDENTITY(1,1),
    Username    NVARCHAR(50) UNIQUE NOT NULL,
    PasswordHash NVARCHAR(256) NOT NULL,
    Email       NVARCHAR(100),
    FullName    NVARCHAR(100),
    IsActive    BIT DEFAULT 1,
    CreatedAt   DATETIME DEFAULT GETDATE()
);

CREATE TABLE Categories (
    CategoryID   INT PRIMARY KEY IDENTITY(1,1),
    CategoryName NVARCHAR(100) NOT NULL,
    Description  NVARCHAR(500),
    ImageURL     NVARCHAR(300),
    IsActive     BIT DEFAULT 1
);

CREATE TABLE Brands (
    BrandID     INT PRIMARY KEY IDENTITY(1,1),
    BrandName   NVARCHAR(100) NOT NULL,
    Description NVARCHAR(500),
    LogoURL     NVARCHAR(300),
    Country     NVARCHAR(100),
    IsActive    BIT DEFAULT 1
);

CREATE TABLE Products (
    ProductID        INT PRIMARY KEY IDENTITY(1,1),
    ProductName      NVARCHAR(200) NOT NULL,
    BrandID          INT REFERENCES Brands(BrandID),
    CategoryID       INT REFERENCES Categories(CategoryID),
    Description      NVARCHAR(2000),
    Price            DECIMAL(10,2) NOT NULL,
    DiscountPercent  DECIMAL(5,2) DEFAULT 0,
    StockQuantity    INT DEFAULT 0,
    ImageURL         NVARCHAR(300),
    AdditionalImages NVARCHAR(800),
    Gender           NVARCHAR(20) DEFAULT 'Unisex',
    CaseColor        NVARCHAR(50),
    StrapMaterial    NVARCHAR(50),
    CaseDiameter     NVARCHAR(20),
    WaterResistance  NVARCHAR(50),
    Movement         NVARCHAR(100),
    Crystal          NVARCHAR(50),
    IsActive         BIT DEFAULT 1,
    IsFeatured       BIT DEFAULT 0,
    IsNewArrival     BIT DEFAULT 0,
    IsBestSeller     BIT DEFAULT 0,
    Rating           DECIMAL(3,2) DEFAULT 0,
    ReviewCount      INT DEFAULT 0,
    CreatedAt        DATETIME DEFAULT GETDATE()
);

CREATE TABLE Orders (
    OrderID         INT PRIMARY KEY IDENTITY(1,1),
    UserID          INT REFERENCES Users(UserID),
    OrderDate       DATETIME DEFAULT GETDATE(),
    TotalAmount     DECIMAL(10,2),
    DiscountAmount  DECIMAL(10,2) DEFAULT 0,
    GST             DECIMAL(10,2) DEFAULT 0,
    ShippingCharge  DECIMAL(10,2) DEFAULT 0,
    GrandTotal      DECIMAL(10,2),
    CouponCode      NVARCHAR(50),
    OrderStatus     NVARCHAR(50) DEFAULT 'Pending',
    PaymentMethod   NVARCHAR(50),
    PaymentStatus   NVARCHAR(50) DEFAULT 'Pending',
    ShippingAddress NVARCHAR(500),
    ShippingCity    NVARCHAR(100),
    ShippingState   NVARCHAR(100),
    ShippingZipCode NVARCHAR(20),
    TrackingNumber  NVARCHAR(100),
    Notes           NVARCHAR(500)
);

CREATE TABLE OrderDetails (
    OrderDetailID  INT PRIMARY KEY IDENTITY(1,1),
    OrderID        INT REFERENCES Orders(OrderID),
    ProductID      INT REFERENCES Products(ProductID),
    Quantity       INT NOT NULL,
    UnitPrice      DECIMAL(10,2) NOT NULL,
    DiscountPercent DECIMAL(5,2) DEFAULT 0,
    TotalPrice     DECIMAL(10,2) NOT NULL
);

CREATE TABLE Cart (
    CartID    INT PRIMARY KEY IDENTITY(1,1),
    UserID    INT REFERENCES Users(UserID),
    ProductID INT REFERENCES Products(ProductID),
    Quantity  INT DEFAULT 1,
    AddedAt   DATETIME DEFAULT GETDATE()
);

CREATE TABLE Wishlist (
    WishlistID INT PRIMARY KEY IDENTITY(1,1),
    UserID     INT REFERENCES Users(UserID),
    ProductID  INT REFERENCES Products(ProductID),
    AddedAt    DATETIME DEFAULT GETDATE()
);

CREATE TABLE Reviews (
    ReviewID   INT PRIMARY KEY IDENTITY(1,1),
    ProductID  INT REFERENCES Products(ProductID),
    UserID     INT REFERENCES Users(UserID),
    Rating     INT CHECK (Rating BETWEEN 1 AND 5),
    ReviewText NVARCHAR(1000),
    IsApproved BIT DEFAULT 0,
    CreatedAt  DATETIME DEFAULT GETDATE()
);

CREATE TABLE Coupons (
    CouponID      INT PRIMARY KEY IDENTITY(1,1),
    CouponCode    NVARCHAR(50) UNIQUE NOT NULL,
    DiscountType  NVARCHAR(20),   -- 'Percentage' or 'Fixed'
    DiscountValue DECIMAL(10,2),
    MinOrderAmount DECIMAL(10,2) DEFAULT 0,
    MaxUses       INT,
    UsedCount     INT DEFAULT 0,
    ExpiryDate    DATETIME,
    IsActive      BIT DEFAULT 1
);

CREATE TABLE Payments (
    PaymentID     INT PRIMARY KEY IDENTITY(1,1),
    OrderID       INT REFERENCES Orders(OrderID),
    PaymentMethod NVARCHAR(50),
    Amount        DECIMAL(10,2),
    TransactionID NVARCHAR(100),
    PaymentDate   DATETIME DEFAULT GETDATE(),
    Status        NVARCHAR(50)
);

CREATE TABLE ContactMessages (
    MessageID INT PRIMARY KEY IDENTITY(1,1),
    Name      NVARCHAR(100),
    Email     NVARCHAR(100),
    Phone     NVARCHAR(20),
    Subject   NVARCHAR(200),
    Message   NVARCHAR(2000),
    IsRead    BIT DEFAULT 0,
    SentAt    DATETIME DEFAULT GETDATE()
);

CREATE TABLE NewsletterSubscribers (
    SubscriberID  INT PRIMARY KEY IDENTITY(1,1),
    Email         NVARCHAR(100) UNIQUE NOT NULL,
    SubscribedAt  DATETIME DEFAULT GETDATE(),
    IsActive      BIT DEFAULT 1
);

-- ==================== INDEXES ====================
CREATE INDEX IX_Products_BrandID    ON Products(BrandID);
CREATE INDEX IX_Products_CategoryID ON Products(CategoryID);
CREATE INDEX IX_Orders_UserID       ON Orders(UserID);
CREATE INDEX IX_Cart_UserID         ON Cart(UserID);
CREATE INDEX IX_Wishlist_UserID     ON Wishlist(UserID);
CREATE INDEX IX_Reviews_ProductID   ON Reviews(ProductID);

-- ==================== SEED DATA ====================

-- Admin (password: Admin@123 — SHA256 hash placeholder)
INSERT INTO Admin (Username, PasswordHash, Email, FullName)
VALUES ('admin', 'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f', 'admin@cypherwatch.com', 'CYPHER Admin');

-- Categories
INSERT INTO Categories (CategoryName, Description, ImageURL) VALUES
('Luxury',        'Ultra-premium timepieces for connoisseurs',          'https://placehold.co/400x300/0A0A0A/C9A84C?text=Luxury'),
('Classic',       'Timeless designs that never go out of style',        'https://placehold.co/400x300/0A0A0A/C9A84C?text=Classic'),
('Sports',        'Rugged watches built for performance',               'https://placehold.co/400x300/0A0A0A/C9A84C?text=Sports'),
('Smart Watch',   'Technology meets style on your wrist',               'https://placehold.co/400x300/0A0A0A/C9A84C?text=SmartWatch'),
('Limited Edition','Exclusive pieces with collector value',             'https://placehold.co/400x300/0A0A0A/C9A84C?text=Limited'),
('Dress Watch',   'Elegant watches for formal occasions',               'https://placehold.co/400x300/0A0A0A/C9A84C?text=Dress'),
('Diver',         'Professional-grade water-resistant timepieces',      'https://placehold.co/400x300/0A0A0A/C9A84C?text=Diver'),
('Chronograph',   'Precision stopwatch functionality meets design',     'https://placehold.co/400x300/0A0A0A/C9A84C?text=Chronograph');

-- Brands
INSERT INTO Brands (BrandName, Description, LogoURL, Country) VALUES
('Rolex',   'The world''s most recognised luxury watch brand',    'https://placehold.co/200x100/0A0A0A/C9A84C?text=ROLEX',   'Switzerland'),
('Omega',   'Official timekeeper of the Olympic Games',           'https://placehold.co/200x100/0A0A0A/C9A84C?text=OMEGA',   'Switzerland'),
('Tissot',  'Swiss watches of excellence since 1853',             'https://placehold.co/200x100/0A0A0A/C9A84C?text=TISSOT',  'Switzerland'),
('Casio',   'Innovation and design for everyday life',            'https://placehold.co/200x100/0A0A0A/C9A84C?text=CASIO',   'Japan'),
('Seiko',   'Precision Japanese watchmaking since 1881',          'https://placehold.co/200x100/0A0A0A/C9A84C?text=SEIKO',   'Japan'),
('Fossil',  'Modern American watch brand with vintage flair',     'https://placehold.co/200x100/0A0A0A/C9A84C?text=FOSSIL',  'USA'),
('Citizen', 'Eco-Drive technology leaders',                       'https://placehold.co/200x100/0A0A0A/C9A84C?text=CITIZEN', 'Japan'),
('Titan',   'India''s most loved watch brand',                    'https://placehold.co/200x100/0A0A0A/C9A84C?text=TITAN',   'India');

-- Products (30 watches)
INSERT INTO Products (ProductName,BrandID,CategoryID,Description,Price,DiscountPercent,StockQuantity,ImageURL,Gender,CaseColor,StrapMaterial,CaseDiameter,WaterResistance,Movement,Crystal,IsFeatured,IsNewArrival,IsBestSeller,Rating) VALUES
('Submariner Date',      1,7,'The iconic Rolex diver with Oystersteel case and rotatable bezel.',         850000,5, 10,'https://placehold.co/500x500/1A1A1A/C9A84C?text=Submariner',  'Men',  'Silver','Oyster Bracelet','41mm','300m','Automatic','Sapphire',1,0,1,4.9),
('Seamaster 300',        2,7,'Omega''s legendary dive watch as worn by James Bond.',                     545000,10,15,'https://placehold.co/500x500/1A1A1A/C9A84C?text=Seamaster',   'Men',  'Blue',  'Rubber','42mm','300m','Co-Axial Auto','Sapphire',1,0,1,4.8),
('PRX Powermatic 80',    3,2,'Ultra-thin integrated bracelet watch from Tissot.',                         38000,0, 25,'https://placehold.co/500x500/1A1A1A/C9A84C?text=PRX',         'Unisex','Silver','Steel Bracelet','40mm','100m','Automatic','Sapphire',1,1,0,4.7),
('G-Shock GA-2100',      4,3,'Carbon Core Guard structure for extreme shock resistance.',                 12500,15,50,'https://placehold.co/500x500/1A1A1A/C9A84C?text=GShock',      'Men',  'Black', 'Resin','45mm','200m','Quartz','Mineral',0,1,1,4.6),
('Presage Cocktail',     5,1,'Japanese automatic with stunning sunburst dial inspired by cocktails.',    45000,0, 20,'https://placehold.co/500x500/1A1A1A/C9A84C?text=Presage',     'Men',  'Gold',  'Leather','40mm','50m','Automatic','Hardlex',1,0,0,4.8),
('Chronos Elite',        6,8,'Fossil chronograph with sophisticated brown leather strap.',               18500,20,30,'https://placehold.co/500x500/1A1A1A/C9A84C?text=Chronos',     'Men',  'Rose Gold','Leather','42mm','50m','Quartz','Mineral',0,0,1,4.4),
('Eco-Drive Promaster',  7,7,'Citizen''s flagship solar-powered diver with titanium case.',             55000,10,18,'https://placehold.co/500x500/1A1A1A/C9A84C?text=EcoDrive',    'Men',  'Black', 'Titanium','44mm','200m','Eco-Drive','Sapphire',0,1,0,4.7),
('Raga Vela',            8,6,'Elegant gold-tone ladies watch with mother-of-pearl dial.',               12000,5, 40,'https://placehold.co/500x500/1A1A1A/C9A84C?text=RagaVela',   'Women','Gold',  'Leather','28mm','30m','Quartz','Mineral',1,0,0,4.5),
('Datejust 41',          1,1,'Rolex Datejust — the essential luxury watch for every occasion.',        750000,0, 8, 'https://placehold.co/500x500/1A1A1A/C9A84C?text=Datejust',    'Men',  'White', 'Jubilee Bracelet','41mm','100m','Automatic','Sapphire',1,0,1,5.0),
('Constellation',        2,6,'Omega''s dress watch with distinctive "griffes" and integrated bracelet.',290000,8, 12,'https://placehold.co/500x500/1A1A1A/C9A84C?text=Constellation','Unisex','Silver','Steel Bracelet','39mm','100m','Co-Axial Auto','Sapphire',0,0,1,4.7),
('T-Sport Solar',        3,3,'Tissot solar-powered sports watch for adventurous spirits.',              22000,10,35,'https://placehold.co/500x500/1A1A1A/C9A84C?text=TSport',      'Men',  'Blue',  'Silicone','45mm','100m','Solar Quartz','Sapphire',0,1,0,4.5),
('Edifice EFS-S560',     4,8,'Tough Solar chronograph with Bluetooth connectivity.',                    18000,0, 22,'https://placehold.co/500x500/1A1A1A/C9A84C?text=Edifice',     'Men',  'Black', 'Steel Bracelet','43mm','100m','Tough Solar','Sapphire',0,0,1,4.6),
('5 Sports SRPD',        5,3,'Seiko 5 Sports automatic — Japanese quality at an accessible price.',    19500,5, 45,'https://placehold.co/500x500/1A1A1A/C9A84C?text=Seiko5',      'Men',  'Red',   'Steel Bracelet','42mm','100m','Automatic','Hardlex',0,1,1,4.5),
('Neutra Chronograph',   6,8,'Clean Scandinavian-inspired design with sub-dials.',                     15500,15,28,'https://placehold.co/500x500/1A1A1A/C9A84C?text=Neutra',      'Unisex','Silver','Leather','42mm','50m','Quartz','Mineral',0,0,0,4.3),
('Satellite Wave F900',  7,5,'Ultra-precision GPS satellite timekeeping.',                             125000,0, 6, 'https://placehold.co/500x500/1A1A1A/C9A84C?text=Satellite',   'Men',  'Silver','Titanium','43mm','100m','Eco-Drive GPS','Sapphire',1,0,0,4.9),
('Zephyr Silver',        8,2,'Titan Zephyr with silver guilloche dial and slim profile.',               8500,0, 60,'https://placehold.co/500x500/1A1A1A/C9A84C?text=Zephyr',      'Men',  'Silver','Leather','38mm','30m','Quartz','Mineral',0,0,1,4.4),
('Explorer II',          1,3,'Built for cave explorers and polar researchers — 24hr hand.',            920000,0, 5, 'https://placehold.co/500x500/1A1A1A/C9A84C?text=ExplorerII',  'Men',  'White', 'Oyster Bracelet','42mm','100m','Automatic','Sapphire',1,0,0,5.0),
('Speedmaster Moonwatch',2,1,'The first watch worn on the Moon — a true legend.',                    650000,5, 10,'https://placehold.co/500x500/1A1A1A/C9A84C?text=Speedmaster', 'Men',  'Black', 'Leather','42mm','50m','Manual Wind','Hesalite',1,0,1,5.0),
('Everytime Swissmatic', 3,2,'Swiss automatic movement in a slim, minimalist case.',                  28500,10,32,'https://placehold.co/500x500/1A1A1A/C9A84C?text=Everytime',   'Unisex','Grey', 'Leather','38mm','30m','Automatic','Sapphire',0,1,0,4.6),
('Mudmaster GWG-2000',   4,3,'Triple sensor G-Shock built for off-road mud environments.',             42000,10,14,'https://placehold.co/500x500/1A1A1A/C9A84C?text=Mudmaster',   'Men',  'Khaki', 'Resin','55mm','200m','Solar+Radio','Mineral',0,0,1,4.7),
('Grand Seiko Spring',   5,1,'Snowflake dial with SBGA211 Spring Drive movement.',                   450000,0, 4, 'https://placehold.co/500x500/1A1A1A/C9A84C?text=GrandSeiko',  'Men',  'White', 'Leather','41mm','100m','Spring Drive','Sapphire',1,0,0,5.0),
('Minimalist Leather',   6,6,'Ultra-thin dress watch with genuine Italian leather strap.',              9500,0, 55,'https://placehold.co/500x500/1A1A1A/C9A84C?text=Minimalist',  'Unisex','Gold', 'Leather','36mm','30m','Quartz','Mineral',0,0,0,4.3),
('CB5040-20E Signature', 7,8,'Circular Driving Watches with GPS in a classic package.',               85000,0, 9, 'https://placehold.co/500x500/1A1A1A/C9A84C?text=Signature',   'Men',  'Black', 'Leather','44mm','100m','Eco-Drive GPS','Sapphire',0,1,0,4.8),
('Sonata Quartz Ladies', 8,6,'Sonata steel-chain bracelet — premium Indian everyday wear.',            5500,5, 80,'https://placehold.co/500x500/1A1A1A/C9A84C?text=Sonata',      'Women','Silver','Steel Bracelet','28mm','30m','Quartz','Mineral',0,0,1,4.2),
('Skydweller',           1,1,'Rolex''s most complex model — dual timezone with annual calendar.',    1850000,0, 3, 'https://placehold.co/500x500/1A1A1A/C9A84C?text=Skydweller',  'Men',  'Gold',  'Oyster Bracelet','42mm','100m','Automatic','Sapphire',1,0,0,5.0),
('Aqua Terra 150',       2,7,'Omega all-terrain dive watch with teak-pattern dial.',                  380000,0, 11,'https://placehold.co/500x500/1A1A1A/C9A84C?text=AquaTerra',   'Men',  'Blue',  'Steel Bracelet','41mm','150m','Co-Axial Auto','Sapphire',0,0,1,4.9),
('T-Touch Expert Solar', 3,5,'Tissot''s tactile solar watch with 17 functions.',                    125000,8, 7, 'https://placehold.co/500x500/1A1A1A/C9A84C?text=TTouch',      'Men',  'Titanium','Titanium','47mm','100m','Solar Quartz','Sapphire',1,0,0,4.8),
('Protrek PRW-3500',     4,3,'Triple sensor outdoor PRO-Trek for mountaineers.',                      28000,12,20,'https://placehold.co/500x500/1A1A1A/C9A84C?text=Protrek',     'Men',  'Black', 'Resin','53mm','100m','Solar','Sapphire',0,1,0,4.6),
('Astron GPS Solar',     5,5,'World''s first GPS solar watch — adjusts to local time zones.',       195000,5, 8, 'https://placehold.co/500x500/1A1A1A/C9A84C?text=Astron',      'Men',  'Titanium','Titanium','42mm','100m','GPS Solar','Sapphire',1,0,0,4.9),
('Neva Gold Ladies',     8,6,'Titan Neva premium ladies collection with diamond hour markers.',      15000,10,25,'https://placehold.co/500x500/1A1A1A/C9A84C?text=NevaGold',    'Women','Gold',  'Leather','32mm','30m','Quartz','Sapphire',0,1,0,4.6);

-- Sample User (password: User@123)
INSERT INTO Users (FullName, Email, Phone, PasswordHash, City, Country)
VALUES ('John Doe', 'john@example.com', '9876543210',
        'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f',
        'Mumbai', 'India');

-- Coupons
INSERT INTO Coupons (CouponCode, DiscountType, DiscountValue, MinOrderAmount, MaxUses, ExpiryDate, IsActive) VALUES
('CYPHER10', 'Percentage', 10, 5000,  100, '2025-12-31', 1),
('CYPHER500', 'Fixed',      500, 10000, 50,  '2025-12-31', 1),
('WELCOME15', 'Percentage', 15, 3000,  200, '2025-12-31', 1),
('LUXURY20',  'Percentage', 20, 50000, 20,  '2025-06-30', 1);

-- Sample Reviews
INSERT INTO Reviews (ProductID, UserID, Rating, ReviewText, IsApproved) VALUES
(1, 1, 5, 'Absolutely stunning watch. The craftsmanship is unparalleled!', 1),
(2, 1, 5, 'Best dive watch I have ever owned. Omega never disappoints.', 1),
(3, 1, 4, 'Great value for money Swiss automatic. Highly recommend!', 1),
(9, 1, 5, 'The Datejust is pure class. Worth every rupee.', 1);

PRINT 'CypherWatchDB created successfully with all tables and seed data.';
GO
