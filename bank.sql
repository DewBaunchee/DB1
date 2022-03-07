IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[FK_site_pages_site_pages]') AND
OBJECTPROPERTY(id, 'IsForeignKey') = 1)
ALTER TABLE [site_pages] DROP CONSTRAINT [FK_site_pages_site_pages]
GO
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[FK_payments_operational_accounts]') AND
OBJECTPROPERTY(id, 'IsForeignKey') = 1)
ALTER TABLE [payments_operational] DROP CONSTRAINT [FK_payments_operational_accounts]
GO
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[FK_payments_operational_accounts_02]') AND
OBJECTPROPERTY(id, 'IsForeignKey') = 1)
ALTER TABLE [payments_operational] DROP CONSTRAINT [FK_payments_operational_accounts_02]
GO
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[FK_payments_archive_accounts]') AND
OBJECTPROPERTY(id, 'IsForeignKey') = 1)
ALTER TABLE [payments_archive] DROP CONSTRAINT [FK_payments_archive_accounts]
GO
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[FK_payments_archive_accounts_02]') AND
OBJECTPROPERTY(id, 'IsForeignKey') = 1)
ALTER TABLE [payments_archive] DROP CONSTRAINT [FK_payments_archive_accounts_02]
GO
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[FK_accounts_m2m_statuses_accounts]') AND
OBJECTPROPERTY(id, 'IsForeignKey') = 1)
ALTER TABLE [accounts_m2m_statuses] DROP CONSTRAINT [FK_accounts_m2m_statuses_accounts]
GO
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[FK_accounts_m2m_statuses_statuses]') AND
OBJECTPROPERTY(id, 'IsForeignKey') = 1)
ALTER TABLE [accounts_m2m_statuses] DROP CONSTRAINT [FK_accounts_m2m_statuses_statuses]
GO
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[FK_accounts_owners]') AND
OBJECTPROPERTY(id, 'IsForeignKey') = 1)
ALTER TABLE [accounts] DROP CONSTRAINT [FK_accounts_owners]
GO
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[statuses]') AND OBJECTPROPERTY(id,
'IsUserTable') = 1)
DROP TABLE [statuses]
GO
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[site_pages]') AND OBJECTPROPERTY(id,
'IsUserTable') = 1)
DROP TABLE [site_pages]
GO
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[payments_operational]') AND
OBJECTPROPERTY(id, 'IsUserTable') = 1)
DROP TABLE [payments_operational]
GO
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[payments_archive]') AND OBJECTPROPERTY(id,
'IsUserTable') = 1)
DROP TABLE [payments_archive]
GO
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[owners]') AND OBJECTPROPERTY(id,
'IsUserTable') = 1)
DROP TABLE [owners]
GO
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[offices]') AND OBJECTPROPERTY(id,
'IsUserTable') = 1)
DROP TABLE [offices]
GO
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[accounts_m2m_statuses]') AND
OBJECTPROPERTY(id, 'IsUserTable') = 1)
DROP TABLE [accounts_m2m_statuses]
GO
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id('[accounts]') AND OBJECTPROPERTY(id,
'IsUserTable') = 1)
DROP TABLE [accounts]
GO
CREATE TABLE [statuses]
(
 [s_id] tinyint NOT NULL IDENTITY (1, 1),
 [s_name] nvarchar(200) NOT NULL
)
GO
CREATE TABLE [site_pages]
(
 [sp_id] int NOT NULL IDENTITY (1, 1),
 [sp_parent] int NULL,
 [sp_name] nvarchar(100) NOT NULL
)
GO
CREATE TABLE [payments_operational]
(
 [po_id] bigint NOT NULL IDENTITY (1, 1),
 [po_from] bigint NOT NULL,
 [po_to] bigint NOT NULL,
 [po_money] money NULL,
 [po_dt] datetime NOT NULL
)
GO
CREATE TABLE [payments_archive]
(
 [pa_id] bigint NOT NULL,
 [pa_from] bigint NOT NULL,
 [pa_to] bigint NOT NULL,
 [pa_money] money NULL,
 [pa_dt] datetime NOT NULL
)
GO
CREATE TABLE [owners]
(
 [o_id] bigint NOT NULL IDENTITY (1, 1),
 [o_name] nvarchar(200) NOT NULL
)
GO
CREATE TABLE [offices]
(
 [of_id] int NOT NULL IDENTITY (1, 1),
 [of_city] nvarchar(50) NULL,
 [of_name] nvarchar(50) NULL,
 [of_sales] int NULL
)
GO
CREATE TABLE [accounts_m2m_statuses]
(
 [ams_a_id] bigint NOT NULL,
 [ams_s_id] tinyint NOT NULL,
 [ams_last_update] datetime NOT NULL
)
GO
CREATE TABLE [accounts]
(
 [a_id] bigint NOT NULL IDENTITY (1, 1),
 [a_owner] bigint NOT NULL,
 [a_is_system] bit NOT NULL,
 [a_balance] money NOT NULL
)
GO
ALTER TABLE [statuses]
 ADD CONSTRAINT [PK_statuses]
 PRIMARY KEY CLUSTERED ([s_id])
