<?php
header('Content-Type: application/json');
ob_start();
$dbh = new PDO('sqlite:sueddeutsche.de.sqlite');

if(preg_match("/^[0-9]+$/", $_GET['threshold'])) {
	$threshold = $_GET['threshold'];
	$sth = $dbh->prepare('SELECT * FROM perurl WHERE leser >= :threshold');
	$sth->execute(array(':threshold' => $threshold));
} else {
	$sth = $dbh->prepare('SELECT * FROM perurl');
	$sth->execute();
}
$result = $sth->fetchAll(PDO::FETCH_ASSOC);

$json = json_encode($result, JSON_NUMERIC_CHECK);
echo $json;

ob_end_flush();
?>