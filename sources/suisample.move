// Copyright (c) Mysten Labs, Inc.

module suilotto::lotto {
    use sui::event;
    use sui::coin::{Self, Coin};
    use sui::balance::Balance;
    use sui::sui::SUI;
    use sui::dynamic_object_field::{Self as dof};
    use sui::event::emit;


    public struct NewRound has copy, drop {
        id: ID,
        deposits: vector<Deposit>,
        is_active: bool,
        total_deposit: u64,
    }

    public struct Deposit has store, drop, copy {
        depositor: address,
        amount: u64,
    }

    public struct Result has store, drop, copy {
        id: ID,
        winner: address,
        prize: u64,
    }

    public struct Round has key, store {
        id: UID,
        deposits: vector<Deposit>,
        is_active: bool,
        total_deposit: Balance<SUI>,
    }


    public entry fun start_round( coin: Coin<SUI>, ctx: &mut TxContext) : ID {
        let id = object::new(ctx);
        let round_id = id.to_inner();
        let deposits = vector[];
        let round = Round {
            id,
            deposits,
            is_active: true,
            total_deposit: coin.into_balance(),
        };

        transfer::share_object(round);
        emit(NewRound {
            id: round_id,
            deposits: vector[],
            is_active: true,
            total_deposit: 0,
        });

        round_id
    }

    public entry fun deposit(round: &mut Round, coin: Coin<SUI>, ctx: &mut TxContext) {
        assert!(round.is_active, 1);
        let deposit = Deposit {
            depositor: ctx.sender(),
            amount: coin.value(),
        };
        round.deposits.push_back(deposit);
        coin::put(&mut round.total_deposit, coin);

        emit(Deposit {
            depositor: deposit.depositor,
            amount: deposit.amount,
        });
    }

    public entry fun draw_winner(round: &mut Round, random: u64, round_id: ID, ctx: &mut TxContext) {
        assert!(round.is_active, 2);
        assert!(vector::length(&round.deposits) > 0, 3);

        // Determine the winner based on the random number
        let winner_index = random % (vector::length(&round.deposits) as u64);
        let winner_deposit = &round.deposits[winner_index];
        
        let Round {
            id, 
            deposits,
            is_active,
            total_deposit,
        } = dof::remove<ID, Round>(&mut round.id, round_id);

        object::delete(id);
        vector::destroy_empty(deposits);

        let winner_address = winner_deposit.depositor;
        let prize = total_deposit.value();
        transfer::public_transfer(total_deposit.into_coin(ctx), winner_address);

        emit(Result {
            id: round_id,
            winner: winner_address,
            prize: prize,
        });
    }
 
}
