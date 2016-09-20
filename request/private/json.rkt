#lang racket

(require json
         "base.rkt"
         "exn.rkt"
         "struct.rkt"
         "wrap.rkt")

(provide (struct-out exn:fail:json)
         json-requester)

(struct exn:fail:json exn () #:transparent)

(define json-headers
  '("Accept: application/json" "Content-Type: application/json"))

(define (make-json-exn handler-response)
  (exn:fail:json (~a handler-response) (current-continuation-marks)))

(define (wrap-json-body body)
  (if (jsexpr? body)
      (jsexpr->bytes body)
      body))

(define (handle-json-response response)
  (define json-resp 
    (with-handlers ([exn:fail:read? (λ (e) #f)])
      (string->jsexpr response)))
  (if (not json-resp)
      (raise (make-json-exn response))
      json-resp))

(define json-requester
  (wrap-requester-response
   handle-json-response
   (wrap-requester-body
    wrap-json-body
    (add-requester-headers
     json-headers http-requester/exn))))

(module+ test
  (require net/url
           rackunit)

  (check-pred requester? json-requester)

  (define (make-url path)
    (string->url (format "http://httpbin.org/~a" path)))

  (define (get-headers response)
    (hash-ref response 'headers))

  (define (get-data response)
    (hash-ref response 'data))
  
  (define json-get (requester-get json-requester))
  (define json-put (requester-put json-requester))
  (define json-post (requester-post json-requester))
  (define json-delete (requester-delete json-requester))

  (define get-200 ((requester-get json-requester)
                   (make-url "get") #:headers '("x-men: colossus")))
    
  (check-pred jsexpr? get-200)
  (check-equal? (hash-ref (get-headers get-200) 'Content-Type)
               "application/json")
  (check-equal? (hash-ref (get-headers get-200) 'Accept)
               "application/json")
  (check-equal? (hash-ref (get-headers get-200) 'X-Men)
                "colossus")

  (define put-200 (json-put (make-url "put") (hash 'foo "bar")))
  (check-pred jsexpr? put-200)
  (check-equal? (get-data put-200) "{\"foo\":\"bar\"}")

  (define post-200 (json-post (make-url "post") (hash 'foo "bar")))
  (check-pred jsexpr? post-200)
  (check-equal? (get-data post-200) "{\"foo\":\"bar\"}")

  (define delete-200 (json-delete (make-url "delete")))
  (check-pred jsexpr? delete-200)

  ;; get HTML which should throw exn:fail:json
  (check-exn
   exn:fail:json?
   (λ () ((requester-get json-requester) (make-url "html"))))
    
  ;; httpbin returns a non-JSON body for 418 Teapot
  (check-exn
   exn:fail:network:http:code?
   (λ () (json-get (make-url "status/418"))))

  (check-exn
   exn:fail:network:http:code?
   (λ () (json-get (make-url "status/406")))))