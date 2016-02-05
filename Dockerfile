FROM alpine:latest
MAINTAINER TAGOMORI Satoshi <tagomoris@gmail.com>
LABEL Description="Fluentd docker image" Vendor="Fluent Organization" Version="1.1"

# Do not split this into multiple RUN!
# Docker creates a layer for every RUN-Statement
# therefore an 'apk delete build*' has no effect
RUN apk --no-cache --update add \
                            build-base \
                            ca-certificates \
                            ruby \
                            ruby-irb \
                            ruby-dev && \
    echo 'gem: --no-document' >> /etc/gemrc && \
    gem install fluentd -v 0.12.20 && \
    apk del build-base ruby-dev && \
    rm -rf /tmp/* /var/tmp/* /var/cache/apk/* \
    adduser -D -g '' -u 1000 -h /home/fluent fluent && \
    chown -R fluent:fluent /home/fluent && \
    mkdir -p /fluentd/etc /fluentd/log && \
    chown -R fluent:fluent /fluentd && \
    fluent-gem install fluent-plugin-kubernetes_metadata_filter fluent-plugin-elasticsearch &&
    echo "gem: --user-install --no-document" >> ~/.gemrc

USER fluent
WORKDIR /home/fluent

ENV PATH /home/fluent/.gem/ruby/2.2.0/bin:$PATH
ENV GEM_PATH /home/fluent/.gem/ruby/2.2.0:$GEM_PATH

COPY fluent.conf /fluentd/etc/
ONBUILD COPY fluent.conf /fluentd/etc/

ENV FLUENTD_OPT=""
ENV FLUENTD_CONF="fluent.conf"

EXPOSE 24224

CMD exec fluentd -c /fluentd/etc/$FLUENTD_CONF -p /fluentd/plugins $FLUENTD_OPT
