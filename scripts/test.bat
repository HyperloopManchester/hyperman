@echo off

set testset=%1

IF "%testset%"=="all" goto :all
IF "%testset%"=="log" goto :log_node
IF "%testset%"=="main" goto :main_node
IF "%testset%"=="motor" goto :motor_node
IF "%testset%"=="stdlib" goto :stdlib
IF "%testset%"=="web" goto :web_node

echo "Usage: %0 [all|log|main|motor|stdlib|web]"

:all
CALL pio test -e native
goto :end

:log_node
CALL pio remote test -e log_node --upload-port /dev/ttyACM0 -f log_node
goto :end

:main_node
CALL pio remote test -e main_node --upload-port /dev/ttyACM1 -f main_node
goto :end

:motor_node
CALL pio remote test -e motor_node --upload-port /dev/ttyACM2 -f motor_node
goto :end

:stdlib
CALL pio test -e native -f stdlib
goto :end

:web_node
CALL pio remote test -e web_node --upload-port /dev/ttyACM3 -f web_node
goto :end

:end
