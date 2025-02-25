Arma3-Server-Mod-Manager-Linux

Arma 3 Linux Command-Line Server Mod Manager for Linux Game Server Manager (LGSM)

Official LGSM Website: LinuxGSMGitHub Repository: LinuxGSM GitHub

This is an independent project for LGSM and is not affiliated with it.

Current Version: 1.3

Requirements:

GNU Bash, version 4.1.5 or later

Overview

armamm is a command-line tool designed to manage ArmA 3 mods efficiently on a Linux server running LGSM. It provides automated solutions for downloading, updating, and organizing mods, including managing .bikey files and scheduling updates via cron jobs.

Features:

Mod Downloading

Uses steamcmd to download both the server and mods.

Downloads mods to the Steam Workshop directory and converts filenames to lowercase.

Creates symbolic links for mods within the ArmA 3 server mods directory.

Usage:

Enter the Workshop ID of the desired ArmA 3 mod.

The script downloads and symlinks the mod inside the server directory.

.bikey File Management

Requires verifySignatures = 2 in arma3server.server.cfg to function properly.

Automates adding and removing .bikey files in the server’s key directory.

Functionality:

Adding Keys: Searches for .bikey files in the Workshop folder and prompts the user for installation.

Removing Keys: Identifies .bikey files in the server keys folder and allows selective removal.

Mod Updates

Two update methods:

Manual update: User selects specific mods to update.

Automated cron update: Runs at a scheduled time (e.g., daily at 5 AM) to check for mod updates automatically.

Mod Counting

Counts the total number of downloaded mods and .bikey files.

Filename Lowercasing

Ensures all mods in the Steam Workshop directory have lowercase filenames for compatibility.

Usage

Installation

Download armamm.sh and configure the paths as needed.

The script functions independently of its location.

Note: Currently supports only one server per script instance.

Set execution permissions:

chmod +x armamm.sh

Run the script:

./armamm.sh

Command Reference

Download Mods:

./armamm.sh dl    # Short command
./armamm.sh download    # Full command

Manage .bikey Files:

# Add Keys
./armamm.sh ak
./armamm.sh addkeys

# Remove Keys
./armamm.sh rk
./armamm.sh removekeys

Update Mods:

# Manual Update
./armamm.sh up
./armamm.sh updatemods

# Cron Job Update
./armamm.sh cup
./armamm.sh cronupdate

Example cron entry to run daily at 8 AM:

0 8 * * * /home/lgsm/arma/armamm.sh cup >> /home/lgsm/cron/arma/`date +\%y\%m\%d`_armamm.sh_cronupdate.log

Count Mods:

./armamm.sh co
./armamm.sh count

Lowercase Mods:

./armamm.sh lo
./armamm.sh lowercase

Help Menu:

./armamm.sh h
./armamm.sh help

Reporting Issues or Suggesting Improvements

If you encounter bugs or have suggestions for improvements, please submit them in the Issues section on GitHub.

Thank you for using armamm!
