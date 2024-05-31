module sui_lotto::sui_lotto {

  use sui::coin::{Self, Coin};
  use sui::balance;
  use sui::sui::SUI;
  
  public struct LottoPool has key, store {
    id: UID, 
    suiBalance: balance::Balance<SUI>
  }

  public fun create_lotto(ctx: &mut TxContext) {
    let object = LottoPool {
      id: object::new(ctx),
      suiBalance: balance::zero()
    };
    transfer::share_object(object);
  }

  public entry fun participate_lotto(coinToDeposit: Coin<SUI>, object: &mut LottoPool) {
    let balanceToAdd = coin::into_balance(coinToDeposit);
    balance::join(&mut object.suiBalance, balanceToAdd);
  }

public fun send_to_winner(amountToWithdraw: u64, object: &mut LottoPool, ctx: &mut TxContext): Coin<SUI> {
    let balanceToWithdraw = balance::split(&mut object.suiBalance, amountToWithdraw);
    coin::from_balance(balanceToWithdraw, ctx)
  }


}