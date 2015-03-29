<?php
header('Content-Type: application/json');
$dbh = new PDO('sqlite:sueddeutsche.de.sqlite');

if(preg_match("/^[0-9]+$/", $_GET['limit'])) {
	$limit = $_GET['limit'];
	$sth = $dbh->prepare('SELECT * FROM total LIMIT :limit');
	$sth->execute(array(':limit' => $limit));
} else {
	$sth = $dbh->prepare('SELECT * FROM total');
	$sth->execute();
}
$result = $sth->fetchAll(PDO::FETCH_ASSOC);

$json = json_encode($result, JSON_NUMERIC_CHECK);
echo $json;
?>