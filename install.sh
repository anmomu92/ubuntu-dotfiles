#!/bin/bash
#
# Author: Antonio Moran

# TODO: Improve logs readability

BACKUP_DIR="$HOME/.backups/config"
REPO_DIR=$(dirname "$(realpath "$0")")
SCRIPTS_DIR="$HOME/.local/scripts"
LOG_DIR="$HOME/.local/log"
LOG_FILE="$LOG_DIR/ubuntu-dotfiles-$(date +%Y-%m-%d).log"

# Create dotfiles dir
if [[ ! -d "${XDG_CONFIG_HOME:="$HOME/.config"}" ]]; then
	mkdir -p $HOME/.config
fi

# Create backup dir
if [[ ! -d "$BACKUP_DIR" ]]; then
	mkdir -p "$BACKUP_DIR"
fi

# Create scripts dir
if [[ ! -d "$SCRIPTS_DIR" ]]; then
	mkdir -p "$SCRIPTS_DIR"
fi

# Create log dir
if [[ ! -d "$LOG_DIR" ]]; then
	mkdir -p "$LOG_DIR"
fi

echo "UBUNTU DOTFILES INSTALLATION SCRIPT" > $LOG_FILE
echo "-----------------------------------" >> $LOG_FILE
echo "" >> $LOG_FILE

echo ":: Proceeding to dotfiles linkage" >> $LOG_FILE
echo "::" >> $LOG_FILE
echo ":: Dotfiles to link" >> $LOG_FILE
echo "::" >> $LOG_FILE

# Look for the dotfiles
for d in $REPO_DIR/.config/*; do
	app=$(basename $d)

	echo ":: $app" >> $LOG_FILE

	# Remove symlinks or backup dotfiles
	if [[ -L $XDG_CONFIG_HOME/$app ]]; then
		echo "" >> $LOG_FILE
		echo ":: Removing $app symlink" >> $LOG_FILE
		rm $XDG_CONFIG_HOME/$app 2>> $LOG_FILE
	elif [[ -d $XDG_CONFIG_HOME/$app && ! -L $XDG_CONFIG_HOME/$app ]]; then
		echo "" >> $LOG_FILE
		echo ":: Backing up $app" >> $LOG_FILE
		rm -rf $BACKUP_DIR/$app 2>> $LOG_FILE
		mv $XDG_CONFIG_HOME/$app $BACKUP_DIR/$app 2>> $LOG_FILE
	fi

	# Create symlink
	echo "::" >> $LOG_FILE
	echo ":: Linking $app" >> $LOG_FILE
	echo "-----------------" >> $LOG_FILE
	echo "" >> $LOG_FILE
	ln -s $d $XDG_CONFIG_HOME/$app 2>> $LOG_FILE 
done

echo ":: Proceeding to scripts linkage" >> $LOG_FILE
echo "::" >> $LOG_FILE
echo ":: Scripts to link" >> $LOG_FILE
echo "::" >> $LOG_FILE

# Look for the scripts
for s in $REPO_DIR/.local/scripts/; do	
	script=$(basename $s)

	echo ":: $script" >> $LOG_FILE

	# Remove previous symlinks
	if [[ -L $SCRIPTS_DIR/$script ]]; then
		echo "" >> $LOG_FILE
		echo ":: Removing $script symlink"
		rm $SCRIPTS_DIR/$script 2>> $LOG_FILE
	fi

	# Create symlink
	echo "::" >> $LOG_FILE
	echo ":: Linking $script" >> $LOG_FILE
	echo "-----------------" >> $LOG_FILE
	echo "" >> $LOG_FILE
	ln -s $s $SCRIPTS_DIR/$script 2>> $LOG_FILE 
done

echo ":: INSTALLATION COMPLETE!"
echo ":: You can check out the log at $LOG_FILE"
