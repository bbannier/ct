FROM alpine

ARG FOO

RUN echo $FOO > /foo
