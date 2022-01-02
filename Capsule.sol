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

abstract contract ERC721 {
  event Transfer(
    address indexed _from,
    address indexed _to,
    uint256 indexed _tokenId
  );
  event Approval(
    address indexed _owner,
    address indexed _approved,
    uint256 indexed _tokenId
  );

  function balanceOf(address _owner) external view virtual returns (uint256);

  function ownerOf(uint256 _tokenId) external view virtual returns (address);

  function transferFrom(
    address _from,
    address _to,
    uint256 _tokenId
  ) external payable virtual;

  function approve(address _approved, uint256 _tokenId)
    external
    payable
    virtual;
}

contract Capsule is TimeCapsule, ERC721 {
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
