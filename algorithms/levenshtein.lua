----------------------------------------------------------------
---
---@module strsim.algorithms.levenshtein
---
--- Levenshtein distance algorithm optimized for LuaJIT
---
----------------------------------------------------------------

local min = math.min
local byte = string.byte

local levenshtein = {}

----------------------------------------------------------------
---
---Calculate the Levenshtein distance between two strings
---Uses Wagner-Fischer algorithm with single-row optimization
---
---@param a string First string
---@param b string Second string
---
---@return number distance The minimum edit distance
----------------------------------------------------------------
function levenshtein.distance(a, b)
    -- Handle nil inputs
    if a == nil then a = "" end
    if b == nil then b = "" end

    local len_a, len_b = #a, #b

    -- Early termination: identical strings
    if a == b then
        return 0
    end

    -- Early termination: one string is empty
    if len_a == 0 then return len_b end
    if len_b == 0 then return len_a end

    -- Ensure a is the shorter string (optimize space usage)
    if len_a > len_b then
        a, b = b, a
        len_a, len_b = len_b, len_a
    end

    -- Strip common prefix
    local prefix = 0
    while prefix < len_a and byte(a, prefix + 1) == byte(b, prefix + 1) do
        prefix = prefix + 1
    end

    -- Strip common suffix
    local suffix = 0
    while suffix < (len_a - prefix) and 
        byte(a, len_a - suffix) == byte(b, len_b - suffix) do
        suffix = suffix + 1
    end

    -- After stripping, check if anything remains
    local start_a = prefix + 1
    local start_b = prefix + 1
    len_a = len_a - prefix - suffix
    len_b = len_b - prefix - suffix

    if len_a == 0 then return len_b end
    if len_b == 0 then return len_a end

    -- Single-row DP array
    -- prev_row[j] represents the distance to transform a[1..i-1] to b[1..j]
    local prev_row = {}

    -- Initialize first row: transforming empty string to b[1..j]
    for j = 0, len_b do
        prev_row[j] = j
    end

    -- Fill the DP matrix row by row
    for i = 1, len_a do
        local char_a = byte(a, start_a + i - 1)
        local prev_diag = prev_row[0]  -- Value from previous diagonal
        prev_row[0] = i                 -- Cost of deleting i characters from a

        for j = 1, len_b do
            local char_b = byte(b, start_b + j - 1)
            local old_val = prev_row[j]

            if char_a == char_b then
                -- Characters match: no operation needed
                prev_row[j] = prev_diag
            else
                -- Minimum of: substitution, insertion, deletion
                local substitute = prev_diag + 1
                local insert = prev_row[j] + 1      -- prev_row[j] is cell above
                local delete = prev_row[j - 1] + 1  -- prev_row[j-1] is cell to left

                prev_row[j] = min(substitute, min(insert, delete))
            end

            prev_diag = old_val
        end
    end

    return prev_row[len_b]
end

------------------------------------------------------------
---
---Calculate similarity between two strings (0.0 to 1.0)
---
---@param a string First string
---@param b string Second string
---
---@return number similarity Normalized similarity score
---
------------------------------------------------------------
function levenshtein.similarity(a, b)
    if a == nil then a = "" end
    if b == nil then b = "" end

    local len_a, len_b = #a, #b

    if len_a == 0 and len_b == 0 then
        return 1.0
    end

    local max_len = len_a > len_b and len_a or len_b
    local dist = levenshtein.distance(a, b)

    return 1.0 - (dist / max_len)
end

return levenshtein
