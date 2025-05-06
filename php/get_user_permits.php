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

header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $email = $_POST['email'];

    $sql = "SELECT p.id, p.district, p.valid_from, p.valid_to 
            FROM permits p
            JOIN users_permits up ON p.id = up.permit_id
            JOIN users u ON u.id = up.user_id
            WHERE u.email = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param('s', $email);
    $stmt->execute();
    $result = $stmt->get_result();

    $permits = [];
    while ($row = $result->fetch_assoc()) {
        $permits[] = $row;
    }

    echo json_encode(['status' => 'success', 'permits' => $permits]);
    
    $stmt->close();
    $conn->close();
}
?>
