-- Запрос 1: Соединение 3+ таблиц
-- Вывод записей с данными клиента, специалиста и вакцины

SELECT 
    CONCAT(c.last_name, ' ', c.first_name) AS client_name,
    CONCAT(s.last_name, ' ', s.first_name) AS specialist_name,
    v.name AS vaccine_name,
    v.manufacturer,
    a.appointment_datetime,
    a.status
FROM appointments a
JOIN clients c ON a.client_id = c.client_id
JOIN specialists s ON a.specialist_id = a.specialist_id
JOIN vaccines v ON a.vaccine_id = v.vaccine_id
ORDER BY a.appointment_datetime;
