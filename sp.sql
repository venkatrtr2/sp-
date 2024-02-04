USE [vss]
GO

/****** Object:  StoredProcedure [dbo].[USP_ScheduleAuditTrial]    Script Date: 04-02-2024 14:04:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  --declare
ALTER PROCEDURE [dbo].[USP_ScheduleAuditTrial]
--declare
@pfromDate datetime,
@ptoDate datetime,
@pgroupcallid varchar(50),
@ptype varchar(10)
-- exec USP_ScheduleAuditTrial '2022-03-21 00:00','2022-03-21 23:59','','Date'
-- exec USP_ScheduleAuditTrial '','','GrpCall-374048','callid'

as
begin                                                         
set nocount on   

--select @pfromDate='2022-04-26 12:20'
--select @ptoDate='2022-04-26 23:59'
--select @pgroupcallid='GrpCall-376918'
--select @ptype='callid'

create table #temp_schedulemodified(
id int,id_1 int, pre_id int,servicecode varchar(4),vessel_code varchar(6),old_vessel_code varchar(6),voyage_code varchar(6),
old_voyage_code varchar(6),sub_bound char(1),old_sub_bound char(1),portcode varchar(6),
terminalcode varchar(10),old_terminalcode varchar(10),arrdock datetime,old_arrdock datetime,
dep_dock datetime,old_dep_dock datetime,callorder int,isoverlap char(1),
status char(1),old_status char(1),servicetype char(1),servicetype_desc varchar(50),type char(1),
type_desc varchar(50),groupcallid varchar(50),
crdate datetime,jobprocessed char(1),jobprocesseddate datetime,cruser varchar(15),
cycle_no int,sub_cycleno int,
callid varchar(50),bound char(1),old_bound char(1),bound_order int,
portname varchar(150),terminalname varchar(150),vesselname varchar(200), old_callorder int, old_type char(1),old_type_desc varchar(50),
actualcallorder int, pre_actualcallorder int, change_events varchar(500),ARR_PILOT datetime,PRE_ARR_PILOT datetime,DEP_PILOT datetime,PRE_DEP_PILOT datetime,EOSP datetime,PRE_EOSP datetime,BOSP datetime,PRE_BOSP datetime,DISTANCE float ,PRE_DISTANCE float,SPEED float,PRE_SPEED float)



create table #temp_Final(
id int,id_1 int, pre_id int,servicecode varchar(4),vessel_code varchar(6),old_vessel_code varchar(6),voyage_code varchar(6),
old_voyage_code varchar(6),sub_bound char(1),old_sub_bound char(1),portcode varchar(6),
terminalcode varchar(10),old_terminalcode varchar(10),arrdock datetime,old_arrdock datetime,
dep_dock datetime,old_dep_dock datetime,callorder int,isoverlap char(1),
status char(1),old_status char(1),servicetype char(1),servicetype_desc varchar(50),type char(1),
type_desc varchar(50),groupcallid varchar(50),
crdate datetime,jobprocessed char(1),jobprocesseddate datetime,cruser varchar(15),
cycle_no int,sub_cycleno int,
callid varchar(50),bound char(1),old_bound char(1),bound_order int,
portname varchar(150),terminalname varchar(150),vesselname varchar(200), old_callorder int, old_type char(1),old_type_desc varchar(50),
actualcallorder int, pre_actualcallorder int, change_events varchar(500),ARR_PILOT datetime,PRE_ARR_PILOT datetime,DEP_PILOT datetime,PRE_DEP_PILOT datetime,EOSP datetime,PRE_EOSP datetime,BOSP datetime,PRE_BOSP datetime,DISTANCE float ,PRE_DISTANCE float,SPEED float,PRE_SPEED float, agencyuser char(1))


create table #temp_schedulemodified_id(id int,vessel_code varchar(6),voyage_code varchar(6),
 sub_bound char(1), terminalcode varchar(10), arrdock datetime,dep_dock datetime, status char(1),
bound char(1),callid varchar(100),callorder int,type char(1), old_type char(1),
actualcallorder int, pre_actualcallorder int,ARR_PILOT datetime,DEP_PILOT datetime,EOSP datetime,BOSP datetime,DISTANCE float ,SPEED float) 

create table #tmp_vessel  ( vesselname varchar(200))
create table #tmp_port  ( portname varchar(150))
create table #tmp_terminal  ( terminalName varchar(150))


create table #temp_agencyuser(id int identity(1,1),loginname varchar(100),UserType char(2));

insert into #temp_agencyuser(loginname,UserType)
select loginname,UserType from nfr.dbo.userdetails


if(@ptype ='Date')
	begin  



	Insert into #temp_Final(id,servicecode ,vessel_code ,old_vessel_code ,voyage_code ,
        old_voyage_code ,sub_bound ,old_sub_bound ,portcode ,
        terminalcode ,old_terminalcode ,arrdock ,old_arrdock ,
        dep_dock ,old_dep_dock ,callorder ,isoverlap ,
        status,old_status ,servicetype ,servicetype_desc ,type ,
        type_desc ,groupcallid ,
        crdate ,jobprocessed ,jobprocesseddate ,cruser ,
        cycle_no ,sub_cycleno ,
        callid ,bound ,old_bound ,bound_order ,
        old_callorder , old_type ,old_type_desc ,
        change_events ,ARR_PILOT ,PRE_ARR_PILOT ,DEP_PILOT ,PRE_DEP_PILOT ,EOSP ,PRE_EOSP ,BOSP ,PRE_BOSP ,DISTANCE  ,PRE_DISTANCE ,SPEED ,PRE_SPEED )
		   
		select distinct id,servicecode,vessel_code,pre_vessel_code,voyage_code,
		pre_voyage_code,sub_bound,pre_sub_bound,portcode,
		terminalcode,pre_terminalcode,arrdock,pre_arrdock,
		dep_dock,pre_dep_dock,callorder,isoverlap,
		status,pre_status,servicetype,case when servicetype='M' THEN  'Mainline' else 'Feeder' end as servicetype_desc ,type,
		(case when type='I' THEN  'Insert' when type='U' Then 'Update' when type='D' Then 'Omitted' when type='P' Then 'Physical Delete' end) as type_desc, groupcallid,
		crdate,jobprocessed,jobprocesseddate,cruser,
		cycle_no,sub_cycleno,
		callid,bound,pre_bound,bound_order,
		pre_callorder ,pre_type,pre_type_desc,
		change_events,ARR_PILOT,pre_Arr_Pilot,DEP_PILOT,pre_Dep_Pilot,EOSP,pre_eosp,BOSP,pre_bosp,DISTANCE,pre_Distance,SPEED,pre_Speed  from schedulemodified (nolock)
		where  (change_events is not null or change_events<>'')
		--and vessel_code<>pre_vessel_code
  --      and voyage_code<>pre_voyage_code
  --      and sub_bound<>pre_sub_bound 
  --      and terminalcode<>pre_terminalcode
  --      and arrdock<>pre_arrdock
  --      and dep_dock<>pre_dep_dock
  --      and status<>pre_status
  --      and bound <> pre_bound
  --      and callorder<>pre_callorder
  --      and type<>pre_type
  --      and ARR_PILOT<>PRE_ARR_PILOT
  --      and DEP_PILOT<>PRE_DEP_PILOT
  --      and EOSP<>PRE_EOSP 
  --      and BOSP<>PRE_BOSP
  --      and DISTANCE<>PRE_DISTANCE 
  --      and SPEED<>PRE_SPEED
		 and crdate between @pfromdate and @ptodate 
		order by callid,id

		insert into #temp_schedulemodified  (id,servicecode,vessel_code,voyage_code,sub_bound,portcode,terminalcode,
		arrdock,dep_dock,callorder,isoverlap,status,servicetype,type,
		groupcallid,crdate,jobprocessed,jobprocesseddate,cruser,cycle_no,sub_cycleno,callid,bound,bound_order,ARR_PILOT,DEP_PILOT,EOSP,BOSP,DISTANCE,SPEED )
		select distinct id,servicecode,vessel_code,voyage_code,sub_bound,portcode,terminalcode,arrdock,dep_dock,
		callorder,isoverlap,status,servicetype,type,groupcallid,crdate,jobprocessed,
		jobprocesseddate,cruser,cycle_no,sub_cycleno,callid,bound,bound_order,ARR_PILOT,DEP_PILOT,EOSP,BOSP,DISTANCE,SPEED  from schedulemodified (nolock)
		where   (change_events is  null or change_events='')   and crdate between @pfromdate and @ptodate  
		order by callid,id

			insert into #temp_ScheduleModified_id(id,vessel_code,voyage_code, sub_bound, terminalcode, arrdock,dep_dock,status,
bound,callid,callorder,type,ARR_PILOT,DEP_PILOT,EOSP,BOSP,DISTANCE,SPEED)
select m.id, m.vessel_code, m.voyage_code, m.sub_bound, m.terminalcode, m.arrdock, m.dep_dock, m.status,
m.bound,m.callid,m.callorder,m.type,m.ARR_PILOT,m.DEP_PILOT,m.EOSP,m.BOSP,m.DISTANCE,m.SPEED  from schedulemodified m (nolock)
where crdate between @pfromdate and @ptodate 
		order by callid,id
	end

else
	begin

	Insert into #temp_Final(id,servicecode ,vessel_code ,old_vessel_code ,voyage_code ,
        old_voyage_code ,sub_bound ,old_sub_bound ,portcode ,
        terminalcode ,old_terminalcode ,arrdock ,old_arrdock ,
        dep_dock ,old_dep_dock ,callorder ,isoverlap ,
        status,old_status ,servicetype ,servicetype_desc ,type ,
        type_desc ,groupcallid ,
        crdate ,jobprocessed ,jobprocesseddate ,cruser ,
        cycle_no ,sub_cycleno ,
        callid ,bound ,old_bound ,bound_order ,
        old_callorder , old_type ,old_type_desc ,
        change_events ,ARR_PILOT ,PRE_ARR_PILOT ,DEP_PILOT ,PRE_DEP_PILOT ,EOSP ,PRE_EOSP ,BOSP ,PRE_BOSP ,DISTANCE  ,PRE_DISTANCE ,SPEED ,PRE_SPEED )
		   
		select distinct id,servicecode,vessel_code,pre_vessel_code,voyage_code,
		pre_voyage_code,sub_bound,pre_sub_bound,portcode,
		terminalcode,pre_terminalcode,arrdock,pre_arrdock,
		dep_dock,pre_dep_dock,callorder,isoverlap,
		status,pre_status,servicetype,case when servicetype='M' THEN  'Mainline' else 'Feeder' end as servicetype_desc ,type,
		(case when type='I' THEN  'Insert' when type='U' Then 'Update' when type='D' Then 'Omitted' when type='P' Then 'Physical Delete' end) as type_desc, groupcallid,
		crdate,jobprocessed,jobprocesseddate,cruser,
		cycle_no,sub_cycleno,
		callid,bound,pre_bound,bound_order,
		pre_callorder,pre_type,pre_type_desc,
		change_events,ARR_PILOT,pre_Arr_Pilot,DEP_PILOT,pre_Dep_Pilot,EOSP,pre_eosp,BOSP,pre_bosp,DISTANCE,pre_Distance,SPEED,pre_Speed  from schedulemodified (nolock)
		where groupcallid=@pgroupcallid and (change_events is not null or change_events<>'') 
		--and vessel_code<>pre_vessel_code) 
  --      and voyage_code<>pre_voyage_code
  --      and sub_bound<>pre_sub_bound 
  --      and terminalcode<>pre_terminalcode
  --      and arrdock<>pre_arrdock
  --      and dep_dock<>pre_dep_dock
  --      and status<>pre_status
  --      and bound <> pre_bound
  --      and callorder<>pre_callorder
  --      and type<>pre_type
  --      and ARR_PILOT<>PRE_ARR_PILOT
  --      and DEP_PILOT<>PRE_DEP_PILOT
  --      and EOSP<>PRE_EOSP 
  --      and BOSP<>PRE_BOSP
  --      and DISTANCE<>PRE_DISTANCE 
  --      and SPEED<>PRE_SPEED
		order by callid,id

		insert into #temp_ScheduleModified  (id,servicecode,vessel_code,voyage_code,sub_bound,portcode,terminalcode,
		arrdock,dep_dock,callorder,isoverlap,status,servicetype,type,
		groupcallid,crdate,jobprocessed,jobprocesseddate,cruser,cycle_no,sub_cycleno,callid,bound,bound_order,ARR_PILOT,DEP_PILOT,EOSP,BOSP,DISTANCE,SPEED )
		select distinct id,servicecode,vessel_code,voyage_code,sub_bound,portcode,terminalcode,arrdock,dep_dock,
		callorder,isoverlap,status,servicetype,type,groupcallid,crdate,jobprocessed,
		jobprocesseddate,cruser,cycle_no,sub_cycleno,callid,bound,bound_order,ARR_PILOT,DEP_PILOT,EOSP,BOSP,DISTANCE,SPEED  from schedulemodified (nolock)
		where groupcallid=@pgroupcallid and (change_events is  null or change_events='' )
		order by callid,id

			insert into #temp_ScheduleModified_id(id,vessel_code,voyage_code, sub_bound, terminalcode, arrdock,dep_dock,status,
		bound,callid,callorder,type,ARR_PILOT,DEP_PILOT,EOSP,BOSP,DISTANCE,SPEED)
		select m.id, m.vessel_code, m.voyage_code, m.sub_bound, m.terminalcode, m.arrdock, m.dep_dock, m.status,
		m.bound,m.callid,m.callorder,m.type,m.ARR_PILOT,m.DEP_PILOT,m.EOSP,m.BOSP,m.DISTANCE,m.SPEED  from schedulemodified m (nolock)
		where groupcallid=@pgroupcallid 
		order by callid,id

	end

update #temp_Final set vesselname=v.vesselname from #temp_Final t (nolock) inner join vesselmaster v (nolock) on t.vessel_code=v.vesselcode 
update #temp_Final set portname=v.portname from #temp_Final t (nolock) inner join ports v (nolock)  on t.portcode=v.portcode 
update #temp_Final set terminalname=v.terminalname from #temp_Final t (nolock) inner join terminals v (nolock)  on t.terminalcode=v.terminalcode



update #temp_ScheduleModified set vesselname=v.vesselname from #temp_ScheduleModified t (nolock) inner join vesselmaster v (nolock) on t.vessel_code=v.vesselcode 
update #temp_ScheduleModified set portname=v.portname from #temp_ScheduleModified t (nolock) inner join ports v (nolock)  on t.portcode=v.portcode 
update #temp_ScheduleModified set terminalname=v.terminalname from #temp_ScheduleModified t (nolock) inner join terminals v (nolock)  on t.terminalcode=v.terminalcode

create table #tmpCallid(id int, callid varchar(50))

insert into #tmpCallid(id, callid)
select id, callid from #temp_ScheduleModified (nolock) order by callid, id

declare @cnt int, @id int, @callid varchar(100),@pre_id int

select @cnt=count(callid) from #tmpCallid (nolock)

create table #tmpSchedule(id int,pre_id int,vessel_code varchar(6),voyage_code varchar(6), sub_bound char(1), terminalcode varchar(10),
arrdock datetime, dep_dock datetime, status char(1), bound char(1) ,callid varchar(100), callorder int,type char(1),ARR_PILOT datetime,DEP_PILOT datetime,EOSP datetime,BOSP datetime,DISTANCE float ,SPEED float) 


while (@cnt > 0)
	begin
		select top 1 @id=id, @callid=callid from #tmpCallid order by callid,id
		select @pre_id= max(id) from #temp_ScheduleModified_id (nolock) where callid=@callid and id < @id 

		--delete from #tmpSchedule
		insert into #tmpSchedule(id,pre_id,vessel_code,voyage_code, sub_bound, terminalcode, arrdock, dep_dock,
		status, bound,callid,callorder,type,ARR_PILOT,DEP_PILOT,EOSP,BOSP,DISTANCE,SPEED)
		select @id,@pre_id,vessel_code,voyage_code, sub_bound, terminalcode, arrdock,dep_dock,status,
		bound,callid,callorder,type,ARR_PILOT,DEP_PILOT,EOSP,BOSP,DISTANCE,SPEED	
		 from #temp_ScheduleModified_id (nolock)
		where callid=@callid and id=@pre_id

		--update s set s.old_vessel_code=a.vessel_code,s.old_Voyage_code=a.Voyage_code,old_sub_bound=a.sub_bound,old_terminalcode=a.terminalcode,
		--old_arrdock=a.arrdock,
		--old_dep_dock=a.dep_dock,old_status=a.status,old_Bound=a.bound,
		--old_callorder=a.callorder from #temp_ScheduleModified s (nolock)
		--inner join #tmpSchedule a (nolock) on  s.callid=a.callid and s.id=a.id where s.id=@id

		delete from #tmpCallid where id=@id
		select  @cnt=0,@pre_id=0
		select @cnt=count(callid) from #tmpCallid
	end
	

update s set s.old_vessel_code=a.vessel_code,s.old_Voyage_code=a.Voyage_code,old_sub_bound=a.sub_bound,old_terminalcode=a.terminalcode,
old_arrdock=a.arrdock,
old_dep_dock=a.dep_dock,old_status=a.status,old_Bound=a.bound,
old_callorder=a.callorder,
id_1=a.id,
pre_id=a.pre_id,
old_type=a.type ,PRE_ARR_PILOT=a.ARR_PILOT,PRE_DEP_PILOT=a.DEP_PILOT,PRE_EOSP=a.EOSP ,PRE_BOSP=a.BOSP,PRE_DISTANCE=a.DISTANCE ,PRE_SPEED=a.SPEED  from #temp_ScheduleModified s (nolock)
inner join #tmpSchedule a (nolock) on  s.callid=a.callid and s.id=a.id-- where s.id=@id

delete from #temp_Final where vessel_code=old_vessel_code
and voyage_code=old_voyage_code
and sub_bound=old_sub_bound 
and terminalcode=old_terminalcode
and arrdock=old_arrdock
and dep_dock=old_dep_dock
and status=old_status
and bound = old_bound
and callorder=old_callorder
and type=old_type
and ARR_PILOT=PRE_ARR_PILOT
and DEP_PILOT=PRE_DEP_PILOT
and EOSP=PRE_EOSP 
and BOSP=PRE_BOSP
and DISTANCE=PRE_DISTANCE 
and SPEED=PRE_SPEED

delete from #temp_ScheduleModified where vessel_code=old_vessel_code
and voyage_code=old_voyage_code
and sub_bound=old_sub_bound 
and terminalcode=old_terminalcode
and arrdock=old_arrdock
and dep_dock=old_dep_dock
and status=old_status
and bound = old_bound
and callorder=old_callorder
and type=old_type
and ARR_PILOT=PRE_ARR_PILOT
and DEP_PILOT=PRE_DEP_PILOT
and EOSP=PRE_EOSP 
and BOSP=PRE_BOSP
and DISTANCE=PRE_DISTANCE 
and SPEED=PRE_SPEED

update #temp_ScheduleModified set type_desc='Insert' where type='I' 
update #temp_ScheduleModified set type_desc='Update' where type='U' 
update #temp_ScheduleModified set type_desc='Omitted' where type='D' 
update #temp_ScheduleModified set type_desc='Physical Delete' where type='P' 

update #temp_ScheduleModified set old_type_desc='Insert' where old_type='I' 
update #temp_ScheduleModified set old_type_desc='Update' where old_type='U' 
update #temp_ScheduleModified set old_type_desc='Omitted' where old_type='D' 
update #temp_ScheduleModified set old_type_desc='Physical Delete' where old_type='P' 

update #temp_ScheduleModified set servicetype_desc='Mainline' where servicetype='M'  
update #temp_ScheduleModified set servicetype_desc='Feeder' where servicetype<>'M' 

update #temp_ScheduleModified set change_events='' 
update #temp_ScheduleModified set change_events=change_events+'VESSEL, ' where vessel_code <> old_vessel_code and  old_vessel_code is not null --or old_vessel_code <>'' 
update #temp_ScheduleModified set change_events=change_events+'VOYAGE, ' where voyage_code <> old_voyage_code and old_voyage_code is not null --or old_voyage_code <>'' 
update #temp_ScheduleModified set change_events=change_events+'BOUND, ' where sub_bound <> old_sub_bound and old_sub_bound is not null --or old_sub_bound <>'' 
update #temp_ScheduleModified set change_events=change_events+'PF_BOUND, ' where bound <> old_bound and old_bound is not null --or old_bound <>'' 
update #temp_ScheduleModified set change_events=change_events+'TERMINAL, ' where terminalcode <> old_terminalcode and old_terminalcode is not null --or old_terminalcode <>'' 
update #temp_ScheduleModified set change_events=change_events+'ARR_DOCK, ' where arrdock <> old_arrdock and old_arrdock is not null --or old_arrdock <>'' 
update #temp_ScheduleModified set change_events=change_events+'DEP_DOCK, ' where dep_dock <> old_dep_dock and old_dep_dock is not null -- or old_dep_dock <>'' 
update #temp_ScheduleModified set change_events=change_events+'STATUS, ' where status <> old_status and old_status is not null --or old_status <>'' 

update #temp_ScheduleModified set change_events=change_events+'ROTATION_CHANGE, ' where callorder <> old_callorder and old_callorder is not null --or old_status <>'' 
update #temp_ScheduleModified set change_events=change_events+'TYPE, ' where type <> old_type and old_type is not null --or old_status <>'' 


------

--ARR_PILOT=PRE_ARR_PILOT
--DEP_PILOT=PRE_DEP_PILOT
--EOSP=PRE_EOSP 
--BOSP=PRE_BOSP
--DISTANCE=PRE_DISTANCE 
--SPEED=PRE_SPEED

update #temp_ScheduleModified set change_events=change_events+'ARR_PILOT, ' where ARR_PILOT <> PRE_ARR_PILOT and PRE_ARR_PILOT is not null --or PRE_ARR_PILOT <>'' 

update #temp_ScheduleModified set change_events=change_events+'DEP_PILOT, ' where DEP_PILOT <> PRE_DEP_PILOT and PRE_DEP_PILOT is not null --or PRE_DEP_PILOT <>''  

update #temp_ScheduleModified set change_events=change_events+'EOSP, ' where EOSP <> PRE_EOSP and PRE_EOSP is not null --or PRE_EOSP <>''  

update #temp_ScheduleModified set change_events=change_events+'BOSP, ' where BOSP <> PRE_BOSP and PRE_BOSP is not null --or PRE_BOSP <>'' 

update #temp_ScheduleModified set change_events=change_events+'DISTANCE, ' where DISTANCE <> PRE_DISTANCE and PRE_DISTANCE is not null --or PRE_DISTANCE <>'' 
 
update #temp_ScheduleModified set change_events=change_events+'SPEED, ' where SPEED <> PRE_SPEED and PRE_SPEED is not null --or PRE_SPEED <>'' 
 
--UPDATE #temp_ScheduleModified
--SET change_events = SUBSTRING(change_events, 0, LEN(change_events))
--WHERE change_events LIKE '%,'
 -----------
 

 update s set s.pre_vessel_code=a.old_vessel_code,
s.pre_voyage_code=a.old_voyage_code,
s.pre_sub_bound=a.old_sub_bound,
s.pre_bound=a.old_bound,
s.pre_terminalcode=a.old_terminalcode,
s.pre_arrdock=a.old_arrdock,
s.pre_dep_dock=a.old_dep_dock,
s.pre_status=a.old_status,
s.pre_callorder=a.old_callorder,
s.pre_type_desc=a.old_type_desc,
s.pre_type=a.old_type,
s.change_events=a.change_events,
s.PRE_ARR_PILOT=a.PRE_ARR_PILOT,
s.PRE_DEP_PILOT=a.PRE_DEP_PILOT,
s.PRE_EOSP=a.EOSP,
s.PRE_BOSP=a.PRE_BOSP,
s.PRE_DISTANCE=a.PRE_DISTANCE,
s.PRE_SPEED=a.PRE_SPEED
 from schedulemodified s inner join #temp_ScheduleModified a (nolock) on  s.callid=a.callid and s.id=a.id

insert into #temp_Final(id,id_1,pre_id,servicecode,portcode,portname,cycle_no,sub_cycleno,groupcallid,callid,cruser,crdate,
bound_order,vessel_code,vesselname,old_vessel_code,voyage_code,old_voyage_code,sub_bound,old_sub_bound,bound,old_bound,
terminalcode,terminalname,old_terminalcode,arrdock,old_arrdock,dep_dock,old_dep_dock,status,old_status,callorder,old_callorder,
isoverlap,servicetype_desc ,type_desc ,old_type_desc,change_events,ARR_PILOT,PRE_ARR_PILOT,
DEP_PILOT,PRE_DEP_PILOT,EOSP,PRE_EOSP,BOSP,PRE_BOSP,DISTANCE,PRE_DISTANCE,SPEED,PRE_SPEED)
select id,id_1,pre_id,servicecode,portcode,portname,cycle_no,sub_cycleno,groupcallid,callid,cruser,crdate,
bound_order,vessel_code,vesselname,old_vessel_code,voyage_code,old_voyage_code,sub_bound,old_sub_bound,bound,old_bound,
terminalcode,terminalname,old_terminalcode,arrdock,old_arrdock,dep_dock,old_dep_dock,status,old_status,callorder,old_callorder,
isoverlap,servicetype_desc ,type_desc ,old_type_desc,change_events,ARR_PILOT,PRE_ARR_PILOT,
DEP_PILOT,PRE_DEP_PILOT,EOSP,PRE_EOSP,BOSP,PRE_BOSP,DISTANCE,PRE_DISTANCE,SPEED,PRE_SPEED from #temp_ScheduleModified (nolock) order by crdate desc

update #temp_Final set agencyuser='A' from #temp_Final t left join #temp_agencyuser a on (t.cruser=a.loginname) where a.UserType = 'A'


update #temp_Final set change_events= change_events+'Arrival Confirmed by Agency user,'  from #temp_Final t inner join actualschedule a on (t.callid=a.callid) where t.agencyuser='A' and a.status='N'  and a.isvar='Y' and t.type ='U'

update #temp_Final set change_events=change_events+'Call Confirmed by Agency user,' from #temp_Final t inner join actualschedule a on (t.callid=a.callid) where t.agencyuser='A' and a.status='S'  and t.type ='U'

UPDATE #temp_Final
SET change_events = SUBSTRING(change_events, 0, LEN(change_events))
WHERE change_events LIKE '%,'

select id,id_1,pre_id,servicecode,portcode,portname,cycle_no,sub_cycleno,groupcallid,callid,cruser,crdate,
bound_order,
vessel_code,vesselname,old_vessel_code,
voyage_code,old_voyage_code,
sub_bound,old_sub_bound,
bound,old_bound,
terminalcode,terminalname,old_terminalcode,
arrdock,old_arrdock,
dep_dock,old_dep_dock,
status,old_status,
callorder,old_callorder,
isoverlap,
servicetype_desc as servicetype,
type_desc as type,old_type_desc as old_type,change_events,
ARR_PILOT,PRE_ARR_PILOT,
DEP_PILOT,PRE_DEP_PILOT,
EOSP,PRE_EOSP,
BOSP,PRE_BOSP,
DISTANCE,PRE_DISTANCE,
SPEED,PRE_SPEED
from #temp_Final (nolock) order by crdate desc

drop table #temp_ScheduleModified
drop table #tmp_vessel
drop table #tmp_port
drop table #tmp_terminal
drop table #tmpCallid
drop table #tmpSchedule
drop table #temp_schedulemodified_id
drop table #temp_Final
drop table #temp_agencyuser

END
  
  
GO


