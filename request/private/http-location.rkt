#lang racket

(require net/url
         fancy-app
         "struct.rkt"
         "wrap.rkt")

(provide
 (contract-out
  [make-domain-requester
   (-> string? requester? requester?)]
  [make-host+port-requester
   (-> string? exact-nonnegative-integer? requester? requester?)]
  [make-https-requester
   (-> requester? requester?)]))


(define (domain+relative-path->http-url domain relative-path)
  (string->url (format "http://~a/~a" domain relative-path)))

(define (host+port->domain host port)
  (format "~a:~a" host port))

(define (http-url->https-url location)
  (struct-copy url location [scheme "https"]))

(define (make-domain-requester domain requester)
  (wrap-requester-location
   (domain+relative-path->http-url domain _) requester))

(define (make-https-requester requester)
 (wrap-requester-location
  (http-url->https-url _) requester))

(define (make-host+port-requester host port requester)
  (make-domain-requester (host+port->domain host port) requester))

(module+ integration-test
  (require json
           rackunit
           "base.rkt"
           "call-response.rkt")

  (define domain "httpbin.org")
  (define http-url (domain+relative-path->http-url domain "/"))
  (define http-req (make-domain-requester domain http-requester))
  (define https-req (make-domain-requester
                     domain (make-https-requester http-requester)))
 
  (define http-resp (get http-req "/get"))
  (define https-resp (get https-req "/get"))

  (check-pred url? http-url)
  (check-equal? (url-scheme http-url) "http")
  (check-equal?
   (hash-ref (string->jsexpr (http-response-body https-resp)) 'url)
   "https://httpbin.org/get")
  
  (check-pred requester? http-req)
  (check-equal? (http-response-code http-resp) 200)
  (check-equal? (http-response-code https-resp) 200))