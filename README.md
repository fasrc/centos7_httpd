# centos7_httpd
minimal dockerized centos 7 apache install

# usage

There's not much going on here. If you need to add modules, add the pkgs to the install list.

Running this as is should give you just the default test page.

    docker run -d -p 8080:80 fasrc/centos7_httpd:latest

Easiest way to modify configuration is to mount config files into the container:

    docker run -d -p 8080:80 -v /path/to/web.conf:/etc/httpd/conf.d/000_default.conf fasrc/centos7_httpd:latest

Do the same for ssl.

This is just a small test image and not meant to do much.
