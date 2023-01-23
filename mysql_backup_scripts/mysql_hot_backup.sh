# get root directory to store backup

if [ -z "$1" ]; then
  echo "Usage: mysql_hot_backup.sh <backup-dir>"
  echo
  exit 1
fi

dir_root=$1

# get mysql directory where binary logs are created
out_base=`mysql -uroot -pDcideadmin -e"show variables like 'log_bin_basename'" | grep log_bin_basename`
arrIN=(${out_base// /})
v_base=${arrIN[1]}
dir_binlog=`dirname ${v_base}`

# get binary log index file name which stores the list of binary logs created.
out_indx=`mysql -uroot -pDcideadmin -e"show variables like 'log_bin_index'" | grep log_bin_index`
arrIN=(${out_indx// /})
v_indx=${arrIN[1]}

# create directory to store the backup using current date and time
v_date=`date '+%Y_%m_%d_%H_%M_%S'`
dir_backup=${dir_root}
rm ${dir_root}/*
#echo Creating $dir_backup
#echo
#mkdir -p $dir_backup

# get the list of binary logs created so far.
v_list_binlogs=`cat ${v_indx}`

# performs the dump copying metadata and user tables storing on directory created.
echo Perfoming full back up mysql database
echo
v_last_log=$(basename `tail -1 ${v_indx}`)
mysqldump -uroot -pDcideadmin  --single-transaction --flush-logs --master-data=2 --all-databases > ${dir_backup}/backup_full_until_${v_last_log}.sql

aws s3 cp ${dir_backup}/backup_full_until_${v_last_log}.sql s3://dcide-mysql8-backups/${v_date}/backup_full_until_${v_last_log}.sql

#echo $v_last_log
#echo $dir_binlog
#echo $v_indx

# loops thru each binary log and copies to diretory created
for L1 in $v_list_binlogs; do
  echo Copying ${dir_binlog}"/"${L1}
  # cp ${dir_binlog}"/"${L1} ${dir_backup}
  v_binlog=`basename ${L1}`
  aws s3 cp ${dir_binlog}"/"${v_binlog} s3://dcide-mysql8-backups/${v_date}/${v_binlog}
done

# purges old binary logs
echo
echo Purging binary files before 3 days
mysql -uroot -pDcideadmin -e"purge binary logs before DATE_SUB(NOW(), INTERVAL 3 DAY)"

echo Finished backup
