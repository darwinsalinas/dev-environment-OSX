#!/bin/bash
# -*- ENCODING: UTF-8 -*-
echo "**************************************************************************"
echo "-----------------------Bienvenido $LOGNAME--------------------------------"
echo "----  Este script te ayudará en la configuración e instalación de tu  ----"
echo "----                Entorno de Desarrollo                             ----"
echo "**************************************************************************"
echo "Paquetes a instalar:
1.Autoconf                2.Git               3.CMake           4.MySQL		
5.PostgreSQL              6.MongoDB           7.SQLite          8.PCRE		
9.Apache                  10.LibJPEG          11.LibPNG         12.LibMCrypt 	
13.FreeType               14.PHP              15.Autoconf       16.Xdebug	
17.MySQL for PHP          18.PostgreSQLPHP    19.MongoDBPHP     20.SQLite for PHP		
21.rbenv                  23.OpenSSL          24.Ruby           25.RubyGems
26.Bundler                7.Ruby on Rails     28.MySQLRuby      29.PostgreSQL for Ruby
30.MongoDBRuby            31.SQLiteRuby       32.Node.js        33.Grunt
34.Bower                  35.Homebrew         36.BrewCask       37.Chrome
38.Sublime Text           39.Firefox          40.Tower          41.iTerm 
42.pgAdmin3               43.Virtual Box      44.genymotion     45.VLC 
46.jdownloader
		"
echo "**************************************************************************
"
echo "Debe tener Xcode Instalado previamente a la ejecución de este script"
echo "Si aun no lo tienes puedes descargarlo desde este enlace:"
echo "https://developer.apple.com/downloads"
echo ""
read -p "Presione [Enter] para continuar..."
echo "+++			Creando estructura de Directorios 			+++"
sudo mkdir -p /usr/local/src
sudo mkdir -p /usr/local/var/log
mkdir -p ~/Library/LaunchAgents
sudo chown -R $LOGNAME:staff /usr/local
echo ""
echo "+++			Directorios Creados							+++"
echo ""
echo "Instalando AUTOCONF..."
cd /usr/local/src
curl --remote-name http://ftp.gnu.org/gnu/autoconf/autoconf-2.69.tar.gz
tar -xzvf autoconf-2.69.tar.gz
cd autoconf-2.69
./configure --prefix=/usr/local/autoconf-2.69
make
make install
ln -s autoconf-2.69 /usr/local/autoconf
echo 'export PATH=/usr/local/autoconf/bin:$PATH' >> ~/.bash_profile
source ~/.bash_profile
echo "**************************************************************************"
autoconf --version
echo "**************************************************************************"
echo "################################"
echo "Instalando GIT..."
echo "################################"
cd /usr/local/src
curl --remote-name https://www.kernel.org/pub/software/scm/git/git-2.3.1.tar.gz
tar -xzvf git-2.3.1.tar.gz
cd git-2.3.1
make configure
./configure --prefix=/usr/local/git-2.3.1
make all
make install
ln -s git-2.3.1 /usr/local/git
echo ""
echo "Instalando Documentacion de GIT..."
echo ""
cd /usr/local/src
curl --remote-name https://www.kernel.org/pub/software/scm/git/git-manpages-2.3.1.tar.gz
tar -xzvof git-manpages-2.3.1.tar.gz -C /usr/local/git/share/man
echo 'export PATH=/usr/local/git/bin:$PATH' >> ~/.bash_profile
echo 'export MANPATH=/usr/local/git/share/man:$MANPATH' >> ~/.bash_profile
source ~/.bash_profile
echo "**************************************************************************"
git --version
echo "**************************************************************************"
echo "################################"
echo "Instalando CMAKE..."
echo "################################"
cd /usr/local/src
curl --remote-name http://www.cmake.org/files/v3.1/cmake-3.1.3.tar.gz
tar -xzvf cmake-3.1.3.tar.gz
cd cmake-3.1.3
./bootstrap --prefix=/usr/local/cmake-3.1.3
make
make install
ln -s cmake-3.1.3 /usr/local/cmake
echo 'export PATH=/usr/local/cmake/bin:$PATH' >> ~/.bash_profile
echo 'export MANPATH=/usr/local/cmake/man:$MANPATH' >> ~/.bash_profile
source ~/.bash_profile
echo "**************************************************************************"
echo "Version de CMAKE instalada"
cmake --version
echo "**************************************************************************"
echo "################################"
echo "Instalando MySQL..."
echo "################################"
cd /usr/local/src
curl --remote-name --location https://dev.mysql.com/get/Downloads/MySQL-5.6/mysql-5.6.23.tar.gz
tar -xzvf mysql-5.6.23.tar.gz
cd mysql-5.6.23
cmake \
  -DCMAKE_INSTALL_PREFIX=/usr/local/mysql-5.6.23 \
  -DCMAKE_CXX_FLAGS="-stdlib=libstdc++" \
  -DDEFAULT_CHARSET=utf8 \
  -DDEFAULT_COLLATION=utf8_general_ci \
  .
