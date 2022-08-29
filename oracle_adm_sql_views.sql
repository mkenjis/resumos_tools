select tablespace_name,file_name,
ceil( (nvl(hwm,1)*8192)/1024/1024 ) smallest,
ceil( blocks*8192/1024/1024) currsize,
ceil( blocks*8192/1024/1024) -
ceil( (nvl(hwm,1)*8192)/1024/1024 ) savings
from dba_data_files a,
( select file_id, max(block_id+blocks-1) hwm
from dba_extents
group by file_id ) b
where a.file_id = b.file_id(+)
order by tablespace_name;


select t.tablespace_name,round(t.mb,0) total_mb,round(t.mb-nvl(f.free_mb,0),0) used_mb,round(1-nvl(f.free_mb,0)/t.mb,2)*100 perc_used from 
(select tablespace_name,sum(bytes/1024/1024) mb from dba_data_files group by tablespace_name
 union 
 select tablespace_name,sum(bytes/1024/1024) mb from dba_temp_files group by tablespace_name) t,
(select tablespace_name,sum(bytes/1024/1024) free_mb from dba_free_space group by tablespace_name) f
where t.tablespace_name=f.tablespace_name(+)
order by t.tablespace_name;


select sum(used_mb),sum(total_mb) from (
select t.tablespace_name,round(t.mb,0) total_mb,round(t.mb-nvl(f.free_mb,0),0) used_mb,round(1-nvl(f.free_mb,0)/t.mb,2)*100 perc_used from 
(select tablespace_name,sum(bytes/1024/1024) mb from dba_data_files group by tablespace_name
 union 
 select tablespace_name,sum(bytes/1024/1024) mb from dba_temp_files group by tablespace_name) t,
(select tablespace_name,sum(bytes/1024/1024) free_mb from dba_free_space group by tablespace_name) f
where t.tablespace_name=f.tablespace_name(+));


select block_id,owner,segment_name,segment_type
from dba_extents where file_id=4
order by block_id desc;


select owner,segment_type,count(*)
from dba_extents where file_id=4
group by owner,segment_type 
order by owner,segment_type;


select file_id, max(block_id) hwm
from dba_extents where file_id=4
group by file_id;



SELECT   b.TABLESPACE
       , b.segfile#
       , b.segblk#
       , ROUND (  (  ( b.blocks * p.VALUE ) / 1024 / 1024 ), 2 ) size_mb
       , a.SID
       , a.serial#
       , a.username
       , a.osuser
       , a.program
       , a.status
    FROM v$session a
       , v$sort_usage b
       , v$process c
       , v$parameter p
   WHERE p.NAME = 'db_block_size'
     AND a.saddr = b.session_addr
     AND a.paddr = c.addr
ORDER BY b.TABLESPACE
       , b.segfile#
       , b.segblk#
       , b.blocks;
	   
	   

