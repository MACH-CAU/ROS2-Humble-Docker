#!/bin/bash
#
# 3. development tools and ROS tools 설치하기
# 4. Sourcing the setup script
echo setup.bash!
source /opt/ros/humble/setup.bash			\
|| apt-get install -y ros-humble-desktop	\
&& source /opt/ros/humble/setup.bash

echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc






# bash -c "while true; do echo \"ROS2 still live\"; sleep 100; done"
# tail -f /dev/null



# 파일이 있으면 그냥 source하고 없으면 설치 후 source
