#!/bin/sh
#################### REQUIREMENTS #####################################
# - Install p7zip (e.g. sudo apt-get install p7zip p7zip-full p7zip-rar)
# - Change the path to the config.php file
#######################################################################
# Backup Data folder and SQL Dump
copy () {
	mkdir $PWD/backup;
	cp -vR $dataroot $PWD/backup/moodledata.backup;
	cp -vR $moodlepath $PWD/backup/moodle.backup;
	mysqldump -h $dbhost -u $dbuser --password=$dbpass -C -Q -e --create-options $dbname > moodle-database.sql;
	mv moodle-database.sql $PWD/backup/;
	}

# Compress backup files	
compress (){
	7z a moodle-backup.7z $PWD/backup/;
	}

# Remove working directory
remove (){
	rm -R $PWD/backup;
	rm $PWD/moodle-backup.7z;
	}

# Rename 7 Zip-file to add date stamp	
rename (){
	file_name=moodle-backup.7z
 	current_time=$(date "+%Y.%m.%d-%H.%M.%S")
	echo "Current Time : $current_time"
	new_fileName=$current_time.$file_name
	echo "New FileName: " "$new_fileName"
 	cp $file_name $new_fileName
	}

# The path to the moodle config.php
moodlepath=/var/www/html/moodle
configpath=$moodlepath/config.php 

# Grep user, pw, host, dbname
dbuser=$(grep dbuser $configpath | grep -Eo "'[A-Za-z0-9][A-Za-z0-9]*"| grep -Eo "[A-Za-z0-9][A-Za-z0-9]*")
dbhost=$(grep dbhost $configpath | grep -Eo "'[A-Za-z0-9][A-Za-z0-9]*"| grep -Eo "[A-Za-z0-9][A-Za-z0-9]*")
dbname=$(grep dbname $configpath | grep -Eo "'[A-Za-z0-9][A-Za-z0-9]*"| grep -Eo "[A-Za-z0-9][A-Za-z0-9]*")
dbpass=$(grep dbpass $configpath | grep -Eo "'[A-Za-z0-9][A-Za-z0-9]*"| grep -Eo "[A-Za-z0-9][A-Za-z0-9]*")
dataroot=$(grep dataroot $configpath | grep -Eo "[/][A-Za-z0-9/]*")

# Run the functions
copy&&compress&&rename&&remove;
