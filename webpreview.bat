@echo off
:: Start the dev server in a new window
start cmd /k "npm run dev"

:: Wait 3 seconds for the server to spin up
timeout /t 3 /nobreak > nul

:: Open the browser
start http://localhost:5173