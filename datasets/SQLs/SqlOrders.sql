drop table IF EXISTS dbo.orders;
GO

create table orders(
    order_id varchar(32) NOT NULL,
    customer_id varchar(32) NOT NULL,
    order_status varchar(11) NOT NULL,
    order_purchase_timestamp datetime NOT NULL,
    order_approved_at datetime NULL,
    order_delivered_carrier_date datetime NULL,
    order_delivered_customer_date datetime NULL,
    order_estimated_delivery_date datetime NOT NULL
    PRIMARY KEY (customer_id, order_id)
);
GO

drop PROCEDURE IF EXISTS [dbo].[spOverwriteOrders];
GO

drop type IF EXISTS [dbo].[OrdersType];
GO

CREATE TYPE [dbo].[OrdersType] AS TABLE(
    order_id varchar(32) NOT NULL,
    customer_id varchar(32) NOT NULL,
    order_status varchar(11) NOT NULL,
    order_purchase_timestamp datetime NOT NULL,
    order_approved_at datetime NULL,
    order_delivered_carrier_date datetime NULL,
    order_delivered_customer_date datetime NULL,
    order_estimated_delivery_date datetime NOT NULL
    PRIMARY KEY (customer_id, order_id)
)
GO

CREATE PROCEDURE [dbo].[spOverwriteOrders] @Orders dbo.OrdersType READONLY
    AS
    SET NOCOUNT ON

    BEGIN
    MERGE dbo.orders AS target
    USING (Select order_id, customer_id, order_status, order_purchase_timestamp, order_approved_at, order_delivered_carrier_date, order_delivered_customer_date, order_estimated_delivery_date from @Orders) AS source
            (order_id, customer_id, order_status, order_purchase_timestamp, order_approved_at, order_delivered_carrier_date, order_delivered_customer_date, order_estimated_delivery_date)
    ON (target.order_id       = source.order_id AND
        target.customer_id    = source.customer_id
        )
    WHEN MATCHED THEN
        UPDATE SET 
            order_id = source.order_id, 
            customer_id = source.customer_id, 
            order_status = source.order_status, 
            order_purchase_timestamp = source.order_purchase_timestamp, 
            order_approved_at = source.order_approved_at, 
            order_delivered_carrier_date = source.order_delivered_carrier_date, 
            order_delivered_customer_date = source.order_delivered_customer_date, 
            order_estimated_delivery_date = source.order_estimated_delivery_date
    WHEN NOT MATCHED THEN
        INSERT (order_id, customer_id, order_status, order_purchase_timestamp, order_approved_at, order_delivered_carrier_date, order_delivered_customer_date, order_estimated_delivery_date)
        VALUES (source.order_id, source.customer_id, source.order_status, source.order_purchase_timestamp, source.order_approved_at, source.order_delivered_carrier_date, source.order_delivered_customer_date, source.order_estimated_delivery_date);
    END
    SET NOCOUNT OFF
GO