-- Update/ Create Statistics

-- Update statistics automatically
alter database [dbname]
set auto_update_statistics ON (OFF)

-- Automatically update statistics after creating the executing plan each time
alter database [dbname]
set auto_update_statistics_async ON (OFF)

-- Automatically create statistics
alter database [dbname]
set auto_create_statistics ON (OFF)

-- Create statistics scanning all rows
create statistics [statisticsname]
on [dbname] (column1, column2,...)
with fullscan  /  with sample 100 percent

-- Create statistics scanning only some rows
create statistics [statisticsname]
on [dbname] (column1, column2,...)
with sample 10 percent
