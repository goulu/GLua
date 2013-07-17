--[[
gLUAlib		: Graphics LUA Library
glsl.lua	: mimics GLSL language
Author      : Dr.Goulu (www.3dmon.com)
2007.09.22  : started based on book "OpenGL Shading Language" by Randi J. Rost
2007.10.15  : added angle from http://www.plunk.org/~hatch/rightway.php
2008.02.29  : improved dot to support matrix.vector
--]]

-- generic functional functions

--- applies a function to a table of parameters
-- @param f : function to apply to each element in v
-- @param v : (vector of) parameter(s) to f function
-- @return  : (vector of) result(s) of f(v)
function apply(f,v)
	if type(v)=="number" then return f(v) end
	if type(v)=="table" then
	    local res={}
		for i,x in ipairs(v) do res[i]=f(x) end
		return res
	end
	error("apply "..f.."("..type(v)..") not implemented")
end

local function apply2(f,v1,v2)
	if type(v1)=="number" then return f(v1,v2) end
	if type(v1)=="table" then
	    local res={}
		if type(v2)=="number" then
            for i,x in ipairs(v1) do res[i]=f(x,v2) end
		else
			for i,x in ipairs(v1) do res[i]=f(x,v2[i]) end
		end
		return res
	end
	error("apply "..f.."("..type(v)..") not implemented")
end

-- 5.1 Angle and Trigonometry Functions (p.118-120)

function radians(deg)
	return apply(math.rad,deg)
end

function degrees(rad)
	return apply(math.deg,rad)
end

function sin(rad)
	return apply(math.sin,rad)
end

function cos(rad)
	return apply(math.cos,rad)
end

function tan(rad)
	return apply(math.tan,rad)
end

function asin(x)
	return apply(math.asin,x)
end

function acos(x)
	return apply(math.acos,x)
end

function atan(y,x)
	if not x then
		return apply(math.atan,y)
	else
	    return apply2(math.atan2,y,x)
	end
end

-- 5.2 Exponential Functions (p.121)

function pow(x,y)
	return apply2(math.pow,x,y)
end

function exp2(x)
	return apply2(math.pow,2,x)
end

function log2(x)
	return apply(math.log,x)/math.log(2)
end

function sqrt(x)
	return apply(math.sqrt,x)
end

local function inv(x)
	return apply(function(x) return 1/x end,x)
end

function invsqrt(x)
	return inv(sqrt(x))
end

-- 5.3 Common Functions (p.122-124)

function abs(x)
	return apply(math.abs,x)
end

function sign(x)
	return apply(function(x) if x<0 then return -1 end if x>0 then return 1 end return 0 end,x)
end

function ceil(x)
	return apply(math.ceil,x)
end

function floor(x)
	return apply(math.floor,x)
end

function mod(x,y)
	return apply2(function(x,y) return x % y end,x,y)
end

function fract(x)
	return apply(function(x) local i,f = math.modf(x) return f end,x)
end

function min(a,b)
	return apply2(math.min,a,b)
end

function max(a,b)
	return apply2(math.max,a,b)
end

function clamp(x,l,h)
	return min(max(x,l),h)
end

function mix(x,y,a)
	return add(x,mul(sub(y,x),a))
end

function step(edge,x)
	return apply2(function(x,x0) if x>x0 then return 1 end return 0 end,x,edge)
end

function smoothstep(edge0,edge1,x)
	error("smoothstep() not yet implemented")
end

-- non GLSL-like but nevertheless useful functions

function add(x,y)
	return apply2(function(x,y) return x + y end,x,y)
end

function sub(x,y)
	return apply2(function(x,y) return x - y end,x,y)
end

function mul(x,y)
	if type(x)=="number" then -- swap params, just in case y is a vector
		return apply2(function(x,y) return x * y end,y,x)
	else
 		return apply2(function(x,y) return x * y end,x,y)
	end
end

function div(x,y)
	return apply2(function(x,y) return x / y end,x,y)
end


-- 5.4 Geometric Functions (p.130)

function dot(v1,v2)
	--if type(v1)~=type(v2) then error("dot requires 2 params of the same type") end
	if type(v1)=="number" then return v1*v2 end
	if type(v1)=="table" then
		if type(v1[1])=="number" then -- vector.vector
		    local res=0
			for i,x in ipairs(v1) do res=res+x*v2[i] end
			return res
		else -- matrix.vector
			local res={}
			for i,x in ipairs(v1) do res[i]=dot(x,v2) end
			return res
		end
	end
	error("dot("..type(v1)..type(v2)..") not implemented")
end

function length(v)
	return math.sqrt(dot(v,v))
end

function distance(v1,v2)
	return length(sub(v1,v2))
end

function normalize(v1)
	return div(v1,length(v1))
end

function faceforward(n,i,nref)
	if dot(n,i)<0 then return n else return -n end
end

function reflect(i,n)
	return sub(i,mul(mul(2,dot(n,i)),n))
end

-- 5.6 Vector Relational Functions (p. 133)

-- return true if any component of f(b) is true
function any(b,f)
	if not f then f=(function(x) return x end) end
	if type(b)=="boolean" then return f(b) end
	if type(b)=="number" then return f(b) end
	if type(b)=="table" then
		for i,v in ipairs(b) do
   			if f(v)==true then return true end
		end
		return false
	end
	error("any("..type(b)..")not implemented")
end

-- return true if all components of f(b) are true
function all(b,f)
	if not f then f=(function(x) return x end) end
	if type(b)=="boolean" then return f(b) end
	if type(b)=="number" then return f(b) end
	if type(b)=="table" then
		for i,v in ipairs(b) do
   			if not f(v)==true then return false end
		end
		return true
	end
	error("all("..type(b)..")not implemented")
end

-- improved equality test with tolerance
function equal(v1,v2,tol)
	assert(type(v1)==type(v2),"equal("..type(v1)..","..type(v2)..") : incompatible types")
	if not tol then tol=1E-12 end
	return apply(function(x) return x<=tol end,abs(sub(v1,v2)))
end

function notEqual(v1,v2,tol)
	assert(type(v1)==type(v2),"equal("..type(v1)..","..type(v2)..") : incompatible types")
	if not tol then tol=1E-12 end
	return apply(function(x) return x>tol end,abs(sub(v1,v2)))
end

-- some additional useful functions

-- robust sin(x)/x
function sinx_over_x(x)
	if (1. + x*x == 1.) then return 1 end
	return math.sin(x)/x
end

-- @return angle in radians between u and v vectors
function angle(u,v)
	if dot(u,v) < 0. then
		return math.pi - 2*asin(length(add(u,v))/2)
	else
		return 2*asin(distance(v,u)/2)
	end
end