get 1 raspberry pi

run commands 

sudo apt-get install -y  ruby1.9.3 ruby1.9.1-dev rubygems  git-core firmware-ralink screen tightvncserver ruby-sqlite3 sqlite3
sudo apt-get update
sudo apt-get upgrade

sudo raspi-config
#resize
#change password  

#http://www.raspberrypi.org/phpBB3/viewtopic.php?t=7395

mkdir wifi
cd wifi
wget http://dl.dropbox.com/u/80256631/install-rtl8188cus-latest.sh
wget http://dl.dropbox.com/u/80256631/8192cu-20120701.tar.gz
chmod +x install-rtl8188cus-latest.sh
sudo ./install-rtl8188cus-latest.sh


sudo gem install  --no-rdoc --no-ri haml -v3.1.6
sudo gem install  --no-rdoc --no-ri dm-sqlite-adapter 
sudo gem install  --no-rdoc --no-ri json -v1.7.3
sudo gem install  --no-rdoc --no-ri mail -v2.4.4
sudo gem install  --no-rdoc --no-ri mime
sudo gem install  --no-rdoc --no-ri sass
sudo gem install  --no-rdoc --no-ri sinatra
sudo gem install  --no-rdoc --no-ri ruby-gmail
git clone git://github.com/sbeckeriv/photopi.git
cd photopi
# maybe a release branch

crontab -e
*/20 * * * * ruby /home/pi/photopi/process.rb username pass unread delete

unread says check unread messages only unread is default but if you delete you need to add it in
delete says delete the message. will not delete them from gmail only mark them as read

hacks:
http://extremeshok.com/blog/debian/raspberry-pi-raspbian-tuning-optimising-optimizing-for-reduced-memory-usage/
sudo apt-get install git-core wget ca-certificates binutils preload  -y
sudo echo "CONF_SWAPSIZE=512" > /etc/dphys-swapfile
sudo dphys-swapfile setup
sudo dphys-swapfile swapon 
sudo dpkg-reconfigure dash
sudo sed -i '/[2-6]:23:respawn:\/sbin\/getty 38400 tty[2-6]/s%^%#%g' /etc/inittab
sudo sed -i 's/sortstrategy = 3/sortstrategy = 0/g'  /etc/preload.conf
sudo sed -i 's/vm.swappiness=1/vm.swappiness=10/g'  /etc/sysctl.conf
