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

function curlPost($url, $param) {
	$ch = curl_init();
	curl_setopt($ch, CURLOPT_URL, $url);
	curl_setopt($ch, CURLOPT_POST, 1);
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
	curl_setopt($ch, CURLOPT_POSTFIELDS, $param);
	
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
	return($ret);
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
	$valuelist = json_decode(getStaffvalue($staff));
	$staffid = array_intersect($valuelist, $stafflist);
	foreach($staffid as $k => $v) {
		$data = getObj($v);
		if($data['staff'] == $staff) {
			return($data);
		}
	}
	return(False);
}

function getToList($to) {
	$tos = explode(",", $to);
	$tos = array_unique($tos);
	$tolist = array();
	$tolist['sms'] = array();
	$tolist['mail'] = array();
	$tolist['wechat'] = array();
	$tolist['failed'] = array();

	foreach($tos as $k=>$v) {
		$t1 = microtime(true);
		$staff = getStaffObj($v);
		$t2 = microtime(true);
	//	echo $v . '耗时'.round($t2-$t1,3)."秒\n";
		if(!$staff) {
			array_push($tolist['failed'], $v);
			break;
		}
		array_push($tolist['mail'], $staff['email']);	
		array_push($tolist['sms'], $staff['phone']);	
		array_push($tolist['wechat'], $staff['phone']);	
	}
	foreach($tolist as $k=>$v) {
		$tolist[$k] = implode(",", $v);
	}
	return($tolist);
}

function sendMail($to, $sub, $msg) {
	global $config;
	$tolist = $to['mail'];
	$cmd = $config['mail']['api'];
	$data = exec("$cmd $tolist $sub $msg", $out, $ret);
	return($ret);
}

function sendSMS($to, $msg) {
	global $config;
	$tolist = $to['sms'];

	$param = array();
	$param['user'] = $config['sms']['user'];
	$param['passwd'] = $config['sms']['passwd'];
	$param['phone'] = $tolist;
	$param['msg'] = $msg;

	$param = http_build_query($param);

	$data = curlPost($config['sms']['api'], $param);
	
	return($data);

}

function sendWechat($to, $msg) {

}

function sendMsg($to, $sub, $msg, $typelist) {
	if(in_array("all", $typelist)) {
		sendSMS($to, $msg);
		sendMail($to, $sub, $msg);
		sendWechat($to, $msg);
		return(True);
	}

	if(in_array("sms", $typelist))
		sendSMS($to, $msg);

	if(in_array("mail", $typelist)) {
		sendMail($to, $sub, $msg);
	}

	if(in_array("wechat", $typelist)) {
		sendWechat($to, $msg);
	}

}

function alarmLog($sub, $ret) {
	global $config;
	$log = $config['log']['path'];

	if(isset($_SERVER['REMOTE_ADDR'])) {
		$ipaddr = $_SERVER['REMOTE_ADDR'];
	} else {
		$ipaddr = "127.0.0.1";
	}

	if(isset($_POST['user'])) {
		$user = $_POST['user'];
	} else {
		$user = "localhost";
	}
	
	$ret_str = json_encode($ret);
	$datetime = date("Y-m-d H:i:s");
	file_put_contents($log, "$ipaddr - $user - $datetime - $sub - $ret_str\n", FILE_APPEND);
}
//main
$ret = array();
if(isset($argv[1]) && isset($argv[2])) {

	if(isset($argv[4])) {
		$typelist = array_unique(explode(",", $argv[4]));
	} else {
		$typelist = array("all");
	}

	$to = $argv[1];
	$t1 = microtime(true);
	$to = getToList($to);
	$t2 = microtime(true);
//	echo '总耗时'.round($t2-$t1,3)."秒\n";
	$sub = $argv[2];
	$msg = $argv[3];
} elseif(isset($_POST['to']) && isset($_POST['sub']) && isset($_POST['msg'])) {
	@$pass = $config['user'][$_POST['user']];
	if(isset($_POST['passwd']) && !empty($_POST['passwd']) && $_POST['passwd'] == $pass) {
		$to = getToList($_POST['to']);
		$sub = $_POST['sub'];
		$msg = $_POST['msg'];
		if(isset($_POST['type'])) {
			$typelist = array_unique(explode(",", $_POST['type']));
		} else {
			$typelist = array("all");
		}
	} else {
		$ret['errno'] = "101";
		$ret['errmsg'] = "username or password error!";
		$ret['to'] = $_POST['to'];
		alarmLog($_POST['sub'], $ret);
		die(json_encode($ret));
	}
} else {
	die("nothing to do");
}

$ret['errortype'] = implode(",", array_diff($typelist, $config['type']));
$typelist = array_intersect($typelist, $config['type']);

sendMsg($to, $sub, $msg, $typelist);

if($typelist == ["all"]) {
	die(json_encode($to));
}
foreach($typelist as $k=>$v) {
	$ret[$v] = $to[$v];
}
$ret["failed"] = $to['failed'];
alarmLog($sub, $ret);
die(json_encode($ret));

