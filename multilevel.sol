// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Tree {
    mapping(address => address) public references;
    mapping(address => bool) private isUser;

    constructor() {
        references[msg.sender] = address(0);
        isUser[msg.sender] = true;
    }

    function submit(address _ref) public payable {
        require(msg.value == 1 ether, "Amount should be 1 ether");
        require(isUser[_ref], "Reference address not available");
        require(
            references[msg.sender] == address(0),
            "User already registered"
        );
        references[msg.sender] = _ref;
        isUser[msg.sender] = true;

        address checkRef;

        if (references[msg.sender] == _ref) {
            checkRef = _ref;
            payable(checkRef).transfer((msg.value * 10) / 100);

            if (references[checkRef] != address(0)) {
                checkRef = references[checkRef];
                payable(references[checkRef]).transfer((msg.value * 5) / 100);

                if (references[checkRef] != address(0)) {
                    checkRef = references[checkRef];
                    payable(references[checkRef]).transfer(
                        (msg.value * 3) / 100
                    );

                    if (references[checkRef] != address(0)) {
                        checkRef = references[checkRef];
                        payable(references[checkRef]).transfer(
                            (msg.value * 2) / 100
                        );

                        if (references[checkRef] != address(0)) {
                            checkRef = references[checkRef];
                            payable(references[checkRef]).transfer(
                                (msg.value * 1) / 100
                            );
                        }
                    }
                }
            }
        } else {
            return;
        }
    }
}