#!/bin/bash
#checkspam.sh parse the spamd.log to print a report whit spamers domain and IP Address

cd /home/psanchez/bin/

# Generating files to parse
echo "Parsing spamd.log file..."
grep "result: Y" /var/log/spamassassin/spamd.log > idspam.txt
if grep -v -e "unknown" idspam.txt > toparse.txt
 then
  i=1
  while read line 
  do
   to_date=$(head -$i /home/psanchez/bin/toparse.txt | cut -d "[" -f 1 | tail -1) 
   to_extract=$(head -$i /home/psanchez/bin/toparse.txt | cut -d "@" -f 2 | cut -d ">" -f 1 | tail -1)
   to_address=$(nslookup $to_extract | grep "Address: " | tail -1)
  echo "$to_date| $to_extract | $to_address" >> gral_spam.txt
  let i=i+1
  done < toparse.txt
fi
clear
cat gral_spam.txt | uniq
echo " "
echo " "
echo "Parse has been done..."
rm *.txt
exit 0
