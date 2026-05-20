-- ФАЙЛ: sql/schema_variant15.sql
-- =====================================================
-- БАЗА ДАННЫХ: Запись на вакцинацию (Вариант 15)
-- СУБД: MySQL 8.0+
-- =====================================================

DROP DATABASE IF EXISTS vaccination_booking_variant15;
CREATE DATABASE vaccination_booking_variant15 
    CHARACTER SET utf8mb4 
    COLLATE utf8mb4_unicode_ci;
USE vaccination_booking_variant15;

-- ТАБЛИЦА: Клиенты
CREATE TABLE clients (
    client_id INT AUTO_INCREMENT PRIMARY KEY,
    last_name VARCHAR(50) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    patronymic VARCHAR(50),
    phone VARCHAR(20) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    birth_date DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ТАБЛИЦА: Согласие родителей
CREATE TABLE parent_consents (
    consent_id INT AUTO_INCREMENT PRIMARY KEY,
    client_id INT NOT NULL UNIQUE,
    parent_last_name VARCHAR(50) NOT NULL,
    parent_first_name VARCHAR(50) NOT NULL,
    parent_phone VARCHAR(20) NOT NULL,
    consent_date DATE NOT NULL,
    document_number VARCHAR(50),
    FOREIGN KEY (client_id) REFERENCES clients(client_id) 
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ТАБЛИЦА: Вакцины
CREATE TABLE vaccines (
    vaccine_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    vaccine_type ENUM('живая', 'инактивированная', 'мРНК', 'векторная', 'субъединичная') NOT NULL,
    manufacturer VARCHAR(100) NOT NULL,
    doses_per_package INT NOT NULL CHECK (doses_per_package > 0),
    stock_quantity INT NOT NULL DEFAULT 0 CHECK (stock_quantity >= 0),
    expiration_date DATE NOT NULL,
    price DECIMAL(10,2) NOT NULL CHECK (price > 0),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ТАБЛИЦА: Специалисты
CREATE TABLE specialists (
    specialist_id INT AUTO_INCREMENT PRIMARY KEY,
    last_name VARCHAR(50) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    specialization ENUM('терапевт', 'иммунолог', 'педиатр', 'инфекционист') NOT NULL,
    phone VARCHAR(20) NOT NULL,
    cabinet_number INT NOT NULL CHECK (cabinet_number BETWEEN 1 AND 50),
    is_active BOOLEAN DEFAULT TRUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ТАБЛИЦА: Записи
CREATE TABLE appointments (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    client_id INT NOT NULL,
    specialist_id INT NOT NULL,
    vaccine_id INT NOT NULL,
    appointment_datetime DATETIME NOT NULL,
    status ENUM('запланировано', 'проведено', 'отменено', 'завершено') DEFAULT 'запланировано',
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (client_id) REFERENCES clients(client_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (specialist_id) REFERENCES specialists(specialist_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (vaccine_id) REFERENCES vaccines(vaccine_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    UNIQUE KEY unique_specialist_slot (specialist_id, appointment_datetime)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ТАБЛИЦА: Побочные реакции
CREATE TABLE side_effects (
    effect_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT NOT NULL,
    effect_name VARCHAR(100) NOT NULL,
    severity ENUM('лёгкая', 'средняя', 'тяжёлая') NOT NULL,
    description TEXT,
    reported_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    resolved BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ТАБЛИЦА: Оплата
CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT NOT NULL UNIQUE,
    amount DECIMAL(10,2) NOT NULL CHECK (amount > 0),
    payment_method ENUM('наличные', 'карта', 'онлайн', 'страховка') NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('ожидает', 'успешно', 'отклонён', 'возврат') DEFAULT 'ожидает',
    transaction_id VARCHAR(100),
    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ИНДЕКСЫ
CREATE INDEX idx_appointments_datetime ON appointments(appointment_datetime);
CREATE INDEX idx_appointments_client ON appointments(client_id);
CREATE INDEX idx_appointments_status ON appointments(status);
CREATE INDEX idx_vaccines_expiration ON vaccines(expiration_date);
CREATE INDEX idx_vaccines_stock ON vaccines(stock_quantity);
CREATE INDEX idx_clients_birthdate ON clients(birth_date);
