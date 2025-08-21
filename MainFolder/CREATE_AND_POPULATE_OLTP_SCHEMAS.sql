-- Create Database
CREATE DATABASE RetailDB;
 USE RetailDB;
 -- =====================================================
-- RetailDB OLTP Schema in SQL SERVER
-- =====================================================

-- Customers Table
CREATE TABLE Customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) UNIQUE,
    Phone NVARCHAR(20),
    [Address] NVARCHAR(255)
);

-- Products Table
CREATE TABLE Products (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    Category NVARCHAR(50),
    Price DECIMAL(10,2) NOT NULL,
    StockQty INT DEFAULT 0
);

-- Orders Table
CREATE TABLE Orders (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    OrderDate DATETIME DEFAULT GETDATE(),
    Status NVARCHAR(20) DEFAULT 'Pending',
    CONSTRAINT FK_Orders_Customer FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- OrderDetails Table
CREATE TABLE OrderDetails (
    OrderDetailID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,
    CONSTRAINT FK_OrderDetails_Order FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    CONSTRAINT FK_OrderDetails_Product FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Suppliers Table
CREATE TABLE Suppliers (
    SupplierID INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    ContactInfo NVARCHAR(255)
);

-- Inventory Table
CREATE TABLE Inventory (
    InventoryID INT IDENTITY(1,1) PRIMARY KEY,
    ProductID INT NOT NULL,
    SupplierID INT NOT NULL,
    Quantity INT NOT NULL,
    LastRestockDate DATETIME,
    CONSTRAINT FK_Inventory_Product FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    CONSTRAINT FK_Inventory_Supplier FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID)
	);
   
-- =====================================================
-- INSERT SAMPLE DATA INTO RetailDB (SQL Server)
-- =====================================================
-- Insert Customers 
INSERT INTO Customers (Name, Email, Phone, Address) VALUES
('John Doe', 'john.doe@email.com', '555-1234', '123 Main St'),
('Jane Smith', 'jane.smith@email.com', '555-5678', '456 Oak Ave'),
('Michael Johnson', 'michael.j@email.com', '555-9012', '789 Pine Rd'),
('Emily Davis', 'emily.d@email.com', '555-3456', '321 Maple Blvd'),
('David Brown', 'david.b@email.com', '555-7890', '654 Birch Ln');

-- Insert Suppliers
INSERT INTO Suppliers (Name, ContactInfo) VALUES
('TechSource Ltd', 'techsource@email.com, +1-555-1000'),
('GadgetWorld Inc', 'gadgetworld@email.com, +1-555-2000'),
('OfficeMart Supplies', 'officemart@email.com, +1-555-3000');

-- Insert Products (assume SupplierID exists)
INSERT INTO Products (Name, Category, Price, StockQty) VALUES
('Laptop Pro 15', 'Electronics', 1200.00, 50),
('Wireless Mouse', 'Accessories', 25.50, 200),
('Mechanical Keyboard', 'Accessories', 80.00, 150),
('Office Chair', 'Furniture', 180.00, 75),
('USB-C Hub', 'Electronics', 40.00, 100);

-- Insert Inventory (mapping products to suppliers)
INSERT INTO Inventory (ProductID, SupplierID, Quantity, LastRestockDate) VALUES
(1, 1, 50, '2025-07-01'),
(2, 2, 200, '2025-07-10'),
(3, 2, 150, '2025-07-15'),
(4, 3, 75, '2025-07-20'),
(5, 1, 100, '2025-07-25');

-- Insert Orders (linked to Customers)
INSERT INTO Orders (CustomerID, OrderDate, Status) VALUES
(1, '2025-08-01', 'Completed'),
(2, '2025-08-02', 'Completed'),
(3, '2025-08-03', 'Pending'),
(4, '2025-08-04', 'Completed'),
(5, '2025-08-05', 'Shipped');

-- Insert OrderDetails (must match valid OrderID and ProductID)
INSERT INTO OrderDetails (OrderID, ProductID, Quantity, UnitPrice) VALUES
(1, 1, 1, 1200.00),   -- John bought a Laptop
(1, 2, 2, 25.50),     -- John also bought 2 Mice
(2, 3, 1, 80.00),     -- Jane bought a Keyboard
(2, 5, 1, 40.00),     -- Jane bought a USB-C Hub
(3, 4, 1, 180.00),    -- Michael ordered an Office Chair (Pending)
(4, 2, 3, 25.50),     -- Emily bought 3 Mice
(5, 1, 1, 1200.00),   -- David ordered a Laptop
(5, 5, 2, 40.00);     -- David ordered 2 USB-C Hubs
