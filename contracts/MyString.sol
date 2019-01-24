pragma solidity >=0.4.25 <0.6.0;

contract MyString {
    string public myStringVar;

    function setMyString(string memory _string) public {
        myStringVar = _string;
    }
}