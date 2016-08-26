#lang info

(define collection 'multi)

(define version "0.1")

(define deps
  '("base"
    "fancy-app"
    "rackunit-lib"
    "scribble-lib"
    "typed-racket-lib"
    "typed-racket-more"))

(define build-deps
  '("net-doc"
    "rackunit-lib"
    "rackunit-doc"
    "racket-doc"))

(define test-omit-paths
  '("info.rkt"
    "request/main.scrbl"
    "request/doc-utils"
    "request/private/base.scrbl"
    "request/private/struct.scrbl"))
