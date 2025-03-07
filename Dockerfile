FROM ubuntu:22.04

ENV TERM screen-256color
ENV LC_ALL en_US.UTF-8
ENV LC_CTYPE en_US.UTF-8
ENV HOME /root
ENV XDG_CONFIG_HOME /root/.config

# COPY ./sshd_config /etc/ssh/sshd_config

CMD ["/sbin/my_init"]

# apt
RUN apt update \
&& apt -y install software-properties-common

RUN apt-add-repository ppa:neovim-ppa/stable \
&& apt update \
&& apt -y upgrade \
&& apt -y install \
   software-properties-common \
   bash-completion \
   git \
   neovim \
   python3-distutils \
   python3-dev \
   tmux \
   wget \
   curl \
   xsel \
   netcat \

&& cd /tmp \
&& wget https://bootstrap.pypa.io/get-pip.py \
&& python3 get-pip.py \

# setup with dotfile
&& git clone https://github.com/DuckLL/dotfile.git --depth 1 \
&& cd dotfile \
&& ./linux.sh \

# set vim
&& pip3 install pip -U --user \
&& pip3 install pynvim --user \
&& curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim \
&& nvim +PlugInstall +q +UpdateRemotePlugins +q 

COPY ./python.snippets /root/.config/nvim/plugged/vim-snippets/UltiSnips
COPY ./vim_additions /root/.config/nvim/
RUN cat /root/.config/nvim/vim_additions >> ~/.config/nvim/init.vim

# apt
RUN dpkg --add-architecture i386 \
&& apt update \
&& apt -y install \
   cmake \
   g++ \
   git \
   libc6:i386 \
   ltrace \
   make \
   nasm \
   python3-pip \
   qemu \
   ruby-dev \
   strace \
   python3 \
   gdb \
   gdbserver \

&& pip3 install --upgrade pip \

# pip3
&& pip3 install \
   ipython \
   pwntools \

# pip3
&& pip3 install \
   capstone \
   keystone-engine \
   ropper \
   unicorn \

# rubypwn
&& gem install \
    one_gadget \
    seccomp-tools \
    heapinfo \
&& echo 'for dir in $HOME/.gem/ruby/*; do' >> ~/.bashrc \
&& echo '     [ -d "$dir/bin" ] && PATH="${dir}/bin:${PATH}"' >> ~/.bashrc \
&& echo 'done' >> ~/.bashrc \

# gdb
#&& bash -c "$(wget https://gef.blah.cat/sh -O -)" \
#&& git clone https://github.com/scwuaptx/Pwngdb.git --depth 1 ~/Pwngdb \
#&& cat ~/Pwngdb/.gdbinit >> ~/.gdbinit \
&& cd / \
&& git clone https://github.com/pwndbg/pwndbg \
&& cd pwndbg \
&& ./setup.sh \

&& git clone https://github.com/gpakosz/.tmux.git --depth 1 ~/.tmux \

&& apt install -y \
   automake \
   bison \
   libglib2.0-dev \
   libtool-bin \
   libpcre++-dev \
   nmap \
   p7zip-full \
   pcregrep \
   libc6-dbg \
   libc6-dbg:i386 \
   locales \
&& locale-gen en_US.UTF-8 \
&& dpkg-reconfigure --frontend=noninteractive locales


# GDB package has issues... https://github.com/Gallopsled/pwntools/issues/1783
# So download it ourselves and compile...
#RUN cd /tmp \
#&& wget https://sourceware.org/pub/gdb/snapshots/current/gdb-12.0.50.20220320.tar.xz \
#&& tar xvf gdb-12.0.50.20220320.tar.xz \
#&& cd gdb-12.0.50.20220320 \
#&& ./configure --with-python=/usr/bin/python3 \
#&& make -j 6 \ 
#&& make install \
#&& cd /tmp \ 
#&& /usr/bin/rm -rf /tmp/gdb-12*

# pip
RUN pip3 install \
   angr \
   # distorm3 \
   gmpy \
   # openpyxl \
   pycrypto \
   # Pillow \
   # sympy \
   # ujson \
   # xortool \
   # yara-python \

# binwalk
&& cd /tmp 

RUN apt-get update && apt-get install -y \
    curl \
    build-essential \
    libfontconfig1-dev

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

RUN cd /tmp && cargo install binwalk

# cleanup
RUN apt clean \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

