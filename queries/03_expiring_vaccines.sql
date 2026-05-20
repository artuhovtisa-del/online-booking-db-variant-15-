-- Запрос 3: Вакцины, срок годности которых истекает через месяц
-- Требуется по заданию Варианта 15

SELECT 
    name,
    manufacturer,
    vaccine_type,
    stock_quantity,
    expiration_date,
    DATEDIFF(expiration_date, CURDATE()) AS days_until_expiration
FROM vaccines
WHERE expiration_date BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 1 MONTH)
ORDER BY expiration_date ASC;
