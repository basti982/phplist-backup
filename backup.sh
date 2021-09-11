#!/bin/sh
#################### REQUIREMENTS #####################################
# - Install zip
# - Change the path to the config.php file
#######################################################################
# Backup Data folder and SQL Dump
copy () {
	mkdir $PWD/backup;
	cp -vR $phplistpath $PWD/backup/phplist.backup;
	mysqldump --no-tablespaces -h $dbhost -u $dbuser --password='secret' -C -Q -e --create-options $dbname > phplist-database.sql;
	mv phplist-database.sql $PWD/backup/;
	}

# Compress backup files	
compress (){
	zip -r phplist-backup.zip $PWD/backup/;
	}

# Remove working directory
remove (){
	rm -R $PWD/backup;
	rm $PWD/phplist-backup.zip;
	}

# Rename 7 Zip-file to add date stamp	
rename (){
	file_name=phplist-backup.zip
 	current_time=$(date "+%Y.%m.%d-%H.%M.%S")
	echo "Current Time : $current_time"
	new_fileName=$current_time.$file_name
	echo "New FileName: " "$new_fileName"
	cp $file_name $new_fileName
	}

# The path to the phpconfig config.php
phplistpath=/httpdocs/newsletter/phplist
configpath=/httpdocs/newsletter/phplist/public_html/lists/config/config.php 

# Grep user, pw, host, dbname
dbuser=$(grep database_user $configpath | grep -Eo \'[A-Za-z0-9\_]+\' | grep -Eo [A-Za-z0-9\_]+)
dbhost=$(grep database_host $configpath | grep -Eo \'[A-Za-z0-9\.]+\' | grep -Eo [A-Za-z0-9\.]+)
dbname=$(grep database_name $configpath | grep -Eo \'[A-Za-z0-9\_]+\' | grep -Eo [A-Za-z0-9\_]+)
dbpass=$(grep database_password $configpath | grep -Eo \'[A-Za-z0-9\_]+\' | grep -Eo [A-Za-z0-9\_]+)

# Run the functions
copy&&compress&&rename&&remove;
