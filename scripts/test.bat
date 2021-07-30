@echo off

set board=%1

IF "%board%"=="log" goto :log_node_command
IF "%board%"=="main" goto :main_node_command
IF "%board%"=="motor" goto :motor_node_command
IF "%board%"=="web" goto :web_node_command
IF "%board%"=="native" goto :end

goto :end

:log_node_command
CALL pio remote test -e log_node --upload-port /dev/ttyACM0
goto :end

:main_node_command
CALL pio remote test -e main_node --upload-port /dev/ttyACM1
goto :end

:motor_node_command
CALL pio remote test -e motor_node --upload-port /dev/ttyACM2
goto :end

:web_node_command
CALL pio remote test -e web_node --upload-port /dev/ttyACM3
goto :end

:end
CALL pio test -e native
