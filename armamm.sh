#!/bin/bash

###=======================================================================================###
###     Author:  @fiskce / @Deadalus3010	                        Date: 23/1/2025   ###                        
###=======================================================================================###                ______________ ___________
###                                                                                       ###               / __/  _/ __/ //_/ ___/ __/
###                               Arma 3 Linux Server Manager                             ###              / _/_/ /_\ \/ ,< / /__/ _/  
###                 Purpose: 	Made for Linux Game Server Manager (lgsm)                 ###             /_/ /___/___/_/|_|\___/___/                         
### 	            Github:		https://github.com/GameServerManagers             ### 
###                                                                                       ###                                                                       
###=======================================================================================###


#	PLEASE EDIT THESE VALUES
#	Currently only possible with one server, so create the script for each server individually
#	Do not forget to change the User


#	ArmA 3 Workshop Content Directory
workshoppath='/home/lgsm/.steam/steamapps/workshop/content/107410/'

#	ArmA 3 Mods Directory
modpath='/home/lgsm/arma/serverfiles/mods'

#	ArmA 3 Keys Directory
keypath='/home/lgsm/arma/serverfiles/keys'

#	lgsm SteamCMD path & game gameid
steamcmd='/home/lgsm/.steam/steamcmd/steamcmd.sh'
gameid='107410'	# ArmA 3











###################################################################################################################################################################
#                                                                                                                                                                 
#	DONT EDIT ANYTHING PAST THIS LINE                                                                                                                         
#	(Unless you know what you are doing)                                                                                                                          
#                                                                                                                                                                 
###################################################################################################################################################################










