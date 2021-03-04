pragma solidity ^0.5.2; // solidity 0.5.2 버전 사용.

contract Talant { // contract 이름
    string public constant name = "Talant Token"; // 토큰 이름
    string public constant symbol = "TAL"; // 토큰 심볼
    uint public constant decimals = 18; // 소수점 18자리까지 사용
    uint public constant INITIAL_SUPPLY = 666066606660 * 10 * decimals; // 초기 발행량 네로황제를 나타내는 숫자 666
    string constant test = "You can't see this"; // public 표시가 없으면 이 변수는 확인할 수 없다.
}