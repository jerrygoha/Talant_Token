pragma solidity ^0.6.0;

import 'openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol';

contract TokenLock {
    using SafeERC20 for IERC20;

    // IERC20 토큰 선언
    IERC20 private _token;

    //릴리즈 이후 토큰 분배받는사람들?
    address private _beneficiary;

    // 토큰 락 풀리는시간
    uint256 private _releaseTime;

    
    // 토큰 락 하는사람
    address private _owner;
    bool private _ownable;

    event UnLock(address _receiver, uint256 _amount);
    event Retrieve(address _receiver, uint256 _amount);
    

    modifier onlyOwner() {
        require(isOwnable());
        require(msg.sender == _owner);
        _;
    }

    constructor(IERC20 token, address beneficiary, address owner, uint256 releaseTime, bool ownable) public {
        _token = token;
        _beneficiary = beneficiary;
        _owner = owner;
        _releaseTime = releaseTime;
        _ownable = ownable;
    }

    function isOwnable() public view returns (bool) {
        return _ownable;
    }

    function owner() public view returns (address) {
        return _owner;
    }

    /**
    토큰 반환
     */
    function token() public view returns (IERC20) {
        return _token;
    }

    /**
    언제 반환되는지
     */
    function releaseTime() public view returns (uint256) {
        return _releaseTime;
    }

    /**
    토큰 분배시키는 function
     */
    function release() public {
        require(block.timestamp >= _releaseTime); //분배 시간 지나면 통과

        uint256 amount = _token.balanceOf(address(this));
        require(amount>0);  //분배량 0보다 클때만 분배되도록.

        _token.safeTransfer(_beneficiary, amount);
        emit UnLock(_beneficiary, amount);
    }

    /**
    오너가 직접 토큰 분배를 할 수 있도록 한다.
     */
    function retrieve() onlyOwner public {
        
        uint256 amount = _token.balanceOf(address(this));
        require(amount>0);  //분배량 0보다 클때만 분배되도록.

        _token.safeTransfer(_beneficiary, amount);
        emit Retrieve(_beneficiary, amount);
    }


    
}