FROM debian:buster

# Install pygments (for syntax highlighting) 
RUN apt-get -qq update \
	&& DEBIAN_FRONTEND=noninteractive apt-get -qq install -y --no-install-recommends libstdc++6 python-pygments git ca-certificates asciidoc curl \
	&& rm -rf /var/lib/apt/lists/*

RUN curl -sL -o /tmp/go1.13.linux-amd64.tar.gz https://dl.google.com/go/go1.13.linux-amd64.tar.gz
RUN tar xvfz /tmp/go1.13.linux-amd64.tar.gz
RUN cp go/bin/go /usr/local/bin/
RUN cp go/bin/gofmt /usr/local/bin/
RUN mv go /usr/local/go/

# Configuration variables
ENV HUGO_VERSION 0.75.1
ENV HUGO_BINARY hugo_extended_${HUGO_VERSION}_Linux-64bit.deb
ENV SITE_DIR '/usr/share/blog'

# Download and install hugo
RUN curl -sL -o /tmp/hugo.deb \
    https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/${HUGO_BINARY} && \
    dpkg -i /tmp/hugo.deb && \
    rm /tmp/hugo.deb && \
    mkdir ${SITE_DIR}

WORKDIR ${SITE_DIR}

# Expose default hugo port
EXPOSE 1313

# Automatically build site
ONBUILD ADD site/ ${SITE_DIR}
ONBUILD RUN hugo -d /usr/share/nginx/html/

# By default, serve site
ENV HUGO_BASE_URL http://localhost:1313
CMD hugo server -b ${HUGO_BASE_URL} --bind=0.0.0.0
