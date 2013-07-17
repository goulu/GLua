--[[
gLUAlib		: Graphics LUA Library
vec3.lua    : LUA Class for 3D Vectors with operator overload
Author      : Dr. Goulu (www.3dmon.com)
2007.09.08  : adapted from http://lua-users.org/wiki/PointAndComplex
2007.09.14  : modified to mock Lingo vector
2007.09.25  : remodified to mock GLSL vec3 vector and moved Lingo vector to lingo.lua
--]]

require 'class'

vec3 = class(function(pt,x,y,z)
	z=z or 0
	y=y or 0
	x=x or 0
   pt:set(x,y,z)
 end)
 
function vec3.set(pt,x,y,z)
  if type(x) == 'table' and getmetatable(x) == vec3 then
     local po = x
     x = po[1]
     y = po[2]
     z = po[3]
  end
  pt[1] = x
  pt[2] = y
  pt[3] = z
end



function vec3.__eq(p1,p2)
  return (p1[1]==p2[1]) and (p1[2]==p2[2]) and (p1[3]==p2[3])
end

function vec3.get(p)
  return p[1],p[2],p[3]
end

-- vec3 addition is '+','-'
function vec3.__add(p1,p2)
  return vec3(p1[1]+p2[1], p1[2]+p2[2], p1[3]+p2[3])
end

function vec3.__sub(p1,p2)
  return vec3(p1[1]-p2[1], p1[2]-p2[2], p1[3]-p2[3])
end

-- unitary minus  (e.g in the expression f(-p))
function vec3.__unm(p)
  return vec3(-p[1], -p[2], -p[3])
end

-- scalar and compoent-wise multiplication and division is '*' and '/' respectively
function vec3.__mul(s,p)
	if type(s) == 'table' then
		return vec3( s[1]*p[1], s[2]*p[2], s[3]*p[3] )
	else
		return vec3( s*p[1], s*p[2], s*p[3] )
	end
end

function vec3.__div(p,s)
	if type(s) == 'table' then
		return vec3( p[1]/s[1], p[2]/s[2], p[3]/s[3] )
	else
		return vec3( p[1]/s, p[2]/s, p[3]/s )
	end
end

-- dot product is '^'
function vec3.__pow(p1,p2)
   return p1[1]*p2[1] + p1[2]*p2[2] + p1[3]*p2[3]
end

function vec3.cross(p1,p2)
   return vec3(
     p1[2]*p2[3] - p1[3]*p2[2],
     p1[3]*p2[2] - p1[1]*p2[3],
     p1[1]*p2[2] - p1[2]*p2[1]
   )
end

function vec3.normalize(p)
  local l = p:len()
  p[1] = p[1]/l
  p[2] = p[2]/l
  p[3] = p[3]/l
end

function vec3.translate(pt,x,y,z)
   pt[1] = pt[1] + x
   pt[2] = pt[2] + y
   pt[3] = pt[3] + z
end

function vec3.__tostring(p)	
	return string.format('(%f,%f,%f)',p[1],p[2],p[3])
end

function vec3.__concat(s,p)	
	return tostring(s)..tostring(p)
end

function vec3.len(p)
	local function sqr(x) return x*x end
	return math.sqrt(sqr(p[1]) + sqr(p[2]) + sqr(p[3]))
end
