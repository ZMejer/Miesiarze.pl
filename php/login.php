<?php
ini_set('display_errors', 1);
error_reporting(E_ALL);

$servername = "localhost";
$username = ""; 
$password = "";     
$dbname = "miesiarze_db";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $email = $_POST['email'];
    $password = $_POST['password'];

    $sql = "SELECT * FROM users WHERE email = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("s", $email); 
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        $user = $result->fetch_assoc();
        if ($password == $user['password']) {  
            echo json_encode([
                "status" => "success",
                "message" => "Logowanie udane",
                "user" => $user  
            ]);
        } else {
            echo json_encode(["status" => "error", "message" => "Błędne hasło"]);
        }
    } else {
        echo json_encode(["status" => "error", "message" => "Błędny email"]);
    }

    $stmt->close();
    $conn->close();
}
?>