make
make install
ln -s mysql-5.6.23 /usr/local/mysql
echo 'export PATH=/usr/local/mysql/bin:$PATH' >> ~/.bash_profile
echo 'export MANPATH=/usr/local/mysql/man:$MANPATH' >> ~/.bash_profile
source ~/.bash_profile
mkdir -p /usr/local/var/mysql
/usr/local/mysql/scripts/mysql_install_db --basedir=/usr/local/mysql --datadir=/usr/local/var/mysql
mysql_secure_installation
echo ""
echo "Inicializando el servicio de MySQL..."
echo ""
mysqld_safe --user=mysql --datadir=/usr/local/var/mysql --log-error=/usr/local/var/log/mysql.log &

echo ""
echo "Deteniendo el servicio de MySQL..."
echo ""
mysqladmin --user=root --password shutdown
echo "**************************************************************************"
echo "Version de MySQL instalada..."
mysqld --version
echo "**************************************************************************"
echo "################################"
echo "Instalando PostGreSQL..."
echo "################################"
cd /usr/local/src
curl --remote-name http://ftp.postgresql.org/pub/source/v9.3.5/postgresql-9.3.5.tar.gz
tar -xzvf postgresql-9.3.5.tar.gz
cd postgresql-9.3.5
./configure --prefix=/usr/local/postgresql-9.3.5
make world
make install-world
ln -s postgresql-9.3.5 /usr/local/postgresql
echo 'export PATH=/usr/local/postgresql/bin:$PATH' >> ~/.bash_profile
echo 'export MANPATH=/usr/local/postgresql/share/man:$MANPATH' >> ~/.bash_profile
source ~/.bash_profile
mkdir -p /usr/local/var/postgresql
initdb --pgdata=/usr/local/var/postgresql
echo "################################"
echo "Inicializando servicio de  PostGreSQL..."
pg_ctl -D /usr/local/var/postgresql -l /usr/local/var/log/postgresql.log start
# pg_ctl -D /usr/local/var/postgresql stop
echo "################################"
echo '
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>org.postgresql.postgres</string>

    <key>ProgramArguments</key>
    <array>
      <string>/usr/local/postgresql/bin/postgres</string>
      <string>-D</string>
      <string>/usr/local/var/postgresql</string>
    </array>

    <key>StandardOutPath</key>
    <string>/usr/local/var/log/postgresql.log</string>
    <key>StandardErrorPath</key>
    <string>/usr/local/var/log/postgresql.log</string>

    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
  </dict>
</plist>
' >> ~/Library/LaunchAgents/org.postgresql.postgres.plist
launchctl load ~/Library/LaunchAgents/org.postgresql.postgres.plist
echo "**************************************************************************"
echo "Version  de  PostGreSQL..."
postgres --version
echo "**************************************************************************"
echo "################################"
echo "Instalando MongoDB..."
echo "################################"
cd /usr/local/src
curl --remote-name http://fastdl.mongodb.org/osx/mongodb-osx-x86_64-3.0.0.tgz
tar -zxvf mongodb-osx-x86_64-3.0.0.tgz -C ..
ln -s mongodb-osx-x86_64-3.0.0 /usr/local/mongodb
mkdir -p /usr/local/var/mongodb
echo 'export PATH=/usr/local/mongodb/bin:$PATH' >> ~/.bash_profile
source ~/.bash_profile
mongod --config /usr/local/mongodb/mongod.conf


echo "################################"
echo "Instalando SQLITE..."
echo "################################"
cd /usr/local/src
curl --remote-name http://www.sqlite.org/2015/sqlite-autoconf-3080803.tar.gz
tar -xzvf sqlite-autoconf-3080803.tar.gz
cd sqlite-autoconf-3080803
./configure --prefix=/usr/local/sqlite-3080803
make
make install
ln -s sqlite-3080803 /usr/local/sqlite
echo 'export PATH=/usr/local/sqlite/bin:$PATH' >> ~/.bash_profile
source ~/.bash_profile
echo "**************************************************************************"
sqlite3 -version
echo "**************************************************************************"


