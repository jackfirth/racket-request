#lang racket

(provide defrequester
         defpredicate
         defstructinfo)

(require scribble/manual
         "../private/struct.rkt")


(define-syntax-rule (define-defthing-syntax id contract)
  (define-syntax-rule (id thing-id pre-flow (... ...))
    (defthing thing-id contract pre-flow (... ...))))

(define-defthing-syntax defrequester requester?)
(define-defthing-syntax defpredicate predicate/c)
(define-defthing-syntax defstructinfo struct-info?)
