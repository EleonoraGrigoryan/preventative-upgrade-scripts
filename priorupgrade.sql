-- disable all startup sprocs

declare cr_startup cursor
for
select name from sys.procedures where objectproperty([object_id],'ExecIsStartUp') = 1

open cr_startup
declare @var sysname
fetch next from cr_startup into @var

while @@fetch_status = 0
begin
	exec sp_procoption @var, 'startup', 'off'
	fetch next from cr_startup into @var
end
close cr_startup
deallocate cr_startup

-- disable all enabled trace flag functionalities

if object_id('tempdb..#tb1', 'U') is not null 
drop table #tb1

create table #tb1 ([name] int, [status] int, [global] int, [session] int)
insert into #tb1 exec('dbcc tracestatus()')

declare cr_traceflagsoff cursor 
for
select [name] from #tb1

open cr_traceflagsoff 
declare @trfl int
fetch next from cr_traceflagsoff into @trfl

while @@fetch_status = 0
begin
	dbcc traceoff(@trfl, -1)
	fetch next from cr_traceflagsoff into @trfl
end

close cr_traceflagsoff
deallocate cr_traceflagsoff
-- dbcc tracestatus()
