// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.2;

contract lottery{
    address public manager;
    address payable[] public players;
    uint256 public endTime;
    constructor() payable{
        manager = msg.sender;
        endTime = block.timestamp + 10 minutes;
    }
    function alreadyentered() private view returns(bool){
        for(uint i=0;i<players.length;i++){
            if(players[i] == msg.sender){
               return true;
            }

        }
        return false;
    }

  function enter() payable public{
      require(msg.sender != manager ,"Manager cannot enter");
      require(alreadyentered() == false,"player already entered");
      require(block.timestamp < endTime, "Joining time over");
      require(msg.value >=1 ether , "minimum amount should be paid");
      players.push(payable(msg.sender));
  }

  function randomPick() view private returns(uint){
      return uint(sha256(abi.encodePacked(block.difficulty,block.number,players)));
  }

  function pickWinner() public{
      require(msg.sender == manager , "only manager can pick");
      uint index = randomPick()%players.length;
      address contractAddress = address(this);
      players[index].transfer(contractAddress.balance);
      players = new address payable[](0);
  }
  function everyPlayer() view public returns(address payable[] memory){
      return players;
  }
} 

