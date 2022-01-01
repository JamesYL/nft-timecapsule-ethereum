// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./TimeCapsule.sol";
import "./ERC721.sol";

contract CapsuleOwnership is TimeCapsule, ERC721 {
  mapping(uint256 => address) private approvals;

  function balanceOf(address _owner) external view override returns (uint256) {
    return ownerCapsuleCount[_owner];
  }

  function ownerOf(uint256 _tokenId) external view override returns (address) {
    return capsuleToOwner[_tokenId];
  }

  function transferFrom(
    address _from,
    address _to,
    uint256 _tokenId
  ) external payable override {
    require(
      (capsuleToOwner[_tokenId] == _from) &&
        (msg.sender == _from || msg.sender == approvals[_tokenId])
    );
    ownerCapsuleCount[_from] -= 1;
    ownerCapsuleCount[_to] += 1;
    capsuleToOwner[_tokenId] = _to;
    emit Transfer(_from, _to, _tokenId);
  }

  function approve(address _approved, uint256 _tokenId)
    external
    payable
    override
  {
    require(capsuleToOwner[_tokenId] == msg.sender);
    approvals[_tokenId] = _approved;
    emit Approval(msg.sender, _approved, _tokenId);
  }
}
