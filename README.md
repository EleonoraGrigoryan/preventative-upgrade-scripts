# Preventative Upgrade Scripts

Scripts to run in MS SQL Server prior to and after the upgrade process in order to avoid common upgrade issues. Includes scripts for
- [x] Preventing the execution of startup stored procedures during the upgrade (before)
- [x] Turning off the functionalities of all enabled trace flags (before)
- [x] Setting data and log file autogrowth during the update process (before)
- [x] Running statistics update against user-defined and internal tables in all databases (after)

----
MIT License <br>
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND
