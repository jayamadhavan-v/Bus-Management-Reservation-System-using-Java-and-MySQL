-- createing db 

  create database bus_rs;

-- using db  

use bus_rs;

-- ----------------------------------------------bus table-------------------------------
create table bus (
    bus_id int primary key auto_increment,
    bus_name varchar(50),
    source VARCHAR(50),
    destination VARCHAR(50),
    total_seats INT,
    available_seats INT,
    fare double
);

-- using store prodecure for inserting value into table 

DROP PROCEDURE IF EXISTS  BusData;
DELIMITER $$

CREATE PROCEDURE BusData(
    IN b_name VARCHAR(30),
    IN b_source VARCHAR(30),
    IN b_destination VARCHAR(30),
    IN b_total_seats INT,
    IN b_available_seats INT,
    IN b_fare DOUBLE,
    OUT bus_id int 
)
BEGIN
    INSERT INTO bus (bus_name, source, destination, total_seats, available_seats, fare)
    VALUES (b_name, b_source, b_destination, b_total_seats, b_available_seats, b_fare);
    SET bus_id = LAST_INSERT_ID();
END $$

DELIMITER ;

-- check bus info 

DROP PROCEDURE IF EXISTS GetdataQ;

delimiter $$ 
CREATE PROCEDURE GetdataQ(
    IN p_bus_name VARCHAR(50),
    IN p_bus_id INT,
    inout p_result VARCHAR(100)
)
BEGIN
    IF p_bus_name IS NOT NULL THEN
        SELECT CONCAT(' ', available_seats) INTO p_result
        FROM bus
        WHERE bus_name = p_bus_name
        LIMIT 1;
    ELSEIF p_bus_id IS NOT NULL  THEN
        SELECT bus_name INTO p_result
        FROM bus
        WHERE bus_id = p_bus_id
        LIMIT 1;
    ELSE
        SET p_result = 'Invalid input';
    END IF;
END $$
delimiter ;

SHOW CREATE PROCEDURE GetdataQ;

-- driver table 

DROP  TABLE IF EXISTS  driver; 

CREATE TABLE driver (
    driver_id INT PRIMARY KEY AUTO_INCREMENT,
    d_name VARCHAR(50) NOT NULL,
    d_gender VARCHAR(10),
    d_age INT CHECK (d_age > 18),
    d_phoneNo bigint UNIQUE NOT NULL,
    license_number VARCHAR(30) UNIQUE NOT NULL
);

-- Store Procedure for driver 

DROP PROCEDURE IF EXISTS setDriverInfo;
DELIMITER $$

CREATE PROCEDURE setDriverInfo(
    IN dr_name VARCHAR(50),
    IN dr_gender VARCHAR(10),
    IN dr_age INT,
    IN dr_phoneNo bigint,
    IN dr_license_number VARCHAR(30),
    OUT driver_id INT
)
BEGIN
    INSERT INTO driver (d_name, d_gender, d_age, d_phoneNo, license_number)
    VALUES (dr_name, dr_gender, dr_age, dr_phoneNo, dr_license_number);
    SET driver_id = LAST_INSERT_ID();
END $$

DELIMITER ;

-- ------------------------------------passenger table ---------------------------------------

DROP TABLE IF EXISTS passenger;

CREATE TABLE passenger (
    passenger_id INT PRIMARY KEY AUTO_INCREMENT,
    p_name VARCHAR(50) NOT NULL,
    p_gender VARCHAR(10),
    p_age INT CHECK (p_age > 0),
    p_phoneNo BIGINT UNIQUE NOT NULL,
    p_email VARCHAR(100)
);


-- insert pasenger 

DROP PROCEDURE IF EXISTS AddPassenger;

DELIMITER $$

CREATE PROCEDURE AddPassenger(
    IN p_name VARCHAR(100),
    IN p_gender VARCHAR(10),
    IN p_age INT,
    IN p_phoneNo BIGINT,
    IN p_email VARCHAR(100),
    OUT p_passenger_id INT
)
BEGIN
    INSERT INTO passenger (p_name, p_gender, p_age, p_phoneNo, p_email)
    VALUES (p_name, p_gender, p_age, p_phoneNo, p_email);
    SET p_passenger_id = LAST_INSERT_ID();
END $$

DELIMITER ;

-- view
 
DROP PROCEDURE IF EXISTS ViewAllPassengers;

DELIMITER $$

