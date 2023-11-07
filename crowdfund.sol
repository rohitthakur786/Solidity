// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.5.0 <0.9.0;

contract factory {
    Crowdfunding[] public crowdfunding;

    function func(address _owner, string memory _name) public {
        Crowdfunding crowd = new Crowdfunding(_owner, _name);
        crowdfunding.push(crowd);
    }
}

contract Crowdfunding {
    address public owner;
    string public name;
    uint256 public donorCount;
    uint256 public totalamount;
    struct withdrawreq {
        string reason;
        uint256 amount;
        uint256 noOfvotes;
        mapping(address => bool) voters;
    }

    constructor(address _owner, string memory _name) {
        owner = _owner;
        name = _name;
    }

    mapping(uint256 => withdrawreq) public Withdrawreqs;
    uint256 public noOfwithdrawreqs = 0;
    mapping(address => address) public donater;
    mapping(address => uint256) public donation;

    function _donation() external payable {
        donater[msg.sender] = msg.sender;
        require(msg.value >= 1 ether, "minimum amount is one ether");
        require(msg.sender != owner, "owner can not send ");
        donation[msg.sender] += msg.value;
        totalamount += msg.value;
        donorCount++;
    }

    function withdrwalReq(string memory reason, uint256 amount) public {
        require(msg.sender == owner, "only owner can withdraw");
        withdrawreq storage newreq = Withdrawreqs[noOfwithdrawreqs];
        noOfwithdrawreqs++;
        newreq.reason = reason;
        newreq.amount = amount * 10**18;
        newreq.noOfvotes = 0;
    }

    function Vote(uint256 reqid) public {
        require(donater[msg.sender] != address(0), "only donater can vote");
        withdrawreq storage reqdetails = Withdrawreqs[reqid];
        require(reqdetails.amount != 0, "must have request");
        require(!reqdetails.voters[msg.sender], "you have already vote");
        reqdetails.noOfvotes += 1;
    }

    function Withdraw(uint256 reqid) public payable {
        withdrawreq storage reqdetails = Withdrawreqs[reqid];
        require(reqdetails.noOfvotes >= donorCount / 2, "50% vote is needed");
        payable(owner).transfer(reqdetails.amount);
    }
}