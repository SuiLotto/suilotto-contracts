## Struct Documentation:

#### LottoPool: 
Describes the structure and purpose of the LottoPool struct, including its fields.
Function Documentation:

#### create_lotto:
Detailed comments explain the purpose, parameters, behavior, and usage example.

#### participate_lotto: 
Describes how users can deposit SUI into the LottoPool, including parameter details and an example.

#### send_to_winner: 
Provides details on how to withdraw a specified amount of SUI from the LottoPool and send it to a winner, with example usage.

#### Execution 

##### Publish the package
``` sui client publish --gas-budget 20000000 ./sources/sui_lotto.move ```

##### Creating the lotto
``` sui client call --function create_lotto --module sui_lotto --package $PACKAGE_ID --gas-budget 200000000 ```

##### Make sure to export the package
``` export PACKAGE_ID=<package_id> ```

##### Call the participate lotto and make the deposit
``` sui client ptb --move-call $PACKAGE_ID::sui_lotto::participate_lotto '<coin_address>' '<lotto_pool>' ```

##### Finalized after the winner is decided
``` sui client ptb --move-call $PACKAGE_ID::sui_lotto::send_to_winner 1 @<lotto_pool> --assign s --transfer-objects [s] @<to_address> ```



