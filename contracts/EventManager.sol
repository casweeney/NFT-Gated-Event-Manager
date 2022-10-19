// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract EventManager {
    struct Event {
        string title;
        string date;
        string time;
        string venue;
        address organizer;
        address eventNFT;
    }

    mapping(uint => Event) events;
    mapping(address => mapping(uint => bool)) registered;

    uint ID = 1;

    event EventCreated(string indexed title, string date, string time);
    event RegistrationSuccess(uint indexed id);

    error ZeroAddressNotAllowed();
    error AlreadyRegisterd();

    function createEvent(string memory _title, string memory _date, string memory _time, string memory _venue, address _eventNft) external {
        if(msg.sender == address(0)) {
            revert ZeroAddressNotAllowed();
        }
        if(_eventNft == address(0)) {
            revert ZeroAddressNotAllowed();
        }

        Event storage newEvent = events[ID];
        
        newEvent.title = _title;
        newEvent.date = _date;
        newEvent.time = _time;
        newEvent.venue = _venue;
        newEvent.organizer = msg.sender;
        newEvent.eventNFT = _eventNft;

        ID++;

        emit EventCreated(_title, _date, _time);
    }

    function showEvent(uint _id) external view returns(Event memory) {
        return events[_id];
    }

    function registerForEvent(uint _id) external {
        if(msg.sender == address(0)) {
            revert ZeroAddressNotAllowed();
        }

        require(IERC721(events[_id].eventNFT).balanceOf(msg.sender) > 0, "Don't have event NFT");

        bool regStatus = registered[msg.sender][_id];

        if(regStatus == true) {
            revert AlreadyRegisterd();
        }

        registered[msg.sender][_id] = true;

        emit RegistrationSuccess(_id);
    }
}