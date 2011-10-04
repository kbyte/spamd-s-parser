#!/bin/bash
#checkspam.sh parse the spamd.log to print a report whit spamers domain and IP Address
#created by Kbyte <ptrschz@gmail.com>

# Generating files to parse
echo "Parsing spamd.log file..."

#check in spamd.log all entries identified as spam and create idspam.txt file
grep "result: Y" /var/log/spamassassin/spamd.log > idspam.txt

#parsing all that who has domain identified
if grep -v -e "unknown" idspam.txt > toparse.txt
 then
  i=1
  while read line 
  do
   #extract date
   to_date=$(head -$i /home/psanchez/bin/toparse.txt | cut -d "[" -f 1 | tail -1) 
   #extract domain
   to_extract=$(head -$i /home/psanchez/bin/toparse.txt | cut -d "@" -f 2 | cut -d ">" -f 1 | tail -1)
   #get the ip address by nslookup
   to_address=$(nslookup $to_extract | grep "Address: " | tail -1)
   #generating gral_spam.txt file as report
   echo "$to_date| $to_extract | $to_address" >> gral_spam.txt
   let i=i+1
  done < toparse.txt
fi
clear
#show on screen the report eliminating repeated entries
cat gral_spam.txt | uniq
echo " "
echo " "
echo "Parse has been done..."
#removing generated .txt files
rm *.txt
exit 0
