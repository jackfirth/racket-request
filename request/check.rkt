#lang racket

(require "param.rkt"
         rackunit)

(provide (all-from-out "param.rkt")
         check-get
         check-get-exn
         check-get-not-exn
         check-put
         check-put-exn
         check-put-not-exn
         check-post
         check-post-exn
         check-post-not-exn
         check-delete
         check-delete-exn
         check-delete-not-exn)

(define (fail-check-unless-responses-equal actual-response expected-response)
  (unless (equal? actual-response expected-response)
    (fail-check "Check failure - expected response does not equal actual response")))


(define-syntax-rule (with-request-check-info (location response) body ...)
  (with-check-info (['location location]
                    ['response response])
    body ...))

(define-syntax-rule (with-request-check-info/body (location request-body response) body ...)
  (with-check-info (['location location]
                    ['request-body request-body]
                    ['response response])
    body ...))


(define (check-response location actual-response response)
  (with-request-check-info (location actual-response)
    (fail-check-unless-responses-equal actual-response response)))

(define (check-response/body location body actual-response response)
  (with-request-check-info/body (location body actual-response)
    (fail-check-unless-responses-equal actual-response response)))
  

(define-check (check-get location response)
  (check-response location (get location) response))

(define-check (check-get-exn exn-pred location)
  (check-exn exn-pred (thunk (get location))))

(define-check (check-get-not-exn location)
  (check-not-exn (thunk (get location))))


(define-check (check-put location body response)
  (check-response/body location body (put location body) response))

(define-check (check-put-exn exn-pred location body)
  (check-exn exn-pred (thunk (put location body))))

(define-check (check-put-not-exn location body)
  (check-not-exn (thunk (put location body))))


(define-check (check-post location body response)
  (check-response/body location body (post location body) response))

(define-check (check-post-exn exn-pred location body)
  (check-exn exn-pred (thunk (post location body))))

(define-check (check-post-not-exn location body)
  (check-not-exn (thunk (post location body))))


(define-simple-check (check-delete location response)
  (check-response location (delete location) response))

(define-check (check-delete-exn exn-pred location)
  (check-exn exn-pred (thunk (delete location))))

(define-check (check-delete-not-exn location)
  (check-not-exn (thunk (delete location))))
