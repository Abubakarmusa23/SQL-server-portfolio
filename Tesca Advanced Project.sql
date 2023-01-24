use [Tesca OLTPDatabase]
select * from POSChannel
select * from Customer
select * from MaritalStatus
select * from Employee e inner join MaritalStatus f on 
select * from PurchaseTransaction

select top 1000 * from  SalesTransaction

select * from PurchaseTransaction

use sql_essentials

select * from INFORMATION_SCHEMA.COLUMNS

select * from sys.all_objects

select * from sys.database_files
select * from sys.all_objects where object_id=1698105090
select OBJECT_ID('customer') 

use sql_essentials
select * into #purchase from PurchaseTrans where Country='canada'

select * into ##purchase1 from PurchaseTrans where Country='France'

select * from ##purchase1

select * from #purchase

------Physical table

CREATE TABLE test
(
Orderid int, 
Supplier nvarchar(255)
)
insert into test(Orderid,Supplier) select orderid, Supplier from PurchaseTrans
select orderid, Supplier from test
group by Orderid, Supplier

---- Global Table
create table ##test
(
OrderID int, 
Supplier nvarchar(255)
)
insert into ##test(OrderID,Supplier) select orderid, Supplier from PurchaseTrans
---Local Temp
create table #test
(
OrderID int, 
Supplier nvarchar(255)
)
insert into #test(OrderID,Supplier) select orderid, Supplier from PurchaseTrans



-CTE=> Common table expression
-Variable table
-local temp
-Global temp
-Physical -- 

declare @test table 
(
Orderid int,
Supplier nvarchar(255)
)
insert into @test(Orderid,Supplier) select OrderID,Supplier from PurchaseTrans
select * from @test
select * from Product
select * from @test

alter table @test add 

select f.TransID,f.OrderID,f.AccountNumber, f.Supplier, f.Address, f.City, f.PostalCode, f.StateProvince,f.Country,f.Employee,f.DueDate from purchaseduplicate f
where f.TransID in
(
select max(transid) transid from purchaseduplicate f 
group by f.OrderID, f.AccountNumber, f.Supplier, f.Address, f.City, f.PostalCode, f.StateProvince,f.Country,f.Employee,f.DueDate
)
order by f.OrderID



with maxtrans as 
(
select max(transid) transid from purchaseduplicate f 
group by f.OrderID, f.AccountNumber, f.Supplier, f.Address, f.City, f.PostalCode, f.StateProvince,f.Country,f.Employee,f.DueDate
)
	select f.TransID,f.OrderID,f.AccountNumber, f.Supplier, f.Address, f.City, f.PostalCode, f.StateProvince,f.Country,f.Employee,f.DueDate from purchaseduplicate f
	where f.TransID in (select TransID from maxtrans)



SELECT left(Supplier,10), substring(Supplier,1, CHARINDEX(' ',supplier,1)-1) as Firstname, SUBSTRING(supplier,CHARINDEX(' ',supplier,1)+1, LEN(supplier)) as Lastname
 FROM PurchaseTrans

select ASCII('A')

SELECT LEN('SA OWOLABI') 

select substring('SA OWOLABI',4,7)

select CHARINDEX(' ','SA OWOLABI',1) 

select CHARINDEX(' ','SA OWOLABI',1)-1

select substring('SA OWOLABI', CHARINDEX(' ','SA OWOLABI',1)+1, LEN('SA OWOLABI')) 

select cast (RAND()*(SELECT MAX(productID) from product)+1 as int) 

select GETDATE()
select DATEPART(QUARTER,getdate())

select DATENAME(MONTH,getdate())

select ShipDate ,DATEADD(DAY,1,ShipDate) from PurchaseTrans
select ShipDate ,DATEADD(MONTH,1,ShipDate) from PurchaseTrans

select ShipDate ,DATEADD(MONTH,-1,ShipDate) from PurchaseTrans

select ShipDate,OrderDate, datediff(month,orderdate,shipdate) from PurchaseTrans

select ShipDate,OrderDate, datediff(DAY,orderdate,shipdate) from PurchaseTrans

select DATEADD(DAY, OrderDate,ShipDate) from PurchaseTrans
create schema TescaDb
create schema HROvertime
create schema HRAbsent
create schema HRMisconduct

use [Tesca EDW database]
create schema tesca

--- Dimproduct---
-- oltp into staging---
use [Tesca OLTPDatabase]

select p.ProductID,p.Product,p.ProductNumber,p.UnitPrice,d.Department from Product p 
inner join Department d on p.DepartmentID=d.DepartmentID


select count(*) as StgSourceCount from Product p 
inner join Department d on p.DepartmentID=d.DepartmentID


use [Tesca staging database]
create table tescadbproduct
(
	productID int,
	product nvarchar (50) not null, 
	productnumber nvarchar(50),
	Unitprice float, 
	department nvarchar(50),
	Loaddate datetime default getdate(),
	constraint tescadb_product_pk primary key(productID)
)
truncate table tescaDbproduct
select * from tesca.dimproduct
order by productID

select count(*) as StgDescCount from tescadbproduct

--EDW---
use [Tesca staging database]
select productID,product,productnumber,unitprice,department,getdate() as startdate from tescadbproduct

use [Tesca EDW database]
create table tesca.dimproduct
(
	productSK int identity (1,1),
	productID Int,
	product nvarchar (50) not null, 
	productnumber nvarchar(50),
	Unitprice float, 
	department nvarchar(50),
	startdate datetime,
	enddate datetime,
	constraint Tesca_dimproduct_sk primary key(ProductSK)
)
select count(*) as Currentcount from tescadbproduct
select count(*) as Precount from tesca.dimproduct
select count(*) as Postcount from tesca.dimproduct


---- Store OLTP ----
use [Tesca OLTPDatabase]