echo "################################"
echo "Instalando PCRE..."
echo "################################"
cd /usr/local/src
curl --remote-name ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.36.tar.gz
tar -xzvf pcre-8.36.tar.gz
cd pcre-8.36
./configure --prefix=/usr/local/pcre-8.36
make
make install
ln -s pcre-8.36 /usr/local/pcre
echo 'export PATH=/usr/local/pcre/bin:$PATH' >> ~/.bash_profile
source ~/.bash_profile
echo "**************************************************************************"
pcre-config --version
echo "**************************************************************************"


echo "################################"
echo "Instalando Apache..."
echo "################################"
cd /usr/local/src
curl --remote-name http://apache.sunsite.ualberta.ca/httpd/httpd-2.4.12.tar.gz
tar -xzvf httpd-2.4.12.tar.gz
cd httpd-2.4.12
sudo xcode-select -switch /
mkdir -p /Applications/Xcode.app/Contents/Developer/Toolchains/OSX10.10.xctoolchain/usr/bin
ln -s /usr/bin/cc /Applications/Xcode.app/Contents/Developer/Toolchains/OSX10.10.xctoolchain/usr/bin/cc
./configure --prefix=/usr/local/apache-2.4.12
make
make install
ln -s apache-2.4.12 /usr/local/apache
echo '
ServerName dev.local
User $LOGNAME
Group staff

DocumentRoot "/Users/$LOGNAME/Sites"
ErrorLog "/usr/local/var/log/apache.log"
CustomLog "/usr/local/var/log/apache.log" common
<Directory "/Users/$LOGNAME/Sites">
  Options All
  AllowOverride All
  IndexOptions NameWidth=*

  Require all denied
  Require host localhost
  Require host 127.0.0.1
</Directory>
' >> /usr/local/apache/conf/httpd.conf
mkdir -p ~/Sites

echo 'export PATH=/usr/local/apache/bin:$PATH' >> ~/.bash_profile
echo 'export MANPATH=/usr/local/apache/man:$MANPATH' >> ~/.bash_profile
source ~/.bash_profile


sudo touch /Library/LaunchDaemons/org.apache.apache2.plist
sudo echo '
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>org.apache.apache2</string>

    <key>ProgramArguments</key>
    <array>
      <string>/usr/local/apache/bin/httpd</string>
      <string>-D</string>
      <string>FOREGROUND</string>
    </array>

    <key>StandardOutPath</key>
    <string>/usr/local/var/log/apache.log</string>
    <key>StandardErrorPath</key>
    <string>/usr/local/var/log/apache.log</string>

    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
  </dict>
</plist>
' >> /Library/LaunchDaemons/org.apache.apache2.plist
sudo launchctl load /Library/LaunchDaemons/org.apache.apache2.plist
echo "**************************************************************************"
httpd -v
echo "**************************************************************************"


