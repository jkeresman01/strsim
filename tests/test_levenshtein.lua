#!/usr/bin/env luajit
---@module test_levenshtein
--- test suite for Levenshtein distance algorithm

-- Setup package path
package.path = "./?.lua;" .. package.path

local levenshtein = require("algorithms.levenshtein")
local Algorithm = require("algorithm")

local tests_run = 0
local tests_passed = 0
local tests_failed = 0

local function test(name, condition, message)
    tests_run = tests_run + 1
    if condition then
        tests_passed = tests_passed + 1
        print(string.format("  PASS: %s", name))
    else
        tests_failed = tests_failed + 1
        print(string.format("  FAIL: %s: %s", name, message or "assertion failed"))
    end
end

local function assert_eq(name, expected, actual)
    local passed = expected == actual
    local msg = passed and nil or string.format("expected %s, got %s", tostring(expected), tostring(actual))
    test(name, passed, msg)
end

local function assert_near(name, expected, actual, epsilon)
    epsilon = epsilon or 0.0001
    local diff = math.abs(expected - actual)
    local passed = diff < epsilon
    local msg = passed and nil or string.format("expected ~%s, got %s (diff: %s)", expected, actual, diff)
    test(name, passed, msg)
end

local function section(name)
    print(string.format("\n[%s]", name))
end

section("Basic Distance Tests")

assert_eq("empty strings", 0, levenshtein.distance("", ""))
assert_eq("empty to non-empty", 5, levenshtein.distance("", "hello"))
assert_eq("non-empty to empty", 5, levenshtein.distance("hello", ""))
assert_eq("identical strings", 0, levenshtein.distance("hello", "hello"))
assert_eq("single char difference", 1, levenshtein.distance("hello", "hallo"))
assert_eq("single insertion", 1, levenshtein.distance("hello", "helloo"))
assert_eq("single deletion", 1, levenshtein.distance("hello", "hell"))

section("Classic Examples")

assert_eq("kitten->sitting", 3, levenshtein.distance("kitten", "sitting"))
assert_eq("sitting->kitten", 3, levenshtein.distance("sitting", "kitten"))
assert_eq("saturday->sunday", 3, levenshtein.distance("saturday", "sunday"))
assert_eq("sunday->saturday", 3, levenshtein.distance("sunday", "saturday"))
assert_eq("flaw->lawn", 2, levenshtein.distance("flaw", "lawn"))
assert_eq("gumbo->gambol", 2, levenshtein.distance("gumbo", "gambol"))

section("Edge Cases")

assert_eq("single char same", 0, levenshtein.distance("a", "a"))
assert_eq("single char diff", 1, levenshtein.distance("a", "b"))
assert_eq("completely different", 5, levenshtein.distance("abcde", "fghij"))
assert_eq("prefix match", 2, levenshtein.distance("abc", "abcde"))
assert_eq("suffix match", 2, levenshtein.distance("cde", "abcde"))

section("Unicode Handling")

-- Note: Lua's # counts bytes, not characters
-- These tests verify the algorithm works with byte sequences
assert_eq("identical unicode", 0, levenshtein.distance("cafe", "cafe"))

section("Case Sensitivity")

assert_eq("case different", 1, levenshtein.distance("Hello", "hello"))
assert_eq("all caps diff", 5, levenshtein.distance("HELLO", "hello"))

section("Whitespace Handling")

assert_eq("space insertion", 1, levenshtein.distance("hello", "hel lo"))
assert_eq("leading space", 1, levenshtein.distance("hello", " hello"))
assert_eq("trailing space", 1, levenshtein.distance("hello", "hello "))
assert_eq("single space removal", 1, levenshtein.distance("hello world", "helloworld"))

section("Symmetry Tests")

local function test_symmetric(a, b)
    local d1 = levenshtein.distance(a, b)
    local d2 = levenshtein.distance(b, a)
    assert_eq(string.format("symmetric: '%s' <-> '%s'", a, b), d1, d2)
end

test_symmetric("algorithm", "altruistic")
test_symmetric("test", "testing")
test_symmetric("abc", "xyz")
test_symmetric("", "nonempty")

section("Similarity Tests")

