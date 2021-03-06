#!/bin/bash

#title          :wp-update-plugin.sh
#description    :This script will update an individual wp plugin
#author         :Thomas Schmidt
#date           :20150507
#version        :1
#usage          :.\update-wp-plugin.sh
#notes          : Should be placed in the user directory next to the public_html.
#==============================================================================

read -p "Enter user home directory (like /home/username)" home_dir
doc_root=$home_dir/public_html
now=$(date +%Y%m%d)

#lets get the plugin details from the user
read -p "Enter the plugin directory name:" plugin_dir
read -p "Enter new plugin version number:" plugin_ver
read -p "Enter the download zip file link (this can be found by going to the wp plugin update page and right clicking the 'Download Version X.X.X' button and selecting 'Copy link address':" plugin_link

cd $home_dir

#backup the plugins backup
tar -czf $home_dir/wp-plugins-backup-$now.tar.gz $doc_root/wp-content/plugins

#get and extract the plugin
wget --no-check-certificate $plugin_link -O $home_dir/$plugin_dir.$plugin_ver.zip
unzip $home_dir/$plugin_dir.$plugin_ver.zip -d $home_dir/$plugin_dir/

#update the plugin with the files we just extraced
rm -rf $doc_root/wp-content/plugins/$plugin_dir
mv $home_dir/$plugin_dir/$plugin_dir $doc_root/wp-content/plugins/$plugin_dir

#remove the old files we dont need anymore
rm -rf $home_dir/$plugin_dir
rm $home_dir/$plugin_dir.$plugin_ver.zip

#we're all done here...
echo
echo $plugin_dir ' has been updated!'
echo 'Please check wp-admin plugins page to ensure everything is okay.'
echo
