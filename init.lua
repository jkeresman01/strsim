------------------------------------------------------------
---
---@module strsim
---
--- String similarity library for Lua/LuaJIT
--- Provides various string distance and similarity algorithms
---
------------------------------------------------------------

local Algorithm = require("strsim.algorithm")

local strsim = {}

------------------------------------------------------------
---
--- Default algorithm for distance/similarity calculations
---
------------------------------------------------------------
local DEFAULT_ALGORITHM = Algorithm.LEVENSHTEIN

------------------------------------------------------------
---
---Calculate the edit distance between two strings
---@param a string First string
---@param b string Second string
---@param algorithm? StringDistanceAlgorithm Algorithm to use (default: LEVENSHTEIN)
---
---@return number distance The edit distance
------------------------------------------------------------
function strsim.distance(a, b, algorithm)
    algorithm = algorithm or DEFAULT_ALGORITHM
    return algorithm.distance(a, b)
end

------------------------------------------------------------
---
---Calculate the similarity between two strings (0.0 to 1.0)
---
---@param a string First string
---@param b string Second string
---@param algorithm? StringDistanceAlgorithm Algorithm to use (default: LEVENSHTEIN)
---
---@return number similarity Similarity score between 0.0 and 1.0
---
------------------------------------------------------------
function strsim.similarity(a, b, algorithm)
    algorithm = algorithm or DEFAULT_ALGORITHM
    return algorithm.similarity(a, b)
end

strsim.Algorithm = Algorithm

return strsim
