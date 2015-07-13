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
  and responses are instances of an opaque undocumented
  response type (whoops).
}
