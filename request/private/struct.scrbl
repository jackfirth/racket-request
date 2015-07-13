#lang scribble/manual

@(require "../doc-utils/examples.rkt")

@title{Requesters}

@defstruct*[requester ([get (->* (any/c) (#:headers list?) any/c)]
                       [put (->* (any/c any/c) (#:headers list?) any/c)]
                       [post (->* (any/c any/c) (#:headers list?) any/c)]
                       [delete (->* (any/c) (#:headers list?) any/c)])]{
  A structure type for requesters. A requester is defined on
  a @italic{location} type, a @italic{body} type, a @italic{header}
  type, and a @italic{response} type. A requester is composed
  of four procedures, each of which may take an optional list of
  headers to modify the request or add additional information.
  @itemlist[
    @item{
      GET - Given a location, returns a response. Should be
      @italic{safe} - calling GET on a location should never
      modify the resource at the location, and the GET should
      be invisible to anyone else viewing or modifying that
      resource.
    }
    @item{
      PUT - Given a location and a body, returns a response.
      Should be @italic{idempotent} - doing a PUT twice at
      the same location with the same body should be exactly
      the same as doing it once. Additionally, for a location
      that can be PUT to a GET response should contain what
      was last PUT there.
    }
    @item{
      POST - Given a location and a body, returns a response.
      A post need not be either @italic{safe} or @italic{idempotent},
      it may perform arbitrary modification of the resource at
      the location or other resources related to that resource.
      A location that is POST-ed to should contain a resource -
      that is, a GET at that location should not return a resource
      not found response.
    }
    @item{
      DELETE - Given a location, returns a response. In the
      event of a successful response, later GETs (and DELETEs)
      at that location should be unsuccessful.
    }
  ]
  Provided the four provided procedures behave according to the
  specifications outlined above, the constructed @racket[requester]
  defines a REST-ful interface.
}