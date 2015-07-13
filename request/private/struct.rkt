#lang racket

(provide (struct-out requester)
         get
         put
         post
         delete)

(struct requester (get put post delete))

(define (get requester url #:headers [headers '()])
  ((requester-get requester) url #:headers headers))

(define (put requester url data #:headers [headers '()])
  ((requester-put requester) url data #:headers headers))

(define (post requester url data #:headers [headers '()])
  ((requester-post requester) url data #:headers headers))

(define (delete requester url #:headers [headers '()])
  ((requester-delete requester) url #:headers headers))
