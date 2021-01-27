FROM ubuntu

ARG FOO

RUN apt-get update \
 && apt-get install -y --no-install-recommends curl

RUN echo $FOO > /foo
