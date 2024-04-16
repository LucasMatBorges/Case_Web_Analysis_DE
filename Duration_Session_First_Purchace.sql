WITH FirstPurchase AS (
    SELECT
        customer_id,
        MIN(session_id) AS first_purchase_session_id
    FROM events
    WHERE type = 'placed_order'
    GROUP BY customer_id
),
TotalDurationBeforeFirstPurchase AS (
    SELECT
        s.customer_id,
        SUM(s.session_duration) AS total_duration
    FROM
        sessions s
    INNER JOIN FirstPurchase fp ON s.customer_id = fp.customer_id
    WHERE
        s.session_id <= fp.first_purchase_session_id
    GROUP BY
        s.customer_id
)
SELECT
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY total_duration) AS median_duration_before_first_purchase
FROM
    TotalDurationBeforeFirstPurchase;
