#!/usr/bin/php
<?php


$ch = curl_init('http://ratings.food.gov.uk/open-data/');
curl_setopt_array($ch, [
	CURLOPT_HEADER => false, 
	CURLOPT_RETURNTRANSFER => true,
	CURLOPT_FOLLOWLOCATION => true,
	CURLOPT_USERAGENT => 'Bulk XML Download (https://github.com/ylt/opendata_importers)'
]);
$page  = curl_exec($ch);

preg_match_all('/http:\/\/ratings.food.gov.uk\/OpenDataFiles\/([\w]+en-GB.xml)/', $page, $matches, PREG_SET_ORDER);

foreach($matches as list($url, $filename)) {
	$fh = fopen(__DIR__.'/xml/'.$filename, 'wb');
	curl_setopt_array($ch, [
		CURLOPT_URL => $url,
		CURLOPT_FILE => $fh
	]);
	curl_exec($ch);
	fclose($fh);
}
curl_close($ch);