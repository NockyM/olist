drop table if exists dbo.sellers;
GO

create table sellers(
    seller_id varchar(32) NOT NULL,
    seller_zip_code_prefix int NOT NULL,
    seller_city varchar(40) NOT NULL,
    seller_state varchar(2) NOT NULL
    PRIMARY KEY (seller_id)
);
GO

drop PROCEDURE if exists [dbo].[spOverwriteSellers];
GO

drop type if exists [dbo].[SellersType];
GO

CREATE TYPE [dbo].[SellersType] AS TABLE(
    seller_id varchar(32) NOT NULL,
    seller_zip_code_prefix int NOT NULL,
    seller_city varchar(40) NOT NULL,
    seller_state varchar(2) NOT NULL
    PRIMARY KEY (seller_id)
)
GO

CREATE PROCEDURE [dbo].[spOverwriteSellers] @Sellers dbo.SellersType READONLY
    AS
    SET NOCOUNT ON

    BEGIN
    MERGE dbo.sellers AS target
    USING (Select seller_id, seller_zip_code_prefix, seller_city, seller_state from @Sellers) AS source
            (seller_id, seller_zip_code_prefix, seller_city, seller_state)
    ON (target.seller_id       = source.seller_id )
    WHEN MATCHED THEN
        UPDATE SET 
            seller_id = source.seller_id, 
            seller_zip_code_prefix = source.seller_zip_code_prefix, 
            seller_city = source.seller_city, 
            seller_state = source.seller_state
    WHEN NOT MATCHED THEN
        INSERT (seller_id, seller_zip_code_prefix, seller_city, seller_state)
        VALUES (source.seller_id, source.seller_zip_code_prefix, source.seller_city, source.seller_state);
    END
    SET NOCOUNT OFF
GO