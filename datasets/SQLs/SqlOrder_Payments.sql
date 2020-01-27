drop table if exists dbo.order_payments;
GO

create table order_payments(
    order_id varchar(32) not null,
    payment_sequential smallint not null,
    payment_type varchar(11) not null,
    payment_installments smallint not null,
    payment_value decimal not null
);
GO

drop PROCEDURE if exists [dbo].[spOverwriteOrderPayments];
GO

drop type if exists [dbo].[OrderPaymentsType];
GO

CREATE TYPE [dbo].[OrderPaymentsType] AS TABLE(
    order_id varchar(32) not null,
    payment_sequential smallint not null,
    payment_type varchar(11) not null,
    payment_installments smallint not null,
    payment_value decimal not null
)
GO

CREATE PROCEDURE [dbo].[spOverwriteOrderPayments] @OrderPayments dbo.OrderPaymentsType READONLY
    AS
    SET NOCOUNT ON

    BEGIN
    MERGE dbo.order_payments AS target
    USING (Select order_id, payment_sequential, payment_type, payment_installments, payment_value from @OrderPayments) AS source
            (order_id, payment_sequential, payment_type, payment_installments, payment_value)
    ON (target.order_id           = source.order_id AND
        target.payment_sequential = source.payment_sequential AND
        target.payment_type       = source.payment_type
        )
    WHEN MATCHED THEN
        UPDATE SET 
            order_id = source.order_id,
            payment_sequential = source.payment_sequential,
            payment_type = source.payment_type,
            payment_installments = source.payment_installments,
            payment_value = source.payment_value
    WHEN NOT MATCHED THEN
        INSERT (order_id, payment_sequential, payment_type, payment_installments, payment_value)
        VALUES (source.order_id, source.payment_sequential, source.payment_type, source.payment_installments, source.payment_value);
    END
    SET NOCOUNT OFF
GO