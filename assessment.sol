// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract SimpleStorage {
    // State variable to store the number
    uint256 private storedNumber;

    // Address of the contract owner
    address public owner;

    // Event to log changes to the stored number
    event NumberUpdated(uint256 newNumber);

    // Constructor to set the contract owner
    constructor() {
        owner = msg.sender;
    }

    // Modifier to restrict access to the owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function.");
        _;
    }

    // Function to set a new number
    function setNumber(uint256 newNumber) public onlyOwner {
        // Use require() to ensure the new number is valid
        require(newNumber >= 0, "Number must be non-negative.");

        // Update the stored number
        storedNumber = newNumber;

        // Use assert() to ensure that the number was set correctly
        // This is a simple assertion, assuming no other changes would affect storedNumber
        assert(storedNumber == newNumber);

        // Emit an event to log the update
        emit NumberUpdated(newNumber);
    }

    // Function to get the stored number
    function getNumber() public view returns (uint256) {
        return storedNumber;
    }

    // Function to demonstrate explicit use of revert()
    function setNumberWithRevert(uint256 newNumber) public onlyOwner {
        if (newNumber < 0) {
            revert("Number must be non-negative.");
        }
        // Update the stored number
        storedNumber = newNumber;

        // Emit an event to log the update
        emit NumberUpdated(newNumber);
    }
}
