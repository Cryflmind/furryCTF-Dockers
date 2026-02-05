const net = require('net');
const fs = require('fs');
const path = require('path');

// 获取合约信息
function getContractInfo() {
    try {
        return JSON.parse(fs.readFileSync(
            path.join(__dirname, 'contract-info.json'), 
            'utf8'
        ));
    } catch (e) {
        return {
            contract_address: '0x部署中...',
            rpc_url: 'http://localhost:8545',
            chain_id: 1337
        };
    }
}

// NC连接显示的信息
function getNCInfo() {
    const info = getContractInfo();
    
    return `========================================
🔐 智能合约漏洞挑战
========================================

🔗 连接信息：
RPC端点: ${info.rpc_url}
链ID: ${info.chain_id}
合约地址: ${info.contract_address}

⚠️ 提示：
- 合约有100 ETH初始资金
- 成功条件：清空合约中的资金

🔍 完整信息：
用浏览器访问此地址查看ABI和源码
========================================
`;
}

// 创建TCP服务器
const server = net.createServer((socket) => {
    let buffer = '';
    let isHttp = false;
    
    socket.on('data', (data) => {
        buffer += data.toString();
        
        // 检测是否是HTTP请求
        if (buffer.includes('GET ') || buffer.includes('POST ') || 
            buffer.includes('HEAD ') || buffer.includes('HTTP/')) {
            isHttp = true;
            socket.end(); // HTTP请求由nginx处理
            return;
        }
        
        // 不是HTTP请求，发送NC信息
        if (buffer.length > 0 && !isHttp) {
            socket.write(getNCInfo());
            socket.end();
        }
    });
    
    // 如果几秒内没收到数据，也显示信息
    setTimeout(() => {
        if (!socket.destroyed && !isHttp) {
            socket.write(getNCInfo());
            socket.end();
        }
    }, 2000);
    
    socket.on('error', () => {});
});

const PORT = 80;
server.listen(PORT, '0.0.0.0', () => {
    console.log(`📡 NC信息服务器启动 (端口 ${PORT})`);
});

module.exports = { getNCInfo };