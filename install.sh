#!/bin/bash
#
# Author: Antonio Moran

BACKUP_DIR="$HOME/.backups/config"
REPO_DIR=$(dirname "$(realpath "$0")")
SCRIPTS_DIR="$HOME/.local/scripts"
LOG_DIR="$HOME/.local/log"
LOG_FILE="$LOG_DIR/ubuntu-dotfiles-$(date +%Y-%m-%d).log"
TIME_1=0.1
TIME_2=0.5
TIME_3=1

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

echo "UBUNTU DOTFILES INSTALLATION SCRIPT" | tee $LOG_FILE
echo "-----------------------------------" | tee -a $LOG_FILE
echo "" | tee -a $LOG_FILE

sleep $TIME_1

echo ":: Proceeding to dotfiles linkage" | tee -a $LOG_FILE
echo "" | tee -a $LOG_FILE

sleep $TIME_3

# Look for the dotfiles
for d in $REPO_DIR/.config/*; do
	app=$(basename $d)

	echo "$app" | tee -a $LOG_FILE

	sleep $TIME_2

	# Remove symlinks or backup dotfiles
	if [[ -L $XDG_CONFIG_HOME/$app ]]; then
		echo "  Removing $app symlink" | tee -a $LOG_FILE
		rm $XDG_CONFIG_HOME/$app 2>> $LOG_FILE
	elif [[ -d $XDG_CONFIG_HOME/$app && ! -L $XDG_CONFIG_HOME/$app ]]; then
		echo "  Backing up $app" | tee -a $LOG_FILE
		rm -rf $BACKUP_DIR/$app 2>> $LOG_FILE
		mv $XDG_CONFIG_HOME/$app $BACKUP_DIR/$app 2>> $LOG_FILE
	fi

	# Create symlink
	echo "  Linking $app" | tee -a $LOG_FILE
	echo "" | tee -a $LOG_FILE
	ln -s $d $XDG_CONFIG_HOME/$app 2>> $LOG_FILE 
done

echo ":: Proceeding to scripts linkage" | tee -a $LOG_FILE
echo "" | tee -a $LOG_FILE

sleep $TIME_3

# Look for the scripts
for s in $REPO_DIR/.local/scripts/*; do	
	script=$(basename $s)

	echo "$script" | tee -a $LOG_FILE

	sleep $TIME_2

	# Remove previous symlinks
	if [[ -L $SCRIPTS_DIR/$script ]]; then
		echo "  Removing $script symlink" | tee -a $LOG_FILE
		rm $SCRIPTS_DIR/$script 2>> $LOG_FILE
	elif [[ -f $SCRIPTS_DIR/$script && ! -L $SCRIPTS_DIR/$script ]]; then
		echo "  Backing up $app" | tee -a $LOG_FILE
		rm $BACKUP_DIR/$script 2>> $LOG_FILE
		mv $SCRIPTS_DIR/$script $BACKUP_DIR/$script 2>> $LOG_FILE
	fi

	# Create symlink
	echo "  Linking $script" | tee -a $LOG_FILE
	echo "" | tee -a $LOG_FILE
	ln -s $s $SCRIPTS_DIR/$script 2>> $LOG_FILE 
done

sleep $TIME_3

echo ":: Proceeding to enable the gnome-terminal-theme-watcher service" | tee -a $LOG_FILE
echo "" | tee -a $LOG_FILE

sudo systemctl daemon-reload

if ! systemctl --user is-enabled --quiet gnome-terminal-theme-watcher.service; then
	sudo systemctl --user enable gnome-terminal-theme-watcher
elif ! systemctl --user is-active --quiet gnome-terminal-theme-watcher.service; then
	sudo systemctl --user start gnome-terminal-theme-watcher
else
	echo "gnome-terminal-theme-watcher.service is already enabled and active." | tee -a $LOG_FILE
fi

sleep $TIME_3

echo ""
echo ":: INSTALLATION COMPLETE!"
echo ":: You can check out the log at $LOG_FILE"
