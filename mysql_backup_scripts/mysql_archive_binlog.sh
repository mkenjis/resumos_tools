# archive the last binary logs from last hour
#find /var/lib/mysql -name '*binlog*' -mmin -60 -exec cp {} /data/mysql/archive \;
find /var/lib/mysql -name '*binlog*'  -mmin -60 -exec wc {} \; | while read P1 P2 P3 P4; do
  v_binlog=`basename ${P4}`
  if [ ! -f /data/mysql/archive/${v_binlog} ]; then
    cp $P4 /data/mysql/archive
    echo $P4 copied
  else
    read L1 L2 L3 L4 <<< "`wc /data/mysql/archive/${v_binlog}`"
    if [ $P3 -ne $L3 ]; then
      cp $P4 /data/mysql/archive
      echo $P4 copied
    fi
  fi
done

# remove the old ones from last 7 days
find /data/mysql/archive -name '*binlog*' -mtime +7 -exec rm {} \;

