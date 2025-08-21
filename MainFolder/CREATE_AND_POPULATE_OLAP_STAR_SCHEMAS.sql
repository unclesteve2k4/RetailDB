USE Retaildb;
--- =====================================================
-- Create RetailDB Star Schema in SQL Server
-- =====================================================

-- Drop tables if they exist (drop fact table first because of FKs)
IF OBJECT_ID('dbo.FactSales', 'U') IS NOT NULL DROP TABLE dbo.FactSales;
IF OBJECT_ID('dbo.DimProduct', 'U') IS NOT NULL DROP TABLE dbo.DimProduct;
IF OBJECT_ID('dbo.DimSupplier', 'U') IS NOT NULL DROP TABLE dbo.DimSupplier;
IF OBJECT_ID('dbo.DimCustomer', 'U') IS NOT NULL DROP TABLE dbo.DimCustomer;
IF OBJECT_ID('dbo.DimDate', 'U') IS NOT NULL DROP TABLE dbo.DimDate;

-- =====================================================
-- Dimension Tables
-- =====================================================

-- Date Dimension
CREATE TABLE DimDate (
    DateID       INT IDENTITY(1,1) PRIMARY KEY,
    [Date]       DATE NOT NULL,
    [Day]        INT,
    [Month]      INT,
    [Quarter]    INT,
    [Year]       INT
);

-- Customer Dimension
CREATE TABLE DimCustomer (
    CustomerID   INT IDENTITY(1,1) PRIMARY KEY,
    [Name]       NVARCHAR(100) NOT NULL,
    Email        NVARCHAR(100),
    Phone        NVARCHAR(50),
    [Address]    NVARCHAR(255)
);


-- Supplier Dimension
CREATE TABLE DimSupplier (
    SupplierID   INT IDENTITY(1,1) PRIMARY KEY,
    [Name]       NVARCHAR(100) NOT NULL,
    ContactInfo  NVARCHAR(255)
);

-- Product Dimension
CREATE TABLE DimProduct (
    ProductID    INT IDENTITY(1,1) PRIMARY KEY,
    [Name]       NVARCHAR(100) NOT NULL,
    Category     NVARCHAR(50),
    SupplierID   INT,
    Price        DECIMAL(10,2),
    CONSTRAINT FK_Product_Supplier FOREIGN KEY (SupplierID) REFERENCES DimSupplier(SupplierID)
);

-- =====================================================
-- Fact Table
-- =====================================================

CREATE TABLE FactSales (
    SaleID       INT IDENTITY(1,1) PRIMARY KEY,
    DateID       INT NOT NULL,
    CustomerID   INT NOT NULL,
    ProductID    INT NOT NULL,
    Quantity     INT NOT NULL,
    TotalAmount  DECIMAL(12,2) NOT NULL,
    CONSTRAINT FK_Sales_Date FOREIGN KEY (DateID) REFERENCES DimDate(DateID),
    CONSTRAINT FK_Sales_Customer FOREIGN KEY (CustomerID) REFERENCES DimCustomer(CustomerID),
    CONSTRAINT FK_Sales_Product FOREIGN KEY (ProductID) REFERENCES DimProduct(ProductID)
);

-- =====================================================
-- Sample Inserts
-- =====================================================

-- Suppliers
INSERT INTO DimSupplier ([Name], ContactInfo) 
VALUES ('Tech Supplies Inc.', 'tech@supplies.com'),
       ('Fashion Hub Ltd.', 'contact@fashionhub.com');

-- Products
INSERT INTO DimProduct ([Name], Category, SupplierID, Price) 
VALUES ('Laptop', 'Electronics', 1, 899.99),
       ('T-Shirt', 'Clothing', 2, 19.99);

-- Customers
INSERT INTO DimCustomer ([Name], Email, Phone, [Address]) 
VALUES ('Alice Johnson', 'alice@mail.com', '123-456-7890', '123 Main St'),
       ('Bob Smith', 'bob@mail.com', '987-654-3210', '456 Elm St');

-- Dates
INSERT INTO DimDate ([Date], [Day], [Month], [Quarter], [Year]) 
VALUES ('2025-08-01', 1, 8, 3, 2025),
       ('2025-08-02', 2, 8, 3, 2025);

-- Sales (Fact table)
INSERT INTO FactSales (DateID, CustomerID, ProductID, Quantity, TotalAmount) 
VALUES (1, 1, 1, 1, 899.99),  -- Alice bought a Laptop
       (2, 2, 2, 3, 59.97);  -- Bob bought 3 T-Shirts
