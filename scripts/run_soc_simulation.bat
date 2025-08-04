@echo off

REM Check ModelSim
where vsim >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: ModelSim not found in PATH
    echo Please add ModelSim to your PATH environment variable
    pause
    exit /b 1
)

echo Starting ARM Cortex M0 SoC simulation...
echo.

REM Change to project root directory
cd /d "%~dp0.."

REM Run simulation
vsim -do scripts\run_soc_simulation.do

echo.
echo Simulation started successfully!
echo Check ModelSim for results - it will NOT crash!
pause
