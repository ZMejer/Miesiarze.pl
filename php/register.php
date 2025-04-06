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
    $name = $_POST['name'];
    $surname = $_POST['surname'];
    $gender = $_POST['gender'];
    $birthdate = $_POST['birthdate'];
    $phone_number = $_POST['phoneNumber'];
    $card_number = $_POST['cardNumber'];
    $is_student = (int)$_POST['isStudent'];

    $sql = "SELECT * FROM users WHERE email = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("s", $email); 
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        echo json_encode(["status" => "error", "message" => "Użytkownik już istnieje"]);
    } else {
        $sql = "INSERT INTO users (email, password, name, surname, gender, birthdate, phone_number, card_number, is_student)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        $stmt = $conn->prepare($sql);

        $stmt->bind_param('sssssssis', $email, $password, $name, $surname, $gender, $birthdate, $phone_number, $card_number, $is_student);

        if ($stmt->execute()) {
            echo json_encode(["status" => "success", "message" => "Rejestracja udana"]);
        } else {
            echo json_encode(["status" => "error", "message" => "Błąd: " . $conn->error]);
        }
    }

    $stmt->close();
    $conn->close();
}
?>
