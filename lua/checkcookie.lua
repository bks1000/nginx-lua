--openresty前端开发进阶五之cookie篇
--https://www.2cto.com/kf/201702/593842.html
local secretkey='123456789VV0abcdefghi'
--ngx.header.uid = ngx.var["cookie_uid"] --获取单个cookie，_后面的cookie的name，如果不存在则返回nil  --和ngx.var.cookie_uid等价

if ngx.var.cookie_uid == nil or ngx.var.cookie_uname == nil or ngx.var.cookie_token == nil then
    ngx.header["Check-Login"] = "NULL"
    return
end
 
local ctoken = ngx.md5('uid:' .. ngx.var.cookie_uid .. '&uname:' .. ngx.var.cookie_uname .. '&secretkey:' .. secretkey)
 
 if ctoken == ngx.var.cookie_token then
    ngx.header["Check-Login"] = "Yes"
    ngx.exec("@tomcat")
 else
    ngx.header["Check-Login"] = "No"
 end

 return