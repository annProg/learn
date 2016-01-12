<?php
/**
 * Usage:
 * File Name: send.php
 * Author: annhe  
 * Mail: i@annhe.net
 * Created Time: 2016-01-12 10:03:50
 **/

require './config.php';

function curlGet($url) {
	global $config;
	$username = $config['cmdb']['user'];
	$password = $config['cmdb']['password'];
	$ch = curl_init();
	curl_setopt($ch, CURLOPT_URL, $url);
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
	curl_setopt($ch, CURLOPT_HTTPAUTH, CURLAUTH_BASIC);
	curl_setopt($ch, CURLOPT_USERPWD, "$username:$password");
	$data = curl_exec($ch);

	return($data);
}

function getObj($objid) {
	global $config;
	$param = "objects/$objid";
	$url = $config['cmdb']['url'] . $param;
	$data = json_decode(curlGet($url), true);
	$data = $data['objectFields'];
	$ret = array();

	foreach($data as $key=>$value) {
		foreach($value as $k=>$v) {
			$ret[$v['name']] = $v['value'];
		}
	}
	print_r($ret);
}

function getStaffList() {
	global $config;
	$param = "objectlist/by-objecttype/" . urlencode($config['cmdb']['objtype']);
	$url = $config['cmdb']['url'] . $param;
	return(curlGet($url));
}

function getStaffvalue($staff) {
	global $config;
	$param = "objectlist/by-fieldvalue/" . urlencode($staff);
	$url = $config['cmdb']['url'] . $param;
	return(curlGet($url));
}

function getStaffObj($staff) {
	$stafflist = json_decode(getStaffList());
	$valuelist = json_decode(getStaffvalue("hean"));
	$staffid = array_intersect($valuelist, $stafflist);
	foreach($staffid as $k => $v) {
		$data = getObj($v);
		if($data['staff'] == $staff) {
			return($data);
		}
	}
	return(False);
}

function sendMail($to, $msg) {

}

function sendSMS($to, $msg) {

}

function sendWechat($to, $msg) {}

function sendMsg($to, $msg, $type) {
	$typelist = explode(",", $type);
	if(in_array("sms", $typelist))
		sendSMS($to, $msg);

	if(in_array("mail", $typelist))
		sendMail($to, $msg);

	if(in_array("wechat", $typelist))
		sendWechat($to, $msg);

	if(in_array("all", $typelist))
		sendSMS($to, $msg);
		sendMail($to, $msg);
		sendWechat($to, $msg);
}

function 

//main
if(isset($argv[1]) && isset($argv[2])) {
	if(isset($argv[3])) {
		$type = $argv[3];
	} else {
		$type = "all";
	}

	$to = $argv[1];
	$msg = $argv[2];
	sendMsg($to, $msg, $type);
} else {
	die("nothing to do");
}
