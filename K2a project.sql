--Float Category table--
Create table FloatCategory
(
FloatCategoryID int,
FLoatRate float,
FloatExceedQty float,
FloatEXceedRate float,
Primary key (FloatCategoryID)
)

insert into Floatcategory (FloatCategoryID,FLoatRate,FloatExceedQty,FloatEXceedRate)
values (1,0.4,15,0.7), 
(2,0.1,15,0.6),
(3,0.2,50,0.75),
(4,0.24,68,0.9),
(5,0.12,100,1.8) 

select * from FloatCategory

 

--Employee table--
Create table Equiptment
(
EquiptmentID int,
EquiptmentName varchar(55),
Unitprice decimal (12,2),
DiscountPercent Float, 
FloatCategory_SK int,
Primary key(EquiptmentID),
Constraint Equiptment_FloatCategorySK Foreign key (FloatCategory_SK) references FloatCategory(FloatCategoryID)
)

insert into Equiptment(EquiptmentID, EquiptmentName, Unitprice, DiscountPercent,FloatCategory_SK)
values (1, ' Cup -Lock System of Shuttering – 3.2 M high',122.50,0.015,1),
(2,'Steel Props – 4.2 M High',100,0.02,1),
(3,'Steel shuttering plates – 3 ft x 2 ft',1000.50,0.05,1),
(4,'Steel section Girders – 8ft to 12 ft' ,1700.00,0.01,1),
(5,'Steel pipes for scaffolding',15000.00,0.08,1),
(6,'Telescopic Girders',200,0.4,1),
(7,'Tower Crane',233,0.14,1),
(8,'Tractor mounted Crane' ,105,0.4,1),
(9,'Concrete batching plant' ,1325.70,0.015,1),
(10,'Mobile batching plant' ,99.87,0.011,1),
(11,'Concrete Pump (Greaves – 40 cum/hr)',1500.50,0.095,1),
(12,'Tremix machine set with trowel & floater',700.69,0.15,1),
(13,'Concrete mixers',120,0.15,1),
(14,'D.G. Set – 82.KVA' ,12.50,0.15,1),
(15,'Vibrators (Electrical)',200.99,0.001,1),
(16,'Vibrators (Petrol)',4100.90,0.03,1),
(17,'Stone cutting machine (Platform type)',1200.56,0.09,1),
(18,'Stone cutting machine (hand type)' ,1780,0.0094,1),
(19,'Groove cutting machine',122.50,0.5,1),
(20,'Builder’sÂ Hoist with winch',122.50,0.5,1),
(21,'Bar Bending & cutting machine' ,122.50,0.5,1),
(22,'Truck' ,122.50,0.5,1),
(23,'Air Compressor',122.50,0.5,1),
(24,'Road Roller',122.50,0.5,1),
(25,'Vibro-Roller',122.50,0.5,1),
(26,'Tipper – Tata' ,122.50,0.5,1),
(27,'Excavator – ACE' ,122.50,0.5,1),
(28,'Tractor with trolly – 40 HP',122.50,0.5,1),
(29,'Water pump',122.50,0.5,1),
(30,'Cutter Hitachi – Model CM 45',122.50,0.5,1),
(31,'Welding Set – Aircooled',122.50,0.5,1),
(32,'Drilling Machine Bosch – GSB – 16' ,122.50,0.5,1),
(33,'Mud pump – GEC – 1 HP 2 HP',122.50,0.5,1),
(34,'Floor Grinding machine – 2 HP' ,122.50,0.5,1),
(35,'Earth Compactor – 7.5 HP motor',122.50,0.5,1),
(36,'CGI Sheets – 10′, 12′ Long' ,122.50,0.5,1)

Select * from Equiptment
select count(*) as quantity from Equiptment

