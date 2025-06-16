#!/bin/bash

# PharmaCorp Lab Build Script
# Must be run as root

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

set -e

echo "Updating system and installing dependencies..."
apt update && apt upgrade -y
apt install -y nginx pwgen

# Define company departments
DEPARTMENTS=("RND" "Clinical" "Regulatory" "IT" "HR" "Finance" "Sales" "Manufacturing")

echo "Creating department groups..."
for dept in "${DEPARTMENTS[@]}"; do
    groupadd $dept
done

echo "Creating department shared directories..."
BASE_DIR="/srv/pharmacorp"
mkdir -p $BASE_DIR

for dept in "${DEPARTMENTS[@]}"; do
    mkdir -p "$BASE_DIR/$dept"
    chown :$dept "$BASE_DIR/$dept"
    chmod 770 "$BASE_DIR/$dept"
done

# Name lists for more realistic usernames
FIRST_NAMES=(John Sarah Michael Emily Daniel Laura David Jessica James Amanda Brian Lisa Matthew Rebecca Andrew Jennifer)
LAST_NAMES=(Smith Johnson Williams Brown Jones Miller Davis Garcia Martinez Robinson Clark Lewis Lee Walker Hall Allen Young Hernandez)

# Create users per department
USERS_PER_DEPT=30

echo "Generating users..."
for dept in "${DEPARTMENTS[@]}"; do
    for i in $(seq 1 $USERS_PER_DEPT); do
        # Generate random name
        FIRST=${FIRST_NAMES[$RANDOM % ${#FIRST_NAMES[@]}]}
        LAST=${LAST_NAMES[$RANDOM % ${#LAST_NAMES[@]}]}
        USERNAME=$(echo "${FIRST:0:1}${LAST}" | tr '[:upper:]' '[:lower:]')
        USERNAME="${USERNAME}${RANDOM:0:3}"  # Avoid duplicates

        # Create user
        useradd -m -s /bin/bash -g $dept $USERNAME

        # Generate random password
        PASSWORD=$(pwgen 12 1)
        echo "${USERNAME}:${PASSWORD}" | chpasswd

        # Save credentials to a log file
        echo "$USERNAME ($FIRST $LAST) - $dept - $PASSWORD" >> /root/pharmacorp_user_credentials.txt
    done
done

echo "Generating sample departmental files..."
for dept in "${DEPARTMENTS[@]}"; do
    for i in {1..10}; do
        echo "Confidential report ${i} for $dept department." > "$BASE_DIR/$dept/${dept}_Report_${i}.txt"
        chmod 660 "$BASE_DIR/$dept/${dept}_Report_${i}.txt"
    done
done

echo "Configuring Nginx internal portal..."
echo "<html><body><h1>PharmaCorp Internal Portal</h1></body></html>" > /var/www/html/index.html
systemctl restart nginx

echo "COMPLETE: PharmaCorp server fully provisioned."
echo "User credentials saved to: /root/pharmacorp_user_credentials.txt"

