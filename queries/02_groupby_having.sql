-- Запрос 2: Группировка с HAVING
-- Статистика по специалистам: количество записей и завершённых вакцинаций

SELECT 
    CONCAT(s.last_name, ' ', LEFT(s.first_name, 1), '.') AS specialist,
    s.specialization,
    COUNT(a.appointment_id) AS total_appointments,
    SUM(CASE WHEN a.status = 'проведено' THEN 1 ELSE 0 END) AS completed
FROM specialists s
LEFT JOIN appointments a ON s.specialist_id = a.specialist_id
GROUP BY s.specialist_id
HAVING total_appointments > 0
ORDER BY total_appointments DESC;
