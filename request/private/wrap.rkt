#lang racket

(require "struct.rkt"
         fancy-app)

(provide wrap-requester
         wrap-requester-location
         wrap-requester-body
         wrap-requester-response
         add-requester-headers)


(define (wrap-requester wrapper requester-to-wrap)
  (requester (wrapper (requester-get requester-to-wrap))
             (wrapper (requester-put requester-to-wrap))
             (wrapper (requester-post requester-to-wrap))
             (wrapper (requester-delete requester-to-wrap))))


(define (wrap-requester-location location-func requester)
  (define ((wrapper handler) location #:headers [headers '()] . rest)
    (apply handler (location-func location) #:headers headers rest))
  (wrap-requester wrapper requester))

(define (wrap-requester-body body-func requester)
  (define ((wrapper handler) location #:headers [headers '()] . rest)
    (apply handler location #:headers headers (map body-func rest)))
  (wrap-requester wrapper requester))

(define (wrap-requester-response response-func requester)
  (define ((wrapper handler) location #:headers [headers '()] . rest)
    (response-func (apply handler location #:headers headers rest)))
  (wrap-requester wrapper requester))

(define (add-requester-headers base-headers requester)
  (define ((wrapper handler) location #:headers [headers '()] . rest)
    (apply handler location #:headers (append base-headers headers) rest))
  (wrap-requester wrapper requester))
