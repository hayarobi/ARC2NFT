------------------------------------------------------------------------------
-- Aergo Standard NFT Interface (Proposal) - 20210425
------------------------------------------------------------------------------

extensions["searchable"] = true

local function escape(str)
  return str:gsub("[%(%)%.%%%+%-%*%?%[%]%^%$]", function(c) return "%" .. c end)
end

local function token_matches(tokenId, query)

  if tokenId == nil then
    return false
  end

  local token = _tokens[tokenId]

  local pattern = query["pattern"]
  local metadata = query["metadata"]

  if pattern then
    if not tokenId:match(pattern) then
      return false
    end
  end

  if metadata then
    for key,find in pairs(metadata) do
      local op = find["op"]
      local value = find["value"]
      local neg = false
      local matches = false
      if string.sub(op,1,1) == "!" then
        neg = true
        op = string.sub(op, 2)
      end
      local token_value = token[key]
      if token_value == nil and op ~= "=" then
        -- does not match
      elseif op == "=" then
        matches = token_value == value
      elseif op == ">" then
        matches = token_value > value
      elseif op == ">=" then
        matches = token_value >= value
      elseif op == "<" then
        matches = token_value < value
      elseif op == "<=" then
        matches = token_value <= value
      elseif op == "between" then
        matches = (token_value >= value and token_value <= find["value2"])
      elseif op == "match" then
        matches = string.match(token_value, value) ~= nil
      else
        assert(false, "operator not known: " .. op)
      end
      if neg then matches = not matches end
      if not matches then return false end
    end
  end

  return true
end

-- retrieve the first token found that mathes the query
-- the query is a table that can contain these fields:
--   owner    - the owner of the token (address)
--   contains - check if the tokenId contains this string
--   pattern  - check if the tokenId matches this Lua regex pattern
-- the prev_index must be 0 in the first call
-- for the next calls, just inform the returned index from the previous call
-- return value: (2 values) index, tokenId
-- if no token is found with the given query, it returns (nil, nil)
function findToken(query, prev_index)
  _typecheck(query, 'table')
  _typecheck(prev_index, 'uint')

  local contains = query["contains"]
  if contains then
    query["pattern"] = escape(contains)
  end

  local index, tokenId
  local owner = query["owner"]

  if owner then
    -- iterate over the tokens from this user
    local list = _user_tokens[owner] or {}
    local check_tokens = (prev_index == 0)

    for position,index2 in ipairs(list) do
      if check_tokens then
        tokenId = _ids[tostring(index2)]
        if token_matches(tokenId, query) then
          index = index2
          break
        else
          tokenId = nil
        end
      elseif index2 == prev_index then
        check_tokens = true
      end
    end

  else
    -- iterate over all the tokens
    local last_index = _last_index:get()
    index = prev_index

    while tokenId == nil and index < last_index do
      index = index + 1
      tokenId = _ids[tostring(index)]
      if not token_matches(tokenId, query) then
        tokenId = nil
      end
    end
  end

  if tokenId == nil then
    index = nil
  end

  return index, tokenId
end


abi.register_view(findToken)
