#!/bin/bash

THRESHOLD=3

LOG_FILE="/var/log/sudo-access.log"

ADMIN_EMAIL="mohamedjasim10a@gmail.com"

LOW_PRIV_USERS=$(awk -F: '$3 >= 1000 && $3 != 65534 {print $1}' /etc/passwd)

echo $LOW_PRIV_USERS

for USER in $LOW_PRIV_USERS; do

        SUDO_COUNT=$(grep -c "$USER : user NOT in sudoers" $LOG_FILE)

        if [ $SUDO_COUNT -gt $THRESHOLD ]; then
                echo "Threshold reached.. Mailing about - $USER"
                SUBJECT="Excessive sudo attempts by $USER"
                BODY="The user $USER has attempted to use sudo commands $SUDO_COUNT times."
                echo "$BODY" | mail -s "$SUBJECT" "$ADMIN_EMAIL"
        fi
done