SELECT
to_char(first_time,'YYYY-MM-DD') day,
to_char(sum(decode(to_char(first_time,'HH24'),'00',1,0)),'999') "00",
to_char(sum(decode(to_char(first_time,'HH24'),'01',1,0)),'999') "01",
to_char(sum(decode(to_char(first_time,'HH24'),'02',1,0)),'999') "02",
to_char(sum(decode(to_char(first_time,'HH24'),'03',1,0)),'999') "03",
to_char(sum(decode(to_char(first_time,'HH24'),'04',1,0)),'999') "04",
to_char(sum(decode(to_char(first_time,'HH24'),'05',1,0)),'999') "05",
to_char(sum(decode(to_char(first_time,'HH24'),'06',1,0)),'999') "06",
to_char(sum(decode(to_char(first_time,'HH24'),'07',1,0)),'999') "07",
to_char(sum(decode(to_char(first_time,'HH24'),'08',1,0)),'999') "08",
to_char(sum(decode(to_char(first_time,'HH24'),'09',1,0)),'999') "09",
to_char(sum(decode(to_char(first_time,'HH24'),'10',1,0)),'999') "10",
to_char(sum(decode(to_char(first_time,'HH24'),'11',1,0)),'999') "11",
to_char(sum(decode(to_char(first_time,'HH24'),'12',1,0)),'999') "12",
to_char(sum(decode(to_char(first_time,'HH24'),'13',1,0)),'999') "13",
to_char(sum(decode(to_char(first_time,'HH24'),'14',1,0)),'999') "14",
to_char(sum(decode(to_char(first_time,'HH24'),'15',1,0)),'999') "15",
to_char(sum(decode(to_char(first_time,'HH24'),'16',1,0)),'999') "16",
to_char(sum(decode(to_char(first_time,'HH24'),'17',1,0)),'999') "17",
to_char(sum(decode(to_char(first_time,'HH24'),'18',1,0)),'999') "18",
to_char(sum(decode(to_char(first_time,'HH24'),'19',1,0)),'999') "19",
to_char(sum(decode(to_char(first_time,'HH24'),'20',1,0)),'999') "20",
to_char(sum(decode(to_char(first_time,'HH24'),'21',1,0)),'999') "21",
to_char(sum(decode(to_char(first_time,'HH24'),'22',1,0)),'999') "22",
to_char(sum(decode(to_char(first_time,'HH24'),'23',1,0)),'999') "23"
from
v$log_history
where first_time > '20-05-2017'
GROUP by to_char(first_time,'YYYY-MM-DD')
ORDER by to_char(first_time,'YYYY-MM-DD') desc;

select count(*),sum(blocks*block_size)/(1024*1024) mb 
from v$archived_log a
inner join v$log_history b on a.recid = b.recid;

-- sessions and its current sqls
select distinct s.sid,s.serial#,s.osuser,s.schemaname,s.process,s.status,s.program,s.event,s.wait_time,q.sql_text 
from v$session s, v$sql q
where s.sql_id=q.sql_id and s.username is not null and s.wait_class<>'Idle' order by s.osuser,s.process;


-- sessions and any locked object
select distinct s.SID||':'||s.SERIAL#,substr(s.process,1,instr(s.process,':')-1) ux_id_process,
       s.osuser,s.schemaname,s.status,s.program,o.object_name,l.xidusn,l.process,q.sql_text
from v$session s, v$sql q,
v$locked_object l, dba_objects o
where s.sql_id=q.sql_id(+) --and s.username is not null 
and s.sid = l.session_id(+) and l.object_id=o.object_id and l.xidusn <> 0
order by s.osuser;


alter session set nls_date_format='dd/mm/yyyy hh24:mi:ss';

select fetches,executions,disk_reads,buffer_gets,rows_processed, trunc(cpu_time/1000000/60,2) cpu_time_mins,trunc(elapsed_time/1000000/60,2) elapsed_time_mins,trunc(elapsed_time/executions/1000000/60) elapstime_perexec_mins,
last_load_time,last_active_time,parsing_schema_name,action,dbms_lob.substr(sql_text,4000,1) 
from v$sql 
where executions>0 and parsing_schema_name not in ('SYS','RDSADMIN') and sql_text not like '%DS_SVC%'
order by cpu_time desc;


-- sessions and temp usage
select distinct
   c.username "user", c.osuser, c.sid, c.serial#, b.spid "unix_pid",
   c.machine, c.program "program",
   a.blocks * e.block_size/1024/1024 mb_temp_used  ,
   a.tablespace, d.sql_text
from
   v$sort_usage a,
   v$process b,
   v$session c,
   v$sqlarea d,
   dba_tablespaces e
where   c.saddr=a.session_addr
and   b.addr=c.paddr
and   c.sql_address=d.address(+)
and   a.tablespace = e.tablespace_name;


select s.fetches_total,s.executions_total,s.disk_reads_total,s.buffer_gets_total,s.physical_read_requests_total,
trunc(s.cpu_time_total/1000000/60) cpu_time_total_mins,trunc(s.elapsed_time_total/1000000/60) elapsed_time_total_mins,
trunc(s.elapsed_time_total/s.executions_total/1000000/60) elapsed_time_mins,
s.module,s.action,s.parsing_schema_name,t.sql_text from dba_hist_sqlstat s, dba_hist_sqltext t
where s.sql_id=t.sql_id and s.dbid = t.dbid and s.executions_total>0 and parsing_schema_name in ('SOLWMS')


