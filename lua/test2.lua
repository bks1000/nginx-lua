-- 参考 http://outofmemory.cn/code-snippet/14394/nginx-run-lua
--get请求，我要得到token符合条件的，我会处理之后，再加上请求头，转发(隐蔽的页面)，不符合条件的，直接返回明显的页面
--[[local uri_args = ngx.req.get_uri_args()

for k, v in pairs(uri_args) do
    if k == "token" then
       tk = v
       --TODO:
       --处理token
       --正确的话，添加请求头
       --添加请求头
       local headers = ngx.req.get_headers()
       ngx.header["Xsdfsdfsdfsf"]=tk
    end
end--]]


--添加请求头
--local headers = ngx.req.get_headers()
--ngx.header["Xsdfsdfsdfsf"]='010101010101010101101'

--跳转
--ngx.redirect('/lua',302)

ngx.header.Foo = "blah" --添加到响应头

