ALTER TABLE IF EXISTS site_pages
    DROP CONSTRAINT FK_site_pages_site_pages;
ALTER TABLE IF EXISTS payments_operational
    DROP CONSTRAINT FK_payments_operational_accounts;
ALTER TABLE IF EXISTS payments_operational
    DROP CONSTRAINT FK_payments_operational_accounts_02;
ALTER TABLE IF EXISTS payments_archive
    DROP CONSTRAINT FK_payments_archive_accounts;
ALTER TABLE IF EXISTS payments_archive
    DROP CONSTRAINT FK_payments_archive_accounts_02;
ALTER TABLE IF EXISTS accounts_m2m_statuses
    DROP CONSTRAINT FK_accounts_m2m_statuses_accounts;
ALTER TABLE IF EXISTS accounts_m2m_statuses
    DROP CONSTRAINT FK_accounts_m2m_statuses_statuses;
ALTER TABLE IF EXISTS accounts
    DROP CONSTRAINT FK_accounts_owners;
DROP TABLE IF EXISTS statuses;
DROP TABLE IF EXISTS site_pages;
DROP TABLE IF EXISTS payments_operational;
DROP TABLE IF EXISTS payments_archive;
DROP TABLE IF EXISTS owners;
DROP TABLE IF EXISTS offices;
DROP TABLE IF EXISTS accounts_m2m_statuses;
DROP TABLE IF EXISTS accounts;

CREATE TABLE statuses
(
    s_id   SMALLSERIAL NOT NULL,
    s_name CHAR(200)   NOT NULL
);

CREATE TABLE site_pages
(
    sp_id     SERIAL    NOT NULL,
    sp_parent int       NULL,
    sp_name   CHAR(100) NOT NULL
);

CREATE TABLE payments_operational
(
    po_id    BIGSERIAL,
    po_from  BIGINT NOT NULL,
    po_to    BIGINT NOT NULL,
    po_money MONEY  NOT NULL,
    po_dt    TIMESTAMP
);

CREATE TABLE payments_archive
(
    pa_id    BIGINT NOT NULL,
    pa_from  BIGINT NOT NULL,
    pa_to    BIGINT NOT NULL,
    pa_money MONEY  NOT NULL,
    pa_dt    TIMESTAMP
);

CREATE TABLE owners
(
    o_id   BIGSERIAL,
    o_name CHAR(200) NOT NULL
);

CREATE TABLE offices
(
    of_id    SERIAL,
    of_city  CHAR(50) NULL,
    of_name  CHAR(50) NULL,
    of_sales INT      NULL
);

CREATE TABLE accounts_m2m_statuses
(
    ams_a_id        BIGINT    NOT NULL,
    ams_s_id        SMALLINT  NOT NULL,
    ams_last_update TIMESTAMP NOT NULL
);

CREATE TABLE accounts
(
    a_id        BIGSERIAL,
    a_owner     BIGINT NOT NULL,
    a_is_system BIT    NOT NULL,
    a_balance   MONEY  NOT NULL
);

ALTER TABLE statuses
    ADD CONSTRAINT PK_statuses
        PRIMARY KEY (s_id);
CLUSTER statuses USING PK_statuses;

ALTER TABLE site_pages
    ADD CONSTRAINT PK_site_pages
        PRIMARY KEY (sp_id);
CLUSTER site_pages USING PK_site_pages;

ALTER TABLE payments_operational
    ADD CONSTRAINT PK_payments_operational
        PRIMARY KEY (po_id);
CLUSTER payments_operational USING PK_payments_operational;

ALTER TABLE payments_archive
    ADD CONSTRAINT PK_payments_archive
        PRIMARY KEY (pa_id);
CLUSTER payments_archive USING PK_payments_archive;

ALTER TABLE owners
    ADD CONSTRAINT PK_owners
        PRIMARY KEY (o_id);
CLUSTER owners USING PK_owners;

ALTER TABLE offices
    ADD CONSTRAINT PK_offices
        PRIMARY KEY (of_id);
CLUSTER offices USING PK_offices;

ALTER TABLE accounts_m2m_statuses
    ADD CONSTRAINT PK_accounts_m2m_statuses
        PRIMARY KEY (ams_a_id, ams_s_id);
CLUSTER accounts_m2m_statuses USING PK_accounts_m2m_statuses;

ALTER TABLE accounts
    ADD CONSTRAINT PK_accounts
        PRIMARY KEY (a_id);
CLUSTER accounts USING PK_accounts;


ALTER TABLE site_pages
    ADD CONSTRAINT FK_site_pages_site_pages
        FOREIGN KEY (sp_parent) REFERENCES site_pages (sp_id)
            ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE payments_operational
    ADD CONSTRAINT FK_payments_operational_accounts
        FOREIGN KEY (po_from) REFERENCES accounts (a_id)
            ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE payments_operational
    ADD CONSTRAINT FK_payments_operational_accounts_02
        FOREIGN KEY (po_to) REFERENCES accounts (a_id)
            ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE payments_archive
    ADD CONSTRAINT FK_payments_archive_accounts
        FOREIGN KEY (pa_from) REFERENCES accounts (a_id)
            ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE payments_archive
    ADD CONSTRAINT FK_payments_archive_accounts_02
        FOREIGN KEY (pa_to) REFERENCES accounts (a_id)
            ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE accounts_m2m_statuses
    ADD CONSTRAINT FK_accounts_m2m_statuses_accounts
        FOREIGN KEY (ams_a_id) REFERENCES accounts (a_id)
            ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE accounts_m2m_statuses
    ADD CONSTRAINT FK_accounts_m2m_statuses_statuses
        FOREIGN KEY (ams_s_id) REFERENCES statuses (s_id)
            ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE accounts
    ADD CONSTRAINT FK_accounts_owners
        FOREIGN KEY (a_owner) REFERENCES owners (o_id)
            ON DELETE NO ACTION ON UPDATE NO ACTION;
