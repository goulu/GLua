--[[
gLUAlib		: Graphics LUA Library
test.vec3	: Test and benchmark of vec3.lua
Author      : Dr. Goulu (www.3dmon.com)
2007.09.08  : surprise ! the vector class is faster than table ops !! ???
--]]


print("testing vec3...")
require "vec3"
local v1=vec3()

v1 = vec3(1,2,3)
assert("v1="..v1=="v1=(1.000000,2.000000,3.000000)")	

v2 = vec3(4,5,6)
assert(v1+v2==vec3(5,7,9))
assert(v1-v2==vec3(-3,-3,-3))

assert(v1*v2==vec3(4,10,18))
assert(v1/v2==vec3(1/4,2/5,1/2))

assert(2*v1==vec3(2,4,6))
assert(v2/2==vec3(2,2.5,3))

assert(v1^v2==32) -- dot product
print ("cross(v1,v2)="..vec3.cross(v1,v2)) -- cross product
print ("... ok !")

if os then -- we have a clock, so we can do some benchmarks
	print("vec3 benchmark ...")
	local n=1000
	local p
	local t = os.clock()
	for i=1,n do
		p=v1^v2
	end
	print(string.format("vec3 class: %.2f\n", os.clock() - t))
	
	v1={1,2,3}
	v2={4,5,6}
	t = os.clock()
	for i=1,n do
		p=v1[1]*v2[1]+v1[2]*v2[2]+v1[3]*v2[3]
	end
	print(string.format("array: %.2f\n", os.clock() - t))
	print("... ok !")
end

