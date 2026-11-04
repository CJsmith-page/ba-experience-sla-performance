-- The core query: join the systems and flag each delivery
-- Simplified: simplified, with invented table and column names.

SELECT r.request_id,
       r.customer_id,
       j.sla_due_at,
       d.delivered_at,
       CASE WHEN d.delivered_at IS NOT NULL
             AND d.delivered_at <= j.sla_due_at
            THEN 'On time' ELSE 'Late' END AS sla_status
       -- plus minutes_late, counted in the customer's business calendar
FROM requests r                         -- Salesforce
JOIN tickets j    ON j.request_id = r.request_id   -- Jira
LEFT JOIN deliveries d ON d.request_id = r.request_id  -- undelivered stays in, as Late
