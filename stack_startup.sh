#!/bin/bash

export ROS_DOMAIN_ID=1
ROBOT_WS_PATH="$HOME/agilex_ws"

source "/opt/ros/humble/setup.bash"
source "$ROBOT_WS_PATH/install/setup.bash"

echo "Starting start launch file"
ros2 launch limo_bringup limo_start.launch.py &
sleep 5

echo "Starting bridge launch file"
ros2 launch rosbridge_server rosbridge_websocket_launch.xml &
sleep 5

echo "Starting nav launch file"
ros2 launch limo_bringup limo_nav2_diff.launch.py
