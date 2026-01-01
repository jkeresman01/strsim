------------------------------------------------------------
---@class StringDistanceAlgorithm
---
---@field name string
---@field distance fun(a: string, b: string): number
---@field similarity? fun(a: string, b: string): number
---
------------------------------------------------------------
local Algorithm = {}

------------------------------------------------------------
---
---Define an algorithm with a name
---
---@param name string
---@param module table
---
---@return StringDistanceAlgorithm
---
------------------------------------------------------------
local function define(name, module)
  module.name = name
  return module
end

Algorithm.LEVENSHTEIN = define(
  "LEVENSHTEIN",
  require("algorithms.levenshtein")
)

-- TODO: Implement rest of the party
-- Placeholder for future algorithms
-- Algorithm.DAMERAU_LEVENSHTEIN = define(
--   "DAMERAU_LEVENSHTEIN",
--   require("strsim.algorithms.damerau")
-- )
-- Algorithm.JARO_WINKLER = define(
--   "JARO_WINKLER",
--   require("strsim.algorithms.jaro_winkler")
-- )

return setmetatable(Algorithm, {
  __newindex = function()
    error("strsim.Algorithm is read-only", 2)
  end
})
