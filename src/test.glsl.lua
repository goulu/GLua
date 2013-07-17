--[[
gLUAlib		: Graphics LUA Library
test.glsl	: Unit test of glsl.lua
Author      : Dr. Goulu (www.3dmon.com)
2007.09.08  : 
--]]


print("testing glsl.lua ...")
require "glsl"

assert(radians(180)==math.pi)
assert(equal(degrees(math.pi/2),90))

a=radians({10,90,179})
assert(equal(acos(cos(a)),a))

a=radians({-80,0,60})
assert(equal(asin(sin(a)),a))

assert(equal(atan(tan(a)),a))

a=radians({-179,-45,30,120})
assert(equal(atan(sin(a),cos(a)),a))

a={1,2,3}
assert(equal(mul(sqrt(a),invsqrt(a)),{1,1,1}))

assert(equal(floor({-3.2,4.9}),{-4,4}))
assert(equal(ceil({-3.2,4.9}),{-3,5}))

a={-2,0,3}
assert(equal(mul(abs(a),sign(a)),a))

assert(min(2,3)==2)
assert(equal(min({1,2,3},2),{1,2,2}))

assert(equal(fract({-1.2, -0.2, 0.2, 1.2}),{-.2,-.2,.2,.2}))

assert(max(2,-3)==2)
assert(equal(max({1,2,3},2),{2,2,3}))

assert(equal(clamp({-3,1,3},-2,2),{-2,1,2}))
assert(equal(clamp({-3,1,3},{-2,0,1},{2,2,2}),{-2,1,2}))

assert(mix(1,3,.5)==2)
assert(equal(mix({-3,1,3},{1,-3,7},.5),{-1,-1,5}))
assert(equal(mix({-3,1,3},{1,-3,7},{.25,.75,.5}),{-2,-2,5}))

assert(dot({1,0,2},{0,1,2})==4)
assert(length({3,4})==5)
assert(distance({1,2,3},{4,5,6})==math.sqrt(27))
assert(length(normalize({1.1,2.2,-3.3}))==1.0)

assert(all({true,1,3==3,4>2}))
assert(any({false,0,3==3,4<2}))

assert(equal(angle({1,0,0},{0,1,0}),math.pi/2))
assert(equal(angle({1,0,0},{0,-1,0}),math.pi/2))
assert(equal(angle({-1,0,0},{0,-1,0}),math.pi/2))
assert(equal(angle({-1,0,0},{0,1,0}),math.pi/2))
assert(equal(angle({-1,0,0},{1,0,0}),math.pi))

print("... ok !")
