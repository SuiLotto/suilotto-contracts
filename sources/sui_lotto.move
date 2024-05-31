module sui_lotto::sui_lotto {

  use sui::coin::{Self, Coin};
  use sui::balance;
  use sui::sui::SUI;
  
  /// The `LottoPool` struct represents a lottery pool that holds a balance of SUI tokens.
  //LottoPool object which is the main pool in the sui_lotto and carries all the information 
  //about the sui deposits
  public struct LottoPool has key, store {
    /// Unique identifier for the lottery pool.
    id: UID, 
    /// Balance of SUI tokens held in the lottery pool.
    suiBalance: balance::Balance<SUI>
  }

/// Creates a new `LottoPool` with a zero balance and shares it.
    ///
    /// # Parameters
    /// - `ctx`: The transaction context, providing the context for the transaction execution.
    ///
    /// # Behavior
    /// - Initializes a new `LottoPool` with a unique identifier and a zero balance.
    /// - Shares the newly created `LottoPool` object so it can be accessed by others.
    ///
    /// # Example Usage
    /// ```
    /// create_lotto(&mut ctx);
  /// ```
  public fun create_lotto(ctx: &mut TxContext) {
    let object = LottoPool {
      id: object::new(ctx),
      suiBalance: balance::zero()
    };
    transfer::share_object(object);
  }

 /// Allows a user to participate in the lottery by depositing SUI tokens into the `LottoPool`.
    ///
    /// # Parameters
    /// - `coinToDeposit`: The SUI coin to be deposited into the lottery pool.
    /// - `object`: A mutable reference to the `LottoPool` object where the coins will be deposited.
    ///
    /// # Behavior
    /// - Converts the deposited SUI coin into a balance.
    /// - Adds the balance of the deposited coin to the `LottoPool`.
    ///
    /// # Example Usage
    /// ```
    /// participate_lotto(coin, &mut lotto_pool);
  /// ```
  public entry fun participate_lotto(coinToDeposit: Coin<SUI>, object: &mut LottoPool) {
    let balanceToAdd = coin::into_balance(coinToDeposit);
    balance::join(&mut object.suiBalance, balanceToAdd);
  }

 /// Sends a specified amount of SUI from the `LottoPool` to a winner.
    ///
    /// # Parameters
    /// - `amountToWithdraw`: The amount of SUI to be withdrawn from the lottery pool.
    /// - `object`: A mutable reference to the `LottoPool` object from which the SUI will be withdrawn.
    /// - `ctx`: The transaction context, providing the context for the transaction execution.
    ///
    /// # Returns
    /// - A `Coin<SUI>` representing the withdrawn amount of SUI.
    ///
    /// # Behavior
    /// - Splits the specified amount from the `LottoPool` balance.
    /// - Converts the split balance into a SUI coin.
    ///
    /// # Example Usage
    /// ```
    /// let winner_coin = send_to_winner(100, &mut lotto_pool, &mut ctx);
  /// ```
public fun send_to_winner(amountToWithdraw: u64, object: &mut LottoPool, ctx: &mut TxContext): Coin<SUI> {
    let balanceToWithdraw = balance::split(&mut object.suiBalance, amountToWithdraw);
    coin::from_balance(balanceToWithdraw, ctx)
  }


}