echo "################################"
echo "Instalando Librerias..."
echo "################################"
cd /usr/local/src
curl --remote-name http://www.ijg.org/files/jpegsrc.v9a.tar.gz
tar -xzvf jpegsrc.v9a.tar.gz
cd jpeg-9a
./configure --prefix=/usr/local/libjpeg-9a
make
make install
ln -s libjpeg-9a /usr/local/libjpeg
cd /usr/local/src
curl --remote-name --location http://download.sourceforge.net/libpng/libpng-1.6.16.tar.gz
tar -xzvf libpng-1.6.16.tar.gz
cd libpng-1.6.16
./configure --prefix=/usr/local/libpng-1.6.16
make
make install
ln -s libpng-1.6.16 /usr/local/libpng
cd /usr/local/src
curl --remote-name --location http://downloads.sourceforge.net/project/mcrypt/Libmcrypt/2.5.8/libmcrypt-2.5.8.tar.gz
tar -xzvf libmcrypt-2.5.8.tar.gz
cd libmcrypt-2.5.8
./configure --prefix=/usr/local/libmcrypt-2.5.8
make
make install
ln -s libmcrypt-2.5.8 /usr/local/libmcrypt
cd /usr/local/src
curl --remote-name --location http://sourceforge.net/projects/freetype/files/freetype2/2.5.5/freetype-2.5.5.tar.gz
tar -xzvf freetype-2.5.5.tar.gz
cd freetype-2.5.5
./configure --prefix=/usr/local/freetype-2.5.5
make
make install
ln -s freetype-2.5.5 /usr/local/freetype
echo "################################"
echo "Instlando PHP"
echo "################################"
cd /usr/local/src
curl --location --output php-5.5.17.tar.gz http://ca.php.net/get/php-5.5.17.tar.gz/from/this/mirror
tar -xzvf php-5.5.17.tar.gz
cd php-5.5.17
./configure \
	--prefix=/usr/local/php-5.5.17 \
	--with-config-file-path=/usr/local/php-5.5.17/etc \
	--enable-bcmath \
	--enable-mbstring \
	--enable-sockets \
	--enable-zip \
	--with-apxs2=/usr/local/apache/bin/apxs \
	--with-bz2 \
	--with-curl \
	--with-freetype-dir=/usr/local/freetype \
	--with-gd \
	--with-imap-ssl \
	--with-jpeg-dir=/usr/local/libjpeg \
	--with-mcrypt=/usr/local/libmcrypt \
	--with-mysql \
	--with-mysqli \
	--with-pear \
	--with-pdo-mysql \
	--with-pdo-pgsql=/usr/local/postgresql \
	--with-pgsql=/usr/local/postgresql \
	--with-png-dir=/usr/local/libpng \
	--with-openssl \
	--with-xmlrpc \
	--with-xsl \
	--with-zlib
make
make install
ln -s php-5.5.17 /usr/local/php
cp php.ini-development /usr/local/php/etc/php.ini
pecl config-set php_ini /usr/local/php/etc/php.ini
pear config-set php_ini /usr/local/php/etc/php.ini
echo '
	<IfModule mime_module>
	  AddType application/x-httpd-php .php
	</IfModule>
	<IfModule dir_module>
	  DirectoryIndex index.html index.php
	</IfModule>
' >> /usr/local/apache/conf/httpd.conf
echo 'export PATH=/usr/local/php/bin:$PATH' >> ~/.bash_profile
echo 'export MANPATH=/usr/local/php/man:$MANPATH' >> ~/.bash_profile
source ~/.bash_profile
sudo apachectl restart
echo "**************************************************************************"
php --version
echo "**************************************************************************"
echo "################################"
echo "Instalando autoconf"
echo "################################"
cd /usr/local/src
curl --remote-name http://ftp.gnu.org/gnu/autoconf/autoconf-2.69.tar.gz
tar -xzvf autoconf-2.69.tar.gz
cd autoconf-2.69
./configure --prefix=/usr/local/autoconf-2.69
make
make install
ln -s autoconf-2.69 /usr/local/autoconf
echo 'export PATH=/usr/local/autoconf/bin:$PATH' >> ~/.bash_profile
source ~/.bash_profile
echo "**************************************************************************"
autoconf --version
echo "**************************************************************************"
echo "################################"
echo "Instalando XDebug"
echo "################################"
pecl install xdebug
echo 'zend_extension="/usr/local/php/lib/php/extensions/no-debug-zts-20131226/xdebug.so"' >> /usr/local/php/etc/php.ini

pecl install mongo

echo "################################"
echo "Instalando rbenv"
echo "################################"
git clone git://github.com/sstephenson/rbenv.git /usr/local/rbenv
echo 'export PATH=/usr/local/rbenv/bin:$PATH' >> ~/.bash_profile
echo 'export RBENV_ROOT=/usr/local/rbenv' >> ~/.bash_profile
echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
source ~/.bash_profile
git clone https://github.com/sstephenson/rbenv-gem-rehash.git /usr/local/rbenv/plugins/rbenv-gem-rehash
echo "################################"
echo "Instalando openssl"
echo "################################"
cd /usr/local/src
curl --remote-name http://www.openssl.org/source/openssl-1.0.2.tar.gz
tar -xzvf openssl-1.0.2.tar.gz
cd openssl-1.0.2
./configure darwin64-x86_64-cc --prefix=/usr/local/openssl-1.0.2
make
make install
ln -s openssl-1.0.2 /usr/local/openssl
echo 'export PATH=/usr/local/openssl/bin:$PATH' >> ~/.bash_profile
echo 'export MANPATH=/usr/local/openssl/ssl/man:$MANPATH' >> ~/.bash_profile
source ~/.bash_profile
security find-certificate -a -p /Library/Keychains/System.keychain > /usr/local/openssl/ssl/cert.pem
security find-certificate -a -p /System/Library/Keychains/SystemRootCertificates.keychain >> /usr/local/openssl/ssl/cert.pem
echo "**************************************************************************"
openssl version -a
echo "**************************************************************************"
echo "################################"
echo "Instalando Ruby"
echo "################################"
cd /usr/local/src
curl --remote-name http://cache.ruby-lang.org/pub/ruby/2.1/ruby-2.1.5.tar.gz
tar -xzvf ruby-2.1.5.tar.gz
cd ruby-2.1.5
./configure \
  --prefix=/usr/local/rbenv/versions/2.1.5 \
  --with-opt-dir=/usr/local/openssl
