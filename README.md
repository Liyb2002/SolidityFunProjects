# SolidityFunProjects
Purely for fun/ some apps might be useful/ for learning

A. Voting
This is a voting smart contract based on official documentary of Solidity
How it works:
1.Chairman starts an auction, votes apply for chances to vote
2.Chairman approve voter's rights to vote for candidates
3.Chairman counts votes
4.Chairman can choose admins to help him work


B. Auction
This is a auction smart contract based on official documentary of Solidity
How it works:
1.Owner starts an auction; he decides no long the bid should be
2.Bidders can bid
3.If bidders loose in the bid, they can withdraw their money before the bid ends
4.When the bid officially ends, all money that is not withdraw goes back to the owner


C.BlindBid
BlindBid is adapted from Auction

D.SingleTransaction
Seller deploy a single transaction that worth 2*value
Buyer need to spend 2*value first---to avoid intentional fraudulent.

E.transactionPlatform
A program adapted from SingleTransaction
Instead, the contract is deployed by a owner (like Amazon), and all transactions happen on the platform
faudulent is avoided.
Allow platform transaction fee (1e10 wei currently)
