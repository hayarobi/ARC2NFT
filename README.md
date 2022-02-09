# Aergo Non-Fungible Token Contract, ARC2

This defines interface and behaviors for aergo non-fungible token contract.

## Abstract

## Specification

### Token

Following is an interface contract declaring the required functions to meet the ARC-2 standard.

(NOTE) The token id is a string of up to 128 bytes

``` lua
-- Get the token name
-- @type    query
-- @return  (string) name of this token
function name() end

-- Get the token symbol
-- @type    query
-- @return  (string) symbol of this token
function symbol() end

-- Count of all NFTs
-- @type    query
-- @return  (integer) the number of non-fungible tokens on this contract
function totalSupply() end

-- Count of all NFTs assigned to an owner
-- @type    query
-- @param   owner  (address) a target address
-- @return  (integer) the number of NFT tokens of owner
function balanceOf(owner) end

-- Find the owner of an NFT
-- @type    query
-- @param   tokenId (str128) the NFT id
-- @return (address) the address of the owner of the NFT
function ownerOf(tokenId) end

-- Transfer a token to 'to'
-- @type    call
-- @param   to      (address) a receiver's address
-- @param   tokenId (str128) the NFT token to send
-- @param   ...     (Optional) addtional data, MUST be sent unaltered in call to 'onARC2Received' on 'to'
-- @event   transfer(from, to, tokenId)
function transfer(to, tokenId, ...) end
```

### Burnable extension

``` lua
function burn(tokenId) end
```

### Mintable extension

``` lua
-- Indicate if an account is a minter
-- @type    query
-- @param   account  (address)
-- @return  (bool) true/false
function isMinter(account)

-- Add an account to minters
-- @type    call
-- @param   account  (address)
-- @event   addMinter(account)
function addMinter(account)

-- Remove an account from minters
-- @type    call
-- @param   account  (address)
-- @event   removeMinter(account)
function removeMinter(account)

-- Renounce the Minter Role of TX sender
-- @type    call
-- @event   removeMinter(TX sender)
function renounceMinter()

-- Mint a new non-fungible token
-- @type    call
-- @param   to       (address) recipient's address
-- @param   tokenId  (str128) the NFT id
-- @param   ...      additional data, is sent unaltered in call to 'tokensReceived' on 'to'
-- @return  value returned from 'tokensReceived' callback, or nil
-- @event   mint(to, tokenId)
function mint(to, tokenId, ...)

-- return Max Supply
-- @type    query
-- @return  amount   (integer) amount of tokens to mint
function maxSupply()
```

### Approval extension

```lua
-- Change or reaffirm the approved address for an NFT
-- @type    call
-- @param   to          (address) the new approved NFT controller
-- @param   tokenId     (str128) the NFT token to approve
-- @event   approve(owner, to, tokenId)
function approve(to, tokenId) end

-- Get the approved address for a single NFT
-- @type    query
-- @param   tokenId  (str128) the NFT token to find the approved address for
-- @return  (address) the approved address for this NFT, or the zero address if there is none
function getApproved(tokenId) end

-- Allow operator to control all sender's token
-- @type    call
-- @param   operator  (address) a operator's address
-- @param   approved  (boolean) true if the operator is approved, false to revoke approval
-- @event   approvalForAll(owner, operator, approved)
function setApprovalForAll(operator, approved) end

-- Get allowance from owner to spender
-- @type    query
-- @param   owner       (address) owner's address
-- @param   operator    (address) allowed address
-- @return  (bool) true/false
function isApprovedForAll(owner, operator) end

-- Transfer a token of 'from' to 'to'
-- @type    call
-- @param   from    (address) a sender's address
-- @param   to      (address) a receiver's address
-- @param   tokenId (str128) the NFT token to send
-- @param   ...     (Optional) addtional data, MUST be sent unaltered in call to 'onARC2Received' on 'to'
-- @event   transfer(from, to, tokenId)
function transferFrom(from, to, tokenId, ...) end
```

### Pausable extension

``` lua
-- Indicate an account has the Pauser Role
-- @type    query
-- @param   account  (address)
-- @return  (bool) true/false
function isPauser(account)

-- Grant the Pauser Role to an account
-- @type    call
-- @param   account  (address)
-- @event   addPauser(account)
function addPauser(account)

-- Remove the Pauser Role form an account
-- @type    call
-- @param   account  (address)
-- @event   removePauser(account)
function removePauser(account)

-- Renounce the graned Pauser Role of TX sender
-- @type    call
-- @event   removePauser(TX sender)
function renouncePauser()

-- Indecate if the contract is paused
-- @type    query
-- @return  (bool) true/false
function paused()

-- Trigger stopped state
-- @type    call
-- @event   pause(TX sender)
function pause()

-- Return to normal state
-- @type    call
-- @event   unpause(TX sender)
function unpause()
```

### Blacklist extension

``` lua
-- Add accounts to blacklist
-- @type    call
-- @param   account_list (list of address)
-- @event   addToBlacklist(account_list)
function addToBlacklist(account_list)

-- Remove accounts from blacklist
-- @type    call
-- @param   account_list  (list of address)
-- @event   removeFromBlacklist(account_list)
function removeFromBlacklist(account_list)

-- Indicate if an account is on blacklist
-- @type    query
-- @param   account   (address)
function isOnBlacklist(account)
```


### Hook

Contracts that want to handle tokens must implement the following function to define how to handle the tokens they receive. If this function is not implemented, the token transfer will fail. Therefore, it is possible to prevent the token from being lost.

``` lua
-- The ARC2 smart contract calls this function on the recipient after a 'transfer'
-- @param   operator    (address) a address which called token 'transfer' function
-- @param   from        (address) a sender's address
-- @param   tokenId     (str128)  the NFT id
-- @param   ...         addtional data, by-passed from 'transfer' or 'mint' arguments
-- @type    call
function onARC2Received(operator, from, tokenId, ...) end
```
