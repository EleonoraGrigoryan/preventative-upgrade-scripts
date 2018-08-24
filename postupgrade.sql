-- Update statistics for all internal and user defined tables for all databases in a server

declare cr_dbnames cursor
for
select name from sys.databases

open cr_dbnames
declare @dbname sysname
declare @dynamic nvarchar(110)
fetch next from cr_dbnames into @dbname

while @@fetch_status = 0
begin 
  set @dynamic = 'use '+ @dbname + char(13) + 'exec sp_updatestats'
  print @dynamic
  exec( @dynamic)
  fetch next from cr_dbnames into @dbname
end

close cr_dbnames
deallocate cr_dbnames
