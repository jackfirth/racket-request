#lang info


(define collection 'multi)


(define version "0.1")


(define deps
  '("base"
    "fancy-app"
    "rackunit-lib"
    "scribble-lib"
    "typed-racket-lib"
    "typed-racket-more"
    "unstable-contract-lib"))


(define build-deps
  '("cover"
    "rackunit-lib"
    "rackunit-doc"
    "racket-doc"
    "doc-coverage"))


(define test-omit-paths
  '("info.rkt"
    "request/main.scrbl"
    "request/doc-utils"
    "request/private/base.scrbl"
    "request/private/struct.scrbl"))
