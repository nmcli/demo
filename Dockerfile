#FROM image-registry.openshift-image-registry.svc:5000/registry/httpd-24:latest
FROM registry.redhat.io/rhel8/httpd-24:latest

COPY index.html /usr/local/apache2/htdocs/

EXPOSE 8080