select s.StoreID, s.StoreName,s.StreetAddress, c.CityName,st.State, GETDATE() as loaddate from Store s
inner join City c on s.CityID=c.CityID
inner join State st on c.StateID=st.StateID

select count(*) as StgSourceCount from Store s
inner join City c on s.CityID=c.CityID
inner join State st on c.StateID=st.StateID

--- staging ---
use [Tesca staging database]
create table tescaDBstore
(
	StoreID Int,
	Storename nvarchar(50),
	streetaddress nvarchar(50),
	city nvarchar (50),
	[state] nvarchar(50),
	loaddate datetime default getdate(),
	constraint tesca_store_pk primary key(StoreID)
)
truncate table tescaDBstore 

select COUNT(*) as StgDescCount from tescaDBstore

--EDW---
select s.StoreID, s.Storename, s.streetaddress, s.city, s.state from tescaDBstore s


select count(*) as Currentcount from tescaDBstore
select count(*) as Precount from tesca.dimstore
select count(*) as Postcount from tesca.dimstore


use [Tesca EDW database]

create table tesca.dimstore
(	storeSK int identity(1,1),
	StoreID Int,
	Storename nvarchar(50),
	streetaddress nvarchar(50),
	city nvarchar (50),
	[state] nvarchar(50),
	startdate datetime,
	constraint tesca_dimstore_sk primary key(StoreSK)
)

--- promotion staging----
use [Tesca OLTPDatabase]
select p.PromotionID, p.StartDate, p.EndDate, p.DiscountPercent,t.Promotion, GETDATE() as loaddate from Promotion p
inner join PromotionType t on p.PromotionTypeID=t.PromotionTypeID

select COUNT(*) as StgSourceCount from Promotion p
inner join PromotionType t on p.PromotionTypeID=t.PromotionTypeID

use [Tesca staging database]

create table tescaDBpromotion
(
promotionID INT,
PromotionStartDate date,
promotionEndDate date,
DiscountPercent float,
Promotion nvarchar (50),
Loaddate datetime,
constraint tescaDB_promotion_PK primary key (PromotionID)
)

select count(*) as StgDescCount from tescaDBpromotion
truncate table tescaDBpromotion

----Promotion EDW--
use [Tesca staging database]
select p.promotionID,p.PromotionStartDate,p.promotionEndDate,p.DiscountPercent,p.Promotion from tescaDBpromotion p

select count(*) as Currentcount from tescaDBpromotion
select count(*) as Precount from TescaDimPromotion
select count(*) as Postcount from TescaDimPromotion

use [Tesca EDW database]

create table TescaDimPromotion
(
promotionSK INT,
PromotionID Int,
PromotionStartDate date,
promotionEndDate date,
DiscountPercent float,
Promotion nvarchar (50),
Startdate datetime,
constraint tesca_DimPromotion_SK primary key(promotionSK)
)



---Customer OLTP----

use [Tesca OLTPDatabase]

select c.CustomerID,upper (c.LastName)+','+c.FirstName as Customername, c.CustomerAddress,ct.CityName, s.State, GETDATE() as Loaddate from Customer c
inner join City ct on ct.CityID=c.CityID
inner join State s on ct.StateID=s.StateID

select COUNT(*) as StgSourceCount from Customer c
inner join City ct on ct.CityID=c.CityID
inner join State s on ct.StateID=s.StateID

use [Tesca staging database]
---Customer Staging---
select count(*) as StgDescCount from tescaDbCustomer
create table tescaDbCustomer
(
	CustomerID INT,
	CustomerName Nvarchar(250),
	CustomerAdress Nvarchar(50),
	City Nvarchar(50),
	State Nvarchar(50),
	Loaddate datetime default getdate(),
	constraint tescadb_customer_Pk primary key (customerID)
)
truncate table tescaDbCustomer
--type 2 on Customer name and type 1 on other
select c.CustomerID,c.CustomerName,c.CustomerAdress,c.City,c.State from tescaDbCustomer c
select count(*) as Currentcount from tescaDbCustomer
select count(*) as Precount  from TescaDimcustomer
select count(*) as Postcount  from TescaDimcustomer



--Customer EDW---
use [Tesca EDW database]

create table TescaDimcustomer
(
	CustomerSK Int Identity(1,1),
	CustomerID INT,
	CustomerName Nvarchar(250),
	CustomerAdress Nvarchar(50),
	City Nvarchar(50),
	State Nvarchar(50),
	Startdate datetime,
	Enddate datetime,
	Loaddate datetime default getdate(),
	constraint tesca_DimCustomer_SK primary key (customerSK)
)

----POSChannel OLTP-----

use [Tesca OLTPDatabase]

select p.ChannelID, p.ChannelNo, p.DeviceModel, p.InstallationDate, p.SerialNo from POSChannel p

select count(*) as StgSourceCount from POSChannel p

--- POSChannel Staging--

use [Tesca staging database]
create table tescaDbPOSChannel
(
ChannelID INT,
ChannelNO Nvarchar(50),
DeviceModel nvarchar(50),
SerialNO Nvarchar(50),
InstallationDate datetime,
Loaddate datetime default getdate(),
constraint tescaDb_POSChannel_PK primary key(ChannelID)
)

select count(*) as StgDescCount from tescaDbPOSChannel

Truncate table tescaDbPOSChannel

---Load POSChannel EDW----
select p.ChannelID, p.ChannelNo, p.DeviceModel, p.InstallationDate, p.SerialNo from tescaDbPOSChannel p

use [Tesca EDW database]

create table tescaDimChannel
(
ChannelSK INT identity (1,1),
ChannelID INT,
ChannelNO Nvarchar(50),
DeviceModel nvarchar(50),
SerialNO Nvarchar(50),
InstallationDate datetime,
startdate datetime,
enddate datetime, 
constraint tesca_DimPOSChannel_SK primary key(ChannelSK)
)

