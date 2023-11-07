// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract Voting{

    struct Proposal{
        string name;
        uint votes;
    }
    mapping(address=> bool) private voters;
    Proposal[] public proposals; 
    
    function SubmitProposal(string memory name) public{
        require(!voters[msg.sender],"Proposal already submitted");
        proposals.push(Proposal(name,0));
        voters[msg.sender]=true;
    }

    function vote(uint256 Index) public{
        require(proposals.length > Index,"Index is out of bound");
        require(!voters[msg.sender],"Already Voted");
        proposals[Index].votes++;
        voters[msg.sender] = true;

    }
    function WinningProposal()public view returns(string memory){
        uint256 winingVote = 0;
        uint256 winingIndex = 0;
        for (uint i=0;i<proposals.length;i++){
            if(proposals[i].votes > winingVote){
                winingVote = proposals[i].votes;
                winingIndex = i;
            }
        }
        return proposals[winingIndex].name;
    }
}