#!/usr/bin/env bash
# Character for separating values
# (commas are not safe, because some servers return speeds with commas)
sep=";"

# Temporary file holding speedtest-cli output
user=$USER
if test -z $user; then
  user=$USERNAME
fi
log=/tmp/$user/speedtest-csv.log

# Local functions
function str_extract() {
 pattern=$1
 # Extract
 res=`grep "$pattern" $log | sed "s/$pattern//g"`
 # Drop trailing ...
 res=`echo $res | sed 's/[.][.][.]//g'`
 # Trim
 res=`echo $res | sed 's/^ *//g' | sed 's/ *$//g'`
 echo $res
}

# Display header?
if test "$1" = "--header"; then
  start="start"
  stop="stop"
  from="from"
  from_ip="from_ip"
  server="server"
  server_dist="server_dist"
  server_ping="server_ping"
  download="download"
  upload="upload"
  share_url="share_url"
else
  mkdir -p `dirname $log`

  start=`date +"%Y-%m-%d %H:%M:%S"`

  if test -n "$SPEEDTEST_CSV_SKIP" && test -f "$log"; then
    # Reuse existing results (useful for debugging)
    1>&2 echo "** Reusing existing results: $log"
  else
    # Query Speedtest
    /usr/local/bin/speedtest-cli --share > $log
  fi

  stop=`date +"%Y-%m-%d %H:%M:%S"`


  # Parse
  from=`str_extract "Testing from "`
  from_ip=`echo $from | sed 's/.*(//g' | sed 's/).*//g'`
  from=`echo $from | sed 's/ (.*//g'`

  server=`str_extract "Hosted by "`
  server_ping=`echo $server | sed 's/.*: //g'`
  server=`echo $server | sed 's/: .*//g'`
  server_dist=`echo $server | sed 's/.*\\[//g' | sed 's/\\].*//g'`
  server=`echo $server | sed 's/ \\[.*//g'`

  download=`str_extract "Download: "`
  upload=`str_extract "Upload: "`
  share_url=`str_extract "Share results: "`
fi
# Standardize units?
if test "$1" = "--standardize"; then
  download=` $download | sed 's/Mbits/Mbit/'`
  upload=`$upload | sed 's/Mbits/Mbit/'`
fi

#SQL User details
user="user";
secret="Password";

#DB Details
db="ISP";
table="InternetSpeedWatchdog";

#Query
query="INSERT INTO $db.$table (id, start_date, stop_date, from_isp, from_ip, server_dist, server_ping, download, upload, share_link)
        VALUES (NULL, '$start', '$stop', '$from', '$server', '$server_dist', '$server_ping', '$download', '$upload', '$share_url');"

#Sending the query to the DB
mysql -u $user -p$secret <<MY_QUERY
  $query
MY_QUERY