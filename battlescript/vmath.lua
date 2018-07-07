Mbit = require "mbit"

math.PI = 3.14

Vector = class("Vector")
function Vector:ctor(x,y)
    self.x = x
    self.y = y
end

function Vector:lengh()
    return math.sqrt(self.x*self.x+self.y*self.y)
end

vmath = {}
function vmath.normalize(x1,y1,x2,y2)
    local vx = x2-x1
    local vy = y2-y1
    local l = math.sqrt(vx*vx+vy*vy)
    return vx/l,vy/l
end

function vmath.normalizeVec(v)
    local l = v:lengh()
    return v.x/l,v.y/l
end

function vmath.lengh(x1,y1,x2,y2)
    local vx = x2-x1
    local vy = y2-y1
    return math.sqrt(vx*vx+vy*vy)
end

function vmath.lenghInt(x1,y1,x2,y2)
    return math.floor(vmath.lengh(x1,y1,x2,y2))
end

function vmath.vector(x1,y1,x2,y2)
    local vc = Vector.new(x2-x1,y2-y1)
    return vc
end

function vmath.dot(v1,v2)
    return v1.x*v2.x+v1.y*v2.y
end

function vmath.crose(v1,v2)
    return v1.x*v2.y-v1.y*v2.x
end

function vmath.radian(v1,v2)
    return math.acos(vmath.dot(v1,v2)/(v1:lengh()*v2:lengh()))
end

function vmath.angle(v1,v2)
    return vmath.radian(v1,v2)*180/math.PI
end