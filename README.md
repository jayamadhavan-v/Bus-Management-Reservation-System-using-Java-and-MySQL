# Bus Management & Reservation System (Java & MySQL)

A complete console-based Bus Reservation & Management System built using **Java, JDBC, and MySQL**.  
It provides secure role-based login, bus management, and ticket booking with clean architecture and validated database operations.

---

## 🏷️ Badges
![Java](https://img.shields.io/badge/Java-17-orange)
![MySQL](https://img.shields.io/badge/MySQL-Database-blue)
![JDBC](https://img.shields.io/badge/JDBC-Connector-yellow)
![Status](https://img.shields.io/badge/Status-Active-brightgreen)
![License](https://img.shields.io/badge/License-MIT-lightgrey)

---

## 🚍 Features

### 🔐 Role-Based Login
- Admin login  
- Manager login  
- Secure credential validation via MySQL DB

### 🚌 Bus Management
- Add new bus  
- Update bus details  
- Delete bus  
- View all buses  
- Manage routes, timings, and seats  

### 🎫 Ticket Reservation
- Book tickets  
- Check seat availability  
- Cancel bookings  
- Generate unique Booking IDs  
- Manage passenger details  

### 💽 Database Integration
- MySQL + JDBC  
- DAO design pattern  
- Prevents SQL injection using PreparedStatements  
- Validations & exception handling  

---
## 📁 Project Structure

Use this tree in README to show folders and responsibilities:

```text
src/
├── dao/            # CRUD operations for each entity (BusDAO, BookingDAO, PassengerDAO, ManagerDAO)
├── model/          # POJOs / Entity classes (Bus.java, Booking.java, Passenger.java, Manager.java)
├── service/        # Business logic / Services (BookingService, BusService, AuthService)
├── util/           # Utilities (DBConnection.java, ValidationUtils.java)
└── main/           # Main app & menu handlers (Main.java, AdminMenu.java, ManagerMenu.java)
```
## 🗃️ ER Diagram (Conceptual)
```
+------------------+        +--------------------+        +----------------------+
|   bus_details    | 1    * |   booking_details  | *    1 |  passenger_details   |
|------------------|--------|--------------------|--------|----------------------|
| bus_id (PK)      |        | booking_id (PK)    |        | passenger_id (PK)    |
| bus_name         |        | bus_id (FK)        |        | name                 |
| route            |        | passenger_id (FK)  |        | age                  |
| timing           |        | seat_no            |        | mobile               |
| total_seats      |        | booking_date       |        +----------------------+
+------------------+        +--------------------+

---
```

## ⚙️ How to Run the Project

### 1️⃣ Clone the Repository
```bash
https://github.com/jayamadhavan-v/Bus-Management-Reservation-System-using-Java-and-MySQL

2️⃣ Import into IntelliJ IDEA / Eclipse
3️⃣ Add MySQL JDBC Driver

Download MySQL Connector/J → Add to project libraries.

4️⃣ Setup MySQL Database
CREATE DATABASE bus_system;
USE bus_system;

CREATE TABLE manager_login (
    manager_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50),
    password VARCHAR(50)
);

CREATE TABLE bus_details (
    bus_id INT AUTO_INCREMENT PRIMARY KEY,
    bus_name VARCHAR(100),
    route VARCHAR(100),
    timing VARCHAR(50),
    total_seats INT
);

CREATE TABLE passenger_details (
    passenger_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    age INT,
    mobile VARCHAR(20)
);

CREATE TABLE booking_details (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,
    bus_id INT,
    passenger_id INT,
    seat_no INT,
    FOREIGN KEY (bus_id) REFERENCES bus_details(bus_id),
    FOREIGN KEY (passenger_id) REFERENCES passenger_details(passenger_id)
);

5️⃣ Configure DB Credentials
Class.forName("com.mysql.cj.jdbc.Driver");
Connection con = DriverManager.getConnection(
    "jdbc:mysql://localhost:3306/bus_system",
    "root",
    "yourpassword"
);
```

6️⃣ Run Main Class

Start the application using the main program from the main package.

🧪 Sample Console Output
=== BUS RESERVATION SYSTEM ===

1. Admin Login
2. Manager Login
3. Exit
Enter your choice: 1

Username: admin  
Password: ****  

Login Successful!

1. Add Bus
2. View Bus List
3. Book Ticket
4. Logout

⭐ Future Enhancements

Web version using JSP/Servlet or Spring Boot

Passenger login system

Email/SMS booking confirmation

Payment integration

Seat layout visualization

🤝 Contributing

Pull requests are welcome!
Feel free to open issues for bugs or suggestions.

📜 License

This project is licensed under the MIT License.

⭐ Support

If you found this helpful, consider giving the repository a star ⭐.


