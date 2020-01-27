drop table if exists dbo.order_items;
GO

create table order_items(
    order_id varchar(32) not null,
    order_item_id smallint not null,
    product_id varchar(32) not null,
    seller_id varchar(32) not null,
    shipping_limit_date datetime not null,
    price decimal not null,
    freight_value decimal not null
); 
GO

drop PROCEDURE if exists [dbo].[spOverwriteOrderItems];
GO

drop type if exists [dbo].[OrderItemsType];
GO

CREATE TYPE [dbo].[OrderItemsType] AS TABLE(
    order_id varchar(32) not null,
    order_item_id smallint not null,
    product_id varchar(32) not null,
    seller_id varchar(32) not null,
    shipping_limit_date datetime not null,
    price decimal not null,
    freight_value decimal not null
)
GO

CREATE PROCEDURE [dbo].[spOverwriteOrderItems] @OrderItems dbo.OrderItemsType READONLY
    AS
    SET NOCOUNT ON

    BEGIN
    MERGE dbo.order_items AS target
    USING (Select order_id, order_item_id, product_id, seller_id, shipping_limit_date, price, freight_value from @OrderItems) AS source
            (order_id, order_item_id, product_id, seller_id, shipping_limit_date, price, freight_value)
    ON (target.order_id       = source.order_id and 
        target.order_item_id  = source.order_item_id and
        target.product_id     = source.product_id AND
        target.seller_id      = source.seller_id
        )
    WHEN MATCHED THEN
        UPDATE SET 
        order_id = source.order_id,
        order_item_id = source.order_item_id,
        product_id = source.product_id,
        seller_id = source.seller_id,
        shipping_limit_date = source.shipping_limit_date,
        price = source.price,
        freight_value = source.freight_value
    WHEN NOT MATCHED THEN
        INSERT (order_id, order_item_id, product_id, seller_id, shipping_limit_date, price, freight_value)
        VALUES (source.order_id, source.order_item_id, source.product_id, source.seller_id, source.shipping_limit_date, source.price, source.freight_value);
    END
    SET NOCOUNT OFF
GO