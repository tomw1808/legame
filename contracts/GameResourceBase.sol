pragma solidity ^0.5.0;

contract GameResourceInterface {
    function tokenCollectable() public view returns(bool);
    function timeUntilCollectable() public view returns(uint);
    function startProducing() public;
    function collectToken() public;
}