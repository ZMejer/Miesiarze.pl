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
    $district = $_POST['district'];
    $email = $_POST['email'];

    $sql_0 = "SELECT id FROM users WHERE email = ?";
    $stmt_0 = $conn->prepare($sql_0);
    $stmt_0->bind_param("s", $email); 
    $stmt_0->execute();
    $result = $stmt_0->get_result();
    $user = $result->fetch_assoc();
    $user_id = $user['id'];  

    if (!$user_id) {
        echo json_encode(["status" => "error", "message" => "Użytkownik nie istnieje."]);
        exit;
    }

    $valid_from = date('Y-m-d');
    $valid_to = date('Y-12-31');

    $sql = "INSERT INTO permits (district, valid_from, valid_to) VALUES (?, ?, ?)";
    $stmt = $conn->prepare($sql);

    if ($stmt === false) {
        echo json_encode(["status" => "error", "message" => "Błąd przygotowania zapytania: " . $conn->error]);
        exit;
    }

    $stmt->bind_param('sss', $district, $valid_from, $valid_to);

    if ($stmt->execute()) {
        $permit_id = $conn->insert_id;

        $sql_2 = "INSERT INTO users_permits (user_id, permit_id) VALUES (?, ?)";
        $stmt_2 = $conn->prepare($sql_2);
        $stmt_2->bind_param('ii', $user_id, $permit_id);
        if ($stmt_2->execute()) {
            echo json_encode(["status" => "success", "message" => "Dodanie zezwolenia i przypisanie do użytkownika udane"]);
        } else {
            echo json_encode(["status" => "error", "message" => "Błąd przypisania zezwolenia do użytkownika: " . $stmt_2->error]);
        }
        $stmt_2->close();
    } else {
        echo json_encode(["status" => "error", "message" => "Błąd przy dodawaniu zezwolenia: " . $stmt->error]);
    }

    $stmt->close();
    $conn->close();
}
?>
