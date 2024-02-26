## njs scripting language



njs is a subset of the JavaScript language that allows extending nginx functionality. njs is created in compliance with [ECMAScript 5.1](http://www.ecma-international.org/ecma-262/5.1/) (strict mode) with some [ECMAScript 6](http://www.ecma-international.org/ecma-262/6.0/) and later extensions. The compliance is still [evolving](https://nginx.org/en/docs/njs/compatibility.html).





- [Download and install](https://nginx.org/en/docs/njs/install.html)
- [Changes](https://nginx.org/en/docs/njs/changes.html)
- [Reference](https://nginx.org/en/docs/njs/reference.html)
- [Examples](https://github.com/nginx/njs-examples/)
- [Security](https://nginx.org/en/docs/njs/security.html)
- [Compatibility](https://nginx.org/en/docs/njs/compatibility.html)
- [Command-line interface](https://nginx.org/en/docs/njs/cli.html)
- [Tested OS and platforms](https://nginx.org/en/docs/njs/index.html#tested_os_and_platforms)

 



- [ ngx_http_js_module](https://nginx.org/en/docs/http/ngx_http_js_module.html)
- [ ngx_stream_js_module](https://nginx.org/en/docs/stream/ngx_stream_js_module.html)

 



- [Writing njs code using TypeScript definition files](https://nginx.org/en/docs/njs/typescript.html)
- [Using node modules with njs](https://nginx.org/en/docs/njs/node_modules.html)

 



Use cases



- Complex access control and security checks in njs before a request reaches an upstream server

- Manipulating response headers

- Writing flexible asynchronous content handlers and filters

  See [examples](https://github.com/nginx/njs-examples/) and [blog posts](https://www.nginx.com/blog/tag/nginx-javascript-module/) for more njs use cases.



Basic HTTP Example

To use njs in nginx:

- [install](https://nginx.org/en/docs/njs/install.html) njs scripting language

- create an njs script file, for example, `http.js`. See [Reference](https://nginx.org/en/docs/njs/reference.html) for the list of njs properties and methods.

  > ```
  > function hello(r) {
  >  r.return(200, "Hello world!");
  > }
  > 
  > export default {hello};
  > ```

   

- in the `nginx.conf` file, enable [ngx_http_js_module](https://nginx.org/en/docs/http/ngx_http_js_module.html) module and specify the [js_import](https://nginx.org/en/docs/http/ngx_http_js_module.html#js_import) directive with the `http.js` script file:

  > ```
  > load_module modules/ngx_http_js_module.so;
  > 
  > events {}
  > 
  > http {
  >  js_import http.js;
  > 
  >  server {
  >      listen 8000;
  > 
  >      location / {
  >          js_content http.hello;
  >      }
  >  }
  > }
  > ```

   

  There is also a standalone [command line](https://nginx.org/en/docs/njs/cli.html) utility that can be used independently of nginx for njs development and debugging.



Tested OS and platforms



- FreeBSD / amd64;
- Linux / x86, amd64, arm64, ppc64el;
- Solaris 11 / amd64;
- macOS / x86_64;

 



Presentation at nginx.conf 2018

