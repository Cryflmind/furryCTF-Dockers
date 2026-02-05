const script = document.createElement('script');
script.src = './js/dataReport.js';
document.head.appendChild(script);

const socket = io();
const canvas = document.getElementById('gameCanvas');
const ctx = canvas.getContext('2d');
const scoreEl = document.getElementById('score');

const box = 20; // 格子大小
let snake = [];
let food = {};
let score = 0;
let d; // 方向
let game;
let lastRenderTime = 0;
const GAME_SPEED = 100; // 100ms 更新一次

// 监听服务器消息
socket.on('system_msg', (msg) => {
    console.log("[系统消息]: " + msg);
});

function init() {
    snake = [];
    snake[0] = { x: 9 * box, y: 10 * box };
    score = 0;
    d = undefined;
    scoreEl.innerText = score;
    generateFood();
}

function generateFood() {
    food = {
        x: Math.floor(Math.random() * 19) * box,
        y: Math.floor(Math.random() * 19) * box
    };
}

// 存储当前方向和下一个方向，避免键盘事件延迟
let nextDirection = null;

document.addEventListener("keydown", direction);

function direction(event) {
    // 使用 nextDirection 临时存储，避免方向立即改变导致蛇回头
    let keyDirection = null;
    
    if (event.keyCode == 37 && d != "RIGHT") keyDirection = "LEFT";
    else if (event.keyCode == 38 && d != "DOWN") keyDirection = "UP";
    else if (event.keyCode == 39 && d != "LEFT") keyDirection = "RIGHT";
    else if (event.keyCode == 40 && d != "UP") keyDirection = "DOWN";
    
    // 立即更新下一个方向
    if (keyDirection) {
        nextDirection = keyDirection;
    }
}

function collision(head, array) {
    for (let i = 0; i < array.length; i++) {
        if (head.x == array[i].x && head.y == array[i].y) return true;
    }
    return false;
}

function draw() {
    // 绘制背景
    ctx.fillStyle = "#000";
    ctx.fillRect(0, 0, canvas.width, canvas.height);

    // 绘制蛇
    for (let i = 0; i < snake.length; i++) {
        ctx.fillStyle = (i == 0) ? "#00ff41" : "#FFF";
        ctx.fillRect(snake[i].x, snake[i].y, box, box);
        ctx.strokeStyle = "#000";
        ctx.strokeRect(snake[i].x, snake[i].y, box, box);
    }

    // 绘制食物
    ctx.fillStyle = "red";
    ctx.fillRect(food.x, food.y, box, box);
}

function update() {
    // 如果有下一个方向，更新当前方向
    if (nextDirection) {
        d = nextDirection;
        nextDirection = null;
    }

    // 如果没有方向，不更新游戏状态
    if (!d) return;

    // 蛇头坐标
    let snakeX = snake[0].x;
    let snakeY = snake[0].y;

    if (d == "LEFT") snakeX -= box;
    if (d == "UP") snakeY -= box;
    if (d == "RIGHT") snakeX += box;
    if (d == "DOWN") snakeY += box;

    // 吃到食物
    if (snakeX == food.x && snakeY == food.y) {
        score++;
        scoreEl.innerText = score;
        generateFood();
    } else {
        snake.pop(); // 移除尾部
    }

    let newHead = { x: snakeX, y: snakeY };

    // 碰撞检测
    if (snakeX < 0 || snakeX >= canvas.width || snakeY < 0 || snakeY >= canvas.height || collision(newHead, snake)) {
        clearInterval(game);
        gameOver();
        return;
    }

    snake.unshift(newHead);
}

// 使用 requestAnimationFrame 来获得更平滑的动画
function gameLoop(timestamp) {
    if (!lastRenderTime) lastRenderTime = timestamp;
    
    const elapsed = timestamp - lastRenderTime;
    
    // 当达到游戏速度时更新游戏状态
    if (elapsed > GAME_SPEED) {
        update();
        draw();
        lastRenderTime = timestamp;
    }
    
    // 继续游戏循环
    if (game) {
        requestAnimationFrame(gameLoop);
    }
}

function gameOver() {
    game = null;
    alert("游戏结束！你的得分是: " + score);
    sendData();
}

function startGame() {
    if (game) {
        cancelAnimationFrame(game);
        game = null;
    }
    
    init();
    // 默认向右移动，防止静止导致无法开始
    d = "RIGHT";
    nextDirection = null;
    lastRenderTime = 0;
    
    // 启动游戏循环
    game = true;
    requestAnimationFrame(gameLoop);
}
