#lang scribble/manual

@(require "../doc-utils/examples.rkt"
          "../doc-utils/def.rkt")

@title{HTTP Requests and Requester}

@defrequester[base-requester]{
  A simple requester for the HTTP protocol built with
  @racket[get-impure-port], @racket[put-impure-port],
  @racket[post-impure-port], and @racket[delete-impure-port].
  Locations are @racket[url?]s, headers are @racket[string?]s
  as in the impure port functions, bodies are @racket[bytes?],
  and responses are instances of the @racket[response] struct.
}

@defstruct*[response ([code exact-positive-integer?]
                      [headers (hash/c string? string?
                                       #:immutable? #t)]
                      [body string?])]{
  A structure type for HTTP responses. Contains a status
  code, a hash of headers, and a raw body string.
  @racket[base-requester] responds with instances of
  this structure type.
}

@defpredicate[response?]{Predicate satisfied by @racket[response]s.}
@defstructinfo[struct:response]{Struct info instance for @racket[response]s.}

@deftogether[(
  @defproc[(repsonse-code [response response?])
           exact-positive-integer?]
  @defproc[(response-headers [response response?])
           (hash/c string? string?
                   #:immutable? #t)]
  @defproc[(response-body [response response?])
           string?])]{
  Field accessors for instances of the @racket[response] struct.
}
