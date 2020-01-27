drop table if exists dbo.product_translation;
GO

create table product_translation(
    product_category_name varchar(46) NOT NULL,
    product_category_name_english varchar(39) NOT NULL
    PRIMARY KEY (product_category_name, product_category_name_english)
);
GO

drop PROCEDURE if exists [dbo].[spOverwriteProductTranslation];
GO

drop type if exists [dbo].[ProductTranslationType];
GO

CREATE TYPE [dbo].[ProductTranslationType] AS TABLE(
    product_category_name varchar(46) NOT NULL,
    product_category_name_english varchar(39) NOT NULL
    PRIMARY KEY (product_category_name, product_category_name_english)
)
GO

CREATE PROCEDURE [dbo].[spOverwriteProductTranslation] @ProductTranslation dbo.ProductTranslationType READONLY
    AS
    SET NOCOUNT ON

    BEGIN
    MERGE dbo.product_translation AS target
    USING (Select product_category_name, product_category_name_english from @ProductTranslation) AS source
            (product_category_name, product_category_name_english)
    ON (target.product_category_name       = source.product_category_name )
    WHEN MATCHED THEN
        UPDATE SET 
            product_category_name = source.product_category_name, 
            product_category_name_english = source.product_category_name_english
    WHEN NOT MATCHED THEN
        INSERT (product_category_name, product_category_name_english)
        VALUES (source.product_category_name, source.product_category_name_english);
    END
    SET NOCOUNT OFF
GO