CREATE TABLE geo_location
(
    id        SERIAL,
    longitude DECIMAL(9, 6),
    latitude  DECIMAL(8, 6),

    CONSTRAINT PK_geo_location PRIMARY KEY (id)
);

CLUSTER geo_location USING pk_geo_location;