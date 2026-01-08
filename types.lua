--------------------------------------------------------------------------------------
---@meta

---@class StringDistanceAlgorithm
---@field name string The algorithm name
---@field distance fun(a: string, b: string): number Calculate edit distance
---@field similarity fun(a: string, b: string): number Calculate similarity

---@class strsim.AlgorithmEnum
---@field LEVENSHTEIN StringDistanceAlgorithm Levenshtein edit distance
---@field DAMERAU_LEVENSHTEIN StringDistanceAlgorithm Damerau-Levenshtein distance
---@field JARO_WINKLER StringDistanceAlgorithm Jaro-Winkler similarity
---@field HAMMING StringDistanceAlgorithm Hamming distance
---@field LCS StringDistanceAlgorithm Longest Common Subsequence
---@field OSA StringDistanceAlgorithm Optimal String Alignment
---@field JARO StringDistanceAlgorithm Jaro similarity

---@class strsim
---
---@field Algorithm strsim.AlgorithmEnum Available algorithms
--------------------------------------------------------------------------------------
local strsim = {}

--------------------------------------------------------------------------------------
---
---Calculate the edit distance between two strings
---
---@param a string First string
---@param b string Second string
---@param algorithm? StringDistanceAlgorithm Algorithm to use (default: LEVENSHTEIN)
---
---@return number distance The edit distance
---
--------------------------------------------------------------------------------------
function strsim.distance(a, b, algorithm) end

--------------------------------------------------------------------------------------
---
---Calculate the similarity between two strings (0.0 to 1.0)
---
---@param a string First string
---@param b string Second string
---@param algorithm? StringDistanceAlgorithm Algorithm to use (default: LEVENSHTEIN)
---
---@return number similarity Similarity score between 0.0 and 1.0
---
--------------------------------------------------------------------------------------
function strsim.similarity(a, b, algorithm) end

return strsim
