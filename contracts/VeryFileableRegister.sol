pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";

/*
	Contract needs:
		- a mapping of caller address to a list of verified hashses
		- An event to listen on push events to drive bundle uploads
*/
contract VeryFileableRegister is Ownable {
	using SafeMath for uint256;

	struct RegisteredData {
		bytes32 hashOfData;
		uint256 storageSizeInKbs;
	}

	/**
		* @dev The mapping that stores the hashes a user has stored
		* against the contract
		*/
	mapping (address => RegisteredData[]) register;

	/**
		* @dev The storageFee in wei to charge per kilobyte of data store in the cloud.
		*/
	uint256 public weiPerKb;

	/**
		* @dev The base storageFee in wei to charge
		*/
	uint256 public baseFeeInWei;

	/**
		* @dev An indexed event that allows ETH clients to listen for registration
		* events. This event is used to drive off-chain storage of the files being
		* registered.
		*/
	event Registered(address indexed _caller, bytes32 indexed _hash, uint256 indexed _storageSize);

	constructor() public {
		weiPerKb = 1 szabo;
		baseFeeInWei = 1 finney;
	}

	/**
		* @dev This is a naive getter as it's size will always grow, and will then need to be filtered
		* by the client. For almost all use cases, this will be fine, as it will only hold a few
		* (or maybe a few thousand) entries for a single address. If that ever becomes unmanagable,
		* we can use event parsing from the server which is easily verified to look this up more
		* efficiently
		*/
	function getRegister(address id) public returns (RegisteredData[] memory) {
		return register[id];
	}

	/**
		* @dev Register a new data hash against the sender that represents the
		* sha256 of some data they want to be able to verify in the future.
		*
		* This call is payable because VeryFileable optionally store the underlying files
		* in the cloud for the user. The caller is charged a storageFee per kilobyte stored.
		*
		* This field prevents cheating the VeryFileable service because before service-side
		* infrastructure will upload the file permanently, we reconcile against this value,
		* and if the files size exceeds this value, it is not stored.
		*
		* This value can be zero for uses who opt to not use the provided cloud storage option
		*
		* @param hashOfData sha256 of this data stored in the register
		* @param storageSizeInKbs The amount of cloud storage the user is requesting
		*/
	function registerData(
			bytes32 hashOfData,
			uint256 storageSizeInKbs
	) public payable {
			uint256 storageFee = weiPerKb.mul(storageSizeInKbs);
			uint256 totalFee = storageFee.add(baseFeeInWei);

			uint256 senderBalance = msg.sender.balance;
			require(senderBalance >= totalFee, "Insufficient balance to add to register");
			require(msg.value >= totalFee, "Insufficient value on the transaction");

			address owner = owner();
			address payable payableOwner = address(uint160(owner));
			payableOwner.transfer(msg.value);

			register[msg.sender].push(RegisteredData(hashOfData, storageSizeInKbs));

			emit Registered(msg.sender, hashOfData, storageSizeInKbs);
	}
}
