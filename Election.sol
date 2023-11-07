// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract Election{
    struct Candidate{
    string Name;
    uint256 votes;
    }

    mapping(address=>bool) private voters;
    Candidate[] public Candidates;
     
    function registerCandidates(string memory name) public{
        require(!voters[msg.sender],"Already Registered");
        Candidates.push(Candidate(name,0));
        voters[msg.sender] = true;
    }

    function Voting(uint256 Index)public {
        require(Index<Candidates.length,"Index is out of Range");
        require(!voters[msg.sender],"Already Voted");
        Candidates[Index].votes++;
        voters[msg.sender]= true;
    }

    function getWinner() public view returns  (string memory){
        uint WinnerIndex = 0;
        uint WinnerVotes=0;
        for(uint i=0; i<Candidates.length;i++){
            if(Candidates[i].votes > WinnerVotes ){
                WinnerVotes = Candidates[i].votes;
                WinnerIndex = i;
            }   
        }
        return Candidates[WinnerIndex].Name;
    }
}
