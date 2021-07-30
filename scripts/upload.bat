@echo off

set board=%1

IF "%board%"=="log" goto :log_node_command
IF "%board%"=="main" goto :main_node_command
IF "%board%"=="motor" goto :motor_node_command
IF "%board%"=="web" goto :web_node_command

goto :end

:log_node_command
CALL pio remote run -e log_node -t upload --upload-port /dev/ttyACM0
goto :end

:main_node_command
CALL pio remote run -e main_node -t upload --upload-port /dev/ttyACM1
goto :end

:motor_node_command
CALL pio remote run -e motor_node -t upload --upload-port /dev/ttyACM2
goto :end

:web_node_command
CALL pio remote run -e web_node -t upload --upload-port /dev/ttyACM3
goto :end

:end
echo "Usage: %0 <log|main|motor|web>"
echo "Builds and uploads to the given node"
