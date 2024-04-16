WITH PurchaseSessions AS (
    SELECT
        customer_id,
        session_id,
        type,
        LAG(session_id, 1) OVER (PARTITION BY customer_id ORDER BY session_id) AS previous_session_id
    FROM events
    WHERE type = 'placed_order'
),
SessionCounts AS (
    SELECT
        customer_id,
        session_id,
        COALESCE(previous_session_id, 0) AS previous_session_id
    FROM PurchaseSessions
),
SessionCalculations AS (
    SELECT
        sc.customer_id,
        sc.session_id AS purchase_session_id,
        (
            SELECT COUNT(*)
            FROM sessions
            WHERE sessions.customer_id = sc.customer_id
            AND sessions.session_id <= sc.session_id
            AND (sessions.session_id > sc.previous_session_id OR sc.previous_session_id = 0)
        ) AS sessions_before_purchase
    FROM SessionCounts sc
)
SELECT
    avg(sessions_before_purchase)

FROM SessionCalculations;


