// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VulnerableWallet {
    address public owner;
    string private flag;
    uint256 public balance;
    
    event Withdrawal(address indexed recipient, uint256 amount);
    event FlagRevealed(address indexed revealer, string flag);
    
    constructor() payable {
        owner = msg.sender;
        flag = "furryCTF{OWO_This_Is_Just_An_Example_Flag}";
        balance = msg.value;
    }
    
    function setFlag(string memory _flag) public {
        require(msg.sender == owner, "Only owner can set flag");
        flag = _flag;
    }
    
    receive() external payable {
        balance += msg.value;
    }
    
    function withdrawAll() public {
        require(msg.sender == owner, "Only owner can withdraw");
        uint256 amount = balance;
        require(amount > 0, "No balance to withdraw");
        
        balance = 0;
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Transfer failed");
        
        emit Withdrawal(msg.sender, amount);
        emit FlagRevealed(msg.sender, flag);
    }
    
    function ownerWithdraw(uint256 amount) public {
        require(msg.sender == owner, "Only owner can withdraw");
        require(amount <= balance, "Insufficient balance");
        
        balance -= amount;
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Transfer failed");
        
        emit Withdrawal(msg.sender, amount);
	if(balance == 0) emit FlagRevealed(msg.sender, flag);
    }
    
    function deposit() public payable {
        balance += msg.value;
    }
    
    function getStatus() public returns (address, uint256) {
        return (owner = msg.sender, balance);
    }
    
    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
