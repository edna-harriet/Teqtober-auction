// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./Beneficiary.sol";

contract Bider is Ownable, Beneficiary{
    using SafeMath for uint;
    include Rejected Status
    IERC20 AuccTokens;
    uint constAuccTokenAmount = 10;
    uint constconfirmdAmount = 100 ether;
    uint constChargePerPost = 0.0001 ether;

    uint constconfirmedAucctoken = 100;

    enum statuschoices {
        Waiting,
        Confirmed,
        Cancelled
    }

    struct biderDetails {
        address payable bidowner;
        string companyName;
        string contact;
        string goodsForTender;
        string tenderOwnerName;
        uint bidsTenderIndex;
        statuschoices choice;
        string goodsDescription;
    }
    mapping(uint => biderDetails) bidItems;
    uint bidstenderlength = 0;

    function activateAuccTokens(
        address _AuccTokens
    ) public onlyOwner {
        AuccTokens = IERC20(_AuccTokens);
    }

    //fix this
    function writeBiderDetails(
        uint _tenderIndex,
        string memory _companyName,
        string memory _contact,
        string memory _goodsForTender
    ) public {
        require(
            AuccTokens.balanceOf(msg.sender) >= 5,
            "Please Recharge your Aucctokens"
        );
        //require to bid onlyonce

        require(
            AuccTokens.transferFrom(msg.sender, address(this), 5),
            "unable to transfer TSD tokens"
        );
        require(
            msg.sender != bidItems[_tenderIndex].bidowner,
            "Can Only Bid Once"
        );
        uint _bidsindex = bidstenderlength;

        bidItems[_tenderIndex] = biderDetails(
            payable(msg.sender),
            _companyName,
            _contact,
            _goodsDealsWith,
            tenderItems[_tenderIndex].companyName,
            _bidsindex,
            statuschoices.Waiting,
            tenderItems[_tenderIndex].tenderDescription
        );
        bidstenderlength = bidstenderlength.add(1);
        //status
        //choice = statuschoices.Waiting;
    }

    function readBiderDetails()
        public
        view
        returns (biderDetails[] memory props)
    {
        props = new biderDetails[](tenderIndex); //size array
        for (uint256 index = 0; index < tenderIndex; index++) {
            props[index] = bidItems[index];
        }
    }

    function getTotalBindsLength() public view returns (uint) {
        return bidstenderlength;
    }

    //confirm function
    function confirmTender(
        uint _tenderbidsIndex
    )
        public
        onlyOwner
        returns (address, string memory, string memory, string memory)
    {
        require(
            msg.sender == tenderItems[_tenderbidsIndex].owner,
            "Only The Owner can confirm"
        );
        require(
            bidItems[_tenderbidsIndex].choice == statuschoices.Waiting,
            "Waiting Confirmation"
        );
        // choice = statuschoices.confirmd;
        bidItems[_tenderbidsIndex].choice = statuschoices.confirmd;
        return (
            bidItems[_tenderbidsIndex].bidowner,
            bidItems[_tenderbidsIndex].companyName,
            bidItems[_tenderbidsIndex].contact,
            bidItems[_tenderbidsIndex].goodsForTender
        );
    }

    function onlyconfirmTender(
        uint _tenderbidsIndex
    )
        public
        view
        returns (address, string memory, string memory, string memory)
    {
        //require(msg.sender != address(this),"Only The Owner can confirm");
        require(
            bidItems[_tenderbidsIndex].choice == statuschoices.confirmd,
            "Waiting Confirmation"
        );
        // choice = statuschoices.confirmd;
        //bidItems[_tenderbidsIndex].choice = statuschoices.confirmd;
        return (
            bidItems[_tenderbidsIndex].bidowner,
            bidItems[_tenderbidsIndex].companyName,
            bidItems[_tenderbidsIndex].contact,
            bidItems[_tenderbidsIndex].goodsForTender
        );
    }

    //Rejected Tenders
    //added
    function rejectTender(
        uint _tenderbidsIndex
    )
        public
        onlyOwner
        returns (address, string memory, string memory, string memory)
    {
        require(
            msg.sender == tenderItems[_tenderbidsIndex].owner,
            "Only The Owner can confirm"
        );
        require(
            bidItems[_tenderbidsIndex].choice == statuschoices.Waiting,
            "Waiting Confirmation"
        );
        // choice = statuschoices.confirmd;
        bidItems[_tenderbidsIndex].choice = statuschoices.Rejected;
        return (
            bidItems[_tenderbidsIndex].bidowner,
            bidItems[_tenderbidsIndex].companyName,
            bidItems[_tenderbidsIndex].contact,
            bidItems[_tenderbidsIndex].goodsForTender
        );
    }

    function buyAuccTokens() external payable {
        require(msg.sender.balance >= 0.01 ether, "less balance");
        payable(address(this)).call{value: msg.value};
        AuccTokens.transfer(
            payable(msg.sender),
            constAuccTokenAmount
        );
    }

    function senderBalance() public view returns (uint256) {
        return AuccTokens.balanceOf(msg.sender);
    }

    function confirms() external {
        AuccTokens.confirm(address(this), constconfirmedAmount);
    }

    function getconstAuccamount() public view returns (uint) {
        return constconfirmdAucctoken;
    }

    function changeconstAuccamount(uint amount) public {
        constAuccTokenAmount = amount;
    }

    function getconstconfirmedAmount() public view returns (uint) {
        return constconfirmedAmount;
    }

    function getconstChargePerPost() public view returns (uint) {
        return constChargePerPost;
    }

    receive() external payable {}

    fallback() external payable {}
}
