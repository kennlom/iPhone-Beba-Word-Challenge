<?php

include("error_handling.php");

$file 			= fopen("/Users/Nguyen/Desktop/Projects/Beba/Apps/Beba Word Challenge/Support Files/WordList.txt", "r") or die("Cannot open file");
$writeFile 		= fopen("/Users/Nguyen/Desktop/Projects/Beba/Apps/Beba Word Challenge/Support Files/WordList.sql", "w") or die("Cannot file to write");
$arrayUsedWord 	= array();

// The order of insert will be 6 letters, 5 letters, etc...
// The order should be ordered again a-z to increase the index speed

$arrayInsert = array();

while(!feof($file))
{
	$word = fgets($file);
	$word = str_replace("\n", "", $word);

	if(isset($arrayUsedWord[$word])) continue;
	$arrayUsedWord[$word] = 1;
	
	$len = strlen($word);

	if($len>0 && $len <= 6)
	{	
$arrayInsert[$len][] = $sql = "INSERT INTO Word (Id,GameWord) VALUES (NULL,'$word');";
	}
}

krsort($arrayInsert);

foreach($arrayInsert as $arraySql)
{
	foreach($arraySql as $sql)
	fwrite($writeFile, "$sql\n");
}



fclose($writeFile);
fclose($file);


echo "done";
?>