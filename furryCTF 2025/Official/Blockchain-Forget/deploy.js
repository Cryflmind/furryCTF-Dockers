const Web3 = require('web3');
const fs = require('fs');
const path = require('path');
const solc = require('solc');
const { ethers } = require('ethers');

async function lockDeployerAccount(web3, deployerAddress) {
    try {
        console.log('🔒 锁定部署者账户:', deployerAddress);
        
        // 方法1：使用personal_lockAccount
        try {
            await web3.eth.personal.lockAccount(deployerAddress);
            console.log('✅ 部署者账户已锁定');
        } catch (lockError) {
            console.log('ℹ️  账户可能已锁定或锁定失败:', lockError.message);
        }
        
        // 验证哪些账户是解锁的
        try {
            const unlockedAccounts = await web3.eth.personal.getAccounts();
            console.log('🔓 当前解锁账户数量:', unlockedAccounts.length);
            
            if (unlockedAccounts.includes(deployerAddress.toLowerCase())) {
                console.warn('⚠️  警告：部署者账户仍可能处于解锁状态');
            } else {
                console.log('✅ 验证通过：部署者账户不在解锁列表中');
            }
        } catch (error) {
            console.log('ℹ️  无法获取解锁账户列表:', error.message);
        }
        
    } catch (error) {
        console.error('❌ 账户锁定过程中出错:', error.message);
    }
}

async function deploy() {
    console.log('🚀 部署CTF挑战合约...');
    
    // 读取flag
    const flag = fs.readFileSync('/app/flag.txt', 'utf8').trim();
    console.log('📝 Flag已读取（前20位）:', flag.substring(0, 20) + '...');
    
    // 连接区块链
    const web3 = new Web3('http://localhost:8545');
    
    // 等待区块链完全启动
    try {
        await web3.eth.net.isListening();
        console.log('✅ 成功连接到区块链');
    } catch (error) {
        console.error('❌ 无法连接到区块链:', error.message);
        process.exit(1);
    }
    
    // 从安全位置读取攻击者信息
    const attackerInfoPath = '/app/secure/attacker-info.json';
    if (!fs.existsSync(attackerInfoPath)) {
        console.error('❌ 攻击者信息文件不存在:', attackerInfoPath);
        process.exit(1);
    }
    
    const attackerInfo = JSON.parse(fs.readFileSync(attackerInfoPath, 'utf8'));
    const attackerAddress = attackerInfo.address;
    
    console.log('👤 攻击者地址:', attackerAddress);
    
    // 获取部署者账户（应该是第一个账户）
    const accounts = await web3.eth.getAccounts();
    if (accounts.length === 0) {
        console.error('❌ 没有可用的账户');
        process.exit(1);
    }
    
    const deployer = accounts[0];
    console.log('👤 部署者地址:', deployer);
    
    // 检查余额
    const deployerBalance = await web3.eth.getBalance(deployer);
    console.log('💰 部署者余额:', web3.utils.fromWei(deployerBalance, 'ether'), 'ETH');
    
    // 编译合约
    console.log('🔧 编译合约...');
    const source = fs.readFileSync('/app/target.sol', 'utf8');
    const input = {
        language: 'Solidity',
        sources: { 
            'target.sol': { 
                content: source 
            } 
        },
        settings: { 
            outputSelection: { 
                '*': { 
                    '*': ['abi', 'evm.bytecode'] 
                } 
            } 
        }
    };
    
    const output = JSON.parse(solc.compile(JSON.stringify(input)));
    const contract = output.contracts['target.sol']['VulnerableWallet'];
    
    // 部署合约 - 保持100 ETH，但降低gas价格
    console.log('📦 部署合约到区块链...');
    const contractObj = new web3.eth.Contract(contract.abi);
    
    const deploymentValue = web3.utils.toWei('100', 'ether'); // 保持100 ETH
    const gasPrice = web3.utils.toWei('1', 'gwei'); // 降低gas价格到1 Gwei
    
    const deployed = await contractObj.deploy({
        data: '0x' + contract.evm.bytecode.object,
        arguments: []
    }).send({
        from: deployer,
        gas: 3000000,
        gasPrice: gasPrice, // 使用较低的gas价格
        value: deploymentValue
    });
    
    const contractAddress = deployed.options.address;
    console.log('✅ 合约部署成功，地址:', contractAddress);
    
    // 获取合约余额验证
    const contractBalance = await web3.eth.getBalance(contractAddress);
    console.log('💰 合约余额:', web3.utils.fromWei(contractBalance, 'ether'), 'ETH');
    
    // 设置真实flag
    console.log('🏴 设置Flag...');
    const instance = new web3.eth.Contract(contract.abi, contractAddress);
    
    try {
        await instance.methods.setFlag(flag).send({ 
            from: deployer,
            gas: 200000,
            gasPrice: gasPrice // 同样使用低gas价格
        });
        console.log('✅ Flag设置成功');
    } catch (error) {
        console.error('❌ 设置Flag失败:', error.message);
        process.exit(1);
    }
    
    // 🔒 锁定部署者账户
    await lockDeployerAccount(web3, deployer);
    
    // 准备给攻击者的信息
    const contractInfo = {
        rpc_url: 'http://localhost:8545/rpc/',
        chain_id: 1337,
        contract_address: contractAddress,
        contract_abi: contract.abi,
        attacker_address: attackerAddress
    };
    
    // 保存信息
    fs.writeFileSync('/app/contract-info.json', JSON.stringify(contractInfo, null, 2));
    fs.writeFileSync('/usr/share/nginx/html/info.json', JSON.stringify(contractInfo, null, 2));
    fs.copyFileSync('/app/target.sol', '/usr/share/nginx/html/target.sol');
    
    // 创建私钥获取API端点文件
    const apiResponse = {
        address: attackerAddress,
        private_key: attackerInfo.privateKey,
        note: "此私钥仅用于本次CTF挑战，请勿在真实环境中使用"
    };
    
    fs.writeFileSync('/usr/share/nginx/html/api/attacker-key.json', JSON.stringify(apiResponse, null, 2));
    
    console.log('\n🎉 部署完成！');
    console.log('========================================');
    console.log('📋 合约地址:', contractAddress);
    console.log('👤 攻击者地址:', attackerAddress);
    console.log('💰 合约初始余额: 100 ETH');
    console.log('🔗 RPC端点: http://localhost:8545/rpc/');
    console.log('🔗 私钥获取: http://localhost:8080/api/attacker-key.json');
    console.log('========================================');
    
    // 最终验证
    try {
        const currentState = await instance.methods.getCurrentState().call();
        console.log('🔍 最终验证 - 当前owner:', currentState[0]);
        console.log('🔍 最终验证 - 合约余额:', web3.utils.fromWei(currentState[2], 'ether'), 'ETH');
    } catch (error) {
        console.log('⚠️  最终验证时出错:', error.message);
    }
}

deploy().catch(error => {
    console.error('❌ 部署失败:', error);
    process.exit(1);
});