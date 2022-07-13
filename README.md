# StorX_Multinode_Tools
## Tools for managing multiple StorX nodes



As per StorX, it is important to ensure that both the server OS and the StorX software are up to date on StorX nodes. 

In the event that nodes are not up to date, specific nodes may have their Reputation decreased. Reputation must be maintained above 10 in order to
continue being a Staker. WARNING: If your reputation is below 10, do not attempt to Claim tokens from your node or the contract will BURN your tokens
and you will lose them.

Keeping all nodes up to date takes time, especially if you have multiple nodes and are dealing with them all one-by-one. These scripts are designed
to automate and streamline the process so we can manage larger groups of nodes in an easier and more time-efficient manner.

These tools have been created for the use of myself and a few others. If you plan to use them, please take some time to read through the scripts and
understand them.

Also, please do not be afraid of any jargon. The process of using the scripts will be shown below clearly (hopefully).

---

### WHAT THE SCRIPTS DO


_set_StorX_SSH_auth.sh_

This script streamlines the process of setting up SSH key-based authentication. VPS IP addresses are read from the "ip_addresses" text file that you
will setup below. Managing multiple nodes is MUCH easier when using SSH keys to access each VPS. We need SSH key-based authentication set up in order
to use the actual "updating" scripts we're going to use.


_update_StorX_node_manual.sh_

This script updates only ONE node each time you run it. It will ask you at the beginning to enter the IP address of the VPS it should update. Having
SSH key-based authentication already setup in order to run this script is helpful but not essential.


_update_StorX_node_auto.sh_

This script sequentially updates EVERY node that has its IP address in the "ip_addresses" text file that you will setup below. SSH key-based
authentication needs to be already setup in order for this script to be useful.


_check_StorX_node_statuses.sh_

This script will sequentially check and display the status of EVERY node that has its IP address in the "ip_addresses" text file that you will setup
below. SSH key-based authentication needs to be already setup in order for this script to be useful. Once finished running, you can scroll up and down
in your terminal window to see the current status that each node is showing.

---

### ITEMS TO NOTE

* These scripts do not run directly on any of your node VPS's. You will need an additional computer (running Ubuntu 20.04) that these scripts will be
  installed on (eg. laptop, desktop, virtual machine, VPS).
* The computer you setup for these updates should be one YOU control and only YOU have access to. Using SSH key-based authentication means that this
  administration computer can connect to your nodes whenever it needs to without needing you to manually enter the password for the node VPS. This is
  by design and is how the scripts manage to run multiple commands to update each node whilst remaining unattended. As you can see, this computer must
  not be a random public computer. It must be your computer that you control with your own passwords.

---

### INITIAL SETUP

1. Logon to (or access the terminal on) the computer you will be using for administering your StorX nodes. You will need to be at the command prompt
   in the terminal in order to perform the following steps.

2. Update the system and install base packages:

```
    sudo apt update -y && sudo apt upgrade -y && sudo apt install -y git ssh && sudo apt autoremove -y
```

3. Clone the scripts repository (Note: Preserves any preexisting ip_addresses file in local git repo):

```
    cd $HOME
    mv StorX_Multinode_Tools/ip_addresses . > /dev/null 2>&1
    sudo rm -r StorX_Multinode_Tools > /dev/null 2>&1
    git clone https://github.com/s4njk4n/StorX_Multinode_Tools.git
    cd StorX_Multinode_Tools
    mv ~/ip_addresses . > /dev/null 2>&1
    chmod +x *.sh
```
4. Make sure to press ENTER after pasting the above code into the terminal


#### CUSTOMISE THE "ip_addresses" FILE

1. Open the "ip_addresses" file in nano:

```
    nano ~/StorX_Multinode_Tools/ip_addresses
```

2. On EACH LINE enter the IP address of only ONE of the nodes you wish to be accessed by the update scripts. There should be NO SPACES at the start
   or end of each line. Press ENTER at the end of each line after you finishing entering the last digit of the IP address. The exception to this is
   that when you have entered your FINAL IP address you will not press ENTER to create a new line.

3. Once all the node IP addresses have been entered, we need to exit nano and save the file:

```
    Press "CTRL+X" 
    Press "y"
    Press "ENTER"
```


#### SETUP SSH KEY-BASED AUTHENTICATION

(Note: You must have setup the "ip_addresses" file in the above section first)


##### GENERATE SSH-KEYS 

