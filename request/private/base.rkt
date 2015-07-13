#lang racket

(require net/url
         fancy-app
         "call-response.rkt"
         "struct.rkt")

(provide base-requester)


(define (base-get url #:headers [headers '()])
  (call-response/input-url url (get-impure-port _ headers)))

(define (base-put url body #:headers [headers '()])
  (call-response/input-url url (put-impure-port _ body headers)))

(define (base-post url body #:headers [headers '()])
  (call-response/input-url url (post-impure-port _ body headers)))

(define (base-delete url #:headers [headers '()])
  (call-response/input-url url (delete-impure-port _ headers)))

(define base-requester
  (requester base-get
             base-put
             base-post
             base-delete))
