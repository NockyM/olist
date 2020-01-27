drop table if exists dbo.customers;
GO

create table customers(       
    customer_id varchar(32) NOT NULL,
    customer_unique_id varchar(32),
    customer_zip_code_prefix int,
    customer_city varchar(32),
    customer_state varchar(2)
    PRIMARY KEY (customer_id)
); 
GO

drop PROCEDURE if exists [dbo].[spOverwriteCustomers];
GO

drop type if exists [dbo].[CustomersType];
GO

CREATE TYPE [dbo].[CustomersType] AS TABLE(
    customer_id varchar(32) NOT NULL,
    customer_unique_id varchar(32),
    customer_zip_code_prefix int,
    customer_city varchar(32),
    customer_state varchar(2)
    PRIMARY KEY (customer_id)
)
GO

CREATE PROCEDURE [dbo].[spOverwriteCustomers] @Customers dbo.CustomersType READONLY
    AS
    SET NOCOUNT ON

    BEGIN
    MERGE dbo.customers AS target
    USING (Select customer_id, customer_unique_id, customer_zip_code_prefix, customer_city, customer_state from @Customers) AS source
            (customer_id, customer_unique_id, customer_zip_code_prefix, customer_city, customer_state)
    ON (target.customer_id      = source.customer_id)
    WHEN MATCHED THEN
        UPDATE SET customer_id = source.customer_id,
        customer_unique_id = source.customer_unique_id,
        customer_zip_code_prefix = source.customer_zip_code_prefix,
        customer_city = source.customer_city,
        customer_state = source.customer_state
    WHEN NOT MATCHED THEN
        INSERT (customer_id, customer_unique_id, customer_zip_code_prefix, customer_city, customer_state)
        VALUES (source.customer_id, source.customer_unique_id, source.customer_zip_code_prefix, source.customer_city, source.customer_state);
    END
    SET NOCOUNT OFF
GO