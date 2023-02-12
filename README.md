# BankTransaction
This is a simple SQL script that implements what kind of actions happened in a bank. As we know, we can withdraw or store an amount of money in our bank account. The bank system should record those actions in a history/log also update the bank account's balance.

The SQL script I made implements that system, with help of procedure that will record the action in a correct history table and trigger that will update the balance automatically after insertion to the history table. I used some terms in Indonesian in my code and these are the meanings:

"Transaksi" means "transaction", "tarik" means "to withdraw", "setor" means "to store".
"Update saldo setelah tarik tunai" means "update the balance after withdrawing" and "update saldo setelah setor tunai" means "update the balance after storing"
