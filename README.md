## FlashLoanTemplate  

## Overview  
FlashLoanTemplate is a Solidity smart contract that interacts with the dYdX protocol to perform flash loans. It allows users to borrow assets temporarily without collateral, execute arbitrage, liquidate positions, or perform other DeFi strategies before repaying the loan within the same transaction.

## Features  
- Utilizes dYdX's flash loan functionality.  
- Handles loaned funds through the `callFunction` method.  
- Ensures proper repayment before transaction completion.  
- Provides a flexible structure for integrating custom DeFi strategies.  

## Dependencies  
This contract imports:  
- **dYdX Money Legos**: For interacting with dYdX flash loans.  
- **OpenZeppelin ERC20 Interface**: To interact with ERC-20 tokens.  

```solidity
import "@studydefi/money-legos/dydx/contracts/DydxFlashloanBase.sol";
import "@studydefi/money-legos/dydx/contracts/ICallee.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
```

## How It Works  
1. **Initiate Flash Loan**:  
   - The `initiateFlashLoan` function requests a loan from dYdX.  
   - It determines the `marketId` for the requested token.  
   - Approves the repayment amount (loan amount + fees).  
   - Calls `callFunction`, where the loaned funds can be utilized.  

2. **Handle Loaned Funds (`callFunction`)**:  
   - Executes logic using the borrowed funds (e.g., arbitrage, liquidation).  
   - Ensures sufficient funds to repay dYdX before reverting.  

## Example Usage  
To execute a flash loan, call `initiateFlashLoan` with:  
- `_solo`: The address of the dYdX SoloMargin contract.  
- `_token`: The token address to borrow.  
- `_amount`: The amount to borrow.  

```solidity
function initiateFlashLoan(
    address _solo,
    address _token,
    uint256 _amount
) external { ... }
```

## Requirements  
- Solidity `>=0.4.22 <0.9.0`  
- Ensure dYdX SoloMargin contract is available on the target network.  
- Implement additional logic inside `callFunction` to utilize the borrowed funds.  

## TODO  
- Implement custom logic inside `callFunction`, such as:  
  - Arbitrage trading  
  - Liquidation of undercollateralized accounts  
  - Yield farming strategies  

## Notes  
- The contract **currently reverts** in `callFunction` as a placeholder. You need to replace `revert("!You got desired funds, now code what to do next");` with actual logic.  
- dYdX requires at least 2 Wei deposited into the account to maintain a balanced collateralization ratio.  

## License  
This project is licensed under `SEE LICENSE IN LICENSE`.  

---