select count(*) as Currentcount from tescaDbPOSChannel
select count(*) as Precount  from tescaDimChannel
select count(*) as Postcount  from tescaDimChannel

---Vendor OLTP---
use [Tesca OLTPDatabase]

select v.VendorID,v.VendorNo,concat(Upper (v.LastName),',',v.FirstName) as Vendorname, v.RegistrationNo,v.VendorAddress,c.CityName,s.State, GETDATE() as loaddate from Vendor v
inner join City c on c.CityID=v.CityID
inner join State s on s.StateID=c.StateID


select count(*) as StgSourceCount from Vendor v
inner join City c on c.CityID=v.CityID
inner join State s on s.StateID=c.StateID

---vendor staging---
use [Tesca staging database]

create table tescaDbVendor
(
VendorID INT,
VendorNO Nvarchar(50),
Vendorname Nvarchar (50),
RegistrationNO nvarchar(50),
VendorAddress Nvarchar(50),
City Nvarchar(50),
State Nvarchar (50),
loaddate datetime default getdate(),
constraint TescaDb_Vendor_PK Primary key (VendorID)
)

select count (*) as StgDecCount from tescaDbVendor
Truncate table tescaDbVendor

----vendor EDW----
use [Tesca staging database]

select v.VendorID, v.VendorNO, v.RegistrationNO,v.Vendorname,v.VendorAddress,v.City,v.State  from tescaDbVendor V

use [Tesca EDW database]
create table tescaDimVendor
(
VendorSK Int identity (1,1),
VendorID INT,
VendorNO Nvarchar(50),
Vendorname Nvarchar (50),
RegistrationNO nvarchar(50),
VendorAddress Nvarchar(50),
City Nvarchar(50),
State Nvarchar (50),
Startdate datetime,
endate datetime,
constraint TescaDb_Vendor_SK Primary key (VendorSK)
)

select count(*) as Currentcount from tescaDbVendor
select count(*) as Precount  from tescaDimVendor
select count(*) as Postcount  from tescaDimVendor


----employee OLTP---
use [Tesca OLTPDatabase]

select a.EmployeeID,a.EmployeeNo,CONCAT_WS(',', upper(a.LastName),a.FirstName) as EmployeeName,a.DoB as DateofBirth, m.MaritalStatus, GETDATE() as loadate from Employee a
inner join MaritalStatus M on a.MaritalStatus=m.MaritalStatusID

select count(*) as StgSourceCount from Employee a
inner join MaritalStatus M on a.MaritalStatus=m.MaritalStatusID

---employee staging---
use [Tesca staging database]
create table tescadbEmployee
(
EmployeeID INT,
EmployeeNO Nvarchar(50),
EmployeeName Nvarchar(50),
DateofBirth date,
Maritalstatus nvarchar(50),
Loaddate datetime default getdate()
constraint tescadb_Employee_PK primary key (EMPloyeeID)
)

select count(*) as StgDescCount from tescadbEmployee

Truncate table tescadbEmployee


---Employee EDW-----
use [Tesca staging database]

select e.EmployeeID,e.EmployeeNO,E.EmployeeName,E.DateofBirth,e.Maritalstatus from tescadbEmployee e

use [Tesca EDW database]

create table tescaDimEmployee
(
EmployeeSK int identity (1,1),
EmployeeID INT,
EmployeeNO Nvarchar(50),
EmployeeName Nvarchar(50),
DateofBirth date,
Maritalstatus nvarchar(50),
startedate date,
Enddate date,
constraint tesca_DimEmployee_SK primary key (EmPloyeeSK)
)

select count(*) as Precount  from tescaDimEmployee
select count(*) as Postcount  from tescaDimEmployee

--Misconduct staging---

use [Tesca staging database]

create table HRMisconduct.Misconduct
(
MisconductID Int,
MisconductDescription nvarchar(250),
loaddate datetime default getdate(),
)
truncate table HRMisconduct.Misconduct

----Misconduct EDW--
use [Tesca staging database]
select m.MisconductID,m.MisconductDescription from HRMisconduct.Misconduct m
group by m.MisconductID,m.MisconductDescription

select count(*) as StgSourceCount from HRMisconduct.Misconduct m
group by m.MisconductID,m.MisconductDescription

use [Tesca EDW database]
create table tesca.DimMisconduct
(
	MisconductSK Int identity(1,1),
	MisconductID Int,
	MisconductDescription nvarchar(250),
	startdate datetime,
	constraint tesca_dimMisconduct_SK primary key (MisconductSK)
)
select count(*) as Precount  from tesca.DimMisconduct
select count(*) as Postcount  from tesca.DimMisconduct
select * from tesca.DimMisconduct
----Decision staging---

use [Tesca staging database]
 
create table HRMisconduct.Decison
(
DecisonID Int,
Decison nvarchar(250),
loaddate datetime default getdate()
)

truncate table HRMisconduct.Decison

insert into HRMisconduct.Decison (DecisonID)
values 
('1'),
('2'),
('3'),
('4'),
('5')


insert into HRMisconduct.Decison (Decison)
values 
('Pending Decision'),
('One Week without Pay'),
('One Week Suspension'),
('Two Week Suspension'),
('Dismissed')





select * from HRMisconduct.Decison
----Decison EDW---
use [Tesca staging database]
select d.DecisonID, d.Decison from HRMisconduct.Decison d
group by d.DecisonID, d.Decison 

use [Tesca EDW database]
create table Tesca.DimDecision 
(
DecisionSK Int identity(1,1),
DecisionID Int,
Decision Nvarchar(250),
startdate datetime
constraint Tesca_DimDecision_Sk  primary key (DecisionSK)
)

insert into tesca.DimDecision(DecisionID)
values 
('1'),
('2'),
('3'),
('4'),
('5')


