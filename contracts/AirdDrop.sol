//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

import "hardhat/console.sol";

contract AirDrop is ERC721{ 

      constructor() ERC721("WAGMI GAME", "WAGMI") {
    }

    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    event airDropSuccessful(address minter, string _tokenURI);

    mapping(address => string[]) public AddressToCid;
    mapping(uint => string) _tokenURIs;

      function tokenURI(uint256 _tokenId) public view override returns(string memory) {
        require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
        return bytes(_tokenURIs[_tokenId]).length > 0 ?
            string(abi.encodePacked("https://ipfs.io/ipfs/",_tokenURIs[_tokenId])) : "";
    }

     function _setTokenURI(uint _tokenId, string memory _tokenURI) internal{
        _tokenURIs[_tokenId] = _tokenURI;
    }

      function airDropNFT(address[] memory addressArray, string[] memory _tokenURI) external {
        uint256 tokenId = _tokenIdCounter.current();
        for (uint i = 0; i < addressArray.length; i++){
            _mint(addressArray[i], tokenId);
            _setTokenURI(tokenId,_tokenURI[i]);
            _tokenIdCounter.increment();
            AddressToCid[addressArray[i]].push(_tokenURI[i]);
            emit airDropSuccessful(addressArray[i], _tokenURI[i]);
        }
    }


  
}