If you have already generated SSH keys earlier (if you're also using and have already installed the Plugin Multinode Tools for example), please skip this key-generation step and proceed directly to the next section below with the heading "Register SSH Keys On Nodes"

1. Create your SSH keys that will be used for authentication:

```
    ssh-keygen
```

2. You will then be asked several questions to generate the key. Just keep pressing ENTER to accept the default responses. When finished, you'll
   arrive back at your normal command prompt.


##### REGISTER SSH-KEYS ON NODES

1. Run the set_StorX_SSH_auth.sh script:

```
    cd ~/StorX_Multinode_Tools && ./set_StorX_SSH_auth.sh
```

2. If this is the first time you are accessing a specific node from your current computer, then when the script tries to access that specific
   node you will receive a message asking you "Are you sure you want to continue connecting". Type yes and press ENTER each time.

3. For each node you will also receive a request to enter the password (for the node indicated by the ip address shown in the prompt). Put in
   your password for that node and press ENTER.

4. By doing the above steps the script will sequentially access each node and copy your SSH credentials to it.

---

### TO UPDATE ALL YOUR NODES

1. First you need to know how long it takes for your SLOWEST node to reboot. For example, if most of your nodes at one provider can reboot in
   10sec, but you have some nodes at another provider that take 3min to reboot, then you need to know this rough figure as you will be asked
   for it when you run the update script.

2. Run the update script:

```
    cd ~/StorX_Multinode_Tools && ./update_StorX_node_auto.sh
```

3. You will be prompted to enter how long the script should wait to allow for your nodes to reboot. If you enter a time that is too short, then
   the update process will fail. If you enter a time that is longer than the time it takes your node VPS to reboot, this is no major problem as
   it will just mean that the update process will just take a little longer. The time you enter should just be the number of seconds to wait. 
   For example, to wait 60sec, one would just type 60 and press ENTER. Be aware that some commercial VPS providers have reboot times that are
   VERY SLOOOOOOW. If you're not sure how long it takes for yours or if you want to be on the safe side then just pick something long like
   300 seconds (ie. type 300 and press ENTER)

4. Now sit back and wait. Feel free to watch the script work or go away and do something else until it is finished. Alternately if you have some
   ridiculous number of nodes (Yes I am talking to YOU haha) then go away and leave your computer on for a few days to update all of the nodes.
   Note that while the script is running, there are several parts where it may look like nothing is happening for even a few minutes. This is
   often when the script is just waiting for a response from the VPS or from the software/StorX-network etc. Be patient and it should move on.

---

### TO UPDATE A SPECIFIC NODE

1. First you need to know roughly how long it takes to reboot the node you want to update. The script will ask you how many seconds to allow for
   the node to complete rebooting (It gets rebooted as part of the update process).

2. Run the update script for single nodes:

```
    cd ~/StorX_Multinode_Tools && ./update_StorX_node_manual.sh
```

3. When asked, enter the IP address of the node you wish to update and press ENTER.

4. You will be prompted to enter how long the script should wait to allow for your node to reboot. If you enter a time that is too short, then
   the update process will fail. If you enter a time that is longer than the time it takes your node VPS to reboot, this is no major problem as
   it will just mean that the update process will just take a little longer. The time you enter should just be the number of seconds to wait.
   For example, to wait 60sec, one would just type 60 and press ENTER. Be aware that some commercial VPS providers have reboot times that are
   VERY SLOOOOOOW. If you're not sure how long it takes for yours or if you want to be on the safe side then just pick something long like
   300 seconds (ie. type 300 and press ENTER)

5. Now sit back and wait. Feel free to watch the script work or go away and do something else until it is finished. Note that while the script is
   running, there are several parts where it may look like nothing is happening for even a few minutes. This is often when the script is just
   waiting for a response from the VPS or from the software/StorX-network etc. Be patient and it should move on.

---

### TO UPDATE ONLY THE OPERATING SYSTEM AND THEN REBOOT ALL YOUR VPS's

1. First you need to know roughly how long it takes to reboot the node you want to update. The script will ask you how many seconds to allow for
   the node to complete rebooting (It gets rebooted as part of the update process).

2. Run the OS-updating script:

```
    cd ~/StorX_Multinode_Tools && ./update_StorX_OSonly_and_reboot_auto.sh
```

3. You will be prompted to enter how long the script should wait to allow for your nodes to reboot. If you enter a time that is too short, then
   the update process will fail. If you enter a time that is longer than the time it takes your node VPS to reboot, this is no major problem as
   it will just mean that the update process will just take a little longer. The time you enter should just be the number of seconds to wait. 
   For example, to wait 60sec, one would just type 60 and press ENTER. Be aware that some commercial VPS providers have reboot times that are
   VERY SLOOOOOOW. If you're not sure how long it takes for yours or if you want to be on the safe side then just pick something long like
   300 seconds (ie. type 300 and press ENTER)

4. All of your VPS's that have their IP addresses listed in the "ip_addresses" file will now sequentially have their operating system updated followed
   by a system reboot and then a status check to show the node is online and connected to the StorX network.

---

### TO CHECK THE STATUS OF ALL YOUR NODES

1. This script will query and show the status of every node with an IP address listed in the "ip_addresses" file you setup earlier above. If not
   done yet, you will need to setup the "ip_addresses" file as per the instructions above first.

2. Run the script to check your nodes:

```
    cd ~/StorX_Multinode_Tools && ./check_StorX_node_statuses.sh
```

3. Watch while the status of each node is shown sequentially in your terminal window, or alternately go away and come back later when it is finished.
   You will be able to scroll back up the terminal window later to review them all if there are too many to watch while they are checked one-by-one.

---
