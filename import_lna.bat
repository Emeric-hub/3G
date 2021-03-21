REM @echo off

echo debut de traitement - %date% - %time%

set "reg_path=\\01-gtw-01\upd\Profils_LNA\REGISTRE"
if not exist "\\01-gtw-01\upd\Profils_LNA\REGISTRE\%username%" mkdir "\\01-gtw-01\upd\Profils_LNA\REGISTRE\%username%"
REG QUERY "HKCU\SOFTWARE\UES" | Find "LNA"
IF %ERRORLEVEL% == 0 goto key_found
If %ERRORLEVEL% == 1 goto key_not_found

:key_found
echo --------- Cle existante - backup --------- >> %reg_path%\%username%\%username%.log

echo backup vers %reg_path%\%username%\%username%-backup.cfu
regedit /e %reg_path%\%username%\%username%-backup.cfu HKEY_CURRENT_USER\SOFTWARE\UES\LNA

if exist %reg_path%\%username%\%username%.cfu (

    echo import de %reg_path%\%username%\%username%.cfu >> %reg_path%\%username%\%username%.log

    REM Suppression des anciennes clés
    reg delete HKEY_CURRENT_USER\Software\UES\LNA /f
   
    REM Import des clés
    regedit /S %reg_path%\%username%\%username%.cfu

    REM Maj Chemin
    regedit /S %reg_path%\Update_Path.cfu /f

    REM Backup du fichier importé
    move %reg_path%\%username%\%username%.cfu %reg_path%\%username%\%username%-import.cfu

) 
goto end


:key_not_found
echo --------- Cle non existante - import --------- >> %reg_path%\%username%\%username%.log

if exist %reg_path%\%username%\%username%.cfu (

    echo import de %reg_path%\%username%\%username%.cfu >> %reg_path%\%username%\%username%.log
    regedit /S %reg_path%\%username%\%username%.cfu
    regedit /S %reg_path%\Update_Path.cfu /f

    move %reg_path%\%username%\%username%.cfu %reg_path%\%username%\%username%-import.cfu


) else (

    echo import de %reg_path%\default.cfu >> %reg_path%\%username%\%username%.log
	regedit /i /S %reg_path%\default.cfu >> %reg_path%\%username%\%username%.log
)
goto end

:end

@exit

