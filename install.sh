#!/bin/bash
#
# Author: Antonio Moran

BACKUP_DIR="$HOME/.backups/config"
REPO_DIR=$(dirname "$(realpath "$0")")
SCRIPTS_DIR="$HOME/.local/scripts"

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

# Look for the dotfiles
for d in $REPO_DIR/.config/*; do
	app=$(basename $d)

	# Remove symlinks or backup dotfiles
	if [[ -L $XDG_CONFIG_HOME/$app ]]; then
		echo ""
		echo ":: Removing $app symlink"
		rm $XDG_CONFIG_HOME/$app
	elif [[ -d $XDG_CONFIG_HOME/$app && ! -L $XDG_CONFIG_HOME/$app ]]; then
		echo ""
		echo ":: Backing up $app"
		rm -rf $BACKUP_DIR/$app
		mv $XDG_CONFIG_HOME/$app $BACKUP_DIR/$app
	fi

	# Create symlink
	echo "::"
	echo ":: Linking $app"
	echo "-----------------"
	echo ""
	ln -s $d $XDG_CONFIG_HOME/$app 
done

# Look for the scripts
for s in $REPO_DIR/.local/scripts/; do	
	script=$(basename $s)

	# Remove previous symlinks
	if [[ -L $SCRIPTS_DIR/$script ]]; then
		echo ""
		echo ":: Removing $script symlink"
		rm $SCRIPTS_DIR/$script
	fi

	# Create symlink
	echo "::"
	echo ":: Linking $script"
	echo "-----------------"
	echo ""
	ln -s $s $SCRIPTS_DIR/$script 
done