assert_near("identical similarity", 1.0, levenshtein.similarity("hello", "hello"))
assert_near("empty strings similarity", 1.0, levenshtein.similarity("", ""))
assert_near("completely different similarity", 0.0, levenshtein.similarity("abc", "xyz"))
assert_near("one char diff similarity", 0.8, levenshtein.similarity("hello", "hallo")) -- 1 - 1/5

section("Algorithm Enum Tests")

assert_eq("algorithm name", "LEVENSHTEIN", Algorithm.LEVENSHTEIN.name)
assert_eq("algorithm has distance fn", "function", type(Algorithm.LEVENSHTEIN.distance))

local ok, err = pcall(function()
    Algorithm.NEW_ALGO = {}
end)
test("algorithm enum is read-only", not ok, err)

section("Stress Tests")

-- Generate long strings for performance testing
local function make_string(len, base)
    local t = {}
    for i = 1, len do
        t[i] = string.char(97 + ((base + i) % 26))
    end
    return table.concat(t)
end

local long_a = make_string(100, 0)
local long_b = make_string(100, 1)
local start_time = os.clock()
local long_dist = levenshtein.distance(long_a, long_b)
local elapsed = os.clock() - start_time

test("long strings (100 chars)", long_dist > 0 and long_dist <= 100)
print(string.format("    (distance: %d, time: %.4fs)", long_dist, elapsed))

-- Very long strings
local very_long_a = make_string(500, 0)
local very_long_b = make_string(500, 3)
start_time = os.clock()
local very_long_dist = levenshtein.distance(very_long_a, very_long_b)
elapsed = os.clock() - start_time

test("very long strings (500 chars)", very_long_dist > 0 and very_long_dist <= 500)
print(string.format("    (distance: %d, time: %.4fs)", very_long_dist, elapsed))

section("Common Prefix/Suffix Optimization Tests")

-- These should be fast due to prefix/suffix stripping
assert_eq("common prefix", 1, levenshtein.distance("prefixA", "prefixB"))
assert_eq("common suffix", 1, levenshtein.distance("Asuffix", "Bsuffix"))
assert_eq("common prefix and suffix", 1, levenshtein.distance("prefixAsuffix", "prefixBsuffix"))
assert_eq("long common prefix", 2, levenshtein.distance("thisisaverylongprefixAB", "thisisaverylongprefixCD"))

section("Nil Input Handling")

assert_eq("nil first arg", 5, levenshtein.distance(nil, "hello"))
assert_eq("nil second arg", 5, levenshtein.distance("hello", nil))
assert_eq("both nil", 0, levenshtein.distance(nil, nil))

section("Special Characters")

assert_eq("newlines", 1, levenshtein.distance("hello\nworld", "helloworld"))
assert_eq("tabs", 1, levenshtein.distance("hello\tworld", "hello world"))
assert_eq("mixed special", 0, levenshtein.distance("a\t\n\r", "a\t\n\r"))

section("Benchmark")

local function benchmark(name, iterations, fn)
    -- Warmup
    for _ = 1, 100 do fn() end

    local start = os.clock()
    for _ = 1, iterations do
        fn()
    end
    elapsed = os.clock() - start

    print(string.format("  %s: %d iterations in %.3fs (%.0f ops/sec)", 
    name, iterations, elapsed, iterations / elapsed))
end

local str_short_a = "kitten"
local str_short_b = "sitting"
local str_med_a = "the quick brown fox jumps"
local str_med_b = "the quick brown dog leaps"
local str_long_a = make_string(200, 0)
local str_long_b = make_string(200, 5)

benchmark("short strings (7 chars)", 100000, function()
    levenshtein.distance(str_short_a, str_short_b)
end)

benchmark("medium strings (25 chars)", 10000, function()
    levenshtein.distance(str_med_a, str_med_b)
end)

benchmark("long strings (200 chars)", 1000, function()
    levenshtein.distance(str_long_a, str_long_b)
end)





print(string.format("\n" .. string.rep("=", 50)))
print(string.format("Tests: %d total, %d passed, %d failed", 
tests_run, tests_passed, tests_failed))
print(string.rep("=", 50))

if tests_failed > 0 then
    os.exit(1)
else
    print("All tests passed!")
    os.exit(0)
end
