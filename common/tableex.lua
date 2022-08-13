local table = table

function table.indexof(t, e)
    for i = 1, #t do
        if t[i] == e then
            return i
        end
    end
    return 0
end

function table.remove_by(t, e)
    local id = table.indexof(t, e)
    if id > 0 then
        table.remove(t, id)
    end
    return id
end

function table.find(t, e)
    for i, v in ipairs(t) do
        if v == e then return i end
    end
    return 0
end

function table.is_array(t)
    local max = 0
    local count = 0
    for k, v in pairs(t) do
        if type(k) == 'number' then
            if k > max then max = k end
            count = count + 1
        else
            return false
        end
    end
    if max > count * 2 then
        return false
    end

    return true
end

function table.tostring(t, indent)
    indent = indent or '  '
    local function str(t, n)
        local indent_str1 = string.rep(indent, n)
        local indent_str2 = string.rep(indent, n + 1)
        if type(t) == 'table' then
            if table.is_array(t) then
                local strs = {}
                for i = 1, #t do
                    local v = t[i]
                    if type(v) == 'table' then
                        strs[i] = str(v, n + 1)
                    else
                        strs[i] = tostring(v)
                    end
                end
                return '{' .. table.concat(strs, ', ') ..'}'
            else
                local strs = {}
                for k, v in pairs(t) do
                    if type(v) == 'table' then
                        strs[#strs + 1] = indent_str2 .. tostring(k) .. ' = ' .. str(v, n + 1)
                    else
                        strs[#strs + 1] = indent_str2 .. tostring(k) .. ' = ' .. tostring(v)
                    end
                end
                table.sort(strs)
                return '{\n' .. table.concat(strs, ',\n') .. indent_str1 .. '\n' .. indent_str1 .. '}'
            end
        else
            return indent_str1 .. tostring(t)
        end
    end

    return str(t, 0)
end

function table.copy(t)
    local r = {}
    for k, v in pairs(t) do
        r[k] = v
    end
    return r
end

function string.split(str, sep)
    local sep, fields = sep or ":", {}
    local pattern = string.format("([^%s]+)", sep)
    str:gsub(pattern, function(c) fields[#fields+1] = c end)
    return fields
end

-- 获得两个数组中元素的交集
function table.intersection(t1, t2)
    local record = {}
    for i = 1, #t1 do
        record[t1[i]] = true
    end

    local result = {}
    for i = 1, #t2 do
        if record[t2[i]] then
            result[#result + 1] = t2[i]
        end
    end

    return result
end

-- 判断t2是否为t1的子集
do
local _r = {}
function table.contains(t1, t2)
    local r = _r
    for _, e in ipairs(t1) do
        r[e] = (r[e] or 0) + 1
    end

    for _, e in ipairs(t2) do
        if not r[e] or r[e] <= 0 then

            -- clear _r for reuse
            for k in pairs(r) do r[k] = nil end

            return false
        end
        r[e] = r[e] - 1
    end

    -- clear _r for reuse
    for k in pairs(r) do r[k] = nil end

    return true
end
end

-- 将两个数组中的内容相加
function table.add(t1, t2)
    local r = {}
    for i = 1, #t1 do
        r[i] = t1[i]
    end

    for i = 1, #t2 do
        r[#r + 1] = t2[i]
    end

    return r
end

-- 将数组中的元素反向
function table.reverse(t)
    local r = {}
    for i = 1, #t do
        r[i] = t[#t - i + 1]
    end
    return r
end

-- 数组相减, a = {1,2,3} b = {1} a - b = {2, 3}
function table.sub(a, b)
    local r = {}
    local records = {}
    for _, e in ipairs(b) do records[e] = true end

    for _, e in ipairs(a) do
        if not records[e] then
            table.insert(r, e)
        end
    end
end

-- 获得数组的key
function table.get_keys(t)
    local keys = {}
    for k, v in pairs(t) do
        table.insert(keys, k)
    end
    return keys
end

-- 数组求和
function table.sum(t)
    local r = 0
    for _, v in ipairs(t) do
        r = r + v
    end
    return r
end

-- 获得数组内对应元素的个数
function table.count_e(t, e)
    local r = 0
    for i, v in ipairs(t) do
        if e == v then
            r = r + 1
        end
    end
    return r
end

-- 交换数组中的元素
function table.swap(t, a, b)
    local tmp = t[a]
    t[a] = t[b]
    t[b] = tmp
end

-- 将每个元素按照e_fmt的个数来获得数组中的元素字符串
-- eg: table.concat(t, '%.2f', ', ')
function table.concat_fmt(t, e_fmt, sep)
    local st = {}
    for i, e in ipairs(t) do
        st[i] = string.format(e_fmt, e)
    end
    return table.concat(st, sep)
end

function table.map_len(t)
    local len = 0
    for _, _ in pairs(t) do
        len = len + 1
    end
    return len
end

return table