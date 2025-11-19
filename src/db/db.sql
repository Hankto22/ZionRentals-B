-- =============================================
-- Users Table
-- =============================================
CREATE TABLE Users (
    user_id INT IDENTITY(1,1) PRIMARY KEY,
    first_name NVARCHAR(50) NOT NULL,
    last_name NVARCHAR(50) NOT NULL,
    email NVARCHAR(100) UNIQUE NOT NULL,
    password NVARCHAR(255) NOT NULL,
    contact_phone NVARCHAR(20),
    address NVARCHAR(200),
    role NVARCHAR(20) DEFAULT 'user' CHECK (role IN ('user','attendant','admin')),
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE()
);

-- =============================================
-- Vehicle Specifications Table
-- =============================================
CREATE TABLE VehicleSpecifications (
    vehicle_spec_id INT IDENTITY(1,1) PRIMARY KEY,
    manufacturer NVARCHAR(100) NOT NULL,
    model NVARCHAR(100) NOT NULL,
    year INT NOT NULL CHECK (year >= 1990),
    fuel_type NVARCHAR(20) CHECK (fuel_type IN ('petrol','diesel','hybrid','electric')),
    engine_capacity NVARCHAR(50),
    transmission NVARCHAR(20) CHECK (transmission IN ('manual','automatic')),
    seating_capacity INT CHECK (seating_capacity > 0),
    color NVARCHAR(50),
    features NVARCHAR(500)
);

-- =============================================
-- Vehicles Table
-- =============================================
CREATE TABLE Vehicles (
    vehicle_id INT IDENTITY(1,1) PRIMARY KEY,
    vehicle_spec_id INT NOT NULL,
    rental_rate DECIMAL(10,2) NOT NULL,
    availability NVARCHAR(20) DEFAULT 'available' CHECK (availability IN ('available','reserved','rented','maintenance')),
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (vehicle_spec_id) REFERENCES VehicleSpecifications(vehicle_spec_id) ON DELETE CASCADE
);

-- =============================================
-- Locations Table
-- =============================================
CREATE TABLE Locations (
    location_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    address NVARCHAR(200) NOT NULL,
    city NVARCHAR(100),
    country NVARCHAR(100),
    created_at DATETIME2 DEFAULT GETDATE()
);

-- =============================================
-- Bookings Table
-- =============================================
CREATE TABLE Bookings (
    booking_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    vehicle_id INT NOT NULL,
    location_id INT NOT NULL,
    booking_date DATETIME2 NOT NULL,
    return_date DATETIME2 NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    booking_status NVARCHAR(20) DEFAULT 'Pending' CHECK (booking_status IN ('Pending','Confirmed','Cancelled','Completed')),
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (vehicle_id) REFERENCES Vehicles(vehicle_id) ON DELETE CASCADE,
    FOREIGN KEY (location_id) REFERENCES Locations(location_id) ON DELETE CASCADE
);

-- =============================================
-- Payments Table
-- =============================================
CREATE TABLE Payments (
    payment_id INT IDENTITY(1,1) PRIMARY KEY,
    booking_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_status NVARCHAR(20) DEFAULT 'Pending' CHECK (payment_status IN ('Pending','Paid','Failed','Refunded')),
    payment_date DATETIME2 DEFAULT GETDATE(),
    payment_method NVARCHAR(50) CHECK (payment_method IN ('cash','card','mobile_money','bank_transfer')),
    transaction_id NVARCHAR(100),
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (booking_id) REFERENCES Bookings(booking_id) ON DELETE CASCADE
);

