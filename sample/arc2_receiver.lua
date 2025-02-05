
-- ARC2 token receiver interface
function nonFungibleReceived(operator, from, tokenId, ...)
  contract.event("GotARC2", operator, from, tokenId, ...)
  return "GotARC2: " .. tokenId
end

function transferARC2(contractId, to, tokenId, ...)
  contract.call(contractId, "transfer", to, tokenId, ...)
end

abi.register(transferARC2, nonFungibleReceived)
