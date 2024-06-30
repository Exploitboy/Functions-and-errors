// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleRevertExample {
    mapping(address => uint) public balance;

    // Function to deposit Ether using revert
    function deposit() public payable {
        if (msg.value <= 0) {
            revert("amount you want to deposit must be greater than zero");
        }
        balance[msg.sender] += msg.value;
    }

    // Function to transfer balance using require
    function transfer(address _to, uint _amount) public {
        require(balance[msg.sender] >= _amount, " you don't have enough funds to transfer.");
        balance[_to] += _amount;
        balance[msg.sender] -= _amount;
    }

    // Function to withdraw balance using assert
    function withdraw(uint _amount) public {
        assert(balance[msg.sender] >= _amount);
        balance[msg.sender] -= _amount;
        payable(msg.sender).transfer(_amount);
    }
}
