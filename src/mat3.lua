--[[
gLUAlib		: Graphics LUA Library
mat3.lua    : LUA Class for 3x3 matrix, column major, with operator overload
Author      : Dr. Goulu (www.3dmon.com)
2007.09.25  : derived from vec3
--]]

require 'vec3'
--require 'class'

-- constructor :
-- mat3()	:returns a null matrix
-- mat3(1)	:identity matrix
-- mat3(x,y,z)	: column vectors x,y,z
-- mat3({x,y,z}): column vectors x,y,z
-- mat3(9 numbers) : filled in column order
mat3 = class(function(pt,m11,m12,m13,m21,m22,m23,m31,m32,m33)
	if not m11 then m11=1 end
	if not m12 then m12=0 end
	if not m13 then m13=0 end
	if not m21 then m21=0 end
	if not m22 then m22=m11 end
	if not m23 then m23=0 end	
	if not m31 then m31=0 end
	if not m32 then m32=0 end
	if not m33 then m33=m11 end   
	pt:set(m11,m12,m13,m21,m22,m23,m31,m32,m33)
 end)

function mat3.set(pt,m11,m12,m13,m21,m22,m23,m31,m32,m33)
	if type(m11) == 'table' then
		if type(m12) == 'table' then -- 3 vectors
			m21=m12[1]; m22=m12[2]; m23=m12[3]
			m31=m13[1]; m32=m13[2]; m33=m13[3]
			m12=m11[2]; m13=m11[3]; m11=m11[1] -- must be last!
		else -- 3x3 table in m11
			               m12=m11[1][2]; m13=m11[1][3]
			m21=m11[2][1]; m22=m11[2][2]; m23=m11[2][3]
			m31=m11[3][1]; m32=m11[3][2]; m33=m11[3][3]
			m11=m11[1][1] -- must be last!
		end
	end
	pt[1]=vec3(m11,m12,m13)
	pt[2]=vec3(m21,m22,m23)
	pt[3]=vec3(m31,m32,m33)
end

function mat3.x(self) return self[1] end
function mat3.y(self) return self[2] end
function mat3.z(self) return self[3] end

function mat3.diag(self)
	return vec3(self[1][1], self[2][2], self[3][3])
end

function mat3.row(self,i)
	return vec3(self[1][i], self[2][i], self[3][i])
end

function mat3.transpose(self)
	return mat3(self:row(1),self:row(2),self:row(3))
end

function mat3.__eq(p1,p2)
  return (p1[1]==p2[1]) and (p1[2]==p2[2]) and (p1[3]==p2[3])
end


-- mat3 addition is '+','-'
function mat3.__add(p1,p2)
  return mat3(p1[1]+p2[1], p1[2]+p2[2], p1[3]+p2[3])
end

function mat3.__sub(p1,p2)
  return mat3(p1[1]-p2[1], p1[2]-p2[2], p1[3]-p2[3])
end

-- unitary minus  (e.g in the expression f(-p))
function vec3.__unm(p)
  return vec3(-p[1], -p[2], -p[3])
end

-- scalar and compoent-wise multiplication and division is '*' and '/' respectively
function mat3.__mul(s,p)
	if type(s) == 'table' then
		return mat3( s[1]*p[1], s[2]*p[2], s[3]*p[3] )
	else
		return mat3( s*p[1], s*p[2], s*p[3] )
	end
end

function mat3.__div(p,s)
	if type(s) == 'table' then
		return mat3( p[1]/s[1], p[2]/s[2], p[3]/s[3] )
	else
		return mat3( p[1]/s, p[2]/s, p[3]/s )
	end
end

-- dot product is '^'
function mat3.__pow(p1,p2)
	local m=p1:transpose()
	if p2:is_a(vec3) then
		return vec3(m[1]^p2, m[2]^p2, m[3]^p2)
	elseif p2:is_a(mat3) then
		return mat3(m[1]^p2[1], m[2]^p2[1], m[3]^p2[1],
					m[1]^p2[2], m[2]^p2[2], m[3]^p2[2],
					m[1]^p2[3], m[2]^p2[3], m[3]^p2[3])
	end	
	error("mat3.__pow("..type(p1)..","..type(p2)..") not implemented")	
end

function mat3.__tostring(p)	
	local v1=tostring(p[1]).."\n "
	local v2=tostring(p[2]).."\n "
	local v3=tostring(p[3])
	return "["..v1..v2..v3.."]"
end

function mat3.__concat(s,p)	
	return s..tostring(p)
end
