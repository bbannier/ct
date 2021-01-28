FROM ubuntu

ARG FOO

RUN apt-get update \
 && apt-get install -y --no-install-recommends curl jq

RUN echo $FOO > /foo
