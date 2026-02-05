const express = require('express');
const app = express();
const http = require('http');
const server = http.createServer(app);
const { Server } = require("socket.io");
const io = new Server(server);
const sqlite3 = require('sqlite3').verbose(); // 引入 SQLite

app.set('view engine', 'ejs');
app.use(express.static('public'));
app.use(express.urlencoded({ extended: true }));

// ================== 数据库初始化 START ==================
// 使用内存数据库 (:memory:)，每次重启都会重置，非常适合 CTF
const db = new sqlite3.Database(':memory:');

db.serialize(() => {
    // 1. 创建管理员表
    db.run("CREATE TABLE admins (id INTEGER PRIMARY KEY, username TEXT, password TEXT)");
    
    // 2. 插入一个没人能猜到的管理员 (迫使选手必须使用 SQL 注入)
    const securePass = "Flag_Is_Not_Here_" + Math.random().toString(36).substring(2);
    const stmt = db.prepare("INSERT INTO admins VALUES (?, ?, ?)");
    stmt.run(1, "admin", securePass);
    stmt.finalize();
    
    console.log("[Database] In-memory SQLite DB initialized with secure admin.");
});
// ================== 数据库初始化 END ==================

// 内存数据存储 (游戏用)
let users = {};

// [VULNERABILITY 1] 原型链污染核心代码
const merge = (target, source) => {
    for (let key in source) {
        if (typeof source[key] === 'object' && source[key] !== null) {
            if (!target[key]) target[key] = {};
            merge(target[key], source[key]);
        } else {
            target[key] = source[key];
        }
    }
    return target;
};

// 路由
app.get('/', (req, res) => { res.render('index'); });

app.get('/leaderboard', (req, res) => {
    res.render('rank', { topScore: 99999, message: "系统资源监控正常。" });
});

// ================== [真·SQL 注入区域] START ==================

app.get('/admin', (req, res) => {
    res.render('login', { error: null });
});

app.post('/admin', (req, res) => {
    const { username, password } = req.body;

    // [VULNERABILITY 2] 极其经典的 SQL 注入漏洞
    // 直接拼接字符串，未做任何过滤
    const sql = `SELECT * FROM admins WHERE username = '${username}' AND password = '${password}'`;

    console.log(`[SQL Query] ${sql}`); // 方便出题人调试，生产环境请删掉

    db.get(sql, (err, row) => {
        if (err) {
            // [Feature] 开启报错注入 (Error-based SQLi)
            // 如果 SQL 语法错了，直接把错误吐给前端，方便 sqlmap 识别
            res.status(500);
            return res.render('login', { error: "Database Error: " + err.message });
        }

        if (row) {
            // 登录成功！
            // 生成一个简单的 Token 允许访问 Dashboard
            return res.redirect('/admin/dashboard?token=auth_bypass_success');
        } else {
            // 登录失败
            return res.render('login', { error: "访问拒绝: 用户名或密码错误" });
        }
    });
});

app.get('/admin/dashboard', (req, res) => {
    const token = req.query.token;
    // 简单校验，防止直接访问
    if (token !== 'auth_bypass_success') {
        return res.redirect('/admin');
    }
    res.render('dashboard');
});

// ================== [真·SQL 注入区域] END ==================

// Socket.io 游戏逻辑 (保持不变)
io.on('connection', (socket) => {
    users[socket.id] = { config: { skin: "default" }, score: 0 };
    
    socket.on('game_over', (data) => {
        try {
            if(data.score) users[socket.id].score = data.score;
            if(data.config) merge(users[socket.id].config, data.config);
            socket.emit('system_msg', '数据已同步。');
        } catch (e) { console.error(e); }
    });

    socket.on('disconnect', () => { delete users[socket.id]; });
});

const PORT = 3000;
server.listen(PORT, () => {
    console.log(`SerpentAI Server running on port ${PORT}`);
});