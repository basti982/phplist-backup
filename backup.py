#!/usr/bin/python3
#Import standard libarys
import shutil
import os
import pymysql
import tarfile

#Define the path of the moodle and the moodledata
moodle="/home/admini/moodle/"
moodledata="/home/admini/moodledata/"
destianation="/home/admini/backup/"

#Function definition
def copy(src, dst, symlinks=False, ignore=None):
	for item in os.listdir(src):
        	s = os.path.join(src, item)
        	d = os.path.join(dst, item)
        	if os.path.isdir(s):
            		shutil.copytree(s, d, symlinks, ignore)
        	else:
            		shutil.copy2(s, d)
def dbversion(): #This function is not used :)
	# Open database connection
	db = pymysql.connect("localhost","admini","0@SYadmin","mydb" )

	# prepare a cursor object using cursor() method
	cursor = db.cursor()

	# execute SQL query using execute() method.
	cursor.execute("SELECT VERSION()")

	# Fetch a single row using fetchone() method.
	data = cursor.fetchone()
	print ("Database version : %s " % data)

	# disconnect from server
	db.close()

def dbcopy():
	bashCommand = "mysqldump -h localhost -u admini --password=0@SYadmin -C -Q -e --create-options $dbname > $PWD/backup/moodle-database.sql;"
	os.system(bashCommand)
	return

def compress():
	tar = tarfile.open("moodlebackup.tar.gz", "w:gz")
	tar.add("/home/admini/backup/", arcname="TarName")
	tar.close()
	
def remove():
	bashCommand = "rm -R backup"
        os.system(bashCommand)
	
	return
def rename():
	
	
	return

os.mkdir(destianation)
os.mkdir(destianation+"moodle")
os.mkdir(destianation+"moodledata")
copy(moodle, destianation+"moodle")
copy(moodledata, destianation+"moodledata")
dbcopy()
compress()
remove()
