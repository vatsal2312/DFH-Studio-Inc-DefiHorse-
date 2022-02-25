// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "./ERC721.sol";
import "./Pausable.sol";
import "./Ownable.sol";
import "./Counters.sol";
import './Whitelist.sol';

contract HorseBoxNFT is ERC721, Pausable, Ownable ,Whitelist{
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    // mapping(address => uint256) public minted;
    mapping(address => uint256) private mintedCount;

    constructor() ERC721("HorseBoxNFT", "HBNFT") {}

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function safeMint(address to) public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
    }

    function userSafeMint(address to) external {
        require(isWhitelisted(msg.sender),"The address is not whitelisted");
        require(mintedCount[msg.sender]< 1,"The address minted NFT already!");
        mintedCount[msg.sender] += 1;
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
          
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        whenNotPaused
        override
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function mintedNFT(address _user) external view returns (uint256) {
        return mintedCount[_user];
    } 
}
