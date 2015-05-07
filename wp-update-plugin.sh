#!/bin/bash

#title        :update-wp-plugin.sh
#description  :This script will update an individual wp plugin
#author		    :Thomas Schmidt
#date         :20150507
#version      :1    
#usage		    :.\wp-update-plugin.sh
#notes        : Should be placed in the user directory next to the public_html.
#==============================================================================

#some variables
home_dir='' #EXAMPLES: /home/yourhomedirectory or /var/www/html/
doc_root=”$home_dir/public_html” #if your document root is not public_html you will need to change it here.
now=$(date +%Y%m%d)

#lets get the plugin details from the user
read -p "Enter the plugin directory name:" plugin_dir
read -p "Enter new plugin version number:" plugin_ver
read -p "Enter the download zip file link (this can be found by going to the wp plugin update page and right clicking the 'Download Version X.X.X' button and selecting 'Copy link address':" plugin_link

#backup the plugins backup
tar -czvf $home_dir/wp-plugins-backup-$now.tar.gz $doc_root/wp-content/plugins

#get and extract the plugin
wget --no-check-certificate $plugin_link $home_dir/$plugin_dir.$plugin_ver.zip
unzip $home_dir/$plugin_dir.$plugin_ver.zip -d $home_dir/$plugin_dir/

#update the redirection plugin with the files we just extraced
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


