# Use RHEL 8 base image
FROM default-route-openshift-image-registry.apps.ext2.mtp.local/registry/httpd-24:latest

# Set environment variables
ENV HTTPD_VERSION 2.4.57
ENV PREFIX /usr/local/apache2

# Install required tools and dependencies
RUN dnf update -y && \
    dnf groupinstall -y "Development Tools" && \
    dnf install -y wget tar pcre-devel openssl-devel expat-devel libtool && \
    dnf clean all

# Download and extract Apache HTTPD source
RUN wget https://downloads.apache.org/httpd/httpd-${HTTPD_VERSION}.tar.gz && \
    tar -xvf httpd-${HTTPD_VERSION}.tar.gz && \
    rm -f httpd-${HTTPD_VERSION}.tar.gz

# Download and extract APR and APR-Util
RUN wget https://downloads.apache.org/apr/apr-1.7.4.tar.gz && \
    tar -xvf apr-1.7.4.tar.gz && \
    rm -f apr-1.7.4.tar.gz && \
    mv apr-1.7.4 httpd-${HTTPD_VERSION}/srclib/apr

RUN wget https://downloads.apache.org/apr/apr-util-1.6.3.tar.gz && \
    tar -xvf apr-util-1.6.3.tar.gz && \
    rm -f apr-util-1.6.3.tar.gz && \
    mv apr-util-1.6.3 httpd-${HTTPD_VERSION}/srclib/apr-util

# Build and install Apache HTTPD
WORKDIR httpd-${HTTPD_VERSION}
RUN ./configure --prefix=${PREFIX} --enable-so --enable-ssl --with-mpm=event --with-included-apr && \
    make && \
    make install

# Clean up source files
WORKDIR /
RUN rm -rf httpd-${HTTPD_VERSION}

# Expose HTTP and HTTPS ports
EXPOSE 80 443

# Add Apache to PATH
ENV PATH="${PREFIX}/bin:${PATH}"

# Start Apache HTTPD server
CMD ["httpd", "-D", "FOREGROUND"]
