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


-- Set autogrowth of 30% for all files(data and log) of all databases including system ones

declare cr_dbnames cursor
for 
select name from sys.databases 

open cr_dbnames
declare @dbname sysname
fetch next from cr_dbnames into @dbname
while @@fetch_status = 0
begin
	declare cr_files cursor
	for
	
	select mf.[name] from sys.master_files mf
	inner join sys.databases d  on  mf.database_id = d.database_id
	where d.[name] = @dbname

	open cr_files
	declare @dynamicfn nvarchar(150)
	declare @filename nvarchar(50)
	fetch next from cr_files into @filename
	while @@fetch_status = 0
	begin
		set @dynamicfn = 'ALTER DATABASE ' + @dbname + ' MODIFY FILE ( NAME ='''+ @filename + ''', FILEGROWTH = 30% )'
		print @dynamicfn
		exec(@dynamicfn)
	
		fetch next from cr_files into @filename
	end
	close cr_files
	deallocate cr_files

	------------
	fetch next from cr_dbnames into @dbname
end
close cr_dbnames
deallocate cr_dbnames


