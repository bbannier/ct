FROM ubuntu

ARG FOO

RUN echo $FOO > /foo
