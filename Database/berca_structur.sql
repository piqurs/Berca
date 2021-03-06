USE [berca]
GO
/****** Object:  Table [dbo].[Customer]    Script Date: 07/09/2021 13:04:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customer](
	[CustomerID] [varchar](50) NOT NULL,
	[CustomerName] [varchar](50) NOT NULL,
	[TOPDays] [decimal](3, 0) NOT NULL,
 CONSTRAINT [PK_Customer] PRIMARY KEY CLUSTERED 
(
	[CustomerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Invoice]    Script Date: 07/09/2021 13:04:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Invoice](
	[InvNo] [decimal](4, 0) NOT NULL,
	[Inv] [char](3) NOT NULL,
	[InvThn] [decimal](4, 0) NOT NULL,
	[CustomerID] [varchar](50) NOT NULL,
	[InvDate] [char](15) NOT NULL,
	[DueDate] [char](15) NOT NULL,
	[Currency] [varchar](50) NULL,
	[Rate] [decimal](6, 4) NOT NULL,
	[InvAmtIDR] [decimal](15, 2) NOT NULL,
	[OpenAmtIDR] [decimal](15, 2) NOT NULL,
	[InvAmtFRG] [decimal](15, 2) NOT NULL,
	[OpenAmtFRG] [decimal](15, 2) NOT NULL,
	[Remark] [char](40) NOT NULL,
	[IsActive] [smallint] NOT NULL,
	[TglEnt] [decimal](2, 0) NOT NULL,
	[BlnEnt] [decimal](2, 0) NOT NULL,
	[ThnEnt] [decimal](4, 0) NOT NULL,
	[JamEnt] [decimal](2, 0) NOT NULL,
	[MntEnt] [decimal](2, 0) NOT NULL,
	[DtkEnt] [decimal](2, 0) NOT NULL,
	[Guid] [varchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[OutstandingInv]    Script Date: 07/09/2021 13:04:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[OutstandingInv]
as
select distinct invno, inv, invthn, customername, cust.CustomerID, TOPDays, ThnEnt , BlnEnt , TglEnt,  Currency, InvAmtIDR, OpenAmtIDR, Remark
from invoice inv
inner join customer cust on inv.CustomerID = cust.CustomerID
GO
/****** Object:  View [dbo].[View_Ost]    Script Date: 07/09/2021 13:04:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[View_Ost]
as
select distinct invno, inv, invthn, customername, cust.CustomerID, TOPDays, ThnEnt , BlnEnt , TglEnt,  Currency, InvAmtIDR, OpenAmtIDR, Remark, 
(inv + '-' + cast(invthn as varchar) + '-' + right('000' + cast(invno as varchar(10)), 4)) as NoInvoice,
(cast (thnent as varchar) + '-' + right('0' + cast(BlnEnt as varchar(10)), 2) + '-' + right('0' + cast(TglEnt as varchar(10)), 2)) as TglInvoice, Guid
from berca.dbo.invoice inv
inner join berca.dbo.customer cust on inv.CustomerID = cust.CustomerID
GO
/****** Object:  View [dbo].[View_OutStanding]    Script Date: 07/09/2021 13:04:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create  view [dbo].[View_OutStanding]
as
select distinct inv.invno, inv.inv, inv.invthn, customername, cust.CustomerID, TOPDays, ThnEnt , BlnEnt , TglEnt,  Currency, InvAmtIDR, OpenAmtIDR, Remark, 
IsActive, (right('000' + cast(inv.invno as varchar(10)), 4) + '-' + inv.inv + '-' + cast(inv.invthn as varchar)) as NoInvoice,
(cast (thnent as varchar) + '-' + right('0' + cast(BlnEnt as varchar(10)), 2) + '-' + right('0' + cast(TglEnt as varchar(10)), 2)) as TglInvoice, Guid
from berca.dbo.invoice inv
inner join berca.dbo.customer cust on inv.CustomerID = cust.CustomerID
GO
/****** Object:  Table [dbo].[Collection]    Script Date: 07/09/2021 13:04:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Collection](
	[CollectionID] [varchar](50) NOT NULL,
	[InvNo] [decimal](4, 0) NOT NULL,
	[Inv] [char](3) NOT NULL,
	[InvThn] [decimal](4, 0) NOT NULL,
	[CollectionDate] [varchar](15) NOT NULL,
	[Currency] [varchar](10) NOT NULL,
	[Rate] [decimal](6, 4) NOT NULL,
	[CollAmtIDR] [decimal](15, 2) NOT NULL,
	[CollAmtFRG] [decimal](15, 2) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[View_OutStanding_2]    Script Date: 07/09/2021 13:04:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create  view [dbo].[View_OutStanding_2]
as
select distinct inv.invno, inv.inv, inv.invthn, customername, cust.CustomerID, CollectionID, TOPDays, ThnEnt , BlnEnt , TglEnt,  coll.Currency, 
InvAmtIDR, OpenAmtIDR, Remark, 
IsActive, (right('000' + cast(inv.invno as varchar(10)), 4) + '-' + inv.inv + '-' + cast(inv.invthn as varchar)) as NoInvoice,
(cast (thnent as varchar) + '-' + right('0' + cast(BlnEnt as varchar(10)), 2) + '-' + right('0' + cast(TglEnt as varchar(10)), 2)) as TglInvoice, Guid
from berca.dbo.invoice inv
inner join berca.dbo.customer cust on inv.CustomerID = cust.CustomerID
inner join berca.dbo.Collection coll on inv.Inv = coll.Inv and inv.InvThn = coll.InvThn and inv.InvNo = coll.InvNo
GO
/****** Object:  Table [dbo].[Currency]    Script Date: 07/09/2021 13:04:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Currency](
	[Currency] [varchar](10) NOT NULL,
	[Eff_Date] [varchar](15) NOT NULL,
	[Rate] [decimal](6, 4) NOT NULL,
 CONSTRAINT [PK_Currency] PRIMARY KEY CLUSTERED 
(
	[Currency] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[GetByCollectId]    Script Date: 07/09/2021 13:04:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetByCollectId]
(
	@CollectionID varchar(50)
)
AS
	SET NOCOUNT ON;
SELECT invno, inv, invthn, customername, CustomerID, CollectionID, TOPDays, ThnEnt, BlnEnt, TglEnt, Currency, InvAmtIDR, OpenAmtIDR, Remark, IsActive, NoInvoice, TglInvoice, Guid FROM dbo.View_OutStanding_2
where CollectionID = @CollectionID
GO
/****** Object:  StoredProcedure [dbo].[GetDataByInv]    Script Date: 07/09/2021 13:04:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetDataByInv]
(
	@invo decimal(4, 0),
	@inv char(3),
	@invthn decimal(4, 0)
)
AS
	SET NOCOUNT ON;
SELECT        invno, inv, invthn, customername, CustomerID, TOPDays, ThnEnt, BlnEnt, TglEnt, Currency, InvAmtIDR, OpenAmtIDR, Remark
FROM            OutstandingInv
WHERE        (invno = @invo) AND (inv = @inv) AND (invthn = @invthn)
GO
/****** Object:  StoredProcedure [dbo].[GetDataByInvoice]    Script Date: 07/09/2021 13:04:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetDataByInvoice]
(
	@NoInvoice varchar(39)
)
AS
	SET NOCOUNT ON;
SELECT invno, inv, invthn, customername, CustomerID, TOPDays, ThnEnt, BlnEnt, TglEnt, Currency, InvAmtIDR, OpenAmtIDR, Remark, IsActive, NoInvoice, TglInvoice, Guid FROM dbo.View_OutStanding
where NoInvoice = @NoInvoice
GO
/****** Object:  StoredProcedure [dbo].[GetDataByNoInv]    Script Date: 07/09/2021 13:04:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetDataByNoInv]
(
	@noinvoice varchar(39)
)
AS
	SET NOCOUNT ON;
SELECT 
invno, inv, invthn, customername, CustomerID, TOPDays, ThnEnt, BlnEnt, TglEnt, Currency, InvAmtIDR, OpenAmtIDR, Remark, NoInvoice, TglInvoice, Guid 
FROM dbo.View_Ost
Where NoInvoice = @noinvoice
GO
/****** Object:  StoredProcedure [dbo].[InsertAll_Invoice]    Script Date: 07/09/2021 13:04:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InsertAll_Invoice]
(
	@InvNo decimal(4, 0),
	@Inv char(3),
	@InvThn decimal(4, 0),
	@CustomerID varchar(50),
	@InvDate char(15),
	@DueDate char(15),
	@Currency varchar(50),
	@Rate decimal(6, 4),
	@InvAmtIDR decimal(15, 2),
	@OpenAmtIDR decimal(15, 2),
	@InvAmtFRG decimal(15, 2),
	@OpenAmtFRG decimal(15, 2),
	@Remark char(40),
	@IsActive smallint,
	@TglEnt decimal(2, 0),
	@BlnEnt decimal(2, 0),
	@ThnEnt decimal(4, 0),
	@JamEnt decimal(2, 0),
	@MntEnt decimal(2, 0),
	@DtkEnt decimal(2, 0)
)
AS
	SET NOCOUNT OFF;
INSERT INTO [BERCA].[DBO].[INVOICE] ([InvNo], [Inv], [InvThn], [CustomerID], [InvDate], [DueDate], [Currency], [Rate], [InvAmtIDR], [OpenAmtIDR], [InvAmtFRG], [OpenAmtFRG], [Remark], [IsActive], [TglEnt], [BlnEnt], [ThnEnt], [JamEnt], [MntEnt], [DtkEnt]) VALUES (@InvNo, @Inv, @InvThn, @CustomerID, @InvDate, @DueDate, @Currency, @Rate, @InvAmtIDR, @OpenAmtIDR, @InvAmtFRG, @OpenAmtFRG, @Remark, @IsActive, @TglEnt, @BlnEnt, @ThnEnt, @JamEnt, @MntEnt, @DtkEnt)
GO
/****** Object:  StoredProcedure [dbo].[InsertAllCustomer]    Script Date: 07/09/2021 13:04:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InsertAllCustomer]
(
	@CustomerID varchar(50),
	@CustomerName varchar(50),
	@TOPDays decimal(3, 0)
)
AS
	SET NOCOUNT OFF;
INSERT INTO [BERCA].[DBO].[CUSTOMER] ([CustomerID], [CustomerName], [TOPDays]) VALUES (@CustomerID, @CustomerName, @TOPDays);
	
SELECT CustomerID, CustomerName, TOPDays FROM Customer WHERE (CustomerID = @CustomerID)
GO
/****** Object:  StoredProcedure [dbo].[InsertBercaInvo]    Script Date: 07/09/2021 13:04:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InsertBercaInvo]
(
	@invno decimal(4, 0),
	@inv char(3),
	@invthn decimal(4, 0),
	@customerid varchar(50),
	@invdate char(15),
	@duedate char(15),
	@currency varchar(50),
	@rate decimal(6, 4),
	@invamtidr decimal(15, 2),
	@openamtidr decimal(15, 2),
	@invamtfrg decimal(15, 2),
	@openamtfrg decimal(15, 2),
	@remark char(40),
	@isactive smallint,
	@tglent decimal(2, 0),
	@blnent decimal(2, 0),
	@thnent decimal(4, 0),
	@jament decimal(2, 0),
	@mntent decimal(2, 0),
	@dtkent decimal(2, 0)
)
AS
	SET NOCOUNT OFF;
INSERT INTO INVOICE
(invno, inv, invthn, customerid, invdate, duedate, 
				currency, rate, invamtidr, openamtidr, invamtfrg, openamtfrg, 
				remark, isactive, tglent, blnent, thnent, jament, mntent, dtkent)
VALUES
(@invno, @inv, @invthn, @customerid, @invdate, @duedate, 
				@currency, @rate, @invamtidr, @openamtidr, @invamtfrg, @openamtfrg, 
				@remark, @isactive, @tglent, @blnent, @thnent, @jament, @mntent, @dtkent)
GO
/****** Object:  StoredProcedure [dbo].[InsertInvNo]    Script Date: 07/09/2021 13:04:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InsertInvNo]
(
	@INVO decimal(4, 0)
)
AS
	SET NOCOUNT OFF;
INSERT INTO BERCA.DBO.INVOICE
(INVNO)
VALUES
(@INVO)
GO
/****** Object:  StoredProcedure [dbo].[InsertInvoice]    Script Date: 07/09/2021 13:04:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InsertInvoice]
(
	@invno decimal(4, 0),
	@inv char(3),
	@invthn decimal(4, 0),
	@customerid varchar(50),
	@invdate char(15),
	@duedate char(15),
	@currency varchar(50),
	@rate decimal(6, 4),
	@invamtidr decimal(15, 2),
	@openamtidr decimal(15, 2),
	@invamtfrg decimal(15, 2),
	@openamtfrg decimal(15, 2),
	@remark char(40),
	@isactive smallint,
	@tglent decimal(2, 0),
	@blnent decimal(2, 0),
	@thnent decimal(4, 0),
	@jament decimal(2, 0),
	@mntent decimal(2, 0),
	@dtkent decimal(2, 0)
)
AS
	SET NOCOUNT OFF;
INSERT INTO BERCA.DBO.INVOICE 
(INVNO, INV, INVTHN, CUSTOMERID, 
INVDATE, DUEDATE, CURRENCY, RATE, 
INVAMTIDR, OPENAMTIDR, INVAMTFRG, OPENAMTFRG,
REMARK, ISACTIVE, TGLENT, BLNENT, 
THNENT, JAMENT, MNTENT, DTKENT)
VALUES
(@invno, @inv, @invthn, @customerid, 
@invdate, @duedate, @currency, @rate, 
@invamtidr, @openamtidr, @invamtfrg, @openamtfrg,
@remark, @isactive, @tglent, @blnent, 
@thnent, @jament, @mntent, @dtkent)
GO
/****** Object:  StoredProcedure [dbo].[InsertInvoice_2]    Script Date: 07/09/2021 13:04:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InsertInvoice_2]
(
	@invno decimal(4, 0),
	@inv char(3),
	@invthn decimal(4, 0),
	@customerid varchar(50),
	@invdate char(15),
	@duedate char(15),
	@currency varchar(50),
	@rate decimal(6, 4),
	@invamtidr decimal(15, 2),
	@openamtidr decimal(15, 2),
	@invamtfrg decimal(15, 2),
	@openamtfrg decimal(15, 2),
	@remark char(40),
	@isactive smallint,
	@tglent decimal(2, 0),
	@blnent decimal(2, 0),
	@thnent decimal(4, 0),
	@jament decimal(2, 0),
	@mntent decimal(2, 0),
	@dtkent decimal(2, 0),
	@guid varchar(50)
)
AS
	SET NOCOUNT OFF;
INSERT INTO BERCA.DBO.INVOICE 
(INVNO, INV, INVTHN, CUSTOMERID, 
INVDATE, DUEDATE, CURRENCY, RATE, 
INVAMTIDR, OPENAMTIDR, INVAMTFRG, OPENAMTFRG,
REMARK, ISACTIVE, TGLENT, BLNENT, 
THNENT, JAMENT, MNTENT, DTKENT, GUID)
VALUES
(@invno, @inv, @invthn, @customerid, 
@invdate, @duedate, @currency, @rate, 
@invamtidr, @openamtidr, @invamtfrg, @openamtfrg,
@remark, @isactive, @tglent, @blnent, 
@thnent, @jament, @mntent, @dtkent, @guid)
GO
/****** Object:  StoredProcedure [dbo].[MaxInvNo]    Script Date: 07/09/2021 13:04:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MaxInvNo]
(
	@invthn decimal(4, 0)
)
AS
	SET NOCOUNT ON;
SELECT MAX(invno) FROM OutstandingInv
WHERE invthn = @invthn
GO
/****** Object:  StoredProcedure [dbo].[NewDeleteCommand]    Script Date: 07/09/2021 13:04:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[NewDeleteCommand]
(
	@Original_CustomerID varchar(50)
)
AS
	SET NOCOUNT OFF;
DELETE FROM [BERCA].[DBO].[CUSTOMER] WHERE (([CustomerID] = @Original_CustomerID))
GO
/****** Object:  StoredProcedure [dbo].[NewInsertCommand]    Script Date: 07/09/2021 13:04:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[NewInsertCommand]
(
	@Currency varchar(10),
	@Eff_Date varchar(15),
	@Rate decimal(6, 4)
)
AS
	SET NOCOUNT OFF;
INSERT INTO [DBO].[CURRENCY] ([Currency], [Eff_Date], [Rate]) VALUES (@Currency, @Eff_Date, @Rate);
	
SELECT Currency, Eff_Date, Rate FROM Currency WHERE (Currency = @Currency)
GO
/****** Object:  StoredProcedure [dbo].[NewUpdateCommand]    Script Date: 07/09/2021 13:04:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[NewUpdateCommand]
(
	@CustomerID varchar(50),
	@CustomerName varchar(50),
	@TOPDays decimal(3, 0),
	@Original_CustomerID varchar(50)
)
AS
	SET NOCOUNT OFF;
UPDATE [BERCA].[DBO].[CUSTOMER] SET [CustomerID] = @CustomerID, [CustomerName] = @CustomerName, [TOPDays] = @TOPDays WHERE (([CustomerID] = @Original_CustomerID));
	
SELECT CustomerID, CustomerName, TOPDays FROM Customer WHERE (CustomerID = @CustomerID)
GO
/****** Object:  StoredProcedure [dbo].[SelectAll_Invoice]    Script Date: 07/09/2021 13:04:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SelectAll_Invoice]
AS
	SET NOCOUNT ON;
SELECT * FROM BERCA.DBO.INVOICE
GO
/****** Object:  StoredProcedure [dbo].[SelectAllCustomer]    Script Date: 07/09/2021 13:04:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SelectAllCustomer]
AS
	SET NOCOUNT ON;
SELECT * FROM BERCA.DBO.CUSTOMER
GO
/****** Object:  StoredProcedure [dbo].[SelectCurrency]    Script Date: 07/09/2021 13:04:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SelectCurrency]
AS
	SET NOCOUNT ON;
SELECT * FROM DBO.CURRENCY
GO
