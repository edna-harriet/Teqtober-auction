// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract AuccToken is ERC20 {
    constructor(address Auccaddress) ERC20("AuccToken", "TDS") {
        _mint(Auccaddress, 10 * 10000 ** 18);
    }
}