CREATE PROCEDURE ViewAllPassengers()
BEGIN
    SELECT * FROM passenger;
END $$

DELIMITER ;

-- update passsenger

DROP PROCEDURE IF EXISTS UpdatePassenger;

DELIMITER $$

CREATE PROCEDURE UpdatePassenger(
    IN in_id INT,
    IN in_name VARCHAR(100),
    IN in_gender VARCHAR(10),
    IN in_age INT,
    IN in_phoneNo BIGINT,
    IN in_email VARCHAR(100)
)
BEGIN
    UPDATE passenger
    SET 
        p_name = in_name,
        p_gender = in_gender,
        p_age = in_age,
        p_phoneNo = in_phoneNo,
        p_email = in_email
    WHERE passenger_id = in_id;
END $$

DELIMITER ;

-- delete 

DROP PROCEDURE IF EXISTS DeletePassenger;

DELIMITER $$

CREATE PROCEDURE DeletePassenger(IN in_id INT)
BEGIN
    DELETE FROM passenger WHERE passenger_id = in_id;
END $$

DELIMITER ;


-- -----------------------------------booking table-------------------------------------------

DROP table  IF EXISTS   booking; 

CREATE TABLE booking (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,
    passenger_id INT NOT NULL,
    bus_id INT NOT NULL,
    seat_no INT unique NULL,
    travel_date DATE NOT NULL,
    booking_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'Booked',
    FOREIGN KEY (passenger_id) REFERENCES passenger(passenger_id) ON DELETE CASCADE,
    FOREIGN KEY (bus_id) REFERENCES bus(bus_id) ON DELETE CASCADE
);


-- add booking 
DROP PROCEDURE IF EXISTS AddNewPassengerWithBooking;
DELIMITER $$

CREATE PROCEDURE AddNewPassengerWithBooking(
    -- Passenger details
    IN in_p_name VARCHAR(100),
    IN in_p_gender VARCHAR(10),
    IN in_p_age INT,
    IN in_p_phoneNo BIGINT,
    IN in_p_email VARCHAR(100),

    -- Booking details
    IN in_bus_id INT,
    IN in_seat_no INT,
    IN in_travel_date DATE,
    IN in_status VARCHAR(20),

    -- Outputs
    OUT out_passenger_id INT,
    OUT out_booking_id INT
)
BEGIN
    DECLARE available INT;

    -- ✅ 1️⃣ Insert new passenger first
    INSERT INTO passenger (p_name, p_gender, p_age, p_phoneNo, p_email)
    VALUES (in_p_name, in_p_gender, in_p_age, in_p_phoneNo, in_p_email);

    SET out_passenger_id = LAST_INSERT_ID();

    -- ✅ 2️⃣ Check bus availability
    SELECT available_seats INTO available
    FROM bus
    WHERE bus_id = in_bus_id;

    IF available IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Bus not found';
    ELSEIF available < 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No available seats for this bus';
    ELSE
        -- ✅ 3️⃣ Insert booking
        INSERT INTO booking (passenger_id, bus_id, seat_no, travel_date, status)
        VALUES (out_passenger_id, in_bus_id, in_seat_no, in_travel_date, in_status);
        
        SET out_booking_id = LAST_INSERT_ID();

        -- ✅ 4️⃣ Decrease available seats in bus
        UPDATE bus
        SET available_seats = available_seats - 1
        WHERE bus_id = in_bus_id;
    END IF;
END $$

DELIMITER ;

-- view all Booking 

DROP PROCEDURE IF EXISTS ViewAllBookings;
DELIMITER $$

CREATE PROCEDURE ViewAllBookings()
BEGIN
    SELECT 
        b.booking_id,
        p.p_name AS passenger_name,
        bs.bus_name AS bus_name,
        b.seat_no,
        b.travel_date,
        b.booking_date,
        b.status
    FROM booking b
    JOIN passenger p ON b.passenger_id = p.passenger_id
    JOIN bus bs ON b.bus_id = bs.bus_id
    ORDER BY b.booking_date DESC;
END $$

DELIMITER ;

-- get booking by passenger id 

DROP PROCEDURE IF EXISTS GetBookingsByPassengerId;
DELIMITER $$

CREATE PROCEDURE GetBookingsByPassengerId(IN in_passenger_id INT)
BEGIN
    SELECT 
        b.booking_id,
        p.p_name AS passenger_name,
        bs.bus_name AS bus_name,
        b.seat_no,
        b.travel_date,
        b.booking_date,
        b.status
    FROM booking b
    JOIN passenger p ON b.passenger_id = p.passenger_id
    JOIN bus bs ON b.bus_id = bs.bus_id
    WHERE b.passenger_id = in_passenger_id
    ORDER BY b.booking_date DESC;
