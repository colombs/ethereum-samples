pragma solidity >=0.4.22 <0.6.0;

import "./Dao.sol";

contract Child is Owned, ChildDAO {
    DAO dao;

    constructor(address payable _dao) public {
        dao = DAO(_dao);
    }

    function getTotalBalance() public view returns (uint) {
        return address(this).balance;
    }

    function contribute(uint quantity) public {
        require(address(this).balance > quantity);
        dao.contribute.value(quantity)();
    }

    function withdrawAll() public {
        dao.withdrawAll();
    }

    function payout() external payable {
    }

    function () external payable {
    }
}