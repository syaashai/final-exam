<?php 

$email = $_GET['email'];
$mobile = $_GET['mobile'];
$name = $_GET['name'];
$amount = $_GET['amount'];

$host = 'https://www.billplz-sandbox.com/api/v3/bills';
$data = array(
    'collection id' => $collection_id,
    'email' => $email,
    'mobile' => $mobile,
    'name' => $name,
    'amount' => ($amount + 1) * 100, 
    'description' =>'Payment for order by ' .$name,
    'callback_url' => "http://192.168.43.47/mytutor2/mobile/php/return_url",
    'redirect_url' => "http://192.168.43.47/mytutor2/mobile/php/payment_update.php?email=$email&mobile=$mobile&amount=$amount&name=$name"

);

$process = curl_init($host );
curl_setopt($process, CURLOPT_HEADER, 0);
curl_setopt($process, CURLOPT_USERPWD, $api_key . ":");
curl_setopt($process, CURLOPT_TIMEOUT, 30);
curl_setopt($process, CURLOPT_RETURNTRANSFER, 1);
curl_setopt($process, CURLOPT_SSL_VERIFYHOST, 0);
curl_setopt($process, CURLOPT_SSL_VERIFYPEER, 0);
curl_setopt($process, CURLOPT_POSTFIELDS, http_build_query($data) );

$return = curl_exec($process);
curl_close($process);

$bill = json_decode($retrurn, true);
header("Location: ($bill['url']}");
?>

    



