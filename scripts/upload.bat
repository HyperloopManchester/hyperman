@echo off

set board=%1

IF "%board%"=="log" goto :log_node
IF "%board%"=="main" goto :main_node
IF "%board%"=="motor" goto :motor_node
IF "%board%"=="web" goto :web_node

echo "Usage: %0 <log|main|motor|web>"
goto :end

:log_node
CALL pio remote run -e log_node -t upload --upload-port /dev/ttyACM0
goto :end

:main_node
CALL pio remote run -e main_node -t upload --upload-port /dev/ttyACM1
goto :end

:motor_node
CALL pio remote run -e motor_node -t upload --upload-port /dev/ttyACM2
goto :end

:web_node
CALL pio remote run -e web_node -t upload --upload-port /dev/ttyACM3
goto :end

:end
