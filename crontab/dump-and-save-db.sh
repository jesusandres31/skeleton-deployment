######## SET GDRIVE ########
#
# Step 1: Download the latest release from Github
# wget https://github.com/prasmussen/gdrive/releases/download/2.1.1/gdrive_2.1.1_linux_386.tar.gz
#
# Step 2: Unzip the Archive
# tar -xvf gdrive_2.1.1_linux_386.tar.gz
#
# Step 3: Perform Authentication
# ./gdrive about

######## SET CRON JOB ########
#
# Step 1: Create all needed folders and update vars in the script
#
# sudo EDITOR=nano crontab -e
#
# # At 00:00 on Sunday
# DUMP_DB_SCRIPT_PATH=/home/Liber/cronjob/dump-and-save-db.sh 
# DUMP_DB_LOG_PATH=/home/Liber/cronjob/dump-and-save-db.log
# 0 0 * * 0 /bin/bash $DUMP_DB_SCRIPT_PATH > $DUMP_DB_LOG_PATH 2>&1

######## SET SCRIP ########
#
#!/bin/sh

# SET VARS...
ROOT_PATH=/home/Liber/cronjob
FOLDER_ID=asdasdasdadadasdasdasddasd
BACKUP_NAME=liber_db_backup
DB_CONT_NAME=liber_db
DB_NAME=liber

# SCRIPT STARTS...
# dump db from container
sudo docker exec -i ${DB_CONT_NAME} pg_dump -U postgres -d ${DB_NAME} > ${ROOT_PATH}/db_dump.sql

# compress file
tar cvzf ${ROOT_PATH}/${BACKUP_NAME}.tar.gz -P ${ROOT_PATH}/db_dump.sql

# upload tar to google drive and delete uploaded file
${ROOT_PATH}/gdrive upload -p ${FOLDER_ID} --delete ${ROOT_PATH}/${BACKUP_NAME}.tar.gz

# save list with files in backup folder
${ROOT_PATH}/gdrive list --query " '${FOLDER_ID}' in parents" --order modifiedTime > ${ROOT_PATH}/list.txt

# get number of files if backup folder
LIST_LEN=$(awk 'END{print NR -1}' ${ROOT_PATH}/list.txt)

# if number of files in backup folder is greater than 10
if [ $LIST_LEN -gt 10 ]
then
    # get ID of the oldest backup file, and delete it
    OLDEST_FILE_ID=$(awk 'FNR == 2 {print $1}' ${ROOT_PATH}/list.txt)
    ${ROOT_PATH}/gdrive delete ${OLDEST_FILE_ID}
fi

# remove temp files
sudo rm ${ROOT_PATH}/db_dump.sql ${ROOT_PATH}/list.txt

echo "Done!"
