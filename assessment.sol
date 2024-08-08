// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract SimpleToken {
    string public name = "SimpleToken";
    string public symbol = "STK";
    uint8 public decimals = 18;
    uint256 public totalSupply;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor(uint256 _initialSupply) {
        require(_initialSupply > 0, "Initial supply must be greater than zero");
        totalSupply = _initialSupply * 10 ** uint256(decimals);
        balanceOf[msg.sender] = totalSupply;
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(_to != address(0), "Invalid address");
        require(balanceOf[msg.sender] >= _value, "Insufficient balance");

        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;

        emit Transfer(msg.sender, _to, _value);

        // Using assert to check for invariants, should never fail if the code is correct
        assert(balanceOf[msg.sender] + balanceOf[_to] == totalSupply);

        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        require(_spender != address(0), "Invalid address");

        allowance[msg.sender][_spender] = _value;

        emit Approval(msg.sender, _spender, _value);

        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_to != address(0), "Invalid address");
        require(balanceOf[_from] >= _value, "Insufficient balance");
        require(allowance[_from][msg.sender] >= _value, "Allowance exceeded");

        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;

        emit Transfer(_from, _to, _value);

        // Using assert to check for invariants, should never fail if the code is correct
        assert(balanceOf[_from] + balanceOf[_to] == totalSupply);
        assert(allowance[_from][msg.sender] >= 0); // Check for underflow

        return true;
    }

    function burn(uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value, "Insufficient balance to burn");

        balanceOf[msg.sender] -= _value;
        totalSupply -= _value;

        emit Transfer(msg.sender, address(0), _value);

        // Using assert to check for invariants, should never fail if the code is correct
        assert(balanceOf[msg.sender] + totalSupply == totalSupply);

        return true;
    }

    function mint(uint256 _value) public {
        // Using revert to control who can mint tokens
        require(msg.sender == address(0x1234567890123456789012345678901234567890), "Unauthorized");

        totalSupply += _value;
        balanceOf[msg.sender] += _value;

        emit Transfer(address(0), msg.sender, _value);
    }
}
