# revTunnel
A shell script to automatically create a reverse tunnel using autossh for portforwarding.

### Installation

Clone the project and then install dependencies:
```
apt install autossh
```  

### Further setup:
* Create a user on the jump box 
```
sudo useradd -s /bin/true -m sshtunuser
mkdir /home/sshtunuser/.ssh
```

* Create a public/private key pair for the user
```
ssh-keygen
sudo chown -R sshtunuser:sshtunuser ~sshtunuser/.ssh
sudo chmod 700 ~sshtunuser/.ssh
sudo chmod 600 ~sshtunuser/.ssh/authorized_keys
```

* The private key, `id_rsa` should be on the same machine as the tunnel.sh script. The public key `id_rsa.pub` should be added to the `authorized_keys` on the jump box
* On the jump box, modify the `/etc/ssh/sshd_config`:
```
Match User sshtunuser
	GatewayPorts yes
	ForceCommand /bin/false
	ClientAliveInterval 30
	ClientAliveCountMax 3
```

* Change the variables: `IP`, `USER`, and `sshkey` at the top of the tunnel.sh script.

## Help menu
```
./tunnel.sh

Help Menu

-l - Local port to send (Required)
-r - Remote port to bind (Required)

Example: ./tunnel.sh -l 80 -r 9001
```

## Usage

Run the shell script with the required options:
```
./tunnel.sh -l 80 -r 9001
```
