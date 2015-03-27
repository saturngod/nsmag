<?php
/* Example */
/* gitlab deploy webhook */
/* gitlab.php?token=45GH3YTBuOizLa9Bwg4x8ICvo0n3QEFVFKBOxtwchjs2a8z8vOdEqzUiLWsvjfz9C */

/* security */
$access_token = '45GH3YTBuOizLa9Bwg4x8ICvo0n3QEFVFKBOxtwchjs2a8z8vOdEqzUiLWsvjfz9C';
//$access_ip = array('122.34.65.90');

/* get user token and ip address */
$client_token = $_GET['token'];

/* test token */
if ($client_token !== $access_token)
{
    echo "error 403";
    exit(0);
}

/* get json data */
$json = file_get_contents('php://input');
$data = json_decode($json, true);

/* get branch */
$branch = $data["ref"];

/* branch filter */
if ($branch === 'refs/heads/master') {
	/* if master branch*/
	/* then pull master */
	exec("/var/www/git_hook/nsmag_website.sh");
}
else {
    echo "WRONG. NO JSON";
    
}
?>