insert into tesca.DimDecision (Decision)
values 
('Pending Decision'),
('One Week without Pay'),
('One Week Suspension'),
('Two Week Suspension'),
('Dismissed')




select count(*) as Precount  from Tesca.DimDecision
select count(*) as Postcount  from Tesca.DimDecision

select * from tesca.DimDecision
--Absent Staging---

use [Tesca staging database]
create table HRabsent.Absentcategory
(
categoryID Int,
category nvarchar(250),
loadate datetime default getdate()
)

truncate table HRabsent.Absentcategory
select count (*) as StgDescCount from HRabsent.Absentcategory
----Absent EDW---

use [Tesca staging database]

select d.categoryID,d.category from HRAbsent.Absentcategory d
group by d.categoryID,d.category

use [Tesca EDW database]


create table tesca.dimAbsentCategory
(
categorySk int identity(1,1),
categoryID Int,
category nvarchar(250),
startedate datetime,
constraint tesca_dimAbsentCategory_sk primary key (categorySk) 
)

select count(*) as Precount from tesca.dimAbsentCategory
select count(*) as Postcount from tesca.dimAbsentCategory


select DATEPART(HOUR,getdate())*60+ DATEPART(MINUTE,GETDATE()) totalminutes, DATEPART(Hour, getdate()) totalhour, DATEPART(Minute, getdate()) minu


pocket-> paper money, coins (data types)
	-> mould block
	pocket<>water 

declare @pocket nvarchar(10)='efgddddscjasdjhbsjdhcljhc' 
--- int, bigint, char, varchar, nvarchar, table,float, decimal, money 



declare @pocket table
(

)

select @pocket
	set nocount on 
	---declarative bloclk--
	declare @max int = 10
	declare @currentcount int =1
	--- logic area---
	while @currentcount<=@max ---- 1<=10 -> true
	begin
	select @currentcount as Cvalue
	select @currentcount= @currentcount+1 --- @currentcount 1+1=2--
	end
	print('End of execution')

----Dim Hour---- 
use [Tesca EDW database]
create table Tesca.Dimhour
(
HourSK int identity(1,1),
Time_Hour int, ----0-23
PeriodOfDay nvarchar(50),  ---0-> Midnight, 1-> 4--> early hours, 5--> 11 Morning, ->12 NOON, 13-->16 Afternoon, 17-->21 Evening, 21-->23 Night
Businesshour nvarchar(50), ----> 0 to 6 closed, 7 to 17 open, 18-23 closed-
Startdate datetime default getdate(),
constraint Tesca_DimHour_sk primary key (HourSK)
)

select * from tesca.Dimhour

Time_Hour int, ----0-23
PeriodOfDay nvarchar(50),  ---0-> Midnight, 1-> 4--> early hours, 5--> 11 Morning, ->12 NOON, 13-->16 Afternoon, 17-->21 Evening, 21-->23 Night
Businesshour 

create procedure tesca.spDimHour 
as 
begin

declare @hourcount int=0
declare @PeriodOfDay nvarchar(50)
declare @Businesshour nvarchar(50)

select object_id(N'tesca.dimhour')

if (select object_id(N'tesca.dimhour')) is not null
Truncate table tesca.dimhour


	while @hourcount<=23
	begin

	insert into tesca.Dimhour(Time_Hour, PeriodOfDay,Businesshour, Startdate)
	select @hourcount as Time_hour,
	case
	when @hourcount=0 then'Midnight'
	when @hourcount>=1 and @hourcount<=4 then 'Early Hour'
	when @hourcount>=5 and @hourcount<=11 then 'Morning'
	when @hourcount=12 then 'Noon'
	when @hourcount>=13 and @hourcount<=16 then 'Afternoon'
	when @hourcount>=17 and @hourcount<=20 then 'Evening'
	when @hourcount>=20 and @hourcount<=23 then 'Night'
	End as Periodofday,
case 
	
	when @hourcount between 0 and 6 or @hourcount between 18 and 23 then 'Closed'
	--when @hourcount>=18 and @hourcount<=22 then 'Closed'
	when @hourcount between 7 and 17 then 'Open'
	End as BusinessHour, 
	Getdate() as startdate

	select @hourcount=@hourcount+1
	end


End



---Store procedure 2014 to 2040 

---Date-- 
---Datedkey ---- yyyymmdd
---Date yyyy-mm-dd
----year
---quarter
---month
---englishmonth
----spanishmonth
----hindumonth
---Dayofweek--- monday,tuesday etc
----week

---create date dimension ----
drop table tesca.DimDate
alter table tesca.DimDate drop Column DateSk

select * from tesca.dimdate


drop table tesca.DimDate
(
	DateSK int identity (1,1),
	ActualDatePk Date,
	ActualYear Int,
	ActualQuarter nvarchar(2),---Q1,Q2,Q3,Q4
	ActualMonth Int,
	EnglishMonth Nvarchar(50),
	SpanishMonth Nvarchar(50),
	HinduMonth Nvarchar(50),
	Englishdayofweek Nvarchar(50),
	Spanishdayofweek nvarchar(50),
	Hindudayofweek nvarchar(50),
	ActualWeekDay Int, 
	ActualWeek Int,
	Actualdayofyear Int,
	Actualdayofmonth int,
	Constraint tesca_DimDate_Sk primary key (DateSk)


	select * from tesca.Fact_sales_analysis
)



select GETDATE()

