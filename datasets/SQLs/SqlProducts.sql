drop table if exists dbo.products;
GO

create table products(
    product_id varchar(32) NOT NULL,
    product_category_name varchar(46) NULL,
    product_name_lenght int NULL,
    product_description_lenght varchar(4) NULL,
    product_photos_qty int NULL,
    product_weight_g int NULL,
    product_length_cm int NULL,
    product_height_cm int NULL,
    product_width_cm int NULL 
    PRIMARY KEY (product_id)
);
GO

drop PROCEDURE if exists [dbo].[spOverwriteProducts];
GO

drop type if exists [dbo].[ProductsType];
GO

CREATE TYPE [dbo].[ProductsType] AS TABLE(
    product_id varchar(32) NOT NULL,
    product_category_name varchar(46) NULL,
    product_name_lenght int NULL,
    product_description_lenght varchar(4) NULL,
    product_photos_qty int NULL,
    product_weight_g int NULL,
    product_length_cm int NULL,
    product_height_cm int NULL,
    product_width_cm int NULL 
    PRIMARY KEY (product_id)
)
GO

CREATE PROCEDURE [dbo].[spOverwriteProducts] @Products dbo.ProductsType READONLY
    AS
    SET NOCOUNT ON

    BEGIN
    MERGE dbo.products AS target
    USING (Select product_id, product_category_name, product_name_lenght, product_description_lenght, product_photos_qty, product_weight_g, product_length_cm, product_height_cm, product_width_cm from @Products) AS source
            (product_id, product_category_name, product_name_lenght, product_description_lenght, product_photos_qty, product_weight_g, product_length_cm, product_height_cm, product_width_cm)
    ON (target.product_id       = source.product_id )
    WHEN MATCHED THEN
        UPDATE SET 
            product_id = source.product_id, 
            product_category_name = source.product_category_name, 
            product_name_lenght = source.product_name_lenght, 
            product_description_lenght = source.product_description_lenght, 
            product_photos_qty = source.product_photos_qty, 
            product_weight_g = source.product_weight_g, 
            product_length_cm = source.product_length_cm, 
            product_height_cm = source.product_height_cm,
            product_width_cm = source.product_width_cm
    WHEN NOT MATCHED THEN
        INSERT (product_id, product_category_name, product_name_lenght, product_description_lenght, product_photos_qty, product_weight_g, product_length_cm, product_height_cm, product_width_cm)
        VALUES (source.product_id, source.product_category_name, source.product_name_lenght, source.product_description_lenght, source.product_photos_qty, source.product_weight_g, source.product_length_cm, source.product_height_cm, source.product_width_cm);
    END
    SET NOCOUNT OFF
GO