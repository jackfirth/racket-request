#lang scribble/manual

@(require "../doc-utils/examples.rkt"
          "../doc-utils/def.rkt"
          (for-label request
                     racket))

@title{HTTP Requests and Requester}

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

@defrequester[json-requester]{
  A simple requester for the HTTP protocol specifically for JSON requests
  built with @racket[get-impure-port], @racket[put-impure-port],
  @racket[post-impure-port], and @racket[delete-impure-port].
  Locations are @racket[url?]s, headers are @racket[string?]s
  as in the impure port functions, bodies are @racket[jsexpr?],
  and responses are instances of the @racket[json-response] struct.
  Two headers are automatically injected into the request:
  "Content-Type: application/json" and "Accept: application/json".
  The body of the request is automatically converted from a @racket[jsexpr?]
  to a JSON string.
}

@defstruct*[json-response ([code exact-positive-integer?]
                           [headers (hash/c string? string?
                                            #:immutable? #t)]
                           [body jsexpr?])]{
  A structure type for HTTP JSON responses. Contains a status
  code, a hash of headers, and a body @racket[jsexpr?].
  @racket[json-requester] responds with instances of
  this structure type. This is distinct from the
  @racket[response] structure type in the web server
  package, as that response is for @italic{sending}
  responses while this struct is used when
  @italic{receiving} them.
}
