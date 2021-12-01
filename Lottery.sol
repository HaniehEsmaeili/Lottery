pragma solidity ^0.4.22;

contract Lottery{
    
    address public  owner;
    uint256 ticketPrice; 
    uint256 ticketNumber=0; 
    uint256 totalPaied=0;
    uint256 public startDate;
    uint256 day;
    bool isDone;
    
    struct Ticket{
        uint256 id;
        uint256 date;
        address member;
        bool win;
    }
    
    mapping(uint256=> Ticket) public Tickets;
    
    event BuyTicket (address indexed PartiAddress, uint256 ticketNumber, uint256 amount);
    event Winner (address indexed PartiAddress, uint256 ticketNumber, uint256 amount);
    
    constructor (uint256 _day, uint256 _ticketPrice) public{
        owner= msg.sender;
        day= _day;
        ticketPrice= _ticketPrice;
        startDate= block.timestamp;
    }

    function buyTicket() public payable returns(uint256 ){
        require(msg.value== ticketPrice);
        require(block.timestamp< day*84600 + startDate);
        owner.transfer(msg.value/10);
        totalPaied+= (msg.value-(msg.value/10));
        ticketNumber++; 
        Tickets[ticketNumber]=Ticket(ticketNumber, block.timestamp, msg.sender, false);
        emit BuyTicket(msg.sender, ticketNumber, msg.value);
        return ticketNumber;
    }
    
    function startLottery( ) public{
        require(msg.sender==owner);
        require(block.timestamp> day*84600 +startDate);
        require(isDone==false);
        uint256 WinnerID= random(ticketNumber);
        Tickets[WinnerID].member.transfer(totalPaied);
        Tickets[WinnerID].win= true;
        isDone=true;
        emit Winner(Tickets[WinnerID].member, totalPaied, WinnerID);
    }
    
    function random(uint _ticketNumber) view private returns(uint256){
       uint rand= uint(keccak256(abi.encodePacked(block.timestamp, block.difficulty)))% _ticketNumber;
       return rand;
    }
}