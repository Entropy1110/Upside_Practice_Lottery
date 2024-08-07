// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;


contract Lottery{
    
    uint16 winningNumber;
    uint lastDraw;
    uint public constant interval = 24 hours;
    mapping(address=>uint16) chosenNumber;
    
    constructor () {
        lastDraw = block.timestamp;
        winningNumber = type(uint16).max;
    }



    function buy external {

    }


    function draw external {
        //TODO winningNumber to random
        winningNumber = 0;
        
    }

    function claim external payable{

    }

    fallback() external payable{

    }
}