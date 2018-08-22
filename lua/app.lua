--出处
--https://blog.csdn.net/wuxiangege/article/details/52238968

local mongo = require "resty.mongol"
local cjson = require "cjson.safe"

ngx.header["mongodb"] = "YES"


-----------------------------------------------------------------------------
----lua call c module
--square = package.loadlib("./ADD.dll", "isquare")
--alert  = package.loadlib("./ADD.dll", "alert")
--add    = package.loadlib("./ADD.dll", "l_add")
--sub    = package.loadlib("./ADD.dll", "l_sub")

-----------------------------------------------------------------------------

-----------------------------------------------------------------------------
--Connect mongodb database
conn = mongo:new()

ok, err = conn:set_timeout(5000) 
ok, err = conn:connect("127.0.0.1", 27017)
if not ok then
    ngx.say("connect failed: "..err)
end

local db = conn:new_db_handle("tamigroup")
if not db then
    ngx.say(db)
end

local col = db:get_col("number")

-----------------------------------------------------------------------------
-- Process request data
local function post_request(data)
    local result = {}
    local request = cjson.decode(data)
    if not request or not request["cmd"] then
        result["result"] = "failed"
        result["reason"] = "no 'cmd' field or not a json struct"
        return result
    end

    local sql_str = ""

    --测试
    if request["cmd"] == "demo" then
        local result = {}
        result["result"] = "ok"
        result["reason"] = "This is a test cmd"
        return result
    end

    --插入人员
    if request["cmd"] == "add" then
        local result = {}

        local t = {}
        table.insert(t, {name=request["name"], id=request["id"]})
        r, err = col:insert(t, nil, true)
        if not r then 
            result["result"] = "insert failed: "..err
        else
            result["result"] = "ok"
        end
        return result
    end

    --删除人员
    if request["cmd"] == "delete" then
        local result = {}

        r, err = col:delete({name=request["name"]}, nil, true)
        if not r then 
            request["result"] = "delete failed: "..err
        else
            result["request"] = "ok" 
        end
        return result
    end

    --修改人员
    if request["cmd"] == "update" then
        local result = {}

        r,err = col:update({name=request["old"]},{name=request["new"]}, nil, nil, true)
        if not r then 
            request[result] = "update failed: "..err
        else
            request[result] = "ok"
        end
        return result
    end

    --查询人员
    if request["cmd"] == "find" then
        local result = {}

        r = col:find({name=result["name"]})
        r:limit(1)
        for i , v in r:pairs() do
            result["data"] = v["name"];
        end

        if not result["data"] then
            result["result"] = "He or she don't exist"
        else
            result["result"] = "ok"
        end
        return result
    end

    --调用c模块
    if request["cmd"] == "lua_call_c" then
        local result = {}
        result["data"] = square(12)
        result["add"] = add(100, 50)
        result["result"] = "ok"
        return result
    end

end

-----------------------------------------------------------------------------
-- Parse request body
ngx.req.read_body()
local method = ngx.var.request_method
if method ~= "POST" then
    local result = {}
    result["result"] = "failed"
    result["reason"] = "use POST method"
    ngx.say(cjson.encode(result))
else
    local data = ngx.req.get_body_data()
    ngx.say(cjson.encode(post_request(data)))
end