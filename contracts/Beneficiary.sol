// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Beneficiary is Ownable {
    using SafeMath for uint;

    struct TenderDetails {
        address payable owner;
        string companyName;
        string tenderDescription;
        string deadlineDate;
        string phoneNumber;
        uint tenderAmount;
        uint tendersindex;
    }
    mapping(uint => TenderDetails) tenderItems;
    uint tenderIndex = 0;

    function writeTenderDetails(
        string calldata _companyName,
        string calldata _tenderDescription,
        string calldata _deadlineDate,
        string calldata _phoneNumber,
        uint _tenderAmount
    ) public {
        uint _tendersindex = tenderIndex;
        tenderItems[tenderIndex] = TenderDetails(
            payable(msg.sender),
            _companyName,
            _tenderDescription,
            _deadlineDate,
            _phoneNumber,
            _tenderAmount,
            _tendersindex
        );
        tenderIndex = tenderIndex.add(1);
    }

    function readTenderDetails()
        public
        view
        returns (TenderDetails[] memory props)
    {
        props = new TenderDetails[](tenderIndex); //size array
        for (uint256 index = 0; index < tenderIndex; index++) {
            props[index] = tenderItems[index];
        }
    }

    //function to return the number of tender items
    function tenderTotals() public view returns (uint) {
        return tenderIndex;
    }
}
