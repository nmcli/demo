# Use RHEL 8 base image
FROM image-registry.openshift-image-registry.svc:5000/registry/httpd-24:latest

# Set environment variables
ENV HTTPD_VERSION 2.4.57
ENV PREFIX /usr/local/apache2

# Expose HTTP and HTTPS ports
EXPOSE 80 443

# Start Apache HTTPD server
CMD ["httpd", "-D", "FOREGROUND"]
