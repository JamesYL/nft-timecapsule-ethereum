// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TimeCapsule {
  event NewCapsule(
    address creator,
    uint256 lockTime,
    uint256 unlockTime,
    uint256 id
  );
  event DestroyCapsule(uint256 id);

  struct Capsule {
    string message;
    uint256 lockTime;
    uint256 unlockTime;
    address originalOwner;
  }

  Capsule[] internal capsules;
  mapping(uint256 => address) internal capsuleToOwner;
  mapping(address => uint256) internal ownerCapsuleCount;

  modifier isOwner(uint256 id) {
    require(capsuleToOwner[id] == msg.sender);
    _;
  }
  modifier isNotBroken(uint256 id) {
    require(capsuleToOwner[id] != address(0));
    _;
  }

  function createCapsule(string memory message, uint256 unlockTime)
    public
    returns (uint256)
  {
    uint256 lockTime = block.timestamp;
    require(lockTime < unlockTime);
    capsules.push(Capsule(message, lockTime, unlockTime, msg.sender));
    uint256 id = capsules.length - 1;
    ownerCapsuleCount[msg.sender]++;
    capsuleToOwner[id] = msg.sender;
    emit NewCapsule(msg.sender, lockTime, unlockTime, id);
    return id;
  }

  function destroyCapsule(uint256 id) public isOwner(id) isNotBroken(id) {
    ownerCapsuleCount[msg.sender]--;
    capsuleToOwner[id] = address(0);
    emit DestroyCapsule(id);
  }

  function readCapsule(uint256 id)
    public
    view
    isNotBroken(id)
    returns (string memory)
  {
    require(block.timestamp > capsules[id].unlockTime);
    return capsules[id].message;
  }

  function readCapsuleMetadata(uint256 id)
    public
    view
    isNotBroken(id)
    returns (
      uint256 lockTime,
      uint256 unlockTime,
      address originalOwner
    )
  {
    return (
      capsules[id].lockTime,
      capsules[id].unlockTime,
      capsules[id].originalOwner
    );
  }
}
