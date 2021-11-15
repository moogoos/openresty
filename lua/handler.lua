-- luarocks install JSON4Lua
-- luarocks install luacrypto

local json = require "json"
local crypto = require "crypto"

local event = 'push'
local secret = os.getenv("GITHUB_SECRET")

ngx.header.content_type = "text/plain; charset=utf-8"


getmetatable('').__index = function (str, i)
    return string.sub(str, i, i)
end


local function const_eq (a, b)
    -- Check is string equals, constant time exec
    local equal = string.len(a) == string.len(b)
    for i = 1, math.max(string.len(a), string.len(b)) do
        equal = (a[i] == b[i]) and equal
    end
    return equal
end


local function verify_signature (hub_sign, data)
    local sign = 'sha1=' .. crypto.hmac.digest('sha1', data, secret)
    return const_eq(hub_sign, sign)
end


local function validate_hook ()
    -- should be POST method
    if ngx.req.get_method() ~= "POST" then
        ngx.log(ngx.ERR, "wrong event request method: ", ngx.req.get_method())
        return ngx.exit (ngx.HTTP_NOT_ALLOWED)
    end

    local headers = ngx.req.get_headers()
    -- with correct header
    if headers['X-GitHub-Event'] ~= event then
        ngx.log(ngx.ERR, "wrong event type: ", headers['X-GitHub-Event'])
        return ngx.exit (ngx.HTTP_NOT_ACCEPTABLE)
    end

    -- should be json encoded request
    if headers['Content-Type'] ~= 'application/json' then
        ngx.log(ngx.ERR, "wrong content type header: ", headers['Content-Type'])
        return ngx.exit (ngx.HTTP_NOT_ACCEPTABLE)
    end

    -- read request body
    ngx.req.read_body()
    local data = ngx.req.get_body_data()

    if not data then
        ngx.log(ngx.ERR, "failed to get request body")
        return ngx.exit (ngx.HTTP_BAD_REQUEST)
    end

    -- validate GH signature
    if not verify_signature(headers['X-Hub-Signature'], data) then
        ngx.log(ngx.ERR, "wrong webhook signature")
        return ngx.exit (ngx.HTTP_FORBIDDEN)
    end

    return true
end


local function pass ()
    return true
end


if validate_hook() then
    pass()
end
