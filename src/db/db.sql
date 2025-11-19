--  Users Table
CREATE TABLE users (
    user_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    contact_phone VARCHAR(20),
    address TEXT,
    role VARCHAR(20) DEFAULT 'user' CHECK (role IN ('user', 'attendant', 'admin')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

--  Vehicle Specification Table
CREATE TABLE vehicle_specifications (
    vehicle_spec_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    manufacturer VARCHAR(100) NOT NULL,
    model VARCHAR(100) NOT NULL,
    year INT NOT NULL CHECK (year >= 1990),
    fuel_type VARCHAR(20) CHECK (fuel_type IN ('petrol','diesel','hybrid','electric')),
    engine_capacity VARCHAR(50),
    transmission VARCHAR(20) CHECK (transmission IN ('manual','automatic')),
    seating_capacity INT CHECK (seating_capacity > 0),
    color VARCHAR(50),
    features TEXT
);

--  Vehicles Table
CREATE TABLE vehicles (
    vehicle_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    vehicle_spec_id UUID NOT NULL,
    rental_rate NUMERIC(10,2) NOT NULL,
    availability VARCHAR(20) DEFAULT 'available' CHECK (availability IN ('available','reserved','rented','maintenance')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_vehicle_spec FOREIGN KEY (vehicle_spec_id) REFERENCES vehicle_specifications(vehicle_spec_id) ON DELETE CASCADE
);

--  Locations Table
CREATE TABLE locations (
    location_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL,
    address TEXT NOT NULL,
    city VARCHAR(100),
    country VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

--  Bookings Table
CREATE TABLE bookings (
    booking_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    vehicle_id UUID NOT NULL,
    location_id UUID NOT NULL,
    booking_date TIMESTAMP NOT NULL,
    return_date TIMESTAMP NOT NULL,
    total_amount NUMERIC(10,2) NOT NULL,
    booking_status VARCHAR(20) DEFAULT 'Pending' CHECK (booking_status IN ('Pending','Confirmed','Cancelled','Completed')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_booking_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_booking_vehicle FOREIGN KEY (vehicle_id) REFERENCES vehicles(vehicle_id) ON DELETE CASCADE,
    CONSTRAINT fk_booking_location FOREIGN KEY (location_id) REFERENCES locations(location_id) ON DELETE CASCADE
);

--  Payments Table
CREATE TABLE payments (
    payment_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    booking_id UUID NOT NULL,
    amount NUMERIC(10,2) NOT NULL,
    payment_status VARCHAR(20) DEFAULT 'Pending' CHECK (payment_status IN ('Pending','Paid','Failed','Refunded')),
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_method VARCHAR(50) CHECK (payment_method IN ('cash','card','mobile_money','bank_transfer')),
    transaction_id VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_payment_booking FOREIGN KEY (booking_id) REFERENCES bookings(booking_id) ON DELETE CASCADE
);

--  Customer Support Tickets Table
CREATE TABLE support_tickets (
    ticket_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    subject VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,
    status VARCHAR(20) DEFAULT 'Open' CHECK (status IN ('Open','In Progress','Resolved','Closed')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_ticket_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

--  Reviews Table
CREATE TABLE reviews (
    review_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    booking_id UUID NOT NULL,
    user_id UUID NOT NULL,
    vehicle_id UUID NOT NULL,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_review_booking FOREIGN KEY (booking_id) REFERENCES bookings(booking_id) ON DELETE CASCADE,
    CONSTRAINT fk_review_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_review_vehicle FOREIGN KEY (vehicle_id) REFERENCES vehicles(vehicle_id) ON DELETE CASCADE
);

-- Maintenance Table
CREATE TABLE maintenance (
    maintenance_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    vehicle_id UUID NOT NULL,
    type VARCHAR(100) NOT NULL,
    notes TEXT,
    cost NUMERIC(10,2),
    status VARCHAR(20) DEFAULT 'Scheduled' CHECK (status IN ('Scheduled','In Progress','Completed')),
    scheduled_at TIMESTAMP,
    completed_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_maintenance_vehicle FOREIGN KEY (vehicle_id) REFERENCES vehicles(vehicle_id) ON DELETE CASCADE
);
