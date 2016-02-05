FROM fluent/fluentd

RUN fluent-gem install fluent-plugin-kubernetes_metadata_filter fluent-plugin-elasticsearch