-- Customer table--
Create Table Customer
(
CustomerID int, 
CustomerName varchar(255),
Category varchar(255),
PrimaryContact varchar(255),
ReferenceNo varchar(255),
PaymentDays int,
PostalCode int,
primary key (CustomerID)
)
insert into Customer( CustomerID, CustomerName,Category,PrimaryContact,ReferenceNo,PaymentDays,PostalCode)
values(1,'A Datum Corporation','Novelty Goods Supplier','Reio Kabin','AA20384',14,46077),
(2,'Woodgrove Bank','Financial Services Supplier','Hubert Helms','28034202',7,94101),
(3,'Consolidated Messenger','Courier','Kerstin Parn','209340283',30,94101),
(4,'Litware Inc.','Packaging Supplier','Elias Myllari','BC0280982',30,95245),
(5,'Humongous Insurance','Insurance Services Supplier','Madelaine Cartier','82420938',14,37770),
(6,'Graphic Design Institute','Novelty Goods Supplier','Penny Buck','8803922',14,64847),
(7,'Fabrikam Inc.','Clothing Supplier','Bill Lawson','293092',30,40351),
(8,'The Phone Company','Novelty Goods Supplier','Hai Dam','237408032',30,56732),
(9,'Trey Research','Marketing Services Supplier','Donald Jones','82304822',7,57543),
(10,'Lucerne Publishing','Novelty Goods Supplier','Prem Prabhu','JQ082304802',30,37659),
(11,'Contoso Ltd.','Novelty Goods Supplier','Hanna Mihhailov','B2084020',7,98253),
(12,'Nod Publishers','Novelty Goods Supplier','Marcos Costa','GL08029802',7,27906),
(13,'Northwind Electric Cars','Toy Supplier','Eliza Soderberg','ML0300202',30,7860),
(14,'A Datum Corporation','Novelty Goods Supplier','Reio Kabin','AA20384',14,46077),
(15,'Contoso Ltd.','Novelty Goods Supplier','Hanna Mihhailov','B2084020',7,98253),
(16,'Consolidated Messenger','Courier','Kerstin Parn','209340283',30,94101),
(17,'Fabrikam Inc.','Clothing Supplier','Bill Lawson','293092',30,40351),
(18,'Graphic Design Institute','Novelty Goods Supplier','Penny Buck','8803922',14,64847),
(19,'Humongous Insurance','Insurance Services Supplier','Madelaine Cartier','82420938',14,37770),
(20,'Litware Inc.','Packaging Supplier','Elias Myllari','BC0280982',30,95245),
(21,'Lucerne Publishing','Novelty Goods Supplier','Prem Prabhu','JQ082304802',30,37659),
(22,'Nod Publishers','Novelty Goods Supplier','Marcos Costa','GL08029802',7,27906),
(23,'Northwind Electric Cars','Toy Supplier','Eliza Soderberg','ML0300202',30,7860),
(24,'Trey Research','Marketing Services Supplier','Donald Jones','82304822',7,57543),
(25,'The Phone Company','Novelty Goods Supplier','Hai Dam','237408032',30,56732),
(26,'Woodgrove Bank','Financial Services Supplier','Hubert Helms','28034202',7,94101),
(27,'Consolidated Messenger','Courier Services Supplier','Kerstin Parn','209340283',30,94101)

select * from Customer
-----Temp table-----
create table ##K2a_temp(

TransID int identity (1,1),
Transdate datetime, 
CustomerID int,
EquiptmentID int,
Quantity float,
)

select * from ##K2a_temp


--- declare variables---
declare @Transdate as date;
declare @StartDateD as date;
declare @EnddateD as date;
declare @Daysbetween as int;
declare @CountN as int;
declare @Count as int;


declare @RandomCustomerID as int
declare @RandomEquiptmentID as int
declare @Randomquantity as int

declare @LowestlimitforcustomerID as int
declare @HighestlimitforcustomerID as int

set @LowestlimitforcustomerID=1
set @HighestlimitforcustomerID=27

declare @LowestlimitforEquiptmentID as int
declare @highestlimitforEquiptmentID as int

set @LowestlimitforEquiptmentID=1
set @highestlimitforEquiptmentID=36

