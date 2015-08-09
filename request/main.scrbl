#lang scribble/manual

@title{Requests}

@defmodule[request]

This library includes functions and forms for working with
@deftech[#:key "request"]{requests} and
@deftech[#:key "requester"]{requesters}. A @italic{request}
is either a @deftech[#:key "GET"]{GET} request, a
@deftech[#:key "PUT"]{PUT} request, a
@deftech[#:key "POST"]{POST} request, or a
@deftech[#:key "DELETE"]{DELETE} request. A @italic{requester}
is a value that can be used to perform these types of requests.
This library provides several requesters built on top of the
HTTP protocol, however in principle these functions work with
any requester that can be constructed to perform each of the
types of requests.

@author[@author+email["Jack Firth" "jackhfirth@gmail.com"]]

source code: @url["https://github.com/jackfirth/racket-request"]

@include-section["private/struct.scrbl"]
@include-section["private/wrap.scrbl"]
@include-section["private/base.scrbl"]
@include-section["private/exn.scrbl"]
@include-section["private/http-location.scrbl"]
@include-section["param.scrbl"]
@include-section["check.scrbl"]
