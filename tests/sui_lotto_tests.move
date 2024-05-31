module sui_lotto::tests {
    use sui::coin::{Self, Coin};
    use sui::balance;
    use sui::sui::SUI;
    use sui::object;
    use sui::tx_context::TxContext;
    use move_stdlib::assert;
    use sui_lotto::sui_lotto::{LottoPool, create_lotto, participate_lotto, send_to_winner};

    // Test case for creating a new LottoPool
    public fun test_create_lotto() {
        let ctx = TxContext::zero();
        create_lotto(&mut ctx);

        // Verify the LottoPool was created and shared
        let created_lotto_pool = object::id(&ctx, 0);
        assert!(object::exists<LottoPool>(created_lotto_pool), 0);
    }

    // Test case for participating in the lotto (depositing SUI)
    public fun test_participate_lotto() {
        let ctx = TxContext::zero();
        create_lotto(&mut ctx);

        let created_lotto_pool = object::id(&ctx, 0);
        let mut lotto_pool = object::borrow_mut<LottoPool>(created_lotto_pool);

        let initial_balance = 1000;
        let deposit_amount = 500;
        let coin = coin::mint(initial_balance, &mut ctx);

        participate_lotto(coin::split(coin, deposit_amount), &mut lotto_pool);

        // Verify the deposit was successful
        let expected_balance = deposit_amount;
        let actual_balance = balance::value(&lotto_pool.suiBalance);
        assert!(actual_balance == expected_balance, 1);
    }

    // Test case for sending SUI to the winner
    public fun test_send_to_winner() {
        let ctx = TxContext::zero();
        create_lotto(&mut ctx);

        let created_lotto_pool = object::id(&ctx, 0);
        let mut lotto_pool = object::borrow_mut<LottoPool>(created_lotto_pool);

        let initial_balance = 1000;
        let deposit_amount = 500;
        let coin = coin::mint(initial_balance, &mut ctx);

        participate_lotto(coin::split(coin, deposit_amount), &mut lotto_pool);

        let withdraw_amount = 300;
        let winner_coin = send_to_winner(withdraw_amount, &mut lotto_pool, &mut ctx);

        // Verify the withdrawal was successful
        let expected_balance_after_withdrawal = deposit_amount - withdraw_amount;
        let actual_balance_after_withdrawal = balance::value(&lotto_pool.suiBalance);
        assert!(actual_balance_after_withdrawal == expected_balance_after_withdrawal, 2);

        // Verify the winner received the correct amount
        let winner_balance = coin::value(winner_coin);
        assert!(winner_balance == withdraw_amount, 3);
    }
}
