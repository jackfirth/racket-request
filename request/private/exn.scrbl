#lang scribble/manual

@(require "../doc-utils/examples.rkt"
          "../doc-utils/def.rkt"
          (for-label request
                     racket))

@title{HTTP Status Code Exception Throwing}

@defstruct*[(exn:fail:network:http:code exn:fail:network)
            ([code exact-positive-integer?])]{
  An exception structure type for non-success HTTP error codes.
  All codes in the range @racket[(<= 400 code 599)] are defined
  as error cases. This exception is thrown by @racket[http-requester]s
  wrapped by @racket[requester-http-exn].
}

@defproc[(requester-http-exn [requester requester?])
         requester?]{
  Given a @racket[requester] whose responses are @racket[http-response]s,
  returns a requester whose responses are the only the response bodies
  of @racket[requester]. In the event of failure error codes
  in the response, an @racket[exn:fail:network:http:code] exception
  is thrown which contains the code and response body.
}

@defrequester[http-requester/exn]{
  Like @racket[http-requester], but throws exceptions for failure codes
  and returns the http response body as it's response. Equivalent to
  @racket[(requester-http-exn http-requester)].
}

@defproc[(http-exn-of-code? [code exact-positive-integer?]
                            [v any/c])
         boolean?]{
  Returns @racket[#t] if @racket[v] is an instance of
  @racket[exn:fail:network:http:code] whose status code is
  @racket[code], and returns @racket[#f] otherwise.
}
