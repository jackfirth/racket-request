#lang racket

(provide request-examples)

(require scribble/eval)


(define-syntax-rule (define-examples-form id require-spec ...)
  (begin
    (define (eval-factory)
      (define base-eval (make-base-eval))
      (base-eval '(require require-spec)) ...
      base-eval)
    (define-syntax-rule (id datum (... ...))
      (examples #:eval (eval-factory) datum (... ...)))))


(define-examples-form request-examples request)
