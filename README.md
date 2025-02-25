# ArmA 3 Linux CLI Server Mod Manager

![](https://edge-prodberiffagroup.b-cdn.net/web/68747470733a2f2f656467652d70726f646265726966666167726f75702e622d63646e2e6e65742f7765622f6461797a7365727665726d616e61676572686561646c696e65676966736d616c6c2d7265766973656479656c6c6f772e676966.gif)

ArmA 3 Linux Command-Line Server Mod Manager for Linux Game Server Manager (LGSM)  

Official LGSM Website: [LinuxGSM](https://linuxgsm.com/)  
GitHub Repository: [LinuxGSM GitHub](https://github.com/GameServerManagers/LinuxGSM)

**This is an independent project for LGSM and is not affiliated with it.**

### Current Version: 1.3

#### Requirements:
- GNU Bash, version 4.1.5 or later

## Overview

**armamm** is a command-line tool designed to manage ArmA 3 mods efficiently on a Linux server running LGSM. It provides automated solutions for downloading, updating, and organizing mods, including managing `.bikey` files and scheduling updates via cron jobs.

### Features:

1. **Mod Downloading**  
   - Uses `steamcmd` to download both the server and mods.
   - Downloads mods to the Steam Workshop directory and converts filenames to lowercase.
   - Creates symbolic links for mods within the ArmA 3 server mods directory.
   - Usage:
     - Enter the Workshop ID of the desired ArmA 3 mod.
     - The script downloads and symlinks the mod inside the server directory.

2. **.bikey File Management**  
   - Requires `verifySignatures = 2` in `arma3server.server.cfg` to function properly.
   - Automates adding and removing `.bikey` files in the server’s key directory.
   - Functionality:
     - **Adding Keys:** Searches for `.bikey` files in the Workshop folder and prompts the user for installation.
     - **Removing Keys:** Identifies `.bikey` files in the server keys folder and allows selective removal.

3. **Mod Updates**  
   - Two update methods:
     1. **Manual update:** User selects specific mods to update.
     2. **Automated cron update:** Runs at a scheduled time (e.g., daily at 5 AM) to check for mod updates automatically.

4. **Mod Counting**  
   - Counts the total number of downloaded mods and `.bikey` files.

5. **Filename Lowercasing**  
   - Ensures all mods in the Steam Workshop directory have lowercase filenames for compatibility.

## Usage

### Installation

1. Download `armamm.sh` and configure the paths as needed.
2. The script functions independently of its location.
3. **Note:** Currently supports only one server per script instance.
4. Set execution permissions:
   ```bash
   chmod +x armamm.sh
   ```
5. Run the script:
   ```bash
   ./armamm.sh
   ```

### Command Reference

- **Download Mods:**
  ```bash
  ./armamm.sh dl    # Short command
  ./armamm.sh download    # Full command
  ```

- **Manage .bikey Files:**
  ```bash
  # Add Keys
  ./armamm.sh ak
  ./armamm.sh addkeys

  # Remove Keys
  ./armamm.sh rk
  ./armamm.sh removekeys
  ```

- **Update Mods:**
  ```bash
  # Manual Update
  ./armamm.sh up
  ./armamm.sh updatemods

  # Cron Job Update
  ./armamm.sh cup
  ./armamm.sh cronupdate
  ```
  Example cron entry to run daily at 8 AM:
  ```bash
  0 8 * * * /home/lgsm/arma/armamm.sh cup >> /home/lgsm/cron/arma/`date +\%y\%m\%d`_armamm.sh_cronupdate.log
  ```

- **Count Mods:**
  ```bash
  ./armamm.sh co
  ./armamm.sh count
  ```

- **Lowercase Mods:**
  ```bash
  ./armamm.sh lo
  ./armamm.sh lowercase
  ```

- **Help Menu:**
  ```bash
  ./armamm.sh h
  ./armamm.sh help
  ```

## Reporting Issues or Suggesting Improvements

If you encounter bugs or have suggestions for improvements, please submit them in the [Issues](https://github.com/fiskce/Arma3-Server-Mod-Manager-Linux/issues) section on GitHub.

---

Thank you for using **armamm**!

