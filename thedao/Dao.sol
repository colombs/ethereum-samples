pragma solidity >=0.4.22 <0.6.0;

contract Owned {
    constructor() public { owner = msg.sender; }
    address payable owner;


    modifier onlyOwner {
        require(
            msg.sender == owner,
            "Only owner can call this function."
        );
        _;
    }

    function kill() onlyOwner public returns(bool) {
        selfdestruct(owner);
        return true;
    }
}

interface ChildDAO {
    function payout() external payable;
}

contract DAO is Owned{
    event Contribution(address _address, uint _amount);
    event WithdrawAll(address _address, uint _amount);

    mapping(address => uint) public balances;

    function withdrawAll() public {
        uint withdrawAmount = balances[msg.sender];
        require(withdrawAmount > 0);

        emit WithdrawAll(msg.sender, withdrawAmount);

        ChildDAO child = ChildDAO(msg.sender);
        child.payout.value(withdrawAmount)();

        balances[msg.sender] = 0;
    }

    function contribute() public payable {
        emit Contribution(msg.sender, msg.value);
        balances[msg.sender] = msg.value;
    }

    function getTotalBalance() public view returns (uint) {
        return address(this).balance;
    }

    function () external payable {
    }
}