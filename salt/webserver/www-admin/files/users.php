<?php

### AUTO MANAGED BY SALT. DO NOT EDIT ###

$usersString = file("/etc/passwd");

foreach($usersString as $line)
{
  $tmp = explode(':', $line);
  $uid = $tmp[2];
  $username = $tmp[0];
  $homedir = $tmp[5];
  if($uid >= 1000 && $username != 'damlp')
  {
    echo "\n<br />".$username.' ('.$uid.') '.$homedir;
  }
}

echo "\n";