END $$

DELIMITER ;

-- cancel a booking 

DROP PROCEDURE IF EXISTS CancelBooking;
DELIMITER $$

CREATE PROCEDURE CancelBooking(IN in_booking_id INT)
BEGIN
    DECLARE busId INT;
    DECLARE currentStatus VARCHAR(20);

    -- Get bus ID and status for this booking
    SELECT bus_id, status INTO busId, currentStatus
    FROM booking
    WHERE booking_id = in_booking_id;

    -- If booking doesn't exist
    IF busId IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Booking not found';
    ELSEIF currentStatus = 'Cancelled' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Booking already cancelled';
    ELSE
        -- Update booking status
        UPDATE booking
        SET status = 'Cancelled'
        WHERE booking_id = in_booking_id;

        -- Restore seat count
        UPDATE bus
        SET available_seats = available_seats + 1
        WHERE bus_id = busId;
    END IF;
END $$

DELIMITER ;

-- delete booking 

DROP PROCEDURE IF EXISTS DeleteBooking;
DELIMITER $$

CREATE PROCEDURE DeleteBooking(IN in_booking_id INT)
BEGIN
    DELETE FROM booking WHERE booking_id = in_booking_id;
END $$

DELIMITER ;

call DeleteBooking(3);

-- ------------------------------------------  employee --------------------------------------

DROP TABLE IF EXISTS employee;

CREATE TABLE employee (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    e_name VARCHAR(50) NOT NULL,
    e_gender VARCHAR(10),
    e_age INT CHECK (p_age > 0),
    e_phoneNo BIGINT UNIQUE NOT NULL,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(100) NOT NULL,
    role ENUM('MANAGER', 'ADMIN') NOT NULL,
    admin_code VARCHAR(20),
    email VARCHAR(100) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ----------------------------------------- Employee-login ----------------------------------

DROP TABLE IF EXISTS employee_login;

CREATE TABLE employee_login (
    login_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT NOT NULL,
    status ENUM('ACTIVE', 'INACTIVE', 'LOGGED_OUT') DEFAULT 'ACTIVE',
    login_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP NULL,
    FOREIGN KEY (employee_id) REFERENCES employee(employee_id) ON DELETE CASCADE
);

--  up to this completed 

--   ------------------------------------testing----------------------------------------------

-- Clear existing data (optional)
DELETE FROM employee;

-- Insert sample Admins
INSERT INTO employee (username, password, role, admin_code, email)
VALUES
('admin1', 'a1234', 'ADMIN', 'ADM001', 'admin1@brs.com'),
('admin2', 'a5678', 'ADMIN', 'ADM002', 'admin2@brs.com');

-- Insert sample Managers
INSERT INTO employee (username, password, role, admin_code, email)
VALUES
('manager1', 'm1234', 'MANAGER', NULL, 'manager1@brs.com'),
('manager2', 'm5678', 'MANAGER', NULL, 'manager2@brs.com');


CALL ViewAllBookings();

CALL AddBooking(1, 2, 15, '2025-11-10', 'Booked', @bid);
SELECT @bid;


CALL AddPassenger('Ravi Kumar', 'Male', 28, 9876543210, 'ravi@gmail.com', @pid);
SELECT @pid;

CALL BusData('KPN Travels', 'Chennai', 'Coimbatore', 40, 40, 750, @busid);
SELECT @busid;

CALL AddNewPassengerWithBooking(
    'Arjun Kumar',       -- Name
    'Male',              -- Gender
    24,                  -- Age
    9876543200,          -- Phone
    'arjun@gmail.com',   -- Email
    2,                   -- Bus ID
    8,                   -- Seat No
    '2025-11-15',        -- Travel date
    'Booked',            -- Status
    @pid,                -- OUT passenger_id
    @bid                 -- OUT booking_id
);

SELECT @pid AS PassengerID, @bid AS BookingID;
SELECT * FROM passenger WHERE passenger_id = @pid;
SELECT * FROM booking WHERE booking_id = @bid;



USE bus_rs;
SHOW PROCEDURE STATUS WHERE Db =  bus_rs;

select * from booking;
select * from  passenger;
select * from bus;
select * from driver;