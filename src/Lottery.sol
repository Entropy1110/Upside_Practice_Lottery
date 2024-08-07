// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;


contract Lottery{
    
    uint16 public winningNumber;
    uint public prize;
    uint public due;
    address[] public participants;
    address[] public winners;
    uint16 private constant INVALID = type(uint16).max;
    mapping(address=>uint16[]) chosenNumber;
    uint remain;

    
    constructor () {
        due = block.timestamp + 24 hours;
        winningNumber = INVALID;
    }

    function buy(uint16 _num) external payable{
        if (remain == 0 && winningNumber != INVALID){
            initialize();
        }
        require(due > block.timestamp, "NotBuyable");
        require(msg.value == 0.1 ether, "InsufficientFunds");
        
        uint len = chosenNumber[msg.sender].length;
        
        
        if (len != 0){
            for (uint i = 0; i < len; i++){
                require(chosenNumber[msg.sender][i] != _num, "NoDuplicate");
            }
        }
        prize += msg.value;
        participants.push(msg.sender);
        chosenNumber[msg.sender].push(_num);
        
    }


    function draw() external {
        require(due <= block.timestamp, "NotYetDrawable");
        require(winningNumber == INVALID);
        
        //TODO winningNumber to random
        winningNumber = 0;       

        for (uint i = 0; i < participants.length; i++)
        {
            address p = participants[i];
            uint len = chosenNumber[p].length;
            for (uint k = 0; k < len; k++){
                if (chosenNumber[p][k] == winningNumber){
                    winners.push(p);
                }
            }
        }
        remain = winners.length;

    }

    function claim() external payable{
        require(winningNumber != INVALID, "NotYetClaimable");
        uint winner_count = winners.length;
        uint total = 0;
        for (uint i = 0; i < winner_count; i++){
            if (msg.sender == winners[i]){
                winners[i] = address(0);
                total = prize / winner_count;
                remain--;
            }
        }
        (bool success, ) = payable(msg.sender).call{value: total}("");
        
    }

    function initialize() internal {
        for (uint i = 0; i < participants.length; i++){
            delete chosenNumber[participants[i]];
            participants.pop();
        }
        for (uint i = 0; i < winners.length; i++){
            winners.pop();
        }
        due = block.timestamp + 24 hours;
        winningNumber = INVALID;
    }

    fallback() external payable{
        prize += msg.value;
    }
}