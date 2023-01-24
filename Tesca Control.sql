use [Tesca control database]


create schema control 

--Environment table--

create table control.Environment
(
Envid int,
Environment nvarchar(255),
constraint control_environment_pk primary key(Envid)
)

insert into control.Environment (Envid,Environment)
values (1, 'Staging'),
(2,'Edw')



---frequency of run--
 create table control.runfrequency
 drop table control.runfrequency
 (
 FreqID int,
 Frequency nvarchar (255),
 constraint control_runfrequency_pk primary key (FreqID)
 )

 insert into control.runfrequency (FreqID,Frequency)
 values (1,'Daily'),
 (2,'Weekly'),
 (3,'Monthly'),
 (4,'Quarterly'),
 (5,'Yearly')

 --Package type -- Dimension, fact--
  drop table control.Packagetype

 create table control.Packagetype
 (
 PackagetypeID int,
 Packagetype nvarchar (255)
 constraint control_package_packagetype_pk primary key (PackagetypeID)
 )

 insert into control.packagetype
 values (1, 'Dimension'),
(2,'Fact')

select * from control.Packagetype




 ---package---
 drop table control.Package

 create table control.Package
 (
 PackageID int,
 PackageName Nvarchar(255),
 PackageTypeID int,
 SequenceNO int,
 EnvID int,
 FreqID int,
 Runstartdate date,
 Runenddate date,
 Active bit,
 Lastrundate datetime,
 constraint cotrol_Package_pk primary key (PackageID),
 constraint control_package_packagetypeID_fk foreign key(PackageTypeId) references control.Packagetype(PackagetypeID),
  constraint control_package_environment_fk foreign key(EnvId) references control.Environment(EnvID),
    constraint control_package_runfrequency_fk foreign key(FreqId) references control.runfrequency(FreqID)
	)


	update control.Package set PackageName='stg.DimProduct.dtsx' where PackageID=1
		update control.Package set PackageName='stg.DimPromotion.dtsx' where PackageID=2
	update control.Package set PackageName='stg.DimStore.dtsx' where PackageID=3
		update control.Package set PackageName='stg.DimCustomer.dtsx' where PackageID=4



		update control.Package set SequenceNO=12000 where PackageID = 12
			update control.Package set SequenceNO=13000 where PackageID = 13
				update control.Package set SequenceNO=14000 where PackageID = 14
					update control.Package set SequenceNO=15000 where PackageID = 15




insert into control.Package(Packageid, Packagename,PackagetypeID, sequenceNo,EnvID,FreqID,runstartdate,Active) Values

(30,'EdwFactAbsenceAnalysis.',2,60000,2,1, CONVERT(date,getdate()),1)

(15,'stg.FactAbsenceAnalysis.dtsx',2,5000,1,1, CONVERT(date,getdate()),1)


(5,'stg.DimPosChannel.dtsx',1,5000,1,1, CONVERT(date,getdate()),1)


(1,'stgDimProduct.dtsx', 1, 1000,1,1, CONVERT(date,getdate()),1),
(2,'stgDimPromotion.dtsx', 1, 2000,1,1, CONVERT(date,getdate()),1),
(3,'stgDimStore.dtsx', 1, 3000,1,1, CONVERT(date,getdate()),1),
(4,'stgDimCustomer.dtsx', 1, 4000,1,1, CONVERT(date,getdate()),1)
(5,'stg.DimPosChannel.dtsx',1,5000,1,1, CONVERT(date,getdate()),1),


select * from control.package



---Precount + current +type2<> postcount-> data failure--
--- precount+ current <> postcount -> data failure--
--- stgsoucrecount<> stgdesccount -> data failure

drop table control.metrics

create table control.metrics
(
MetricID int identity(1,1),
PackageID int,
stgSourcecount bigint,
stgDescCount bigint,
Precount bigint,
Currentcount bigint,
Type1count bigint,
Type2count bigint,
Postcount bigint,
Rundate datetime,
constraint control_metrics_pk primary key (metricID),
constraint control_metrics_PackageID_fk foreign key(PackageID) references control.package(PackageID),
)


declare @StgSourceCount bigint
declare @StgDescCount bigint
declare @PackageID bigint

