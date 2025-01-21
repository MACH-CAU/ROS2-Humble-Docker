
#https://docs.ros.org/en/humble/Installation/Ubuntu-Install-Debians.html#
FROM ubuntu:jammy
RUN echo 'APT::Install-Suggests "0";' >> /etc/apt/apt.conf.d/00-docker
RUN echo 'APT::Install-Recommends "0";' >> /etc/apt/apt.conf.d/00-docker
RUN DEBIAN_FRONTEND=noninteractive
# RUN echo "nameserver 8.8.8.8" | tee /dev/null
RUN apt-get update && apt-get upgrade -y	\
	&& apt-get install -y python3			\
	&& apt-get install -y vim				\
	&& apt-get install -y curl				\
	&& apt-get install -y tmux
	# && rm -rf /var/lib/apt/lists/*
# ----------------------------- < ROS install > -------------------------------

RUN locale  # check for UTF-8
RUN apt-get update && apt-get install locales
RUN locale-gen en_US en_US.UTF-8
RUN update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8


# 1.  ROS 2 apt repository 추가하기
# ㄴ First ensure that the Ubuntu Universe repository is enabled.
RUN apt-get install -y software-properties-common \
	&& add-apt-repository universe

# ㄴ Now add the ROS 2 GPG key with apt.
RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg

# ㄴ Then add the repository to your sources list.
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null

# 2. ROS 2 packages :
# 동시에 ros-humble-desktop &&으로 설치하면 에러 발생함
RUN apt-get update && apt-get upgrade -y

RUN apt-get install -y tzdata
RUN echo "Asia/Seoul" | tee /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata

RUN apt-get install -y ros-humble-desktop
# ㄴ ros-humble-desktop 중에 중간에 area 설정해야 되는 argument가 필요함
# RUN source /opt/ros/humble/setup.bash


# if you want .vim
# COPY colors				/root/.vim/colors
# COPY autoload			/root/.vim/autoload

COPY conf/vimrc			/root/.vimrc
COPY conf/bash_profile	/root/.bash_profile
COPY conf/tmux.conf		/root/.tmux.conf
COPY conf/tpm			/root/.tmux/plugins/tpm

RUN echo "alias tmux=\"tmux -u\"" >> ~/.bashrc				# tmux 한글 깨짐 방지
RUN echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc	# ROS 환경변수 넣기
RUN echo "source /root/.bash_profile" >> ~/.bashrc			# 터미널 색상 적용
RUN echo "stty -ixon" >> ~/.bashrc							# vim freezing 방지
RUN echo "export TERM=xterm-256color" >> ~/.bashrc			# tmux vim 색깔
RUN echo "set -o vi" >> ~/.bashrc							# 터미널에서 vim 사용


# Not need
RUN apt-get install -y openssh-server
COPY conf/sshd_config /etc/ssh/sshd_config
RUN service ssh start
COPY conf/ssh_setting.sh /

ENTRYPOINT echo "bash ssh_setting.sh"
# RUN service ssh status



# RUN useradd -ms /bin/bash ros2
# USER ros2

# RUN sudo apt-get in


# ------------------------------------------------------------------------


# RUN source /opt/ros/humble/setup.bash
# CMD /bin/bash -c "while true; do echo "ROS2 still live"; sleep 100; done"
# CMD ["bash", "-c", \"while true; do echo \"ROS2 still live\"; sleep 100; done\""]
# CMD ["tail", "-f", "/dev/null"]

# if) nameserver 변경 : DNS 문제
# COPY resolv.conf /etc/resolv.conf

# 4. Try some examples
# source /opt/ros/humble/setup.bash
# ros2 run demo_nodes_cpp talker
# -> one terminal

# source /opt/ros/humble/setup.bash
# ros2 run demo_nodes_py listener
# -> another terminal
