#!/bin/bash

# Check if running as root user, and exit if not.
if [ "$EUID" -ne 0 ]
then
  echo "Run as root or use sudo."
  exit 1
fi

echo "Preparing libraries"
# Install sudo incase its not already installed.
apt-get -y install sudo
# Update the server
sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y dist-upgrade
sudo apt-get -y autoremove
sudo apt-get autoclean

# Install required packages and utilities used later in the script
sudo dpkg --add-architecture i386
sudo apt-get update
sudo apt-get -y install curl wget tmux lib32z1 lib32ncurses5 libbz2-1.0:i386 lib32gcc1 lib32stdc++6 libcurl3-gnutls:i386 libtinfo5:i386 libncurses5:i386

# Add user account
useradd -m -s /bin/bash tf2server
passwd tf2server

echo "Creating Install Directory"
cd ~
mkdir ~/SteamCMD
cd ~/SteamCMD

echo "Fetching Steam Command-Line Client"
wget http://media.steampowered.com/installer/steamcmd_linux.tar.gz
tar -xzvf steamcmd_linux.tar.gz
rm steamcmd_linux.tar.gz

echo "Creating helper scripts"
# tf2_ds.txt
cat << EOT >> ./tf2_ds.txt
login anonymous
force_install_dir ../tf2
app_update 232250
quit
EOT
# update.sh
cat << EOT >> ~/update.sh
#!/bin/sh
./SteamCMD/steamcmd.sh +runscript tf2_ds.txt
EOT
# tf.sh
cat << EOT >> ~/tf.sh
#!/bin/sh
cd /home/tf2server/tf2
/home/tf2server/tf2/srcds_run \
    -game tf \
    -console \
    -nohltv \
    -sv_pure 1 \
    +map ctf_2fort \
    +maxplayers 24 \
    -autoupdate \
    -steam_dir /home/tf2server/SteamCMD/ \
    -steamcmd_script /home/tf2server/SteamCMD/tf2_ds.txt \
    +sv_shutdown_timeout_minutes 30
EOT
chmod +x ~/update.sh
chmod +x ~/tf.sh

echo "Installing TF2 (This may take a while)"
./update.sh

# Fix for srcds looking in wrong directory for binaries. (Such as steamclient.so)
ln -s ~/tf2/bin ~/.steam/sdk32

##########
### Configure web server for fastdl
##########

# install Apache
sudo apt-get -y install apache2

# Create a fastdl directory and create a symlink
mkdir -p /var/www/html/fastdl/tf2/
cd /var/www/html/fastdl/tf2/
ln -s /home/tf2server/tf2/tf/maps maps

# Start the service and enable on startup.
sudo systemctl start apache2.service
sudo systemctl enable apache2.service