declare @LowestlimitforQuantity as int
declare @HighestlimitforQuantity as int

set @LowestlimitforQuantity= 50
set @HighestlimitforQuantity=300

--StartDate--

set @StartDateD= '01/01/2015'
set @EnddateD='05/31/2019'
set @Daysbetween=(1+DATEDIFF(DAY, @StartDateD, @EnddateD))
set @Count=1
set @CountN=1

while @Count<=1000000
while @CountN<=1000000

Begin 


select @Transdate= DATEADD(DAY,RAND(CheckSum(NEWID()))*@Daysbetween,@StartDateD)
select @RandomCustomerID= ROUND(((@HighestlimitforcustomerID-@LowestlimitforCustomerID)* Rand())+ @LowestlimitforcustomerID,0)
select @RandomEquiptmentID= ROUND(((@HighestlimitforEquiptmentID-@LowestlimitforEquiptmentID)* Rand())+@LowestlimitforCustomerID,0)
select @Randomquantity= ROUND(((@HighestlimitforQuantity-@LowestlimitforQuantity)* Rand())+@LowestlimitforQuantity,0)




insert into ##K2a_temp(Transdate,CustomerID,EquiptmentID,Quantity)

select @Transdate as Transdate, @RandomCustomerID as CustomerID,
@RandomEquiptmentID as EquiptmentID, @Randomquantity as Quantity

set @CountN=@CountN + @@ROWCOUNT;
set @Count=@Count + 1
end

select * from ##K2a_temp


---Equiptment Transaction--
create table EquiptmentTransaction
(
TransID int Identity(1,1),
TransDate datetime, 
Customer_Sk int, 
Equiptment_Sk int,
Quantity float,
GrossAmount decimal(12,2),
DiscountAmount decimal(12,2),
FloatRateAmount decimal(12,2),
FloatExceededAmount decimal(12,2),
PostalVariationAmount decimal(12,2),
Constraint Equiptment_Transaction_TransID Primary key(TransID),
Constraint Equiptment_Transaction_CustomerSk foreign key(Customer_Sk)references Customer(CustomerID),
Constraint Equiptment_Transaction_EqiptmentSk foreign key(Equiptment_Sk)references Equiptment(EquiptmentID),
)

insert into EquiptmentTransaction (TransDate,Customer_Sk,Equiptment_Sk,Quantity,GrossAmount,DiscountAmount,FloatRateAmount,FloatExceededAmount,PostalVariationAmount)

select Abu.Transdate, Abu.CustomerID, abu.EquiptmentID,abu.Quantity,b.Unitprice*abu.Quantity as 
GrossAmount, b.DiscountPercent* abu.Quantity as 
DiscountAmount,
	Case 
			When 
Abu.Quantity between 100 and 150 then f.FLoatRate* Abu.Quantity
else 0
End FloatrateAmount,
 
Case 

When
Abu.Quantity> 150 then f.FloatEXceedRate* Abu.Quantity
else 0
End FloatexceedAmount,

Case 
when 
c.postalcode between 7000 and 50000
then 0.002* Abu.Quantity
when
c.postalcode between 50001 and 70000 then 0.050* abu.Quantity
when
c.postalcode between 70001 and 90000 then 0.062* Abu.Quantity
when 
c.PostalCode>90000 then 0.078* abu.Quantity
else 0 
end PostalvariationAmount

from ##K2a_temp Abu
inner join dbo.Equiptment b on 
abu.EquiptmentID=b.EquiptmentID
inner join dbo.FloatCategory F on 
b.FloatCategory_SK=f.FloatCategoryID
inner join dbo.Customer C on 
c.CustomerID=Abu.CustomerID

select * from EquiptmentTransaction

select * from ##K2a_temp


---create a dynamic function---

create function Top10Customerlist
(@Transyear int= Transyear,
@Place int= Position
)

returns @ResultTable table 
(
EquiptmentName Nvarchar(255), TransYear int,
GrossAmount int, Position int)

as begin 

with TopCustomer as 
(
select

