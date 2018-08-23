--disable all startup sprocs

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

