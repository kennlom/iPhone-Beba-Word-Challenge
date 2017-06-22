<?php

include("error_handling.php");

$file 			= fopen("/Users/Nguyen/Desktop/Projects/Beba/Apps/Beba Word Challenge/Support Files/LoserMessage.txt", "r") or die("Cannot open file");
$writeFile 		= fopen("/Users/Nguyen/Desktop/Projects/Beba/Apps/Beba Word Challenge/Support Files/LoserMessage.sql", "w") or die("Cannot file to write");
$arrayUsedWord 	= array();

// The order of insert will be 6 letters, 5 letters, etc...
// The order should be ordered again a-z to increase the index speed

$arrayInsert = array();

while(!feof($file))
{
	$word = fgets($file);
	$word = str_replace("\r\n", "", $word);
	$word = str_replace("\n", "", $word);

	if(isset($arrayUsedWord[$word])) continue;
	$arrayUsedWord[$word] = 1;
	
	$len = strlen($word);
	$word = str_replace("'", "''", $word);

	if($len > 0)	
		$arrayInsert[$len][] = $sql = "INSERT INTO Messages (Id,TypeId,Message) VALUES (NULL,3,'$word');";

}


foreach($arrayInsert as $arraySql)
{
	foreach($arraySql as $sql)
	fwrite($writeFile, "$sql\n");
}



fclose($writeFile);
fclose($file);


echo "done";
?>