insert into control.metrics(PackageID,stgSourcecount,stgDescCount,Rundate)
select @PackageID, @StgSourceCount, @StgDescCount, GETDATE() 

update control.Package set Lastrundate=GETDATE() where PackageID=@PackageID


select * from control.metrics
select * from control.Package



select p.PackageID,p.PackageName,p.SequenceNO from control.Package p
where p.EnvID=1 and p.Active=1 and p.Runstartdate<=CONVERT(date,Getdate()) 
and (Runenddate is null or Runenddate>=CONVERT(date,getdate()))


select EOMONTH(getdate())

If DATEPART(weekday,getdate())=7 and CONVERT(date,getdate())<> EOMONTH(getdate())
Begin
select p.PackageID,p.PackageName from control.Package p
where p.EnvID=1 and p.Active=1 and p.Runstartdate<=CONVERT(date,Getdate()) 
and (Runenddate is null or Runenddate>=CONVERT(date,getdate())) and p.FreqID in (1,2) order by p.SequenceNO asc
End

else if  DATEPART(weekday,getdate())=7 and CONVERT(date,getdate())=EOMONTH(getdate())

Begin

select p.PackageID,p.PackageName from control.Package p
where p.EnvID=1 and p.Active=1 and p.Runstartdate<=CONVERT(date,Getdate()) 
and (Runenddate is null or Runenddate>=CONVERT(date,getdate())) and p.FreqID in (1,2,3) order by p.SequenceNO asc
End

Else

Begin

select p.PackageID,p.PackageName from control.Package p
where p.EnvID=1 and p.Active=1 and p.Runstartdate<=CONVERT(date,Getdate()) 
and (Runenddate is null or Runenddate>=CONVERT(date,getdate())) and p.FreqID=1 order by p.SequenceNO asc
End

select * from control.metrics


--Edw Control package---

insert into control.Package(Packageid, Packagename,PackagetypeID, sequenceNo,EnvID,FreqID,runstartdate,Active) Values

(16,'EdwDimproduct.dtsx',1,1000,2,1, CONVERT(date,getdate()),1)

---edw metrics facts--

declare @Precount bigint=?
declare @Currentcount bigint=?
declare @Postcount bigint=?
declare @PackageID bigint=?

insert into control.metrics(PackageID,Precount,Currentcount,Postcount,Rundate)
select @PackageID,@Precount,@Currentcount,@Postcount, GETDATE()

update control.Package set Lastrundate=GETDATE() where PackageID=@PackageID

create table control.Anomalies
(AnomaliesID bigint identity(1,1),
PackageID int,
Dimension nvarchar(255),
AttributeName Nvarchar(255),
TransID bigint,
Rundate datetime default getdate()
constraint control_anomalies_pk primary key (AnomaliesID),
constraint control_anomalies_package_fk foreign key (PackageID) references control.Package(PackageID)
)



select EOMONTH(getdate())

If DATEPART(weekday,getdate())=7 and CONVERT(date,getdate())<> EOMONTH(getdate())
Begin
select p.PackageID,p.PackageName from control.Package p
where p.EnvID=2 and p.Active=1 and p.Runstartdate<=CONVERT(date,Getdate()) 
and (Runenddate is null or Runenddate>=CONVERT(date,getdate())) and p.FreqID in (1,2) order by p.SequenceNO asc
End

else if  DATEPART(weekday,getdate())=7 and CONVERT(date,getdate())=EOMONTH(getdate())

Begin

select p.PackageID,p.PackageName from control.Package p
where p.EnvID=2 and p.Active=1 and p.Runstartdate<=CONVERT(date,Getdate()) 
and (Runenddate is null or Runenddate>=CONVERT(date,getdate())) and p.FreqID in (1,2,3) order by p.SequenceNO asc
End

Else

Begin

select p.PackageID,p.PackageName from control.Package p
where p.EnvID=2 and p.Active=1 and p.Runstartdate<=CONVERT(date,Getdate()) 
and (Runenddate is null or Runenddate>=CONVERT(date,getdate())) and p.FreqID=1 order by p.SequenceNO asc
End














select * from control.metrics
select * from control.Package
select * from control.Anomalies