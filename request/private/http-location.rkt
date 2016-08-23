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
   (-> string? requester? requester?)]))


(define (domain+relative-path->http-url protocol domain relative-path)
  (string->url (format "~a://~a/~a" protocol domain relative-path)))

(define (host+port->domain host port)
  (format "~a:~a" host port))

(define (make-domain-requester domain requester)
  (wrap-requester-location
   (domain+relative-path->http-url "http" domain _) requester))

(define (make-https-requester domain requester)
  (wrap-requester-location
   (domain+relative-path->http-url "https" domain _) requester))

(define (make-host+port-requester host port requester)
  (make-domain-requester (host+port->domain host port) requester))

(module+ test
  (require rackunit
           "base.rkt"
           "call-response.rkt")

  (define domain "httpbin.org")
  (define http-url (domain+relative-path->http-url "http" domain "/"))
  (define https-url (domain+relative-path->http-url "https" domain "/"))

  (define http-req (make-domain-requester domain http-requester))
  (define https-req
    (make-https-requester domain http-requester))
 
  (define http-resp (get http-req "/ip"))
  (define https-resp (get https-req "/ip"))
  
  (check-pred url? http-url)
  (check-equal? "http" (url-scheme http-url))
  (check-equal? "https" (url-scheme https-url))
  
  (check-pred requester? http-req)
  (check-equal? 200 (http-response-code http-resp))
  (check-equal? 200 (http-response-code https-resp)))