# SeleniumBase Debian Linux Dependency Installation
# (Installs all required dependencies on Linux)

# Make sure this script is only run on Linux
# value="$(uname)"
# if [ $value == "Linux" ]
# then
#   echo "Initializing Requirements Setup..."
# else
#   echo "Not on a Linux machine. Exiting..."
#   exit
# fi

# Go home
cd ~

# Configure apt-get resources
sudo sh -c "echo \"deb http://packages.linuxmint.com debian import\" >> /etc/apt/sources.list"
sudo sh -c "echo \"deb http://downloads.sourceforge.net/project/ubuntuzilla/mozilla/apt all main\" >> /etc/apt/sources.list"

# Update aptitude
sudo aptitude update

# Install core dependencies
sudo aptitude install -y --force-yes xserver-xorg-core
sudo aptitude install -y --force-yes x11-xkb-utils

# Install Xvfb (headless display system)
sudo aptitude install -y --force-yes xvfb

# Install fonts for web browsers
sudo aptitude install -y --force-yes xfonts-100dpi xfonts-75dpi xfonts-scalable xfonts-cyrillic

# Install Python core dependencies
sudo apt-get update
sudo apt-get install -y --force-yes python-setuptools

# Install Firefox
sudo gpg --keyserver pgp.mit.edu --recv-keys 3EE67F3D0FF405B2
sudo gpg --export 3EE67F3D0FF405B2 > 3EE67F3D0FF405B2.gpg
sudo apt-key add ./3EE67F3D0FF405B2.gpg
sudo rm ./3EE67F3D0FF405B2.gpg
sudo apt-get -qy --no-install-recommends install -y --force-yes firefox
sudo apt-get -qy --no-install-recommends install -y --force-yes $(apt-cache depends firefox | grep Depends | sed "s/.*ends:\ //" | tr '\n' ' ')
cd /tmp
sudo wget --no-check-certificate -O firefox-esr.tar.bz2 'https://download.mozilla.org/?product=firefox-esr-latest&os=linux32&lang=en-US'
sudo tar -xjf firefox-esr.tar.bz2 -C /opt/
sudo rm -rf /usr/bin/firefox
sudo ln -s /opt/firefox/firefox /usr/bin/firefox
sudo rm -f /tmp/firefox-esr.tar.bz2
sudo apt-get -f install -y --force-yes firefox

# Install more dependencies
sudo apt-get update
sudo apt-get install -y --force-yes xvfb
sudo apt-get install -y --force-yes build-essential chrpath libssl-dev libxft-dev
sudo apt-get install -y --force-yes libfreetype6 libfreetype6-dev
sudo apt-get install -y --force-yes libfontconfig1 libfontconfig1-dev
sudo apt-get install -y --force-yes libmysqlclient-dev
sudo apt-get install -y --force-yes python-dev
sudo apt-get install -y --force-yes python-MySQLdb

# Install PhantomJS
cd ~
export PHANTOM_JS="phantomjs-2.1.1-linux-x86_64"
sudo wget https://bitbucket.org/ariya/phantomjs/downloads/$PHANTOM_JS.tar.bz2
sudo tar xvjf $PHANTOM_JS.tar.bz2
sudo mv -f $PHANTOM_JS /usr/local/share
sudo ln -sf /usr/local/share/$PHANTOM_JS/bin/phantomjs /usr/local/bin

# Install Chrome
cd /tmp
sudo wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt-get -f install -y --force-yes
sudo dpkg -i google-chrome-stable_current_amd64.deb

# Install Chromedriver
sudo wget -N http://chromedriver.storage.googleapis.com/2.20/chromedriver_linux64.zip -P ~/Downloads
sudo unzip -o ~/Downloads/chromedriver_linux64.zip -d ~/Downloads
sudo chmod +x ~/Downloads/chromedriver
sudo rm -f /usr/local/share/chromedriver
sudo rm -f /usr/local/bin/chromedriver
sudo rm -f /usr/bin/chromedriver
sudo mv -f ~/Downloads/chromedriver /usr/local/share/chromedriver
sudo ln -s /usr/local/share/chromedriver /usr/local/bin/chromedriver
sudo ln -s /usr/local/share/chromedriver /usr/bin/chromedriver

# Finalize apt-get dependancies
sudo apt-get -f install -y --force-yes

# Get pip
sudo easy_install pip
sudo apt install python3-pip

# Get librairies needed for the launch of the get Pinnacle.py
pip3 install pandas
pip3 install selenium
pip3 install pyvirtualdisplay
pip3 install datetime
pip3 install requests
pip3 install bs4

# Get the webdriver needed for the use of selenium
sudo apt-get install unzip &&
a=$(uname -m) &&
rm -r /tmp/chromedriver/
mkdir /tmp/chromedriver/ &&
wget -O /tmp/chromedriver/LATEST_RELEASE http://chromedriver.storage.googleapis.com/LATEST_RELEASE &&
if [ $a == i686 ]; then b=32; elif [ $a == x86_64 ]; then b=64; fi &&
latest=$(cat /tmp/chromedriver/LATEST_RELEASE) &&
wget -O /tmp/chromedriver/chromedriver.zip 'http://chromedriver.storage.googleapis.com/'$latest'/chromedriver_linux'$b'.zip' &&
sudo unzip /tmp/chromedriver/chromedriver.zip chromedriver -d /usr/local/bin/ &&
echo 'success?'


# Get crontab
apt-get install cron
