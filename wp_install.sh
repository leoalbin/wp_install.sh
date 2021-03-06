#!/bin/bash
# Setup Variables
 
DBNAME=mydatabase
DBUSER=databaseuser
DBPASS=dnpass
DBHOST=localhost
DBPREFIX=C8v8D2_eomGf_
 
URL=http://urlofsite.com
TITLE=SiteTitle
ADMINUSER=danielpataki
ADMINPASS=mypassword
ADMINEMAIL=myeamil@myemail.com
 
REPOPLUGINS=&amp;amp;amp;quot;amazon-s3-and-cloudfront w3-total-cache jetpack vaultpress google-sitemap-generator limit-login-attempts&amp;amp;amp;quot;
 
# Create Htaccess File With Firewall
 
cat > .htaccess << "EOF"
<ifModule mod_alias.c>
 RedirectMatch 403 /(\$|\*)/?$
 RedirectMatch 403 (?i)(<|>|:|;|\'|\s)
 RedirectMatch 403 (?i)([a-zA-Z0-9]{18})
 RedirectMatch 403 (?i)(https?|ftp|php)\:/
 RedirectMatch 403 (?i)(\"|\.|\_|\&|\&amp)$
 RedirectMatch 403 (?i)(\=\\\'|\=\\%27|/\\\'/?)\.
 RedirectMatch 403 (?i)/(author\-panel|submit\-articles)/?$
 RedirectMatch 403 (?i)/(([0-9]{5})|([0-9]{6}))\-([0-9]{10})\.(gif|jpg|png)
 RedirectMatch 403 (?i)(\,|//|\)\+|/\,/|\{0\}|\(/\(|\.\.|\+\+\+|\||\\\"\\\")
 RedirectMatch 403 (?i)/uploads/([0-9]+)/([0-9]+)/(cache|cached|wp-opt|wp-supercache)\.php
 RedirectMatch 403 (?i)\.(asp|bash|cfg|cgi|dll|exe|git|hg|ini|jsp|log|mdb|out|sql|svn|swp|tar|rar|rdf|well)
 RedirectMatch 403 (?i)/(^$|1|addlink|btn_hover|contact?|dkscsearch|dompdf|easyboard|ezooms|formvars|fotter|fpw|i|imagemanager|index1|install|iprober|legacy\-comments|join|js\-scraper|mapcms|mobiquo|phpinfo|phpspy|pingserver|playing|postgres|product|register|scraper|shell|signup|single\-default|t|sqlpatch|test|textboxes.css|thumb|timthumb|topper|tz|ucp_profile|visit|webring.docs|webshell|wp\-lenks|wp\-links|wp\-plugin|wp\-signup|wpcima|zboard|zzr)\.php
 RedirectMatch 403 (?i)/(\=|\$\&|\_mm|administrator|auth|bytest|cachedyou|cgi\-|cvs|config\.|crossdomain\.xml|dbscripts|e107|etc/passwd|function\.array\-rand|function\.parse\-url|livecalendar|localhost|makefile|muieblackcat|release\-notes|rnd|sitecore|tapatalk|wwwroot)
 RedirectMatch 403 (?i)(\$\(this\)\.attr|\&pws\=0|\&t\=|\&title\=|\%7BshopURL\%7Dimages|\_vti\_|\(null\)|$itemURL|ask/data/ask|com\_crop|document\)\.ready\(fu|echo.*kae|eval\(|fckeditor\.htm|function.parse|function\(\)|gifamp|hilton.ch|index.php\&amp\;quot|jfbswww|monstermmorpg|msnbot\.htm|netdefender/hui|phpMyAdmin/config|proc/self|skin/zero_vote|/spaw2?|text/javascript|this.options)
</ifModule>
 
# 6G:[QUERY STRINGS]
<IfModule mod_rewrite.c>
 RewriteCond %{REQUEST_URI} !^/$ [NC]
 RewriteCond %{QUERY_STRING} (mod|path|tag)= [NC,OR]
 RewriteCond %{QUERY_STRING} ([a-zA-Z0-9]{32}) [NC,OR]
 RewriteCond %{QUERY_STRING} (localhost|loopback|127\.0\.0\.1) [NC,OR]
 RewriteCond %{QUERY_STRING} (\?|\.\./|\*|:|;|<|>|'|"|\)|\[|\]|=\\\'$|%0A|%0D|%22|%27|%3C|%3E|%00|%2e%2e) [NC,OR]
 RewriteCond %{QUERY_STRING} (benchmark|boot.ini|cast|declare|drop|echo.*kae|environ|etc/passwd|execute|input_file|insert|md5|mosconfig|scanner|select|set|union|update) [NC]
 RewriteRule .* - [F,L]
</IfModule>
 
# 6G:[USER AGENTS]
<ifModule mod_setenvif.c>
 #SetEnvIfNoCase User-Agent ^$ keep_out
 SetEnvIfNoCase User-Agent (<|>|'|&lt;|%0A|%0D|%27|%3C|%3E|%00|href\s) keep_out
 SetEnvIfNoCase User-Agent (archiver|binlar|casper|checkprivacy|clshttp|cmsworldmap|comodo|curl|diavol|dotbot|email|extract|feedfinder|flicky|grab|harvest|httrack|ia_archiver|jakarta|kmccrew|libwww|loader|miner|nikto|nutch|planetwork|purebot|pycurl|python|scan|skygrid|sucker|turnit|vikspider|wget|winhttp|youda|zmeu|zune) keep_out
 <limit GET POST PUT>
  Order Allow,Deny
  Allow from all
  Deny from env=keep_out
 </limit>
</ifModule>
 
# 6G:[REFERRERS]
<IfModule mod_rewrite.c>
 RewriteCond %{HTTP_REFERER} (<|>|'|%0A|%0D|%27|%3C|%3E|%00) [NC,OR]
 RewriteCond %{HTTP_REFERER} ([a-zA-Z0-9]{32}) [NC]
 RewriteRule .* - [F,L]
</IfModule>
 
# 6G:[BAD IPS]
<Limit GET POST PUT>
 Order Allow,Deny
 Allow from all
 # uncomment/edit/repeat next line to block IPs
 # Deny from 123.456.789
</Limit>
 
# Install WordPress
wp core download;
wp core config --dbname=${DBNAME} --dbuser=${DBUSER} --dbpass=${DBPASS} --dbhost=${DBHOST} --dbprefix=${DBPREFIX} --extra-php &amp;amp;amp;lt;&amp;amp;amp;lt;PHP
define( 'AUTOSAVE_INTERVAL', 300 );
define( 'WP_POST_REVISIONS', false );
define( 'EMPTY_TRASH_DAYS', 7 );
define( 'DISALLOW_FILE_EDIT', true );
define( 'FORCE_SSL_ADMIN', true );
define( 'AWS_ACCESS_KEY_ID', 'MYAWSKEY' );
define( 'AWS_SECRET_ACCESS_KEY', 'MYAWSSECRET' );
PHP
wp db create
wp core install --url=${URL} --title=${TITLE} --admin_user=${ADMINUSER} --admin_password=${ADMINPASS} --admin_email=${ADMINEMAIL}
 
# Install Repo Plugins
wp plugin install ${REPOPLUGINS} --activate
 
# Misc Cleanup
wp post delete 1
wp plugin delete hello-dolly
wp rewrite structure "/%year%/%monthnum%/%day%/%postname%/"
wp rewrite flush
