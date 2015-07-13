#lang racket

(provide defrequester
         defpredicate)

(require scribble/manual
         "../private/struct.rkt")


(define-syntax-rule (defrequester requester-id pre-flow ...)
  (defthing requester-id requester? pre-flow ...))

(define-syntax-rule (defpredicate predicate-id pre-flow ...)
  (defthing predicate-id predicate/c pre-flow ...))
