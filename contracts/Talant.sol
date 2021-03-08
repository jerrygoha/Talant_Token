pragma solidity ^0.6.0; // solidity 0.5.2 버전 사용.

import 'openzeppelin-solidity/contracts/token/ERC20/ERC20.sol';
import 'openzeppelin-solidity/contracts/token/ERC20/ERC20Pausable.sol';
import './TokenLock.sol';

contract Talant is ERC20Pausable { // contract 이름, 위에서 불러온 erc20.sol파일에 있는 erc20컨트랙트에 코드를 덮어쓰겠다라는 의미.
    uint public  INITIAL_SUPPLY = 666066600000000000000000000; // 초기 발행량 뒤에 18자리0은 소숫점 아래 18자리를 뜻함.
    
    address private owner;

    // lock을 위한 정보 생성
    mapping (address => address) public lockStatus;
    event Lock(address _receiver, uint256 _amount);

    // airdrop을 위한 정보 생성
    // 내역 저장을 위한 address => uint256 매핑
    mapping (address => uint256) public airDropHistory;
    event AirDrop(address _receiver, uint256 _amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "접근 제한" );
        _;
    }

    // ----------------------------------------------------------------------------
    // constructor()
    // 스마트컨트랙트가 생성될 때 딱 1회 호출되는 함수.
    // constructor 함수 내부에 선언된 행동들이 스마트컨트랙트가 생성될 때 함께 이루어진다.
    // erc20 컨트랙트에 정의된 _mint함수를 사용.
    // ERC20(토큰 이름, 심볼)
    // ----------------------------------------------------------------------------
    constructor() public ERC20("Talant Token","TAL") {
        owner = msg.sender;
        _mint(msg.sender, INITIAL_SUPPLY);
    }

    function dropToken(address[] memory receivers, uint256[] memory values) public {
        require(receivers.length != 0);
        require(receivers.length == values.length);

        for (uint256 i = 0; i<receivers.length; i++){
            address receiver = receivers[i];
            uint256 amount = values[i];

            transfer(receiver, amount);
            airDropHistory[receiver] += amount;

            emit AirDrop(receiver, amount);
        }

    }

    function lockToken(address beneficiary, uint256 amount, uint256 releaseTime, bool isOwnable) onlyOwner public {
        TokenLock lockContract = new TokenLock(this, beneficiary, msg.sender, releaseTime, isOwnable);

        transfer(address(lockContract), amount);
        lockStatus[beneficiary] = address(lockContract);
        emit Lock(beneficiary, amount);

    }

}

