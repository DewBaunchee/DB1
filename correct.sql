DROP SCHEMA public CASCADE;
CREATE SCHEMA public;

GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO public;

CREATE TABLE coordinates
(
    cr_id        BIGSERIAL,
    cr_latitude  SMALLINT NOT NULL,
    cr_longitude SMALLINT NOT NULL,
    CONSTRAINT PK_coordinates PRIMARY KEY (cr_id)
);
CLUSTER coordinates USING PK_coordinates;

CREATE TABLE country
(
    co_code CHAR(2) UNIQUE,
    co_name VARCHAR(100) NOT NULL,
    CONSTRAINT PK_country PRIMARY KEY (co_code)
);
CLUSTER country USING PK_country;

CREATE TABLE city
(
    ci_id   BIGSERIAL,
    ci_name VARCHAR(100) NOT NULL,
    CONSTRAINT PK_city PRIMARY KEY (ci_id)
);
CLUSTER city USING PK_city;

CREATE TABLE street
(
    st_id   BIGSERIAL,
    st_name VARCHAR(100) NOT NULL,
    CONSTRAINT PK_street PRIMARY KEY (st_id)
);
CLUSTER street USING PK_street;

CREATE TABLE address
(
    ad_id           BIGSERIAL,
    ad_country      CHAR(2) NOT NULL,
    ad_city         BIGINT  NOT NULL,
    ad_street       BIGINT  NOT NULL,
    ad_house_number INT     NOT NULL,
    CONSTRAINT PK_address PRIMARY KEY (ad_id),
    CONSTRAINT FK_address_country
        FOREIGN KEY (ad_country) REFERENCES country (co_code)
            ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT FK_address_city
        FOREIGN KEY (ad_city) REFERENCES city (ci_id)
            ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT FK_address_street
        FOREIGN KEY (ad_street) REFERENCES street (st_id)
            ON DELETE RESTRICT ON UPDATE RESTRICT
);
CLUSTER address USING PK_address;

CREATE TABLE location
(
    lo_id          BIGSERIAL,
    lo_address     BIGINT NOT NULL,
    lo_coordinates BIGINT NOT NULL,
    CONSTRAINT PK_location PRIMARY KEY (lo_id),
    CONSTRAINT FK_location_address
        FOREIGN KEY (lo_address) REFERENCES address (ad_id)
            ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT FK_location_coordinates
        FOREIGN KEY (lo_coordinates) REFERENCES coordinates (cr_id)
            ON DELETE RESTRICT ON UPDATE RESTRICT
);
CLUSTER location USING PK_location;

CREATE TABLE status
(
    s_id   SMALLSERIAL NOT NULL,
    s_name CHAR(50)    NOT NULL,
    CONSTRAINT PK_status PRIMARY KEY (s_id)
);
CLUSTER status USING PK_status;

CREATE TABLE site_page
(
    sp_id          SMALLSERIAL NOT NULL,
    sp_path        CHAR(100)   NOT NULL,
    sp_key_name    CHAR(100)   NOT NULL,
    sp_label_name  CHAR(100)   NOT NULL,
    sp_description TEXT,
    CONSTRAINT PK_site_page PRIMARY KEY (sp_id)
);
CLUSTER site_page USING PK_site_page;

CREATE TABLE full_name
(
    fn_id         SERIAL,
    fn_first_name VARCHAR(100),
    fn_last_name  VARCHAR(100),
    CONSTRAINT PK_full_name PRIMARY KEY (fn_id)
);
CLUSTER full_name USING PK_full_name;

CREATE TABLE passport
(
    p_uid             CHAR(20) NOT NULL UNIQUE,
    p_birthday        DATE     NOT NULL,
    p_expiration_date DATE     NOT NULL,
    p_owner           INT      NOT NULL,
    CONSTRAINT PK_passport PRIMARY KEY (p_uid)
);
CLUSTER passport USING PK_passport;

