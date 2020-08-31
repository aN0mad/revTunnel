#!/bin/bash

# Pull nessus port back to jump box port 9005
#./tunnel.sh -l 8443 -r 9005

# Variables to set
IP="<IP>"
USER="<USER>"
sshkey="<ID_RSA>"

# trap ctrl-c and call ctrl_c()
trap ctrl_c INT

function ctrl_c() {
    echo "NOTE: Trapped CTRL-C"
    echo "Quitting now..."
    exit
}


# Print help menu
function printHelp {
    echo ""
    echo "Help Menu"
    echo ""
    echo "-l - Local port to send (Required)"
    echo "-r - Remote port to bind (Required)"
}

#### START SCRIPT

# Check the number of arguments passed in
if [ "$#" -ne 4 ]; then
    echo "$#"
    printHelp
    exit
fi

# Check that autossh binary exists
if ! command -v "autossh" &> /dev/null
then
    echo "autossh could not be found"
    echo "Please install autossh with 'apt install autossh'"
    exit
else
    cmd=$(command -v "autossh")
fi


# Set command line arguments
while getopts l:r: flag
do
    case "${flag}" in
        l) lport=${OPTARG};;
        r) rport=${OPTARG};;
    esac
done

# If -l is not provided
if [ -z "$lport" ]
then 
    echo "ERROR: -l not provided"
    printHelp
    exit
fi

# If -r is not provided
if [ -z "$rport" ]
then
    echo "ERROR: -r not provided"
    printHelp
    exit
fi


# Print connection info
echo ""
echo "Connection Info:"
echo "Local port: $lport"
echo "Remote Port: $rport"
echo "SSH Key: $sshkey"
echo ""


LOOP=1
while true
do
    echo "Creating connection: #$LOOP"
    "$cmd" -M 0 -N -o "ServerAliveInterval 15" -o "ServerAliveCountMax 3" -o "ConnectTimeout 10" -o "ExitOnForwardFailure yes" -i "$sshkey" "$USER@$IP" -R "$rport":localhost:"$lport"
    LOOP=$[LOOP+1]
    sleep 2
done