select convert(Date, GETDATE()) as Actualdate
select convert(date, GETDATE(),112)
select convert(nvarchar(8), GETDATE(),112)---Surrogate key--
select DATEPART(year, Getdate()) --Year--
select 'Q'+ cast (DATEPART(QUARTER, Getdate()) as nvarchar) --Q1,Q2,Q3,Q4--
select DATEPART(month,Getdate())
select DATENAME(month, Getdate())
select datepart(WEEKDAY, GETDATE())
select datefromparts (2050,12,31), DATEFROMPARTS(1940,01,01)

 select DATEDIFF(day, Datefromparts(1940,01,01), datefromparts(2050,12,31))
 
 exec spDimDataGeneratoruse '2100-12-31'

 create procedure tesca.spDimDataGeneratoruse(@Enddate date)
 as
 begin
 
 Declare @startdate date=(
 select convert(date,min(Startdate)) from
(
 select min(transdate) Startdate from [Tesca OLTPDatabase].dbo.PurchaseTransaction
 union all
  select min(transdate) Startdate from [Tesca OLTPDatabase].dbo.SalesTransaction
  )A
  )

declare @noofdays int= DATEDIFF(day, @startdate, @enddate)
declare @currentday int=0
declare @currentdate date 
Begin
if (select object_id(N'tesca.dimDate')) is not null
Truncate table tesca.dimDate
while @currentday<=@noofdays
Begin

select @currentdate =(DATEADD(day,@currentday, @startdate))

insert into tesca.DimDate( DateSK,ActualDatePk,ActualYear,ActualQuarter,ActualMonth,EnglishMonth,SpanishMonth,HinduMonth,Englishdayofweek,Spanishdayofweek,Hindudayofweek, ActualWeekDay,ActualWeek,Actualdayofmonth,Actualdayofyear)

 select CONVERT(Nvarchar(8),@currentdate,112) as DateKey, @currentdate as ActualDate, YEAR(@currentdate) as ActualYear,

'Q'+CAST(Datepart(Q,@currentdate) as nvarchar) as ActualQuarter, DATEPART(Month,@currentdate) as ActualMonth, DATENAME(month,@currentdate) as EnglishMonth,
Case DATEPART(month,@currentdate)
When 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio'
when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Septembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre'
End as SpanishMonths,

Case DATEPART(Month,@currentdate)
When 1 then 'Caitra' when 2 then 'Vaisakha' when 3 then 'Jyaistha' when 4 then 'Asadha' when 5 then 'Sravana' when 6 then 'Bhadra'
when 7 then 'Asvina' when 8 then 'Kartika' when 9 then 'Agrahayana' when 10 then 'Pausa' when 11 then 'Magha' when 12 then 'Phalguna'
End HinduMonths,

case DATEPART(weekday, @currentdate) 
when 1 then 'Raviwar' when 2 then 'Somvar' when 3 then 'Mangalwar' when 4 then 'Budwhar'
when 5 then 'Guruwar' when 6 then 'Shukrawar' when 7 then 'Shaniwar'
End HinduDaysofWeek,

Case DATEPART(weekday,@currentdate)
when 1 then 'domingo' when 2 then 'Lunes' when 3 then 'Lartes' when 4 then 'Miercoles'
when 5 then 'Jueves' when 6 then 'Viernes' when 7 then 'Sabado'
End SpanishDaysofweek,

datepart(weekday,@currentdate) as Enlgishdayofweek,


Datepart(weekday,@currentdate) as Actualweekday, DATEPART(week, @currentdate) as Actualweek, DATEPART(DAYOFYEAR,@currentdate) As Actualdayofyear,
DAY(@currentdate) as Actualdayofmonth



select @currentday=@currentday+1
End
end
End
set identity_insert tesca.dimdate on 

select * from tesca.DimDate
 


/*
declare @hourcount int=0
declare @PeriodOfDay nvarchar(50)
declare @Businesshour nvarchar(50)

Begin
	while @hourcount<=23
	begin
	If @hourcount=0
	select @PeriodOfDay='Midnight'
	
	If @hourcount>=1 and @hourcount=4
	select @PeriodOfDay='Early Hour'

	If @hourcount>=5 and @hourcount=12
	select @PeriodOfDay='Morning'

	If @hourcount>=12
	select @PeriodOfDay='Noon'

	If @hourcount>=13 and @hourcount=16
	select @PeriodOfDay='Afternoon'

	If @hourcount>=17 and @hourcount=20
	select @PeriodOfDay='Evening'

	If @hourcount>=21 and @hourcount=23
	select @PeriodOfDay='Night'
	
	select @hourcount,@PeriodOfDay
	select @hourcount=@hourcount+1
	end


End
*/


-- sales facts table--

use [Tesca OLTPDatabase]

if (select COUNT(*) from [Tesca EDW database].tesca.Fact_sales_analysis)>0

Begin
	select s.TransactionID,s.TransactionNO,convert(date,Transdate) as TransDate, datepart(hour,Transdate) as Transhour,
	CONVERT(date,OrderDate) as Orderdate, datepart(hour, OrderDate) as Orderhour,
	CONVERT(date,deliverydate) as DevlierveryDate, ChannelID, CustomerID, EmployeeID, ProductID,
	StoreID, PromotionID,Quantity,TaxAmount,LineAmount,LineDiscountAmount, GETDATE() as LoadDate 
	from SalesTransaction s
	where CONVERT(date, TransDate)= DATEADD(day, -1, convert(date, getdate()))
End 


Else
	Begin 

	select s.TransactionID,s.TransactionNO,convert(date,Transdate) as TransDate, datepart(hour,Transdate) as Transhour,
	CONVERT(date,OrderDate) as Orderdate, datepart(hour, OrderDate) as Orderhour,
	CONVERT(date,deliverydate) as DevlierveryDate, ChannelID, CustomerID, EmployeeID, ProductID,
	 StoreID, PromotionID, Quantity,TaxAmount,LineAmount,LineDiscountAmount, GETDATE() as LoadDate
	from SalesTransaction s
	where CONVERT(date, TransDate)<= DATEADD(day, -1, convert(date, getdate()))
End
use [Tesca OLTPDatabase]

select productID, StoreID promotionID from salestransaction 






declare @StgSourceCount bigint=0

