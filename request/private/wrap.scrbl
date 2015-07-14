#lang scribble/manual

@(require "../doc-utils/examples.rkt"
          "../doc-utils/def.rkt"
          (for-label request
                     racket))

@title{Extending and Wrapping Requesters}

@defproc[(wrap-requester [wrapper (or/c (-> (->* (any/c) (#:headers list?) any/c)
                                            (->* (any/c) (#:headers list?) any/c))
                                        (-> (->* (any/c any/c) (#:headers list?) any/c)
                                            (->* (any/c any/c) (#:headers list?) any/c)))]
                         [requester requester?])
         requester?]{
  Constructs a new requester by wrapping each procedure
  of the old requester with @racket[wrapper].
  @racket[(wrap-requester f (requester get put post delete))]
  is equivalent to
  @racket[(requester (f get) (f put) (f post) (f delete))].
}

@defproc[(wrap-requester-location [location-wrapper (-> any/c any/c)]
                                  [requester requester?])
         requester?]{
  Constructs a new requester which is identical to @racket[requester]
  except that any locations it's given are first transformed with
  @racket[location-wrapper] and then passed on to @racket[requester].
}

@defproc[(wrap-requester-body [body-wrapper (-> any/c any/c)]
                              [requester requester?])
         requester?]{
  Constructs a new requester which is identical to @racket[requester]
  except that any request bodies it's given are first transformed
  with @racket[body-wrapper] and then passed on to @racket[reqeuster].
}

@defproc[(wrap-requester-response [response-wrapper (-> any/c any/c)]
                                  [requester requester?])
         requester?]{
  Constructs a new requester which is identical to @racket[requester]
  except that any responses it returns are transformed with
  @racket[response-wrapper] after being received from @racket[requester].
}

@defproc[(add-requester-headers [headers list?]
                                [requester requester?])
         requester?]{
  Constructs a new requester which is identical to @racket[requester]
  except that it includes @racket[headers] with every request. If
  individual requests are given a header with the same name as any
  of the base @racket[headers], the individual header overwrites
  the base @racket[headers]. This can be used to construct an HTTP
  requester that sends authorization headers on every request or
  always requests a certain content type, for example.
}
