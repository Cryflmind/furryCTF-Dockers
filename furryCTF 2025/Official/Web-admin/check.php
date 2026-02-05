<?php
header('Content-Type: application/json');
require_once "service.php";

$json = file_get_contents('php://input');
$data = json_decode($json, true);

$username = $data['username'] ?? '';
$password = $data['password'] ?? '';

echo check_login($username, $password);
?>