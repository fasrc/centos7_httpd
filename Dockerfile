FROM centos:latest

MAINTAINER FAS Research Computing <rchelp@rc.fas.harvard.edu>

RUN yum clean all && yum update -y && yum install -y epel-release && \
    yum install -y mod_authnz_pam pam pwauth mod_authnz_external mod_proxy_html && \
    yum clean all && rm -Rf /var/cache/yum/
RUN sed -i 's#^ErrorLog.*#ErrorLog \"/var/log/httpd/error_log\"#'  /etc/httpd/conf/httpd.conf && \
    sed -i 's#\"logs/access_log\"#"/var/log/httpd/access_log\"#' /etc/httpd/conf/httpd.conf

ENTRYPOINT ["/usr/sbin/httpd","-DFOREGROUND"]
