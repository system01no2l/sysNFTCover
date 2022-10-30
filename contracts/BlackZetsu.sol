// SPDX-License-Identifier: MIT

pragma solidity ^0.8.2;
import './ERC721.sol';

// Create collectible smart contract

contract BackZetsu is ERC721 {
    // ERC721 metadata
    string public name;
    string public symbol;
    mapping(uint256 => string) _tokenURIs;
    uint256 public tokenCount;

    constructor(string memory _name, string memory _symbol) {
        name = _name;
        symbol = _symbol;
    }

    // Return URI by tokenId
    function tokenURI(uint256 tokenId) public view returns (string memory) {
        require(_owners[tokenId] != address(0), 'Token ID does not exist');
        return _tokenURIs[tokenId];
    }

    function mint(string memory _tokenURI) public {
        tokenCount += 1; // tokenId
        _balances[msg.sender] += 1; // set balance of owner
        _owners[tokenCount] = msg.sender; // set owner of tokenId
        _tokenURIs[tokenCount] = _tokenURI; // set URI of tokenId

        emit Transfer(address(0), msg.sender, tokenCount);
    }

        // Support EIP615
    function supportInterface(bytes4 interfaceID) public pure override returns(bool) {
        return interfaceID == 0x80ac58cd || interfaceID == 0x5b5e139f;
    }
}