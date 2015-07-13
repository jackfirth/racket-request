#lang scribble/manual

@(require "../doc-utils/examples.rkt"
          "../doc-utils/def.rkt")

@title{HTTP Requests and Requester}

@defmodule[request]

@defrequester[http-requester]{
  A simple requester for the HTTP protocol built with
  @racket[get-impure-port], @racket[put-impure-port],
  @racket[post-impure-port], and @racket[delete-impure-port].
  Locations are @racket[url?]s, headers are @racket[string?]s
  as in the impure port functions, bodies are @racket[bytes?],
  and responses are instances of the @racket[http-response] struct.
}

@defstruct*[http-response ([code exact-positive-integer?]
                           [headers (hash/c string? string?
                                            #:immutable? #t)]
                           [body string?])]{
  A structure type for HTTP responses. Contains a status
  code, a hash of headers, and a raw body string.
  @racket[http-requester] responds with instances of
  this structure type. This is distinct from the
  @racket[response] structure type in the web server
  package, as that response is for @italic{sending}
  responses while this struct is used when
  @italic{receiving} them.
}

@defpredicate[http-response?]{
 Predicate satisfied by @racket[http-response]s.
}
@defstructinfo[struct:http-response]{
 Struct info instance for @racket[http-response]s.
}

@deftogether[(
  @defproc[(http-response-code [http-response http-response?])
           exact-positive-integer?]
  @defproc[(http-response-headers [http-response http-response?])
           (hash/c string? string?
                   #:immutable? #t)]
  @defproc[(http-response-body [http-response http-response?])
           string?])]{
  Field accessors for instances of the @racket[http-response] struct.
}
