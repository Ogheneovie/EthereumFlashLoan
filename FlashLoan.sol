    // SPDX-License-Identifier: SEE LICENSE IN LICENSE
    pragma solidity >=0.4.22 <0.9.0;
    pragma experimental ABIEncoderV2;
    
import "@studydefi/money-legos/dydx/contracts/DydxFlashloanBase.sol";
import "@studydefi/money-legos/dydx/contracts/ICallee.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract FlashLoanTemplate is ICallee, DydxFlashLoanBase {
    struct MyCustomData {
        address token;
        uint256 repayAmount;
    }

    // This is the function that will lbe called postLoan
    // / i.e Encode the logic to handle your flashloaned funds here
    function callFunction(
        address sender,
        Account.Info memory account,
        bytes memory data
    ) public {
        MyCustomData memory mcd = abi.decode(data, (MyCustomData));
        uint256 balOfLoanedToken = IERC20(mcd.token).balanceOf(address(this));
    
    // Note that you can ignore the line below
    // if your dydx account (this contract in this case)
    // has deposited at least ~2 Wei of assets into the account
    // to balance out the collaterization ratio
   require(
    balOfLoanedToken >= mcd.repayAmount,"Not enough funds to repay dydx loan!"
   );
   
//    TODO: Encode your logic here
// E.g. arbitrage, liquidate accounts, etc
revert("!You got desired funds, now code what to do next");
    }

    function initiateFlashLoan(
        address _solo,
        address _token,
        uint256 _amount
    ) external {
        ISoloMargin solo = ISoloMargin(_solo);
        
        // Get marketId from token address
        uint256 marketId = _getMarketIdFromTokenAddress(_solo, _token);

        // Calculate repay amount (_amount + (2 wei))
        // Approve transfer from
        uint256 repayAmount = _getRepaymentAmountInternal(_amount);
        IERC20(_token).approve(_solo, repayAmount);

        // 1. Withdraw $
        // 2. CallFunction(...)
        // 3. Deposit back $
        Actions.ActionArgs[] memory operation = new Actions.ActionArgs[](3);

        operations[0] = _getWithdrawAction(marketId, _amount);
        operarions[1] = _getCallAction(
            // Encode MyCustomData for callFunction
            abi.encode(MyCustomData({token: _token, repayAmount: repayAmount}))
        );
        operations[2] = _getDepositAction(marketID, repayAmount);

        Account.Info[] memory accountInfos = new Account.Info[](1);
        accountInfos[0] = _getAccountInfo();

        solo.operate(accountInfos, operations);
    }
}