make
make install
rbenv global 2.1.5
rbenv rehash
echo "**************************************************************************"
ruby --version
echo "**************************************************************************"
gem update --system
gem install bundler
bundle --version
gem install rails
rails --version
gem install mysql
gem install pg
gem install mongo
gem install sqlite3
echo "################################"
echo "Instalando NodeJS GRUNT y BOWER"
echo "################################"
cd /usr/local/src
curl --remote-name http://nodejs.org/dist/v0.12.0/node-v0.12.0-darwin-x64.tar.gz
tar -zxvf node-v0.12.0-darwin-x64.tar.gz -C ..
ln -s node-v0.12.0-darwin-x64 /usr/local/node
echo 'export PATH=/usr/local/node/bin:$PATH' >> ~/.bash_profile
echo 'export MANPATH=/usr/local/node/share/man:$MANPATH' >> ~/.bash_profile
source ~/.bash_profile
echo "**************************************************************************"
node --version
echo "**************************************************************************"
sudo npm install -g grunt-cli
echo "**************************************************************************"
grunt --version
echo "**************************************************************************"
sudo npm install -g bower
echo "**************************************************************************"
bower --version
echo "**************************************************************************"
echo "################################"
echo "Instalando Homebrew"
echo "################################"
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
echo "################################"
echo "Instalando Brew Cask"
echo "################################"
brew install caskroom/cask/brew-cask
echo "################################"
echo "Instalando Chrome"
echo "################################"
brew cask install google-chrome
echo "################################"
echo "Instalando Firefox"
echo "################################"
brew cask install firefox
echo "################################"
echo "Instalando Sublime Text"
echo "################################"
brew tap caskroom/versions
brew cask install sublime-text3
echo "################################"
echo "Instalando Tower"
echo "################################"
brew cask install tower
echo "################################"
echo "Instalando iterm2"
echo "################################"
brew cask install iterm2
echo "################################"
echo "Instalando PgAdmn3"
echo "################################"
brew cask install pgadmin3
echo "################################"
echo "Instalando VirtualBox"
echo "################################"
brew cask install virtualbox
echo "################################"
echo "Instalando genymotion"
echo "################################"
brew cask install genymotion
echo "################################"
echo "Instalando VLC"
echo "################################"
brew cask install vlc
echo "################################"
echo "Instalando jdownloader"
echo "################################"
brew cask install jdownloader
echo "################################"
echo "Instalando 4k-video-downloader"
echo "################################"
brew cask install 4k-video-downloader
echo "################################"
echo "Instalando alfred"
echo "################################"
brew cask install alfred
echo "################################"
echo "Instalando dash"
echo "################################"
brew cask install dash
echo "################################"
echo "Instalando caffeine"
echo "################################"
brew cask install caffeine
echo "################################"
echo "Instalando spectacle"
echo "################################"
brew cask install spectacle
echo "################################"
echo "Instalando cinch"
echo "################################"
brew cask install cinch
echo "################################"
echo "Instalando github"
echo "################################"
brew cask install github
echo "################################"
echo "Instalando sqlitebrowser"
echo "################################"
brew cask install sqlitebrowser
echo "################################"
echo "Instalando adobe-digital-editions"
echo "################################"
brew cask install adobe-digital-editions
echo "################################"
echo "Instalando vuze"
echo "################################"
brew cask install vuze
echo "################################"
echo "Instalando calibre"
echo "################################"
brew cask install calibre
echo "################################"
echo "Instalando oh-my-zsh"
echo "################################"
curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh
echo "#################################################################"
echo "#################       ######################         ##########"
echo "#################################################################"
echo "*                         Todo listo enjoy                      *"
echo "#################################################################"
echo "################        ######################         ##########"
echo "#################################################################"
exit