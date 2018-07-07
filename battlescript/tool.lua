function string.utf8len(input)
    local len  = string.len(input)
    local left = len
    local cnt  = 0
    local arr  = {0, 0xc0, 0xe0, 0xf0, 0xf8, 0xfc}
    while left ~= 0 do
        local tmp = string.byte(input, -left)
        local i   = #arr
        while arr[i] do
            if tmp >= arr[i] then
                left = left - i                
                break
            end
            i = i - 1
        end
        cnt = cnt + 1
    end
    return cnt
end

-- lzh
-- 功能：将字符串拆成单个字符，存在一个table中
function string.utf8tochars(input)
     local list = {}
     local len  = string.len(input)
     local index = 1
     local arr  = {0, 0xc0, 0xe0, 0xf0, 0xf8, 0xfc}
     while index <= len do
        local c = string.byte(input, index)
        local offset = 1
        if c < 0xc0 then
            offset = 1
        elseif c < 0xe0 then
            offset = 2
        elseif c < 0xf0 then
            offset = 3
        elseif c < 0xf8 then
            offset = 4
        elseif c < 0xfc then
            offset = 5
        end
        local str = string.sub(input, index, index+offset-1)
        -- print(str)
        index = index + offset
        table.insert(list, str)
     end

     return list
end

