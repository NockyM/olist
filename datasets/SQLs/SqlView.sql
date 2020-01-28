CREATE VIEW v_Machine AS
SELECT 
	a.*
	, b.freight_value
	, b.price
	, b.shipping_limit_date
	, c.payment_installments
	, c.payment_sequential
	, c.payment_type
	, c.payment_value
	, d.review_score
	, d.review_creation_date
	, d.review_answer_timestamp
	, e.customer_city
	, e.customer_state
FROM dbo.orders a
INNER JOIN dbo.order_items b ON
	a.order_id = b.order_id
INNER JOIN dbo.order_payments c ON
	a.order_id = c.order_id
LEFT JOIN dbo.orders_reviews d ON
	d.order_id = a.order_id
LEFT JOIN dbo.customers e ON
	e.customer_id = a.customer_id