# coding:utf-8

import hashlib

# 待加密信息
secretkey='123456789VV0abcdefghi'
uid = str(12344)
uname = 'zs'
token = 'uid:' +uid + '&uname:' +uname+ '&secretkey:' + secretkey

# 创建md5对象
hl = hashlib.md5()

# Tips
# 此处必须声明encode
# 若写法为hl.update(str)  报错为： Unicode-objects must be encoded before hashing
hl.update(token.encode(encoding='utf-8'))

print('MD5加密前为 ：' + token)
print('MD5加密后为 ：' + hl.hexdigest())