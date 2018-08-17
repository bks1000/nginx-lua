--如果不传参数，会发生500的错误，如果传错参数，会返回404错误。
-- 获取请求路径，不包括参数。例如：/group1/M00/00/00/wKjlpltF-K-AZQQsAABhhboA1Kk469.png
local uri = ngx.var.uri;
-- 获取请求参数
local args = ngx.req.get_uri_args();
-- 获取请求参数中时间戳信息，传入的是毫秒
local ts  = args["ts"];
-- 获取请求参数中 token 信息
local token1 = args["token"];

-- 更新系统缓存时间戳
ngx.update_time();
-- 获取当前服务器系统时间，ngx.time() 获取的是秒
local getTime = ngx.time() * 1000;
-- 计算时间差
local diffTime = tonumber(ts) - getTime;
-- md5 加盐加密
--local token2 = ngx.md5(tostring(uri) .. "salt" .. tostring(ts));
local token2 = ngx.md5("salt" .. tostring(ts));
-- 判断时间是否有效
if (tonumber(diffTime) > 0) then 
    -- 校验 token 是否相等
    if token1 == token2 then
        -- 校验通过则转发请求
        return ngx.exec("@tomcat","a=ccc");
    end
end
ngx.header.Msg='Sorry'
ngx.header.uri=tostring(uri)
ngx.header.ts = ts
ngx.header.token2 = token2
ngx.header.difftime = diffTime