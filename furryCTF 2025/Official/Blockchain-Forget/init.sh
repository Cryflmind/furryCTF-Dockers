#!/bin/bash
set -e

echo "=========================================="
echo "🚀 启动 furryCTF 智能合约挑战"
echo "=========================================="

# 0. 创建必要的目录
mkdir -p /app/secure
mkdir -p /usr/share/nginx/html/api

# 1. 从环境变量读取flag
if [ -z "$GZCTF_FLAG" ]; then
    echo "❌ 错误：请设置 GZCTF_FLAG 环境变量"
    exit 1
fi

echo "📝 Flag: ${GZCTF_FLAG:0:20}..."
echo "$GZCTF_FLAG" > /app/flag.txt

# 2. 生成随机助记词（每个实例都不同）
echo "🔐 生成随机助记词和账户..."
RANDOM_MNEMONIC=$(node -e "
const { ethers } = require('ethers');
const wallet = ethers.Wallet.createRandom();
console.log(wallet.mnemonic.phrase);
")

echo "✅ 助记词已生成（保密存储）"
echo "$RANDOM_MNEMONIC" > /app/secure/mnemonic.txt

# 3. 从助记词获取部署者地址（第一个账户）
echo "👤 获取部署者地址..."
DEPLOYER_ADDRESS=$(node -e "
const { ethers } = require('ethers');
const mnemonic = '$RANDOM_MNEMONIC';
const wallet = ethers.Wallet.fromMnemonic(mnemonic);
console.log(wallet.address);
")
echo "✅ 部署者地址: $DEPLOYER_ADDRESS"

# 4. 从助记词获取攻击者地址（第二个账户）
echo "👤 获取攻击者地址..."
ATTACKER_ADDRESS=$(node -e "
const { ethers } = require('ethers');
const mnemonic = '$RANDOM_MNEMONIC';
const wallet = ethers.Wallet.fromMnemonic(mnemonic, \"m/44'/60'/0'/0/1\");
console.log(wallet.address);
")

ATTACKER_PRIVATE_KEY=$(node -e "
const { ethers } = require('ethers');
const mnemonic = '$RANDOM_MNEMONIC';
const wallet = ethers.Wallet.fromMnemonic(mnemonic, \"m/44'/60'/0'/0/1\");
console.log(wallet.privateKey);
")

echo "✅ 攻击者地址: $ATTACKER_ADDRESS"

# 保存攻击者信息
echo "{\"address\": \"$ATTACKER_ADDRESS\", \"privateKey\": \"$ATTACKER_PRIVATE_KEY\"}" > /app/secure/attacker-info.json
echo "$ATTACKER_PRIVATE_KEY" > /app/secure/attacker-private-key.txt

# 5. 启动Ganache区块链（所有账户默认解锁）
echo "⛓️  启动本地区块链节点..."
ganache-cli \
    --host 0.0.0.0 \
    --port 8545 \
    --networkId 1337 \
    --mnemonic "$RANDOM_MNEMONIC" \
    --defaultBalanceEther 5000 \
    --accounts 2 \
    --quiet > /tmp/ganache.log 2>&1 &

GANACHE_PID=$!
echo "📡 Ganache PID: $GANACHE_PID"

# 等待区块链启动
echo "⏳ 等待区块链节点启动..."
sleep 3

# 6. 部署合约
echo "📦 部署智能合约..."
node deploy.js

if [ $? -ne 0 ]; then
    echo "❌ 合约部署失败"
    echo "📋 Ganache日志:"
    tail -20 /tmp/ganache.log || true
    exit 1
fi

echo "✅ 合约部署成功"

# 7. 创建简单的私钥API服务
echo "🔧 创建私钥API服务..."

# 确保api目录存在
mkdir -p /usr/share/nginx/html/api

# 创建attacker-key.json文件
cat > /usr/share/nginx/html/api/attacker-key.json << EOF
{
  "address": "$ATTACKER_ADDRESS",
  "private_key": "$ATTACKER_PRIVATE_KEY",
  "note": "此私钥仅用于本次CTF挑战，请勿在真实环境中使用",
  "initial_balance": "5000 ETH"
}
EOF

# 创建index.html页面
cat > /usr/share/nginx/html/api/index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>获取私钥 - furryCTF</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; background: #f5f5f5; }
        .container { max-width: 600px; margin: 0 auto; background: white; padding: 30px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        h1 { color: #333; }
        .warning { background: #fff3cd; border: 1px solid #ffeaa7; padding: 15px; margin: 20px 0; border-radius: 5px; }
        .btn { background: #007bff; color: white; padding: 10px 20px; border: none; border-radius: 5px; cursor: pointer; }
        .btn:hover { background: #0056b3; }
        #privateKey { background: #f8f9fa; padding: 15px; border-radius: 5px; margin: 15px 0; word-break: break-all; }
        .info { background: #e7f3ff; border: 1px solid #b3d7ff; padding: 15px; margin: 20px 0; border-radius: 5px; }
    </style>
</head>
<body>
    <div class="container">
        <h1>获取攻击者私钥</h1>
        <div class="warning">
            <strong>⚠️ 重要警告：</strong>
            <p>此私钥仅用于本次CTF挑战！</p>
            <p>请勿在真实环境或主网中使用此私钥！</p>
        </div>
        <div class="info">
            <p><strong>💡 提示：</strong>此账户已预存5000 ETH用于支付gas费用</p>
        </div>
        <button class="btn" onclick="getPrivateKey()">获取私钥</button>
        <div id="result" style="display: none;">
            <h3>账户信息：</h3>
            <p><strong>地址：</strong> <span id="address"></span></p>
            <p><strong>私钥：</strong></p>
            <div id="privateKey"></div>
        </div>
    </div>
    <script>
        async function getPrivateKey() {
            try {
                const response = await fetch('attacker-key.json');
                const data = await response.json();
                
                document.getElementById('address').textContent = data.address;
                document.getElementById('privateKey').textContent = data.private_key;
                document.getElementById('result').style.display = 'block';
                
                alert('私钥已获取，请妥善保管！\n初始余额: ' + (data.initial_balance || '5000 ETH'));
            } catch (error) {
                alert('获取私钥失败: ' + error.message);
            }
        }
    </script>
</body>
</html>
EOF

echo "✅ API服务文件创建完成"

# 8. 启动Web服务
echo "🌐 启动Web服务..."

nginx -g 'daemon off;' &

NGINX_PID=$!
echo "🌐 Nginx PID: $NGINX_PID"

sleep 2

echo "=========================================="
echo "🎉 所有服务启动完成！"
echo "📊 访问地址: http://localhost:8080"
echo "🔗 RPC端点: http://localhost:8080/rpc/"
echo "🔑 私钥获取: http://localhost:8080/api/"
echo "💰 攻击者初始余额: 5000 ETH"
echo "💰 合约初始余额: 100 ETH"
echo "=========================================="
echo ""
echo "💡 挑战提示:"
echo "1. 先访问 http://localhost:8080/api/ 获取攻击者私钥"
echo "2. 使用私钥连接到RPC端点"
echo "3. 分析合约漏洞并利用"
echo "4. 获取flag"
echo "=========================================="

wait