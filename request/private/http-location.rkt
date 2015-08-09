#lang racket

(require net/url
         fancy-app
         "struct.rkt"
         "wrap.rkt")

(provide
 (contract-out
  [make-domain-requester (-> string? requester? requester?)]
  [make-host+port-requester (-> string? exact-nonnegative-integer? requester? requester?)]))


(define (domain+relative-path->http-url domain relative-path)
  (string->url (format "http://~a/~a" domain relative-path)))

(define (host+port->domain host port)
  (format "~a:~a" host port))

(define (make-domain-requester domain requester)
  (wrap-requester-location (domain+relative-path->http-url domain _) requester))

(define (make-host+port-requester host port requester)
  (make-domain-requester (host+port->domain host port) requester))
