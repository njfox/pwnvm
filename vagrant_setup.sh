#!/bin/bash

# Updates
sudo apt-get -y update
#sudo apt-get -y upgrade
sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade

sudo apt-get -y install locales
locale-gen en_US.UTF-8

sudo apt-get -y install python3-pip
sudo apt-get -y install python3-dev
sudo apt-get -y install screen
sudo apt-get -y install gdb gdb-multiarch
sudo apt-get -y install unzip
sudo apt-get -y install build-essential
sudo apt-get -y install unrar
sudo apt-get -y install foremost
sudo apt-get -y install htop

# QEMU with MIPS/ARM - http://reverseengineering.stackexchange.com/questions/8829/cross-debugging-for-mips-elf-with-qemu-toolchain
sudo apt-get -y install qemu qemu-user qemu-user-static
sudo apt-get -y install 'binfmt*'
sudo apt-get -y install libc6-armhf-armel-cross
sudo apt-get -y install debian-keyring
sudo apt-get -y install debian-archive-keyring
sudo apt-get -y install libc6-mipsel-cross
sudo apt-get -y install libc6-armel-cross libc6-armhf-cross libc6-arm64-cross
sudo mkdir /etc/qemu-binfmt
sudo ln -s /usr/mipsel-linux-gnu /etc/qemu-binfmt/mipsel
sudo ln -s /usr/arm-linux-gnueabihf /etc/qemu-binfmt/arm

# These are so the 64 bit vm can build 32 bit
sudo apt-get -y install libx32gcc-4.8-dev
sudo apt-get -y install libc6-dev-i386

# Install ARM binutils
sudo apt-get install binutils-arm-linux-gnueabi

# Install Pwntools
sudo apt-get -y install binutils-x86-64-linux-gnu
sudo apt-get -y install python3 python3-pip python3-dev git libssl-dev libffi-dev build-essential
python3 -m pip install -U --upgrade pip
python3 -m pip install -U --upgrade git+https://github.com/Gallopsled/pwntools.git@dev3

cd
mkdir tools
cd tools

# Install radare2
git clone https://github.com/radare/radare2
pushd radare2
./sys/install.sh
popd

# Install binwalk
git clone https://github.com/devttys0/binwalk
pushd binwalk
python setup.py install
popd

# Install Angr
sudo apt-get -y install python-dev libffi-dev build-essential virtualenvwrapper
sudo pip install virtualenv
virtualenv angr
source angr/bin/activate
pip install angr --upgrade
deactivate

# tmux
sudo apt-get -y install tmux

## GDB Tools
# Install peda
git clone https://github.com/longld/peda.git
# Install pwndbg
git clone https://github.com/zachriggle/pwndbg
# Install gef
git clone https://github.com/hugsy/gef.git
pushd gef
git checkout dev
popd
echo "source ~/tools/gef/gef.py" >> ~/.gdbinit
echo "export LC_ALL=en_US.UTF-8" >> ~/.zshrc
echo "export LC_ALL=en_US.UTF-8" >> ~/.bashrc

# Keystone, Capstone, and Unicorn
sudo apt-get -y install cmake pkg-config libglib2.0-dev
wget https://raw.githubusercontent.com/hugsy/stuff/master/update-trinity.sh
bash ./update-trinity.sh
sudo ldconfig

#Ropper
python3 -m pip install --user --upgrade setuptools
python3 -m pip install --user ropper

# fixenv
wget https://raw.githubusercontent.com/hellman/fixenv/master/r.sh
mv r.sh fixenv
chmod +x fixenv

# Enable 32bit binaries on 64bit host
sudo dpkg --add-architecture i386
sudo apt-get -y update
#sudo apt-get -y upgrade
sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade
sudo apt-get -y install libc6:i386 libc6-dbg:i386 libncurses5:i386 libstdc++6:i386

# Install z3 theorem prover
git clone https://github.com/Z3Prover/z3.git && cd z3
python scripts/mk_make.py --python
cd build; make && sudo make install