CREATE TABLE passport_registration
(
    pr_location BIGINT   NOT NULL,
    pr_passport CHAR(20) NOT NULL UNIQUE,
    CONSTRAINT FK_pfn_registration
        FOREIGN KEY (pr_location) REFERENCES location (lo_id)
            ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT FK_pfn_passport
        FOREIGN KEY (pr_passport) REFERENCES passport (p_uid)
            ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE owner
(
    o_id        SERIAL,
    o_full_name INT      NOT NULL,
    o_passport  CHAR(20) NOT NULL UNIQUE,
    CONSTRAINT PK_owner PRIMARY KEY (o_id),
    CONSTRAINT FK_owner_passport
        FOREIGN KEY (o_passport) REFERENCES passport (p_uid)
            ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT FK_owner_full_name
        FOREIGN KEY (o_full_name) REFERENCES full_name (fn_id)
            ON DELETE RESTRICT ON UPDATE CASCADE
);
CLUSTER owner USING PK_owner;
ALTER TABLE passport
    ADD CONSTRAINT FK_passport_owner
        FOREIGN KEY (p_owner) REFERENCES owner (o_id)
            ON DELETE CASCADE ON UPDATE RESTRICT;

CREATE TABLE currency
(
    cur_code            CHAR(3) UNIQUE NOT NULL,
    cur_currency        VARCHAR(50) UNIQUE,
    cur_symbol          VARCHAR(5),
    cur_fractional_unit VARCHAR(10),
    cur_number_to_basic SMALLINT,
    cur_country         CHAR(2),
    CONSTRAINT PK_currency PRIMARY KEY (cur_code),
    CONSTRAINT FK_currency_country
        FOREIGN KEY (cur_country) REFERENCES country (co_code)
            ON DELETE RESTRICT ON UPDATE RESTRICT
);
CLUSTER currency USING PK_currency;

CREATE TABLE account
(
    a_iban      CHAR(34) NOT NULL UNIQUE,
    a_owner     INTEGER  NOT NULL,
    a_is_system BIT      NOT NULL,
    a_balance   MONEY    NOT NULL,
    a_currency  CHAR(3)  NOT NULL,
    CONSTRAINT PK_account PRIMARY KEY (a_iban),
    CONSTRAINT FK_account_owner
        FOREIGN KEY (a_owner) REFERENCES owner (o_id)
            ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT FK_account_currency
        FOREIGN KEY (a_currency) REFERENCES currency (cur_code)
            ON DELETE RESTRICT ON UPDATE RESTRICT
);
CLUSTER account USING PK_account;

CREATE TABLE account_m2m_status
(
    as_account        CHAR(34)  NOT NULL,
    as_status         SMALLINT  NOT NULL,
    as_assigning_date TIMESTAMP NOT NULL,
    CONSTRAINT FK_account_m2m_status_account
        FOREIGN KEY (as_account) REFERENCES account (a_iban)
            ON DELETE CASCADE ON UPDATE RESTRICT,
    CONSTRAINT FK_account_m2m_status_status
        FOREIGN KEY (as_status) REFERENCES status (s_id)
            ON DELETE CASCADE ON UPDATE RESTRICT
);

CREATE TABLE office
(
    of_id       SERIAL,
    of_location BIGINT   NOT NULL,
    of_name     CHAR(50) NULL,
    CONSTRAINT PK_office PRIMARY KEY (of_id),
    CONSTRAINT FK_office
        FOREIGN KEY (of_location) REFERENCES location (lo_id)
            ON DELETE RESTRICT ON UPDATE RESTRICT
);
CLUSTER office USING PK_office;

CREATE TABLE transaction_operational
(
    to_id         BIGSERIAL,
    to_from       CHAR(34) NOT NULL,
    to_to         CHAR(34) NOT NULL,
    to_amount     MONEY    NOT NULL,
    to_currency   CHAR(3)  NOT NULL,
    to_office     INT      NOT NULL,
    to_commission FLOAT    NOT NULL,
    to_date       TIMESTAMP,
    CONSTRAINT PK_transaction_operational PRIMARY KEY (to_id),
    CONSTRAINT FK_transaction_operational_currency
        FOREIGN KEY (to_currency) REFERENCES currency (cur_code)
            ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT FK_transaction_operational_office
        FOREIGN KEY (to_office) REFERENCES office (of_id)
            ON DELETE RESTRICT ON UPDATE RESTRICT
);
CLUSTER transaction_operational USING PK_transaction_operational;

CREATE TABLE transaction_archive
(
    ta_id         BIGINT,
    ta_from       CHAR(34) NOT NULL,
    ta_to         CHAR(34) NOT NULL,
    ta_amount     MONEY    NOT NULL,
    ta_currency   CHAR(3)  NOT NULL,
    ta_office     INT      NOT NULL,
    ta_commission FLOAT    NOT NULL,
    ta_date       TIMESTAMP,
    CONSTRAINT PK_transaction_archive PRIMARY KEY (ta_id),
    CONSTRAINT FK_transaction_archive_currency
        FOREIGN KEY (ta_currency) REFERENCES currency (cur_code)
            ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT FK_transaction_archive_office
        FOREIGN KEY (ta_office) REFERENCES office (of_id)
            ON DELETE RESTRICT ON UPDATE RESTRICT
);
CLUSTER transaction_archive USING PK_transaction_archive;

CREATE OR REPLACE PROCEDURE archive_transactions(archive_after TIMESTAMP)
LANGUAGE SQL
AS $$
    WITH moved_rows as (
        DELETE FROM transaction_operational as r
        WHERE to_date < archive_after
        RETURNING r.to_id, r.to_from, r.to_to, r.to_amount, r.to_currency, r.to_office, r.to_commission, r.to_date
    )
    INSERT INTO transaction_archive (ta_id, ta_from, ta_to, ta_amount, ta_currency, ta_office, ta_commission, ta_date)
    SELECT * FROM moved_rows;
$$;