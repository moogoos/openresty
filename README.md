# openresty

This is a container that supports lua and more specifically luajson and luacrypto under ubuntu focal 20.04. This so it can be used as a reverse proxy authentication for
github webhooks, and in my case, manage portainer webhooks instead of polling. Aren't you tired of copying and pasting stack configs or editing in the web editor?

This adds an ENV GITHUB_SECRET which can be passed to a lua access_by_lua_file for validating the secret before proxy_pass initiative.

The lua script was ported from https://gist.github.com/Samael500/5dbdf6d55838f841a08eb7847ad1c926 but I do not use the deploy function, we simply return to the
nginx worker to continue the proxy_pass if all validators pass.

To use this container, point your github webhook to this edge instance and set a secret in github webhooks and then pass the secret in your env to this docker container
as GITHUB_SECRET

To use this for portainer webhooks for example, add the following to your vhost or default config in nginx:

```
     location ~ /api/stacks/webhooks/(.*) {
         access_by_lua_file lua/handler.lua;
         allow all;
         
         proxy_pass http://<internal_ip>:9000;
     }
```
