#lang scribble/manual

@(require "doc-utils/examples.rkt"
          "doc-utils/def.rkt"
          "private/base.rkt"
          (for-label (except-in request get put post delete)
                     racket
                     request/param))

@title{Parameterized Requests}

@defmodule[request/param]

When using requesters, it is usually the case that
first a requester is constructed, then all requests
are made with it. This makes specifying the requester
in each request verbose and redundant. This module
provides request functions that operate using a
@racket[current-requester] parameter which can be
modified using @racket[with-requester].

@defparam[current-requester requester requester?
          #:value http-requester]{
  The current requester. Defaults to the simple
  @racket[http-requester].
}

@defform[(with-requester requester-expr body ...)
         #:contracts ([requester-expr requester?])]{
  @racket[parameterize]s the @racket[current-requester] to
  the result of @racket[requester-expr] in @racket[body ...].
}

@deftogether[(
  @defproc[(get [location any/c]
                [#:headers headers list? '()])
           any/c]
  @defproc[(put [location any/c]
                [body any/c]
                [#:headers headers list? '()])
           any/c]
  @defproc[(post [location any/c]
                 [body any/c]
                 [#:headers headers list? '()])
           any/c]
  @defproc[(delete [location any/c]
                   [#:headers headers list? '()])
           any/c])]{
  Equivalent to those defined in @racketmodname[request], but using
  the @racket[current-requester] to make requests.
}
