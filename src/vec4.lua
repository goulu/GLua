--[[
gLUAlib		: Graphics LUA Library
vec3.lua    : LUA Class for 4D Vectors with operator overload
Author      : Dr. Goulu (www.3dmon.com)
2008.01.30  : edited from vec3
--]]

require 'class'

vec4 = class(function(pt,x,y,z,w)
	z=z or 0
	y=y or 0
	x=x or 0
	w=w or 0
   pt:set(x,y,z,w)
 end)
 
function vec4.set(pt,x,y,z,w)
  if type(x) == 'table' and getmetatable(x) == vec3 then
     local po = x
     x = po[1]
     y = po[2]
     z = po[3]
     w = po[4]
  end
  pt[1] = x
  pt[2] = y
  pt[3] = z
  pt[4] = w
end



function vec4.__eq(p1,p2)
  return (p1[1]==p2[1]) and (p1[2]==p2[2]) and (p1[3]==p2[3]) and (p1[4]==p2[4])
end

function vec4.get(p)
  return p[1],p[2],p[3],p[4]
end

function vec4.__add(p1,p2)
  return vec4(p1[1]+p2[1], p1[2]+p2[2], p1[3]+p2[3],p1[4]+p2[4])
end

function vec4.__sub(p1,p2)
  return vec4(p1[1]-p2[1], p1[2]-p2[2], p1[3]-p2[3],p1[4]-p2[4])
end

-- unitary minus  (e.g in the expression f(-p))
function vec4.__unm(p)
  return vec4(-p[1], -p[2], -p[3], -p[4])
end

-- scalar and compoent-wise multiplication and division is '*' and '/' respectively
function vec4.__mul(s,p)
	if type(s) == 'table' then
		return vec4( s[1]*p[1], s[2]*p[2], s[3]*p[3], s[4]*p[4] )
	else
		return vec4( s*p[1], s*p[2], s*p[3], s*p[4] )
	end
end

function vec4.__div(p,s)
	if type(s) == 'table' then
		return vec3( p[1]/s[1], p[2]/s[2], p[3]/s[3], p[4]/s[4] )
	else
		return vec3( p[1]/s, p[2]/s, p[3]/s, p[4]/s )
	end
end

-- dot product is '^'
function vec4.__pow(p1,p2)
   return p1[1]*p2[1] + p1[2]*p2[2] + p1[3]*p2[3] + p1[4]*p2[4]
end

function vec4.normalize(p)
  local l = p:len()
  p[1] = p[1]/l
  p[2] = p[2]/l
  p[3] = p[3]/l
  p[4] = p[4]/l
end

function vec4.__tostring(p)	
	return string.format('(%f,%f,%f,%f)',p[1],p[2],p[3],p[4])
end

function vec4.__concat(s,p)	
	return tostring(s)..tostring(p)
end

function vec4.len(p)
	return math.sqrt(p^p)
end
