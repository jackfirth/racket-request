#lang racket

(require net/url
         fancy-app
         "call-response.rkt"
         "struct.rkt")

(provide http-requester)


(define (http-get url #:headers [headers '()])
  (call-response/input-url url (get-impure-port _ headers)))

(define (http-put url body #:headers [headers '()])
  (call-response/input-url url (put-impure-port _ body headers)))

(define (http-post url body #:headers [headers '()])
  (call-response/input-url url (post-impure-port _ body headers)))

(define (http-delete url #:headers [headers '()])
  (call-response/input-url url (delete-impure-port _ headers)))

(define http-requester
  (requester http-get
             http-put
             http-post
             http-delete))
