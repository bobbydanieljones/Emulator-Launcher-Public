@echo off

REM Wait for the main application to close
timeout /t 3 /nobreak >nul

REM Define paths relative to the directory where the application is executed
SET "AppFolder=%~dp0"  REM Get the directory of the batch file (the application's directory)
SET "UpdateFolder=%AppFolder%TempUpdate"

REM Create the update folder if it doesn't exist
IF NOT EXIST "%UpdateFolder%" (
    mkdir "%UpdateFolder%"
)

REM Delete old application files (except the batch file itself), including directories like images
for %%i in ("%AppFolder%*") do (
    if not "%%~fi"=="%~f0" (
        if exist "%%~fi" (
            if exist "%%~fi\*" (rd /s /q "%%~fi") else (del /q "%%~fi")
        )
    )
)

REM Copy new files and folders (including subdirectories) from the update folder to the application folder
xcopy "%UpdateFolder%\*" "%AppFolder%" /e /i /y

REM Delete the update.zip file
del /q "%UpdateFolder%\update.zip"

REM Start the updated application
start "" "%AppFolder%EmulatorLauncher.exe"

REM Clean up the temporary update folder
rd /s /q "%UpdateFolder%"

REM Delete the update.zip file
del /q "%UpdateFolder%\update.zip"