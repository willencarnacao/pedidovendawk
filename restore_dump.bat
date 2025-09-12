@echo off
set MYSQL_EXE=C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe
echo Executando importacao do dump (ajuste config.ini se necessario)...
"%MYSQL_EXE%" -u root -pwk#25@10 --default-character-set=utf8mb4 < "%~dp0db\dump.sql"
pause
