CREATE TABLE marital_status
(
    key CHAR(10),

    CONSTRAINT PK_marital_status PRIMARY KEY (key)
);
CLUSTER marital_status USING pk_marital_status;