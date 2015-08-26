<?php
/**
 * Usage:
 * File Name: count_url_sogou.php
 * Author: annhe  
 * Mail: i@annhe.net
 * Created Time: 2015-08-27 01:11:25
 **/


$url = array();
for($i=1;$i<$argc;$i++) {
	$filename = $argv[$i];
	
	if(file_exists($filename)) {
		$arr = file($filename);
		$n_arr[$filename] = array();
		foreach($arr as $k => $v) {
			$tmp = explode(" ", $v);
			if(array_key_exists('1', $tmp)) {
				$n_arr[$filename]["$tmp[0]"] = trim($tmp[1]);
				array_push($url, $tmp[0]);
			}
		}
	}
}

$url = array_unique($url);
print_r($url);

$count = array();
foreach($url as $k => $v) {
	$sum = 0;
	$location = array();
	for($i=1;$i<$argc;$i++) {
		$filename = $argv[$i];
		if(array_key_exists("$v", $n_arr[$filename])) {
			$sum += $n_arr[$filename][$v];
			array_push($location, $filename);
		}
	}
	$str_location = implode(",", $location);
	$tmp = array('url' => $v, 'count' => $sum, 'location' => $str_location);
	array_push($count, $tmp);
}

print_r($count);