#	Lowercases all mods
function lowercase() {

	#creating empty strings for later use
	local y="" workshop2=""

	echo -e "   we lowercase everything inside your workshop path..."

	#################
#	Experimental
#	Finds every uppercase folder and file
#	and writes them into an array
#	In theory more efficient, because it only searches directly for uppercase things
#	And doesnt checks every file

#	readarray -d '' uppercase_array_list < <(find $workshoppath -type d,f -name "[[:upper:]]*" -print0)
	
#	It wasnt further developed, because it saved the full path into the array
#	This means, when the folder was lowercased before the files / folders inside it
#	The files / folders wouldnt be found, because the parent folder is lowercased and was saved uppercased in the array
#	Which means, to use this method, I need to sort the array first
#	I will currently use the method down below, even when its not the best way
#	When this script fully works as intended, I will start optimizing it, so I dont waste CPU Cycles
#	(Even when this is an small script)
	#################

	#Checks if it finds any uppercase directory or file
	if  test -z "$(find $workshoppath -type d,f -name "[[:upper:]]*")"
	then
		echo -e "   ...already lowercase...\n"
	else
		echo "   ...working..."
		#
		#	The 'i<=3' is for the folder depth
		#	ArmA 3 has its own mod folder layout, so the depth wont ever change
		#	Lowercase code from: 
		#	https://docs.linuxgsm.com/game-servers/arma-3
		#
		#	Slightly modified
		#
		for ((i=1;i<=3;i++))
		do
			for x in $(find $workshoppath -maxdepth $i | grep [A-Z])
			do
				#${stringZ:NUMBER} --> "Removes" the characters from the first index |  #${#string} --> gets the number of characters the string has
				#Here we "substract" the path from the mod
				#After this operation, y will contain only the mod folder structure and the capital letter found file / folder
				#This way, we dont lowercase anything that is inside the workshop path 
				# -> linux is case sensitive, which means, that the script cant find an folder which is e.g. normally uppercase
				#We only lowercase the modpath itself
				y="${x:${#workshoppath}}"
			
				#Here we lowercase the mod files / folders
				declare -l y

				#Here we create the new path + lowercased mod
				#Now we have solved one big problem:
				#We did not lowercase the path to the mod itself
				#We only lowercased the mod
				workshop2=$workshoppath$y

				#Now we lowercase the found mods without changing the modpath
				mv $x $workshop2
			done
		done

		echo -e "\n\n"

		#
		#	Here we will check if there are still files/folders in capital letters
		#	We also inform the user which files / folders are uppercase
		#	So he can manually lowercase them
		#
		readarray -d '' stilllowercase_ar < <(find $workshoppath -name "[[:upper:]]*" -print0)

		if [[ ${stilllowercase_ar[@]} ]]
		then

        	typeset -i i=0 max=${#stilllowercase_ar[*]}

			while (( i < max ))
			do
				echo "   ${stilllowercase_ar[$i]}"
				i=i+1
			done

			echo -e "\n   $(tput setaf 1)ERROR:$(tput setaf 7) The script couldnt lowercase the files / folders above, please manually lowercase them\n"

			typeset -i i=0 max=${#stilllowercase_ar[*]}

				echo -e "   Do you want to remove them?\n   Answer with 1 (all) or 2 (select them by yourself) or 3 (no)\n"
			unset yn
			read -p "   ?:" yn

			#Is the input either a 1 or 2?
			if [[ ! $yn =~ ^[1-3]+$ ]]
			then
				#Warns the user that his input arent digits (only once)
				echo -e "   $(tput setaf 1)ERROR:$(tput setaf 7) Please only use the digits 1 or 2!\n"
				while [[ ! "$yn" =~ ^[1-3]+$ ]]
				do
					read -p "   ?:" yn
				done

			elif [[  "$yn" == "1" ]]
			then

				while (( i < max ))
				do

					echo -e "   $(tput setaf 2)File/Folder $i: ${stilllowercase_ar[$i]} $(tput setaf 3)was removed $(tput setaf 7)"
					rm -r "${stilllowercase_ar[$i]}"

					i=i+1
				done

			elif [[  "$yn" == "2" ]]
			then

			    while (( i < max ))
				do
					echo -e "   Number: $i | $(tput setaf 2)File/Folder: ${stilllowercase_ar[i]}$(tput setaf 7)"
					i=i+1
				done

				echo -e "   What would you like to remove?\n   ?:"

				#Here we can read multiple variables with spaces inbetween the inputs
				#I cant output anything when using read in an "indexed mode", this is why there is an"   ?:" above
				unset readinput_ar
				read -ra readinput_ar

				#Now we only remove the ones you mentioned above
				for i in "${readinput_ar[@]}"
				do
					echo -e "\n   $(tput setaf 3)Index: $i | File/Folder: ${stilllowercase_ar[i]} | Was Removed $(tput setaf 7)"

					rm -r "${stilllowercase_ar[$i]}"
				done

			elif [[ "$yn" == "3" ]]
			then

				echo -e "   skipped"

			fi

    	fi
		
		echo -e "   ...everything should now be lowercase...\n"
	fi
}

#
#	Counts all downloaded mod folders and counts the bikeys files 
#	(Just to display stuff)
#
function countmods() {
	#Counts all mods
    echo -e "   Found $(ls $workshoppath | wc -l) Mods and $(find $workshoppath -name '*.bikey' | wc -l) '.bikeys' \n"

}

#
#	Read user input for workshop mod id's
#
function readmods() {

	local -n workshopid=$1
    typeset -i modid=0

	echo -e "\n   Please enter the workshop content id..."
	echo -e "   https://steamcommunity.com/sharedfiles/filedetails/?l=english&id="$(tput setaf 2)"450814997"$(tput setaf 7)"(cba3 example)"
	echo -e "   when you are finished, type '1'\n"

	#We fill the "workshop" array with mod IDs which are input by the user

	while [ $modid != 1 ]
	do
		unset modid
		read -p "   id:" modid

		#Is the modid NOT a digit?
		if [[ ! $modid =~ ^[0-9]+$ ]]
		then
			#Warns the user that his input arent digits (only once)
			echo -ne "   $(tput setaf 1)ERROR:$(tput setaf 7) Please only use digits\n"
			while [[ ! "$modid" =~ ^[0-9]+$ ]]
			do
				read -p "   id:" modid
			done
		fi

		workshopid+=($modid)
	done

    #Deleting the exit call (last index) from the array
	#Best solution I had
    unset workshopid[${#workshopid[*]}-1]

}

#	
#	Downloads Workshop Content
#	
function dlworkshop() {

	local workshop

	#Launches the readmods() method
	#Grabs the workshopid array from readmods()
    readmods workshop

	echo -e "\n   $(tput setaf 6)Now we are going download your mods..."
	echo -e "   $(tput setaf 5)and afterwards we check if some files / folders are uppercase...$(tput setaf 7)"

	typeset -i i=0 max=${#workshop[*]} j=${#workshop[*]}-1

	while (( i < max ))
	do
		#We gonna display the current mod and how many are left
		echo -e "\n\n   $(tput setaf 2)mod $i: ${workshop[$i]} $(tput setaf 7)| $(tput setaf 3)$j mod(s) left \n\n$(tput setaf 7)"

		#Here we download the workshop mods
		"${steamcmd}" +login anonymous +workshop_download_item "${gameid}" "${workshop[$i]}" validate +quit

        #Symlink mods into $modpath directory
        #This saves huge amount of disk space
        #Because, for each arma server you use, you only need to have a link to the modfiles inside the /mods directory
        #And no mod files, e.g. 5 servers use the same mod folder, instead of having 5 different unique mod folders
        ln -s "$workshoppath${workshop[$i]}" "$modpath"

		#Now we add one, so we download the next item
		let i+=1
		#Here we decrement the value to display the amount of mods that are left to download
		let j-=1

		#Linebreak, because sometimes steamcmd and the command prompt in linux are in the same line
		echo -e "\n"

	done

	#Now we run the lowercase function
	lowercase
}

#	
#	Searches all .bikey files in the steam workshop directory
#	and asks each one if the user wants to activate it
#
function addkeys() {

	echo -e "\n   Which .bikeys do you want to add?\n   Only needed when you set \"verifySignatures = 2\" in \"arma3server.server.cfg\"\n   Answer with 1 (yes) / 2 (no)\n"

    countmods

	#We check the workshop path and only write the workshop mods inside this array
	readarray -d '' wppdir_ar < <(find $workshoppath -mindepth 1 -maxdepth 1 -type d -print0)
	typeset -i j=0 maxj=${#wppdir_ar[*]}

	#
	#	Now we loop through the workshop paths array
	#	So that the .bikey and mod/meta.cpp files belong to the same mod
	#
	while (( j < maxj ))
	do
		#We write all the .bikey paths in the bikey_ar array
		bikey_ar+=($(find ${wppdir_ar[$j]} -name '*.bikey'))

		#Here we try to make it easier for you, because we not only display the .bikey, but also the mods name
		#And how do we get the name? First, we need to get the path to the mod file
		modname_ar+=($(find ${wppdir_ar[$j]} -name "mod.cpp" -o -name "meta.cpp" | head -n 1))

		j=j+1
	done

	typeset -i i=0 max=${#bikey_ar[*]}

	while (( i < max ))
	do															                               #To get the Modname, we grep the "name" string, we also limit grep to "first found"
		echo -e "   $(tput setaf 2)Bikey $i: ${bikey_ar[$i]:${#workshoppath}}$(tput setaf 7) | $(tput setaf 3)$(grep -m 1 'name' ${modname_ar[$i]} | awk '{ print substr( $0, 9 )}' | awk '{ print substr( $0, 1, length($0)-3 )}')$(tput setaf 7)"

		unset yn
		read -p "   ?:" yn

		#Is the input either a 1 or 2?
		if [[ ! $yn =~ ^[1-2]+$ ]]
		then
			#Warns the user that his input arent digits (only once)
			echo -e "   $(tput setaf 1)ERROR:$(tput setaf 7) Please only use the digits 1 or 2!\n" 
			while [[ ! "$yn" =~ ^[1-2]+$ ]]
			do
				read -p "   ?:" yn
			done
		elif [[  "$yn" == "1" ]]
		then

            cp -u ${bikey_ar[$i]} $keypath #-u -> copy only when the SOURCE file is newer than the destination file or when the destination file is missing

			#Here we catch the cp response, to check if errors occured
			if [ $? -ne 0 ]
			then
				echo -e "   $(tput setaf 1)ERROR:$(tput setaf 7) Couldnt copy the ${bikey_ar[$i]} file!"
			fi

		fi

		i=i+1
	done
}

#	
#	Searches all .bikey files in the server directory
#	and asks each one if the user wants to deactivate it
#
function removekeys() {

    echo -e "\n   Which .bikeys do you want to remove?\n   Only needed when you set \"verifySignatures = 2\" in \"arma3server.server.cfg\"\n   $(tput setaf 1)DO NOT$(tput setaf 7) remove the a3.bikey (if there is any)   \n   Answer with 1 (yes = removes the bikey from the keys directory) / 2 (no)\n"

	#We write all the .bikey paths in the kbikey_ar array | k = keys direcotory
	#We also exclude the "a3.bikey", this is an important server file, without it, no one can join your server
	readarray -d '' kbikey_ar < <(find $keypath -name '*.bikey' ! -name "a3.bikey" -print0)	#! -path 'a3.*'  ! -name "a3.bikey"
	typeset -i i=0 max=${#kbikey_ar[*]}

	echo -e "   Found: $max *.bikey files in $keypath\n"

	while (( i < max ))
	do

		unset yn

		#Here we try to find the .bikey in the workshoppath directory, so we can find the mod or meta.cpp to get the modname
		mod_ar=($(find $workshoppath -name ${kbikey_ar[i]:${#keypath}+1} | head -n 1))

		#This isnt the best solution to go back 2 directories, but I didnt found any better one
		dirname=($(dirname "$(dirname "$mod_ar")"))

		#Here we get the actual modname of the .bikey
		modname_ar=($(find $dirname -name "mod.cpp" -o -name "meta.cpp" | head -n 1))

		echo -e "   $(tput setaf 2)Bikey $i: ${kbikey_ar[$i]:${#keypath}}$(tput setaf 7) | $(tput setaf 3)$(grep -m 1 'name' $modname_ar | awk '{ print substr( $0, 9 )}' | awk '{ print substr( $0, 1, length($0)-3 )}')$(tput setaf 7)" #We limit grep to "first found"

		read -p "   ?:" yn

		#Is the input either a 1 or 2?
		if [[ ! $yn =~ ^[1-2]+$ ]]
		then
			#Warns the user that his input arent digits (only once)
			echo -e "   $(tput setaf 1)ERROR:$(tput setaf 7) Please only use the digits 1 or 2!\n" 
			while [[ ! "$yn" =~ ^[1-2]+$ ]]
			do
				read -p "   ?:" yn
			done
		elif [[  "$yn" == "1" ]]
		then
            rm ${kbikey_ar[$i]} #Here we delete the .bikey file, bye bye, you wont be missed :) (hopefully)
		fi
		i+=1
	done
}

#	
#	Updates mods
#
function updatemods() {

	echo -e "\n   Which mods do you want to update?\n   Do it like so: 0 3 5 2 4 1\n   The order is not important, but dont forget the spaces! Confirm with [enter]\n"

	#We check the workshop path and only write the workshop mods inside this array
	readarray -d '' wppdir_ar < <(find $workshoppath -mindepth 1 -maxdepth 1 -type d -print0)
	typeset -i i=0 max=${#wppdir_ar[*]}

	declare -a readinput_ar

	while (( i < max ))
	do
		modname_ar+=($(find ${wppdir_ar[$i]} -name "mod.cpp" -o -name "meta.cpp" | head -n 1))
		echo -e "Number: $i | $(tput setaf 2)Mod: ${wppdir_ar[i]:${#workshoppath}}$(tput setaf 7) | $(tput setaf 3)$(grep -m 1 'name' ${modname_ar[$i]})$(tput setaf 7)"
		i=i+1
	done

	echo -e "   What would you like to update?\n   ?:"

	#Here we can read multiple variables with spaces inbetween the inputs
	#I cant output anything when using read in an "indexed mode", this is why there is an"   ?:" above
	read -ra readinput_ar

	#Now we only update the ones you mentioned above
	for i in "${readinput_ar[@]}"
	do
		echo -e "\n\n$(tput setaf 2)Index: $i | Mod: ${wppdir_ar[i]:${#workshoppath}}$(tput setaf 7) | $(tput setaf 3)$(grep -m 1 'name' ${modname_ar[$i]})\n\n\n$(tput setaf 7)"

		"${steamcmd}" +login anonymous +workshop_download_item "${gameid}" ${wppdir_ar[i]:${#workshoppath}} validate +quit
	done
}

#
#	Cron Updates
#	This function can get called for cron
#	So the scripts checks all mods if they got an update
#	E.g. each day in the morning
#
function cronupdatemods() {

	#We check the workshop path and only write the workshop mods inside this array
	readarray -d '' wppdir_ar < <(find $workshoppath -mindepth 1 -maxdepth 1 -type d -print0)
	typeset -i j=0 maxj=${#wppdir_ar[*]}

	countmods

	#
	#	Now we loop through the workshop paths array
	#	And download / update all your mods
	#
	while (( j < maxj ))
	do
		modname_ar+=($(find ${wppdir_ar[$j]} -name "mod.cpp" -o -name "meta.cpp" | head -n 1))

		echo -e "\n\nNumber: $j | Mod: ${wppdir_ar[j]:${#workshoppath}} $(grep -m 1 'name' ${modname_ar[$j]})\n\n\n"

		"${steamcmd}" +login anonymous +workshop_download_item "${gameid}" ${wppdir_ar[j]:${#workshoppath}} validate +quit

		j=j+1
	done
}

#	
#	Main
#	
main() {

	echo -e "\n ArmA 3 ez Mod Manager -- v1.3"

	#
	#	ArmA Mod Manager Main Menu
	#

	case "$1" in
		dl|download)    echo -e "\n   workshop download... \n" 
						dlworkshop 
						;;

		co|count)   	echo -e "\n   counting mods... \n" 
						countmods 
						;;

		ak|addkeys) 	echo -e "\n   finding bikeys... \n"
						addkeys 
						;;

		rk|removekeys) 		echo -e "\n   finding bikeys... \n" 
						removekeys 
						;;

		up|update)   	echo -e "\n   update mods... \n" 
						updatemods
						;;
		cup|cronupdate)   	echo -e "\n   update mods... \n" 
						cronupdatemods 
						;;

		lo|lowercase)   echo -e "\n   lowercase mods... \n" 
						lowercase 
						;;

		h|help|*)    	echo -e "
   h|help\t  - Shows this help text, check the github page for more informations
   dl|download\t  - Download Mods
   ak|addkeys\t  - Prompts the user for each one .bikey file found inside the workshop directory, if he wants to add it to the server/keys directory
   rk|removekeys  - Prompts the user for each one .bikey file found inside the server directory, if he wants to remove it from the server/keys directory
   co|count\t  - Shows the amount of mods & bikey files
   up|update\t  - Prompts the user for each Mod it finds, if he wants to update it
   cup|cronupdate - updates all Mods it finds, without any prompt, ideal for using with cron
   lo|lowercase\t  - Lowercases all mods\n" 
						;;
	esac


	echo "Okay bye"

}

#	Launches the main method
main "$@"
