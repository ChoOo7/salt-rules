<?php

header("X-Robots-Tag: noindex, nofollow");
header("Cache-Control: no-cache");
header($_SERVER["SERVER_PROTOCOL"]." 404 Not Found");


echo "Default VHOST <br/>\n";
echo "<br/>\n";
echo "<br/>\n";
echo "ServerName : [".$_SERVER["SERVER_NAME"]."]<br/>\n";
echo "Hostname : [".gethostname()."]<br/>\n";
echo "Port : [".$_SERVER["SERVER_PORT"]."]<br/>\n";

