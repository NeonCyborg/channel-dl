#! /bin/bash
rm ~/.channel-dl/newlist ~/.channel-dl/dl
touch ~/.channel-dl/dl
LINES="$(wc -l ~/.channel-dl/channels | awk '{print $1}')"
for(( i = 1; i <= $LINES; i=i+1 )); do
    curl $(cat ~/.channel-dl/channels | head -n $i | tail -n 1 | awk '{print $1}') | grep "href=\"/watch?" | awk -F "href=\"/" '{ print $2}' | awk -F "</a>" '{print $1}' | awk '!/class=/'| awk -v var=$i -F"\">" '{print $1,var}' >> ~/.channel-dl/newlist
done
if [ -e ~/.channel-dl/db ];then
    LINES="$(wc -l ~/.channel-dl/newlist | awk '{ print $1}')"
    for(( i = 1; i <= $LINES; i=i+1 )); do
	if ! grep -q "$(cat ~/.channel-dl/newlist | head -n $i | tail -n 1 | awk '{ print $1}')" ~/.channel-dl/db; then
	    cat ~/.channel-dl/newlist | head -n $i | tail -n 1 | awk '{ print $1,$2}' >> ~/.channel-dl/dl
	    cat ~/.channel-dl/dl | awk '{print $1}' >> ~/.channel-dl/db
	    echo "NEW VIDEO FOUND"
	fi
    done
else
    cat ~/.channel-dl/newlist | awk '{ print $1 }' >> ~/.channel-dl/db
    echo "DATABASE CREATED"
fi
LINES="$(wc -l ~/.channel-dl/dl | awk '{ print $1}')"
for(( i = 1; i <= $LINES; i=i+1 )); do
    URL="$(cat ~/.channel-dl/dl | head -n $i | tail -n 1 | awk '{print $1}')"
    QUALITY="$(cat ~/.channel-dl/channels | head -n $(cat ~/.channel-dl/dl | head -n $i | tail -n 1 | awk '{print $2}') | tail -n 1 | awk '{print $2}')"
    if [ "$QUALITY" = "high" ]; then
	youtube-dl --force-ipv4 --get-title -f bestvideo+bestaudio "https://youtube.com/$URL"
    fi
    if [ "$QUALITY" = "medium" ]; then
        youtube-dl --force-ipv4 --get-title -f 'bestvideo[height<=480]+bestaudio/best[height<=480]' "https://youtube.com/$URL"
    fi
    if [ "$QUALITY" = "low" ]; then
	youtube-dl --force-ipv4 --get-title -f 'bestvideo[height<=240]+bestaudio/best[height<=240]' "https://youtube.com/$URL"
    fi
    if [ "$QUALITY" = "audio" ]; then
	youtube-dl --force-ipv4 --get-title -f m4a "https://youtube.com/$URL"
    fi
done
