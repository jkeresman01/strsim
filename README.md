<div align="center">

  <h1>strsim</h1>

  <h4>A string similarity library for Lua/LuaJIT</h4>
  <h6>A string similarity library providing edit distance and similarity algorithms.</h4>

  

[![Lua](https://img.shields.io/badge/Lua-blue.svg?style=for-the-badge&logo=lua)](http://www.lua.org)
[![Lua](https://img.shields.io/badge/Lua-blue.svg?style=for-the-badge&logo=lua)](http://www.lua.org)
[![Lua](https://img.shields.io/badge/Lua-blue.svg?style=for-the-badge&logo=lua)](http://www.lua.org)

</div>

## About ##
> [!NOTE]
> Still very WIP

A string similarity library for Lua/LuaJIT providing edit distance and similarity algorithms.

Check this out: 
- https://en.wikipedia.org/wiki/Edit_distance

- https://www.youtube.com/watch?v=ocZMDMZwhCY

## :star: <a name="installation"></a> Installation 

> [!NOTE]
> Library will be deployed to luarocks at some point 

Currently you will have to clone the repository manaully

```bash
git clone https://github.com/yourusername/strsim.git
```
> [!TIP]
> Or add as a dependency in your Lua path.


## Usage

```lua
local strsim = require("init")

local dist = strsim.distance("kitten", "sitting")  -- 3
local sim = strsim.similarity("hello", "hallo")    -- 0.8

-- Use specific algorithm
local dist = strsim.distance("hello", "hallo", strsim.Algorithm.LEVENSHTEIN)
```
> [!NOTE]
> If no algorithm is selected we will default to LEVENSHTEIN

## Algorithms ##

> [!NOTE]
> Only LEVENSHTEIN distance is supported currently


### LEVENSHTEIN - Levenshtein distance (insertions, deletions, substitutions) ###

Levenshtein distance is a string metric for measuring the difference between two sequences. 

Check this out:
https://en.wikipedia.org/wiki/Levenshtein_distance

> <b>Optimizations applied</b>
>
> - Single-row DP (O(min(m,n)) space instead of O(m*n))
> - Early termination for equal strings
> - Strippinmg common prefix/suffix
> - Swapping strings to minimize memory usage
> - Avoiding table.insert, using direct indexing
> - Using byte access instead of sub() for single chars

>  <b>Lua JIT specific optimizations applied:</b>
> - Using local variables for hot paths (LuaJIT optimization)

### DAMERAU_LEVENSHTEIN - Levenshtein + transpositions  ###

> [!NOTE]
> Planned


### OSA - Optimal String Alignment ###

> [!NOTE]
> Planned


### JARO - Jaro similarity ###

> [!NOTE]
> Planned


### JARO_WINKLER - Jaro-Winkler similarity ###

> [!NOTE]
> Planned

### Hamming - Hamming distance (same-length strings only) ###

> [!NOTE]
> Planned

### LCS - Longest Common Subsequence ###

> [!NOTE]
> Planned


