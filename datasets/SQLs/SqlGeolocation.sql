drop table IF EXISTS dbo.geolocation;
GO

create table geolocation(
    geolocation_zip_code_prefix varchar(5),
    geolocation_lat decimal,
    geolocation_lng decimal,
    geolocation_city varchar(40),
    geolocation_state varchar(2)
); 
GO

drop PROCEDURE IF EXISTS [dbo].[spOverwriteGeolocation];
GO

drop type IF EXISTS [dbo].[GeolocationType];
GO

CREATE TYPE [dbo].[GeolocationType] AS TABLE(
    geolocation_zip_code_prefix varchar(5),
    geolocation_lat decimal,
    geolocation_lng decimal,
    geolocation_city varchar(40),
    geolocation_state varchar(2)
)
GO

CREATE PROCEDURE [dbo].[spOverwriteGeolocation] @Geolocation dbo.GeolocationType READONLY
    AS
    SET NOCOUNT ON

    BEGIN
    MERGE dbo.geolocation AS target
    USING (Select geolocation_zip_code_prefix, geolocation_lat, geolocation_lng, geolocation_city, geolocation_state from @Geolocation
            GROUP By geolocation_zip_code_prefix, geolocation_lat, geolocation_lng, geolocation_city, geolocation_state) AS source
            (geolocation_zip_code_prefix, geolocation_lat, geolocation_lng, geolocation_city, geolocation_state)
    ON (target.geolocation_zip_code_prefix  =  source.geolocation_zip_code_prefix AND
        target.geolocation_lat              = source.geolocation_lat AND
        target.geolocation_lng              = source.geolocation_lng AND
        target.geolocation_city             = source.geolocation_city AND
        target.geolocation_state            = source.geolocation_state
        )
    WHEN MATCHED THEN
        UPDATE SET geolocation_zip_code_prefix = source.geolocation_zip_code_prefix,
        geolocation_lat = source.geolocation_lat,
        geolocation_lng = source.geolocation_lng,
        geolocation_city = source.geolocation_city,
        geolocation_state = source.geolocation_state
    WHEN NOT MATCHED THEN
        INSERT (geolocation_zip_code_prefix, geolocation_lat, geolocation_lng, geolocation_city, geolocation_state)
        VALUES (source.geolocation_zip_code_prefix, source.geolocation_lat, source.geolocation_lng, source.geolocation_city, source.geolocation_state);
    END
    SET NOCOUNT OFF
GO