GO
ALTER TABLE [site_pages]
 ADD CONSTRAINT [PK_site_pages]
 PRIMARY KEY CLUSTERED ([sp_id])
GO
ALTER TABLE [payments_operational]
 ADD CONSTRAINT [PK_payments_operational]
 PRIMARY KEY CLUSTERED ([po_id])
GO
ALTER TABLE [payments_archive]
 ADD CONSTRAINT [PK_payments_archive]
 PRIMARY KEY CLUSTERED ([pa_id])
GO
ALTER TABLE [owners]
 ADD CONSTRAINT [PK_owners]
 PRIMARY KEY CLUSTERED ([o_id])
GO
ALTER TABLE [offices]
 ADD CONSTRAINT [PK_offices]
 PRIMARY KEY CLUSTERED ([of_id])
GO
ALTER TABLE [accounts_m2m_statuses]
 ADD CONSTRAINT [PK_accounts_m2m_statuses]
 PRIMARY KEY CLUSTERED ([ams_a_id],[ams_s_id])
GO
ALTER TABLE [accounts]
 ADD CONSTRAINT [PK_accounts]
 PRIMARY KEY CLUSTERED ([a_id])
GO
ALTER TABLE [site_pages] ADD CONSTRAINT [FK_site_pages_site_pages]
 FOREIGN KEY ([sp_parent]) REFERENCES [site_pages] ([sp_id]) ON DELETE No Action ON UPDATE No
Action
GO
ALTER TABLE [payments_operational] ADD CONSTRAINT [FK_payments_operational_accounts]
 FOREIGN KEY ([po_from]) REFERENCES [accounts] ([a_id]) ON DELETE No Action ON UPDATE No Action
GO
ALTER TABLE [payments_operational] ADD CONSTRAINT [FK_payments_operational_accounts_02]
 FOREIGN KEY ([po_to]) REFERENCES [accounts] ([a_id]) ON DELETE No Action ON UPDATE No Action
GO
ALTER TABLE [payments_archive] ADD CONSTRAINT [FK_payments_archive_accounts]
 FOREIGN KEY ([pa_from]) REFERENCES [accounts] ([a_id]) ON DELETE No Action ON UPDATE No Action
GO
ALTER TABLE [payments_archive] ADD CONSTRAINT [FK_payments_archive_accounts_02]
 FOREIGN KEY ([pa_to]) REFERENCES [accounts] ([a_id]) ON DELETE No Action ON UPDATE No Action
GO
ALTER TABLE [accounts_m2m_statuses] ADD CONSTRAINT [FK_accounts_m2m_statuses_accounts]
 FOREIGN KEY ([ams_a_id]) REFERENCES [accounts] ([a_id]) ON DELETE No Action ON UPDATE No Action
GO
ALTER TABLE [accounts_m2m_statuses] ADD CONSTRAINT [FK_accounts_m2m_statuses_statuses]
 FOREIGN KEY ([ams_s_id]) REFERENCES [statuses] ([s_id]) ON DELETE No Action ON UPDATE No Action
GO
ALTER TABLE [accounts] ADD CONSTRAINT [FK_accounts_owners]
 FOREIGN KEY ([a_owner]) REFERENCES [owners] ([o_id]) ON DELETE No Action ON UPDATE No Action