select h.begin_interval_time,h.end_interval_time,s.fetches_total,s.executions_total,s.disk_reads_total,s.buffer_gets_total,
trunc(s.cpu_time_total/1000000/60) cpu_time_total_mins,trunc(s.elapsed_time_total/1000000/60) elapsed_time_total_mins,
trunc(s.elapsed_time_total/s.executions_total/1000000/60) elapsed_time_mins,
s.module,s.action,s.parsing_schema_name,dbms_lob.substr(t.sql_text,4000,1) 
from dba_hist_sqlstat s, dba_hist_sqltext t, dba_hist_snapshot h
where s.sql_id=t.sql_id and s.dbid = t.dbid and s.snap_id = h.snap_id
and s.executions_total>0 and parsing_schema_name in ('SOLWMS')
and h.begin_interval_time between to_date('20/04/2017 04:00:00','dd/mm/yyyy hh24:mi:ss') and to_date('20/04/2017 05:00:00','dd/mm/yyyy hh24:mi:ss')
order by s.disk_reads_total desc


select s.osuser osuser,s.program,s.serial# serial,se.sid,n.name, 
max(se.value) maxmem 
from v$sesstat se, 
v$statname n 
,v$session s 
where n.statistic# = se.statistic# 
and n.name in ('session pga memory','session uga memory') --'session pga memory max','session uga memory max') 
and s.sid=se.sid and s.program not like 'oracle%'
group by n.name,s.program,se.sid,s.osuser,s.serial# 
order by s.program desc,s.serial#, n.name


-- Examine the data collection for V$SYSTEM_EVENT. The events of interest should be ranked by wait time.
-- Identify the wait events that have the most significant percentage of wait time.
select s.WAIT_CLASS,s.event,s.total_waits,s.time_waited,s.average_wait,round(s.time_waited/a.total_time_waited *100,2) "% call time"
from v$system_event s, (select sum(time_waited) total_time_waited from v$system_event  
where event not like 'SQL*Net%' and wait_class not in ('Idle')) a
where s.event not like 'SQL*Net%' and s.wait_class not in ('Idle')
order by s.time_waited desc


-- maximum PGA used by session
select s.osuser osuser,s.program,s.serial# serial,se.sid,n.name, 
max(se.value) maxmem 
from v$sesstat se, 
v$statname n 
,v$session s 
where n.statistic# = se.statistic# 
and n.name in ('session pga memory','session uga memory') --'session pga memory max','session uga memory max') 
and s.sid=se.sid and s.program not like 'oracle%'
group by n.name,s.program,se.sid,s.osuser,s.serial# 
order by s.program desc,s.serial#, n.name

-- lista as sessoes travadas e o dml
select  s.osuser,s.schemaname,s.process,s.status,s.program,q.sql_text from v$session s
inner join v$sql q on q.SQL_ID = s.SQL_ID
where s.BLOCKING_SESSION is not null


select * from v$session;
select * from v$session_wait;
select * from v$service_event;
select * from v$service_wait_class;
select * from v$sql;
select * from v$system_event order by time_waited desc;
select * from v$sysstat;


select * from dba_advisor_findings order by task_id desc;

select * from dba_advisor_finding_names;

select n.*,a.* from dba_advisor_findings a
inner join dba_advisor_finding_names n on a.finding_id = n.id
order by task_id desc;

select dbms_addm.get_report('SYS_AUTO_SPCADV_05000003032020') from dual;

declare
  tname varchar2(60) := 'SYS_AUTO_SPCADV_05000003032020';
begin
  dbms_addm.analyze_db(tname,1,2);
end;
/

select * from dba_advisor_recommendations;

select * from dba_advisor_recommendations r
inner join dba_advisor_findings f on r.task_id=f.task_id and r.finding_id=f.finding_id
order by f.task_id desc;;