if (select COUNT(*) from [Tesca EDW database].tesca.Fact_sales_analysis)>0

Begin
select @StgSourceCount=(select Count(*) as StgSourceCount from SalesTransaction s
	where CONVERT(date, TransDate)= DATEADD(day, -1, convert(date, getdate())))--- from n-1 
End 


Else
	Begin 
	select @StgSourceCount=(
	select Count(*) as StgSourceCount from SalesTransaction
	where CONVERT(date, TransDate)<= DATEADD(day, -1, convert(date, getdate())))--- from inception till n-1 

End

select @StgSourceCount as StgSourceCount





---Sales staging--

use [Tesca staging database]
truncate table tescaDb.Sales_Trans

alter table TescaDb.Sales_Trans alter column TransDate date




create table TescaDb.Sales_Trans
( TransactionID int, 
TransactionNO Nvarchar(50),
TransDate datetime, 
Transhour int,
Orderdate date,
OrderHour int,
DeliveryDate date,
ChannelID int,
CustomerID int,
EmployeeID int,
ProductID int, 
StoreID int, 
PromotionID int,
Quantity float,
Taxamount float,
Lineamount float, 
LineDiscountAmount float,
Loaddate datetime default getdate(),
constraint tescaDb_sale_trans_pk primary key(TransactionID)
)

select count(*) as StgDescCount from TescaDb.Sales_Trans

use [Tesca EDW database]

select DateSK,ActualDatePK from tesca.DimDate
select category,categoryID from tesca.dimAbsentCategory
select CustomerSK,CustomerID from TescaDimcustomer where Enddate is null
select EmployeeSK,EmployeeID from tescaDimEmployee where Enddate is null
select DecisionSK,DecisionID from tesca.DimDecision
select HourSK,Time_Hour from tesca.Dimhour
select MisconductSK,MisconductID from tesca.DimMisconduct
select ChannelSK,ChannelID from tescaDimChannel where enddate is null 
select productSK,productID from tesca.dimproduct where enddate is null
select promotionSK,PromotionID from TescaDimPromotion
select storeSK,StoreID from tesca.dimstore
select VendorSK,VendorID from tescaDimVendor where endate is null


--- Sales EDW----
use [Tesca staging database]
select TransactionID,TransactionNO,TransDate,Transhour,Orderdate,OrderHour,DeliveryDate,ChannelID,CustomerID,EmployeeID,
ProductID, StoreID,PromotionID,Quantity, Taxamount,Lineamount, LineDiscountAmount, GETDATE() as Loaddate from tescaDb.Sales_Trans

use [Tesca EDW database]
alter table Tesca.Fact_sales_analysis alter column TransDate_Sk date

create table Tesca.Fact_sales_analysis
(
Sales_Analysis_Sk bigint Identity(1,1),
TransactionID int,
TransactionNO Nvarchar(50), 
TransDate_Sk int,
TransHour_Sk int,
OrderDate_Sk int,
OrderHour_Sk int,
DeliveryDate_SK int,
ChannelSK int,
CustomerSk int,
EmployeeSk int,
ProductSk int,
StoreSk int,
PromotionSk int,
Quantity int,
Taxamount float,
Lineamount float,
LineDiscountAmount float,
Loaddate datetime, 
constraint tesca_sales_Analysis_sk primary key (sales_analysis_Sk),
constraint tesca_sales_Trans_sk foreign key(Transdate_Sk) references tesca.dimdate(dateSk),
constraint tesca_sales_TransHour_sk foreign key(TransHour_Sk) references tesca.dimHour(HourSk),
constraint tesca_sales_Order_sk foreign key(OrderDate_Sk) references tesca.dimdate(dateSk),
constraint tesca_sales_OrderHour_sk foreign key(OrderHour_Sk) references tesca.dimHour(HourSk),
constraint tesca_sales_DeliveryDate_sk foreign key(DeliveryDate_Sk) references tesca.dimdate(dateSk),
constraint tesca_sales_Channel_sk foreign key(ChannelSk) references tescaDimChannel(ChannelSK),
constraint tesca_sales_Customer_sk foreign key(CustomerSk) references TescaDimCustomer(CustomerSk),
constraint tesca_sales_Employee_sk foreign key(EmployeeSk) references tescaDimEmployee(employeeSK),
constraint tesca_sales_Product_sk foreign key(ProductSk) references tesca.dimproduct(productSK),
constraint tesca_sales_Store_sk foreign key(StoreSk) references tesca.dimstore(storeSK),
constraint tesca_sales_Promotion_sk foreign key(PromotionSk) references tescaDimPromotion(promotionSK),
)

alter table Tesca.Fact_sales_analysis add constraint tesca_sales_Trans_sk foreign key(Transdate_Sk) references tesca.dimdate(dateSk)

select count(*) Precount from Tesca.Fact_sales_analysis
select count(*) Postcount from Tesca.Fact_sales_analysis


---purchase business OLTP process fact load---

use [Tesca OLTPDatabase]
if ( select count(*) from [Tesca EDW database].tesca.Fact_Purchase_analysis)<0
Begin
select p.TransactionID,p.TransactionNO,CONVERT(date,Transdate) as Transdate, CONVERT(date,OrderDate) As Orderdate,
CONVERT(date, deliverydate) As Deliverydate, CONVERT(date,shipdate) as Shipdate, p.VendorID,p.EmployeeID,p.ProductID,p.StoreID,
p.Quantity,p.LineAmount,p.TaxAmount, DATEDIFF(day, convert(date,OrderDate), CONVERT(date,deliverydate))+1 delivery_services, GETDATE() as Loaddate
from PurchaseTransaction p where CONVERT(date,transdate)<=dateadd(day,-1,convert(date,getdate()))-- inception of tesca till n-1
End

Else

