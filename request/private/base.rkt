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

(define (merge-json-headers headers)
  (flatten (cons json-headers headers)))

(define (get call-response-fn url #:headers [headers '()])
  (call-response-fn url (get-impure-port _ headers)))

(define (put call-response-fn url body #:headers [headers '()])
  (call-response-fn url (put-impure-port _ body headers)))

(define (post call-response-fn url body #:headers [headers '()])
  (call-response-fn url (post-impure-port _ body headers)))

(define (delete call-response-fn url #:headers [headers '()])
  (call-response-fn url (delete-impure-port _ headers)))

(define (wrap-http-method method-fn)
  (λ (url #:headers [headers '()] . rest)
    (apply method-fn call-response/input-url url #:headers headers rest)))

(define (wrap-json-method method-fn)
  (λ (url #:headers [headers '()] . rest)
    (apply method-fn call-response/input-json-url url #:headers
           (merge-json-headers headers) rest)))

(define (wrap-json-body method-fn)
  (λ (url body #:headers [headers '()] . rest)
    (apply method-fn url (jsexpr->bytes body) #:headers headers rest)))

(define http-requester
  (requester (wrap-http-method get)
             (wrap-http-method put)
             (wrap-http-method post)
             (wrap-http-method delete)))

(define json-requester
  (requester (wrap-json-method get)
             (wrap-json-body (wrap-json-method put))
             (wrap-json-body (wrap-json-method post))
             (wrap-json-method delete)))
