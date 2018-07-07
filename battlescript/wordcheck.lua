require "class"
require "tool"

local bandData = require "banned_word"

local charNode = class("charNode")

function charNode:ctor(char,isend)
    self.char = char
    self.next = {}
    self.isend = isend or false
end

function charNode:findChar(char)
    return self.next[char]
end

function charNode:addChar(char)
    local node = charNode.new(char)
    self.next[char] = node
    return node
end

local NODE_STATE = {
    CONTINUE = 1,
    ERROR = 2,
    OVER = 3,
}

local checkNode = class("checkNode")

function checkNode:ctor(node,fixnum)
    self.node = node
    self.orgnum = fixnum
    self.fixnum = fixnum
end

function checkNode:check(char)
    local tmpn = self.node:findChar(char)
    if tmpn == nil then
        if self.fixnum <= 0 then
            return NODE_STATE.OVER
        else
            self.fixnum = self.fixnum-1
            return NODE_STATE.CONTINUE
        end
    else
        if tmpn.isend then
            return NODE_STATE.ERROR
        else
            self.node = tmpn
            self.fixnum = self.orgnum
            return NODE_STATE.CONTINUE
        end
    end
end

local wordCheck = class("wordCheck")
function wordCheck:ctor(fixnum)
    self.root = charNode.new()
    self.fixnum = fixnum or 0
end

function wordCheck:splitStr(str)
    return string.utf8tochars(str)
end

function wordCheck:addString(str)
    local list = self:splitStr(str)
    local node = self.root
    for i,c in ipairs(list) do
        local tmpn = node:findChar(c)
        if tmpn == nil then
            node = node:addChar(c)
        else
            node = tmpn
        end
    end
    node.isend = true
end

function wordCheck:checkIsBand(str)
    local list = self:splitStr(str)
    local clist = {}
    for i,c in ipairs(list) do
        local cn = #clist
        if cn > 0 then
            for i=cn,1,-1 do
                local state = clist[i]:check(c)
                if state == NODE_STATE.ERROR then
                    return true
                elseif state == NODE_STATE.OVER then
                    table.remove(clist,i)
                end
            end
        end
        local node = self.root:findChar(c)
        if node then
            table.insert(clist,checkNode.new(node,self.fixnum))
        end
    end
    return false
end

local band = wordCheck.new()
for i,s in ipairs(bandData) do
    band:addString(s)    
end

local teststr = {
    "这是一句屏蔽字测试kdjfkaj看手机电脑付款就是当年",
    "这是一句带屏蔽字测试kdjfk 习近平 aj看手机电脑付款就是当年",
    "送快递发空间上电脑是你的辣酸奶asdoaksndlk新疆",
    "sjndnfn时代峻峰你；开始交电费sdjkfn;klsjN时代峻峰你；是的那份",
    "看见对方能收到甲方fuck试客联盟的拉开什么",
    "这是一句屏蔽字测试kdjfkaj看手机电脑付款就是当年",
    "这是一句带屏蔽字测试kdjfk 习近平 aj看手机电脑付款就是当年",
    "送快递发空间上电脑是你的辣酸奶asdoaksndlk新疆",
    "sjndnfn时代峻峰你；开始交电费sdjkfn;klsjN时代峻峰你；是的那份",
    "看见对方能收到甲方fuck试客联盟的拉开什么",
    "这是一句屏蔽字测试kdjfkaj看手机电脑付款就是当年",
    "这是一句带屏蔽字测试kdjfk 习近平 aj看手机电脑付款就是当年",
    "送快递发空间上电脑是你的辣酸奶asdoaksndlk新疆",
    "sjndnfn时代峻峰你；开始交电费sdjkfn;klsjN时代峻峰你；是的那份",
    "看见对方能收到甲方fuck试客联盟的拉开什么",
}

local t1 = os.clock()
for jt=1,10 do
    for i,s in ipairs(teststr) do
        if band:checkIsBand(s) then
            --print("屏蔽",s)
            local donil = 1
        end 
    end 
end
local t2 = os.clock()
print("use:",t2-t1)

for jt=1,10 do
    for i,s in ipairs(teststr) do
        for k,ck in ipairs(bandData) do
            local st,ed = string.find(s,ck)
            if st then
                --print("find",s,ck)
                local donil = 1
                break
            end
        end
    end 
end

local t3 = os.clock()
print("use:",t3-t2)