Begin
select p.TransactionID,p.TransactionNO,CONVERT(date,Transdate) as Transdate, CONVERT(date,OrderDate) As Orderdate,
CONVERT(date, deliverydate) As Deliverydate, CONVERT(date,shipdate) as Shipdate, p.VendorID,p.EmployeeID,p.ProductID,p.StoreID,
p.Quantity,p.LineAmount,p.TaxAmount, DATEDIFF(day, convert(date,OrderDate), CONVERT(date,deliverydate))+1 delivery_services, GETDATE() as Loaddate
from PurchaseTransaction p where convert(date,transdate)= dateadd(day, 0,convert(date,getdate()))---n-1--
End








declare @StgSourceCount bigint=0

if (select count(*) from [Tesca EDW database].tesca.Fact_Purchase_analysis)<=0
Begin
select @StgSourceCount=(select Count(*) from PurchaseTransaction p where CONVERT (date,transdate)<=dateadd(day,-1,convert(date,getdate())))
End
Else
Begin
select @StgSourceCount= (select count(*) from PurchaseTransaction p where convert(date,transdate)= dateadd(day, 0,convert(date,getdate())))
End

select @StgSourceCount as StgSourceCount

---purchase Staging--

use [Tesca staging database]

create table tescaDB.Purchase_Analysis

(
	TransactionID int,
	TransactionNO nvarchar(50),
	Transdate Date,
	Orderdate Date,
	DeliveryDate Date,
	ShipDate date,
	VendorID int,
	EmployeeID int,
	ProductID int,
	StoreID Int,
	Quantity float,
	Lineamount float,
	Taxamount float,
	Delivery_Services int,
	LoadDate datetime default getdate()
	constraint tescaDb_purchase_Analysis_pk primary key (TransactionID)
)

truncate table tescaDB.Purchase_Analysis

select count(*) as StgDescCount from tescaDB.Purchase_Analysis

-----EDW purchase business process--

select TransactionID,TransactionNO,Transdate,Orderdate,DeliveryDate,ShipDate,VendorID,EmployeeID,ProductID,StoreID,Quantity,Lineamount,Taxamount,Delivery_Services,
getdate() as loaddate from tescadb.Purchase_Analysis

use [Tesca EDW database]


select count(*) as Precount from tesca.Fact_Purchase_analysis
select count(*) as Postcount from tesca.Fact_Purchase_analysis



create table tesca.Fact_Purchase_analysis
(
Purchase_Analysis_Sk bigint identity(1,1),
TransactionID int,
TransactionNO nvarchar(50),
Transdate_sk int,
OrderDate_sk int,
DeliveryDate_Sk int,
ShipDate_sk int,
VendorSK int,
EmployeeSk int,
ProductSk int,
StoreSK int,
Quantity float,
LineAmount float,
TaxAmount float,
Delivery_services int,
Loaddate datetime default getdate(),
Constraint tesca_purchase_Analysis_sk primary key (purchase_analysis_sk),
constraint tesca_Purchase_Transdate_sk foreign key (TransDate_sk) references tesca.DimDate(DateSk),
constraint tesca_Purchase_DeliveryDate_SK foreign key(DeliveryDate_sk) references tesca.DimDate(DateSK),
Constraint tesca_Purchase_shipDate_sk foreign key (Shipdate_sk) references tesca.DimDate(DateSK),
constraint tesca_purchase_Vendor_Sk foreign key (vendorSK) references tescaDimVendor(VendorSK),
constraint tesca_purchase_productsk foreign key (Productsk) references tesca.dimproduct(productsk),
constraint tesca_purchase_Storesk foreign key (StoreSk) references tesca.dimstore(storesk),
)

---HR OverTime---
use [Tesca staging database]
drop table Tescadb.Overtime_Trans
select count(*) as StgDescCount from Tescadb.Overtime_Trans
create table Tescadb.Overtime_Trans
(
OvertimeID bigint,
EmployeeNO Nvarchar(50),
FirstName Nvarchar (50),
Lastname Nvarchar (50),
StartOvertime datetime,
EndOvertime datetime,
Loadate datetime,

)
truncate table Tescadb.Overtime_Trans
select * from Tescadb.Overtime_Trans

select count(*) as EdwCount from [Tesca EDW database].tesca.Fact_HR_Overtime

-- fact Staging Query---
use [Tesca staging database]

select overtimeID, EmployeeNO,FirstName,Lastname,convert(date,StartOvertime) Startovertimedata, DATEPART(hour,Startovertime) StartovertimeHour, CONVERT(date, Endovertime) Endovertimedata,
DATEPART(hour,endovertime) Endovertimehour, DATEDIFF(hour, StartOvertime,EndOvertime) Overtime_hour, GETDATE() as LoadDate 
from Tescadb.Overtime_Trans
where OvertimeID in 
	(select min(OVertimeID) from tescadb.Overtime_Trans group by EmployeeNO,FirstName,Lastname,StartOvertime,EndOvertime)


---Fact EDW Overtime---

use [Tesca EDW database]

