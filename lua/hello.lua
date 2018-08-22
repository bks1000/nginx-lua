local ffi = require "ffi"

ffi.cdef[[
    int add(int x, int y);
    float isquare(float val);
]]

local myffi = ffi.load("D:/SoftwareGree/openresty-1.13.6.2-win64/conf/lua/lualib/mylib.dll") --加载函数库

local res = myffi.add(5, 3) --调用add函数
ngx.header["FFI"] = res   --将结果写入响应头

ngx.say(res)


--[[local ffi = require("ffi")
ffi.cdef[[
int MessageBoxA(void *w, const char *txt, const char *cap, int type);
] ]
ffi.C.MessageBoxA(nil, "Hello world!", "Test", 0)
--]]

