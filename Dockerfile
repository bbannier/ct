FROM ubuntu

ARG FOO

RUN apt-get update \
 && apt-get install -y --no-install-recommends ninja-build \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
    \
 && echo $FOO > /foo \
 && ninja --help
