#lang racket

(require net/url
         fancy-app
         json
         "call-response.rkt"
         "struct.rkt")

(provide http-requester
         json-requester)

(define json-headers
  '("Accept: application/json" "Content-Type: application/json"))

(define (merge-headers headers)
  (flatten (cons json-headers headers)))

(define (http-get url #:headers [headers '()])
  (call-response/input-url url (get-impure-port _ headers)))

(define (http-put url body #:headers [headers '()])
  (call-response/input-url url (put-impure-port _ body headers)))

(define (http-post url body #:headers [headers '()])
  (call-response/input-url url (post-impure-port _ body headers)))

(define (http-delete url #:headers [headers '()])
  (call-response/input-url url (delete-impure-port _ headers)))

(define (http-json-get url #:headers [headers '()])
  (call-response/input-json-url url (get-impure-port _ headers)))

(define (http-json-put url body #:headers [headers '()])
  (call-response/input-json-url url (put-impure-port _ body headers)))

(define (http-json-post url body #:headers [headers '()])
  (call-response/input-json-url url (post-impure-port _ body headers)))

(define (http-json-delete url #:headers [headers '()])
  (call-response/input-json-url url (delete-impure-port _ headers)))

(define (wrap-json-headers method-fn)
  (λ (url #:headers [headers '()] . rest)
    (define json-headers (merge-headers headers))
    (apply method-fn url #:headers json-headers rest)))

(define (wrap-json-body method-fn)
  (λ (url body #:headers [headers '()] . rest)
    (define json-headers (merge-headers headers))
    (define json-body (jsexpr->bytes body))
    (apply method-fn url json-body #:headers json-headers rest)))

(define http-requester
  (requester http-get
             http-put
             http-post
             http-delete))

(define json-requester
  (requester (wrap-json-headers http-json-get)
             (wrap-json-body http-json-put)
             (wrap-json-body http-json-post)
             (wrap-json-headers http-json-delete)))
