# SeleniumBase Debian Linux Dependency Installation
# (Installs all required dependencies on Linux)
# Initial version copied from:
# https://github.com/seleniumbase/SeleniumBase/blob/3f60c2e0fd78807528661aff36120700d4ff1ed6/integrations/linux/Linuxfile.sh

# Make sure this script is only run on Linux
value="$(uname)"
if [ "$value" = "Linux" ]
then
  echo "Initializing Requirements Setup..."
else
  echo "Not on a Linux machine. Exiting..."
  exit
fi

# Go home
cd ~

# Configure apt-get resources
sudo sh -c "echo \"deb http://packages.linuxmint.com debian import\" >> /etc/apt/sources.list"
sudo sh -c "echo \"deb http://downloads.sourceforge.net/project/ubuntuzilla/mozilla/apt all main\" >> /etc/apt/sources.list"

# Update aptitude
sudo apt-get update

# Install core dependencies
sudo apt-get install -y --force-yes unzip
sudo apt-get install -y --force-yes xserver-xorg-core
sudo apt-get install -y --force-yes x11-xkb-utils

# Install Xvfb (headless display system)
sudo apt-get install -y --force-yes xvfb

# Install fonts for web browsers
sudo apt-get install -y --force-yes xfonts-100dpi xfonts-75dpi xfonts-scalable xfonts-cyrillic

# Install Python core dependencies
sudo apt-get update
sudo apt-get install -y --force-yes python-setuptools

# Install more dependencies
sudo apt-get update
sudo apt-get install -y --force-yes xvfb
sudo apt-get install -y --force-yes build-essential chrpath libssl-dev libxft-dev
sudo apt-get install -y --force-yes libfreetype6 libfreetype6-dev
sudo apt-get install -y --force-yes libfontconfig1 libfontconfig1-dev
sudo apt-get install -y --force-yes python-dev

# Install Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt-get -f install -y --force-yes
sudo dpkg -i google-chrome-stable_current_amd64.deb

# Install Chromedriver
wget -N http://chromedriver.storage.googleapis.com/2.36/chromedriver_linux64.zip
unzip -o chromedriver_linux64.zip
chmod +x chromedriver
sudo rm -f /usr/local/share/chromedriver
sudo rm -f /usr/local/bin/chromedriver
sudo rm -f /usr/bin/chromedriver
sudo mv -f chromedriver /usr/local/share/chromedriver
sudo ln -s /usr/local/share/chromedriver /usr/local/bin/chromedriver
sudo ln -s /usr/local/share/chromedriver /usr/bin/chromedriver

# Finalize apt-get dependancies
sudo apt-get -f install -y --force-yes

# Get pip
sudo easy_install pip
sudo apt install python3-pip
# get python dependency
pip3 install pandas
pip3 install selenium
pip3 install pyvirtualdisplay
pip3 install datetime
pip3 install requests
pip3 install bs4

wget -O start_headless.sh https://raw.githubusercontent.com/ArnaudHureaux/scraping-with-google-cloud/master/start_headless.sh
chmod +x start_headless.sh
