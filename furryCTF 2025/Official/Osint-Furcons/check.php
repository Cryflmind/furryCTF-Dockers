<?php
header('Content-Type: application/json');
header("Access-Control-Allow-Origin: *");
session_start();

// 禁用错误显示
ini_set('display_errors', 0);
error_reporting(0);

// 定义正确答案
$answers = [
    1 => '合肥皇冠假日酒店',
    2 => '喜来登酒店(光明六路东一段店)',
    3 => '上海世贸展馆',
    4 => '悉尼帕拉玛塔宾乐雅酒店',
    5 => '札幌电视塔',
    6 => '上海国际时尚中心'
];

// 初始化会话存储
if (!isset($_SESSION['unlocked'])) {
    $_SESSION['unlocked'] = array_fill(0, 6, false);
}

// 获取请求数据
$input = json_decode(file_get_contents('php://input'), true) ?: [];
$action = $_GET['action'] ?? ($input['action'] ?? '');

switch ($action) {
    case 'verify':
        handleVerify($input);
        break;
    case 'get_status':
        handleGetStatus();
        break;
    case 'get_flag':
        handleGetFlag();
        break;
    default:
        echo json_encode(['success' => false, 'message' => '无效动作']);
}

function handleVerify($input) {
    global $answers;

    $image_id = intval($input['image_id'] ?? 0);
    $answer = trim($input['answer'] ?? '');

    // 验证参数
    if ($image_id < 1 || $image_id > 6 || empty($answer)) {
        echo json_encode(['success' => false, 'message' => '参数错误']);
        return;
    }

    // 检查是否已解锁
    if ($_SESSION['unlocked'][$image_id - 1]) {
        echo json_encode(['success' => true, 'correct' => true]);
        return;
    }

    // 验证答案（宽松匹配）
    $clean = function($str) {
        return mb_strtolower(preg_replace('/\s+|[()]/u', '', $str));
    };

    $correct = $clean($answer) === $clean($answers[$image_id]);

    // 更新会话状态
    if ($correct) {
        $_SESSION['unlocked'][$image_id - 1] = true;
    }

    echo json_encode([
        'success' => true,
        'correct' => $correct,
        'unlocked_status' => $_SESSION['unlocked']
    ]);
}

function handleGetStatus() {
    echo json_encode([
        'success' => true,
        'unlocked_status' => $_SESSION['unlocked'] ?? array_fill(0, 6, false)
    ]);
}

function handleGetFlag() {
    $allUnlocked = isset($_SESSION['unlocked']) &&
        count(array_filter($_SESSION['unlocked'])) === 6;

    if ($allUnlocked) {
        echo json_encode([
            'success' => true,
            'flag' => 'furryCTF{Test_Flag}'
        ]);
    } else {
        echo json_encode([
            'success' => false,
            'message' => '尚未解锁所有图片'
        ]);
    }
}
?>