create table Tesca.Fact_HR_Overtime
(
HR_Overtime_SK Int identity (1,1),
EmployeeSK int, 
StartoverdateSK int,
StartoverhourSk int,
EndoverdateSk int,
EndoverhourSK int,
Overtimehour int,
Loaddate datetime default getdate(),
constraint Tesca_HR_Overtime_ primary key(HR_Overtime_SK),
constraint Tesca_HR_Employee_SK foreign key(EmployeeSK) references  tescaDimEmployee(EmployeeSK),
constraint Tesca_HR_Overtime_StartoverdateSK foreign key(StartoverdateSK) references  tesca.DimDate(DateSK),
constraint Tesca_HR_Overtime_StartoverhourSK foreign key(StartoverhourSK) references  tesca.Dimhour(HourSK),
constraint Tesca_HR_Overtime_EndoverdateSK foreign key(EndoverdateSK) references  tesca.DimDate(DateSK),
constraint Tesca_HR_Overtime_EndoverhourSK foreign key(EndoverhourSK) references  tesca.Dimhour(HourSK),
 )

 select count(*) Precount from Tesca.Fact_HR_Overtime
  select count(*) Postcount from Tesca.Fact_HR_Overtime

  select * from Tesca.Fact_HR_Overtime


 --Absent Data--
 use [Tesca staging database]
 create table tescaDB.hr_absence_analysis
 truncate table tescaDB.hr_absence_analysis
 (
 empid int,
 store int,
 absent_date date,
 absent_hour int,
 absent_category int,
 Loaddate datetime default getdate(),
 )

 select * from tescaDB.hr_absence_analysis

 With absent_data (  RowID, Absentkey, empid,store,absent_date,absent_hour,absent_category)
 AS
 (
 select  
 ROW_NUMBER() over ( order by empid,store,absent_date,absent_hour,absent_category) as RowID, 
 concat_WS('~',empid,store, absent_date,absent_hour, absent_category) as absentKey, 
 empid,store,absent_date,absent_hour,absent_category
 from  tescaDb.hr_absence_analysis
 )


 select distinct absent_category from
 (
 select empid,store,absent_date,absent_hour,absent_category, GETDATE() as Loaddate from Absent_Data
 Where  rowID  in (  select min(RowID) from Absent_Data group by Absentkey)
)MOi

  /*
 select min(rowId),  empid,store,absent_date,absent_hour,absent_category from Absent_Data
 group by empid,store,absent_date,absent_hour,absent_category from Absent_Data
 */ 


  --Fact AbsentData---

use [Tesca EDW database]
create table tesca.fact_hr_absence_analysis 
truncate table tesca.fact_hr_absence_analysis 

(
	hr_absence_analysis_sk bigint identity(1,1),
	EmployeeSk int,	
	 storeSK int,
	 absent_dateSK int,
	 absent_categorySk int,
	 absent_hour int,
	 Loadate datetime default getdate()
 constraint tesca_hr_absence_analysis_Sk primary key(hr_absence_analysis_Sk),
  constraint tesca_hr_absence_analysis_Employeesk foreign key (EmployeeSk) references  tescaDimEmployee(EmployeeSk),
  constraint tesca_hr_absence_analysis_Storesk foreign key (StoreSk) references  tesca.dimStore(StoreSk),
  constraint  tesca_hr_absence_analysis_absentDatesk   foreign key (absentdateSk) references tesca.dimdate(datesk),
  constraint  tesca_hr_absence_analysis_absentCategorySk   foreign key (absentcategorySk) references tesca.DimAbsentCategory(Categorysk)
 )

 select * from tesca.fact_hr_absence_analysis

 insert into tesca.fact_hr_absence_analysis select from   


 select count(*) Precount from tesca.fact_hr_absence_analysis 
 select count (*) Postcount from tesca.fact_hr_absence_analysis 

---Absent Misconduct--

 empid,store,absent_date,absent_hour,absent_category

use [Tesca staging database]
truncate table tescaDB.hr_misconduct_analysis
create table tescaDB.hr_misconduct_analysis
(
 empid int,
 store int,
 Misconduct_date date,
 Misconduct_ID int,
 DecisionID int,
 Loaddate datetime default getdate()
 )

 select count (*) as EdwCount from  tescaDB.hr_misconduct_analysis 
  select count (*) as DescCount from  tescaDB.hr_misconduct_analysis 
 

 --- empid,store,absent_date,absent_hour,absent_category

 With Misconduct_data (RowID,  MisconductKey, empid, store, Misconduct_date, Misconduct_ID, DecisionID)                               
 as
 (
 select 
ROW_NUMBER() over (order by empid, store, Misconduct_date, Misconduct_ID, DecisionID) as RowID,
concat_ws('~',empID,store,Misconduct_date, Misconduct_ID,DecisionID)
as MisconductKey,
 empid,store,Misconduct_date,Misconduct_ID,DecisionID
 from tescaDB.hr_misconduct_analysis 
 
 )
  
select empid,store,Misconduct_date,Misconduct_ID,DecisionID, GETDATE() as Loaddate from Misconduct_data
 Where  rowID  in (  select max(RowID) from misconduct_data group by Misconductkey)


 use tesca [Tesca staging database]

  -----Fact misconduct fact---


  use [Tesca EDW database]
 
  create table tesca.fact_hr_misconduct_analysis
  truncate table tesca.fact_hr_misconduct_analysis
  (
  Hr_misconduct_analysis_Sk bigint identity(1,1),
  EmployeeSK int,
  StoreSk int,
  misconductDateSk int,
  MisconductSk int,
  decisionSk int,
  Loadate datetime default getdate(),
  
  constraint tesca_hr_misconduct_analysis_sk primary key (hr_misconduct_analysis_sk),
  constraint tesca_hr_misconduct_analysis_EmployeeSK foreign key(EmployeeSK) references tescaDimEmployee(EmployeeSk),
  constraint tesca_hr_misconduct_analysis_StoreSK foreign key(StoreSK) references tesca.dimstore(StoreSk),
  constraint tesca_hr_misconduct_analysis_misconductdateSK foreign key(MisconductdateSK) references tesca.DimDate(DateSk),
  constraint tesca_hr_misconduct_analysis_misconductSK foreign key(MisconductSK) references tesca.Dimmisconduct(MisconductSk),
  constraint tesca_hr_misconduct_analysis_decisionSK foreign key(decisionSK) references tesca.DimDecision(DecisionSk),
  )


  select count(*) Precount from tesca.fact_hr_misconduct_analysis
    select count(*) Postcount from tesca.fact_hr_misconduct_analysis

	select * from tesca.fact_hr_misconduct_analysis