-- =============================================
-- Support Tickets Table
-- =============================================
CREATE TABLE SupportTickets (
    ticket_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    subject NVARCHAR(200) NOT NULL,
    description NVARCHAR(MAX) NOT NULL,
    status NVARCHAR(20) DEFAULT 'Open' CHECK (status IN ('Open','In Progress','Resolved','Closed')),
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- =============================================
-- Reviews Table
-- =============================================
CREATE TABLE Reviews (
    review_id INT IDENTITY(1,1) PRIMARY KEY,
    booking_id INT NOT NULL,
    user_id INT NOT NULL,
    vehicle_id INT NOT NULL,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comment NVARCHAR(MAX),
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (booking_id) REFERENCES Bookings(booking_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (vehicle_id) REFERENCES Vehicles(vehicle_id) ON DELETE CASCADE
);

-- =============================================
-- Maintenance Table
-- =============================================
CREATE TABLE Maintenance (
    maintenance_id INT IDENTITY(1,1) PRIMARY KEY,
    vehicle_id INT NOT NULL,
    type NVARCHAR(100) NOT NULL,
    notes NVARCHAR(MAX),
    cost DECIMAL(10,2),
    status NVARCHAR(20) DEFAULT 'Scheduled' CHECK (status IN ('Scheduled','In Progress','Completed')),
    scheduled_at DATETIME2,
    completed_at DATETIME2,
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (vehicle_id) REFERENCES Vehicles(vehicle_id) ON DELETE CASCADE
);


Because of foreign keys, you must always insert into **independent tables** before dependent ones.

INSERT INTO Users (first_name, last_name, email, password, contact_phone, address, role)
VALUES 
('John', 'Doe', 'john.doe@example.com', 'hashedpassword123', '+254712345678', 'Nairobi, Kenya', 'user'),
('Mary', 'Smith', 'mary.smith@example.com', 'hashedpassword456', '+254798765432', 'Embu, Kenya', 'attendant'),
('Admin', 'User', 'admin@example.com', 'adminpassword789', '+254700000000', 'HQ Office', 'admin');


 
INSERT INTO VehicleSpecifications (manufacturer, model, year, fuel_type, engine_capacity, transmission, seating_capacity, color, features)
VALUES
('Toyota', 'Corolla', 2020, 'petrol', '1800cc', 'automatic', 5, 'White', 'Air Conditioning, Bluetooth'),
('Nissan', 'X-Trail', 2021, 'diesel', '2000cc', 'manual', 7, 'Black', '4WD, Roof Rack');


INSERT INTO Vehicles (vehicle_spec_id, rental_rate, availability)
VALUES
(1, 3500.00, 'available'), -- references Toyota Corolla spec
(2, 5000.00, 'available'); -- references Nissan X-Trail spec


 
INSERT INTO Locations (name, address, city, country)
VALUES
('Nairobi Branch', 'Westlands Road 45', 'Nairobi', 'Kenya'),
('Embu Branch', 'Kangaru Road 12', 'Embu', 'Kenya');

 
-- Booking by John Doe for Toyota Corolla at Nairobi Branch
INSERT INTO Bookings (user_id, vehicle_id, location_id, booking_date, return_date, total_amount, booking_status)
VALUES
(1, 1, 1, '2025-11-20', '2025-11-25', 17500.00, 'Confirmed');

 
-- Payment for John Doe’s booking
INSERT INTO Payments (booking_id, amount, payment_status, payment_method, transaction_id)
VALUES
(1, 17500.00, 'Paid', 'mobile_money', 'MPESA123456');



-- John Doe raises a support ticket
INSERT INTO SupportTickets (user_id, subject, description, status)
VALUES
(1, 'Late Vehicle Pickup', 'The vehicle was not ready at the scheduled pickup time.', 'Open');


 
-- John Doe reviews his booking
INSERT INTO Reviews (booking_id, user_id, vehicle_id, rating, comment)
VALUES
(1, 1, 1, 5, 'Excellent service, clean vehicle, smooth process!');



-- Maintenance record for Nissan X-Trail
INSERT INTO Maintenance (vehicle_id, type, notes, cost, status, scheduled_at)
VALUES
(2, 'Engine Service', 'Routine oil change and filter replacement', 8000.00, 'Scheduled', '2025-11-30');


