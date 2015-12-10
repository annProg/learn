<?php
/**
 * Usage:
 * File Name: contact.php
 * Author: annhe  
 * Mail: i@annhe.net
 * Created Time: 2015-12-10 14:57:00
 **/

$db = "/home/dev/learn/zabbix/url_monitor/db.json";
$errmsg = '{"errmsg":"no itemid"}';

$json_string = file_get_contents($db);
$data = json_decode($json_string, true);

if (isset($_GET['itemid']))
{
	$itemid = $_GET['itemid'];
}
elseif (isset($argv[1]))
{
	$itemid = $argv[1];
}
else
{
	die($errmsg);
}

if (array_key_exists($itemid, $data))
	die(json_encode($data[$itemid]));
else
	die($errmsg);

