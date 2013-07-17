--[[
gLUAlib		: Graphics LUA Library
test.mat3	: Unit Test of mat3.lua
Author      : Dr. Goulu (www.3dmon.com)
2007.09.26	:
--]]

require 'mat3'

-- TEST PART
print("mat3 test ...")
local m1=mat3()
local m2=mat3(1,0,0,0,1,0,0,0,1)
assert(m1==m2) 

local m3=mat3({1,2,3},{6,5,4},{-7,8,9})
-- assert(tostring(m3)=="[(1.000000,2.000000,3.000000),(6.000000,5.000000,4.000000),(-7.000000,8.000000,9.000000)]")
assert(m3:y()==vec3(6,5,4))

local v1=vec3(1,5,9)
assert(m3:diag()==v1)
assert(m3:row(1)==vec3(1,6,-7))

assert(m3:transpose()==mat3(1,6,-7,2,5,8,3,4,9))

assert(m1+m2==2*m2)
assert(m1*m3==mat3(1,0,0,0,5,0,0,0,9))

assert(m1^v1==v1)
assert(m3^m1==m3)
assert(m1^m3==m3)

print(m3^m3)

print("... ok !")
