<?php

define('MAXIMUM_SERVER_LOAD', 30);
define('MINIMUM_SERVER_MEMORY', 128000);

$isOk = true;
$errorMessage = "";

if($isOk)
{
  //check CPU
  $loads = sys_getloadavg();
  $loadShortTerm = $loads[0];
  if($loadShortTerm > MAXIMUM_SERVER_LOAD)
  {
    $isOk = false;
    $errorMessage = "Load is too high : ".$loadShortTerm.' > '.MAXIMUM_SERVER_LOAD;
  }
}

if($isOk)
{
  //check free Memory
  $freeMemoryInOctet = memory_get_usage();

  if($freeMemoryInOctet < MINIMUM_SERVER_MEMORY)
  {
    $isOk = false;
    $errorMessage = "Free memory level is too low : ".$freeMemoryInOctet.' < '.MINIMUM_SERVER_MEMORY;
  }
}




if($isOk)
{
  header('HTTP/1.1 200 OK');
  header('Content-Type: text/plain');
  header('Connection: close');

  echo "OK\n\n";
  exit(0);
}else{
  $errorMessage = "ERROR : \r\n".$errorMessage."\r\n";
  $contentLength = strlen($errorMessage);

  header('HTTP/1.1 503 Service Unavailable');
  header('Content-Type: text/plain');
  header('Connection: close');

  echo $errorMessage;
  exit(1);
}