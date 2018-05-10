<?php
/**
 * Usage:
 * File Name: ip.php
 * Author: annhe  
 * Mail: i@annhe.net
 * Created Time: 2018-05-11 00:05:03
 * 题目：编程从access.log中找出访问最多的前十个IP，不能使用用linux命令
 */

$log = "/tmp/access-ip.log";

function genAccessLog() {
	global $log;
	$content = '';
	for($i=0;$i<500;$i++) {
		$content .= rand(100,100) . "." . rand(95,100) . "." . rand(90,100) . "." . rand(99,100) . " somelog\n";
	}	
	file_put_contents($log, $content);
}

genAccessLog();
$ips = file_get_contents($log);
$ips = explode("\n", $ips);
$ips = array_filter($ips);

$ipCount = [];

foreach($ips as $k => $v) {
	$item = explode(" ", $v);
	if(array_key_exists($item[0], $ipCount)) {
		$ipCount[$item[0]] += 1;
	} else {
		$ipCount[$item[0]] = 1;
	}
}

$top = [];
$i = 0;
while($i<20) {
	$m = max($ipCount);
	$k = array_search($m, $ipCount);
	unset($ipCount[$k]);
	$top[$k] = $m;
	$i++;
}

print_r($top);
