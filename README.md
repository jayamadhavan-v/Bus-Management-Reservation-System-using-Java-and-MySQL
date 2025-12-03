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

## 🧱 Project Structure

src/
├── dao/ # CRUD operations for each entity
├── model/ # POJO classes (Bus, Manager, Passenger, Booking)
├── service/ # Business logic layer
├── util/ # DB connection + helpers
└── main/ # Main program & menu handlers
