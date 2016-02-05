FROM fluent/fluentd

RUN gem install fluent-plugin-kubernetes_metadata_filter
