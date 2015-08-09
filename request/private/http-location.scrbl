#lang scribble/manual

@(require "../doc-utils/examples.rkt"
          "../doc-utils/def.rkt"
          (for-label request
                     net/url
                     racket))

@title{HTTP Requester Location Wrappers}

Usually an http requester is constructed for a
single REST API at a particular domain. These
functions allow the construction of requesters
that operate at only one domain and accept
relative paths as locations.

@defproc[(make-domain-requester [domain string?]
                                [requester requester?])
         requester?]{
  Given a requester that accepts @racket[url?]s
  as locations, returns a requester that accepts
  @racket[string]s representing relative paths as
  locations. Each path is combined with the given
  @racket[domain] to construct a full http @racket[url],
  which is then passed to the underlying @racket[requester].
  The relative path should not begin with a slash.
  @racketinput[
    (define foo-com-requester
      (make-domain-requester "foo.com" http-requester))
    (get foo-com-requester "some/sort/of/path") ;; request to http://foo.com/some/sort/of/path
]}

@defproc[(make-host+port-requester [host string?]
                                   [port exact-nonnegative-integer?]
                                   [requester requester?])
         requester?]{
  Like @racket[make-domain-requester], except combines
  the @racket[host] and @racket[port] into a domain string.
  @racket[(make-host+port-requester "foo.com" 8080 some-requester)]
  is equivalent to @racket[(make-domain-requester "foo.com:8080" some-requester)]
}
