#!/bin/bash

# Install prerequisites (No sudo needed in Docker container)
apt-get update
apt-get install -y fortune-mod cowsay netcat-openbsd

# Start the application
SRVPORT=4499
RSPFILE=response

rm -f $RSPFILE
mkfifo $RSPFILE

get_api() {
    read line
    echo $line
}

handleRequest() {
    # 1) Process the request
    get_api
    mod=$(fortune)

cat <<EOF > $RSPFILE
HTTP/1.1 200

<pre>$(cowsay $mod)</pre>
EOF
}

prerequisites() {
    echo "Checking for cowsay and fortune..."

    if ! command -v cowsay >/dev/null 2>&1; then
        echo "cowsay is not installed or not found in PATH."
    else
        echo "cowsay is installed."
    fi

    if ! command -v fortune >/dev/null 2>&1; then
        echo "fortune is not installed or not found in PATH."
    else
        echo "fortune is installed."
    fi

    if ! command -v cowsay >/dev/null 2>&1 || ! command -v fortune >/dev/null 2>&1; then
        echo "Install prerequisites."
        exit 1
    fi
}

main() {
    prerequisites
    echo "Wisdom served on port=$SRVPORT..."

    while [ 1 ]; do
        cat $RSPFILE | nc -lN $SRVPORT | handleRequest
        sleep 0.01
    done
}

main
