FROM centos:latest

MAINTAINER FAS Research Computing <rchelp@rc.fas.harvard.edu>

RUN yum clean all && yum update -y && yum install -y epel-release && \
    yum install -y mod_authnz_pam pam pwauth mod_authnz_external mod_proxy_html \
    mod_php mysql-devel mysql-libs mod_ssl php php-cli php-ldap php-mbstring \
    php-mcrypt php-mysql php-pear-MDB2-Driver-mysqli php-pecl-memcached php-xml php-gd msmtp

RUN sed -i \
    -e 's~^ServerSignature On$~ServerSignature Off~g' \
    -e 's~^ServerTokens OS$~ServerTokens Prod~g' \
    -e 's~^#ExtendedStatus On$~ExtendedStatus On~g' \
    -e 's~^DirectoryIndex \(.*\)$~DirectoryIndex \1 index.php~g' \
    -e 's~^NameVirtualHost \(.*\)$~#NameVirtualHost \1~g' \
    -e 's#^ErrorLog.*#ErrorLog \"/var/log/httpd/error_log\"#' \
    -e 's#\"logs/access_log\"#"/var/log/httpd/access_log\"#' \
    /etc/httpd/conf/httpd.conf

RUN ln -sf /usr/share/zoneinfo/EST /etc/localtime && \
    echo "NETWORKING=yes" > /etc/sysconfig/network

RUN sed -i \
    -e 's~^;date.timezone =$~date.timezone = US/Eastern~g' \
    -e 's~^;user_ini.filename =$~user_ini.filename =~g' \
    -e 's~^sendmail_path = /usr/sbin/sendmail -t -i$~sendmail_path = /usr/bin/msmtp -C /etc/msmtprc -t -i~g' \
    /etc/php.ini && \
    echo '<?php phpinfo(); ?>' > /var/www/html/index.php && \
    curl http://msmtp.sourceforge.net/doc/msmtprc.txt -o /etc/msmtprc && \
    yum clean all && rm -Rf /var/cache/yum/ && \
    rm -rvf /usr/{{lib,share}/locale,share/{man,doc,info,gnome/help,cracklib,il8n},{lib,lib64}/gconv,bin/localedef,sbin/build-locale-archive} && \
    rm -rf /var/cache/{ldconfig,yum}/*

EXPOSE 80 443

ENTRYPOINT ["/usr/sbin/httpd","-DFOREGROUND"]
