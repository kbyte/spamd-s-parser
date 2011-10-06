#!/bin/bash
#checkspam.sh parse the spamd.log to print a report whit spamers domain and IP Address

clear

to_file=$1

if [ "$to_file" == "-h" ]
 then
  echo "Checkspam.sh homemade parser to spamd.log"
  echo "========================================="
  echo " "
  echo "Usage: checkspam.sh <logfile path> to indicate a specific spamd.log path"
  echo "Usage: checkspam.sh to get the default spamd.log path (/var/log/spamassassin/spamd.log)"
  echo "Usage: checkspam.sh to show this screen"
  echo " "
  exit 0
fi

if test -z $to_file 
 then 
  to_file="/var/log/spamassassin/spamd.log"
 else
  if ! test -e $to_file
   then
    echo "checkspam (can not get access to $to_file or does not exist the log, try again...)"
    exit 0
  fi
fi

echo -e "checkspamd (logfile: $to_file)...\n"

grep "result: Y" $to_file > idspam.txt
if grep -v -e "unknown" idspam.txt > toparse.txt
 then
  i=1
  while read line 
  do
   ### change /home/user/path/ to your prefered path ###
   to_date=$(head -$i /home/user/path/toparse.txt | cut -d "[" -f 1 | tail -1) 
   to_extract=$(head -$i /home/user/path/toparse.txt | cut -d "<" -f 2 | cut -d "@" -f 2 | cut -d ">" -f 1 | tail -1)
   to_address=$(nslookup $to_extract | grep "Address: " | cut -d ":" -f 2 | tail -1)
   
   if test -z $to_address ; then to_address=" unknown ip" ; fi

   echo -e "\e[1;34m$to_date\e[0m \e[1;33m$to_extract\e[0m (\e[1;31m$to_address \e[0m)" >> gral_spam.txt
  let i=i+1
  done < toparse.txt
fi

if test -s gral_spam.txt 
 then 
  echo "Date                      Identified Domain and IP Address (Only if is available)"
  echo "================================================================================="
  echo " "
  cat gral_spam.txt | uniq
 else
  echo "No Spam has been identified yet..."
fi
echo " "
echo " "
echo "Parse has been done..."
rm *.txt
exit 0