#lang scribble/manual

@(require "doc-utils/examples.rkt"
          "doc-utils/def.rkt"
          (for-label request/param
                     racket
                     rackunit))

@title{RackUnit Requester Integration Testing}
@defmodule[request/check]

This module provides @racket[rackunit] checks that test
requests using the @racket[current-requester] from
@racket[request/param]. This can be used as a lightweight
HTTP API integration testing framework. Note that none of
these checks accept headers. Use @racket[with-requester]
and @racket[add-requester-headers] to add headers to the
current requester for a set of checks. This module also
re-provides everything in @racket[request/param].

@(define-syntax-rule (defvoidproc id+formals pre-flow ...)
   (defproc id+formals void? pre-flow ...))

@defvoidproc[(check-get [location any/c]
                        [expected-response any/c])]{
  Checks that the result of @racket[(get location)] is
  @racket[equal?] to @racket[expected-response].
}

@defvoidproc[(check-put [location any/c]
                        [body any/c]
                        [expected-response any/c])]{
  Checks that the result of @racket[(put location body)] is
  @racket[equal?] to @racket[expected-response].
}

@defvoidproc[(check-post [location any/c]
                         [body any/c]
                         [expected-response any/c])]{
  Checks that the result of @racket[(post location body)] is
  @racket[equal?] to @racket[expected-response].
}

@defvoidproc[(check-delete [location any/c]
                           [expected-response any/c])]{
  Checks that the result of @racket[(delete location body)] is
  @racket[equal?] to @racket[expected-response].
}

@defvoidproc[(check-get-exn [exn-pred predicate/c]
                            [location any/c])]{
  Checks that evaluating @racket[(get location)] raises an exception
  satisfying @racket[exn-pred].
}

@defvoidproc[(check-get-not-exn [location any/c])]{
  Checks that evaluating @racket[(get location)] raises no exceptions.
}

@defvoidproc[(check-put-exn [exn-pred predicate/c]
                            [location any/c]
                            [body any/c])]{
  Checks that evaluating @racket[(put location body)] raises an exception
  satisfying @racket[exn-pred].
}

@defvoidproc[(check-put-not-exn [location any/c]
                                [body any/c])]{
  Checks that evaluating @racket[(put location body)] raises no exceptions.
}

@defvoidproc[(check-post-exn [exn-pred predicate/c]
                             [location any/c]
                             [body any/c])]{
  Checks that evaluating @racket[(post location body)] raises an exception
  satisfying @racket[exn-pred].
}

@defvoidproc[(check-post-not-exn [location any/c]
                                 [body any/c])]{
  Checks that evaluating @racket[(post location body)] raises no exceptions.
}

@defvoidproc[(check-delete-exn [exn-pred predicate/c]
                               [location any/c])]{
  Checks that evaluating @racket[(delete location)] raises an exception
  satisfying @racket[exn-pred].
}

@defvoidproc[(check-delete-not-exn [location any/c])]{
  Checks that evaluating @racket[(delete location)] raises no exceptions.
}
