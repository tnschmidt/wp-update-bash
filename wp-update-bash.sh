#!/bin/bash

#title           	: update-wp.sh
#description   		: This script will update wordpress version to latest
#author		        : Thomas Schmidt
#date          		: 20150507
#version         	: 1    
#usage		        :.\wp-update-bash.sh
#notes           	: Should be placed in the user home directory next to the public_html
#==============================================================================

#some variables
wp_admin_url='' #EXAMPLE http://www.your-wp-site.com/wp-login.php
home_dir='' #EXAMPLE /home/your-user-home
doc_root="$home_dir/public_html" #if your document root is not public html you will need to change this

#get date for today to append to file names
now=$(date +%Y%m%d)

cd $home_dir

#backup the blog
tar -czf $home_dir/blog-backup-$now.tar.gz $doc_root

#backup db -- ENTER YOUR WP DB DETAILS HERE
db_name=`cat $doc_root/wp-config.php | grep DB_NAME | cut -d \' -f 4`
db_user=`cat $doc_root/wp-config.php | grep DB_USER | cut -d \' -f 4`
db_pass=`cat $doc_root/wp-config.php | grep DB_PASSWORD | cut -d \' -f 4`
db_host='localhost'

mysqldump --user=$db_user --password=$db_pass --host=$db_host $db_name > $home_dir/$db_name-db-backup-$now.sql

#lets get the latest wp-version
wget http://wordpress.org/latest.tar.gz $rohome_dirot_dir/latest.tar.gz

#lets extract the wordpress latest update files
mkdir $home_dir/wordpress
tar -xzf $home_dir/latest.tar.gz

#remove old wp-admin and wp-includes directory
rm -rf $doc_root/wp-admin
rm -rf $doc_root/wp-includes

#replace wp-admin and wp-includes with what we just extracted
mv $root_dir/wordpress/wp-admin $doc_root/wp-admin
mv $root_dir/wordpress/wp-includes $doc_root/wp-includes

#copy in the new wp-content base files
/bin/cp $home_dir/wordpress/wp-content/* $doc_root/wp-content/
/bin/cp $home_dir/wordpress/wp-content/themes/* $doc_root/wp-content/themes/
/bin/cp $home_dir/wordpress/wp-content/plugins/* $doc_root/wp-content/plugins/

#remove the wp-content directory in our new version as we dont want to move in the
rm -r $root_dir/wordpress/wp-content

#lets move all the wordpress base files now into our doc root
mv $root_dir/wordpress/* $doc_root/

#now we can remove the wordpress directory that was holding our extracted new version of wordpress
rm -r $root_dir/wordpress

#remove latest.tar.gz file
rm $root_dir/latest.tar.gz

echo
echo '************************************************'
echo '************************************************'
echo 'IMPORTANT: Please log in to wp-admin at '$wp_admin_url' to see if a database update is required and nothing broke!'
echo '************************************************'
echo '************************************************'
echo


