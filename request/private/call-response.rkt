#lang typed/racket

(require typed/net/url
         typed/net/head
         fancy-app
         typed/json)

(provide (struct-out http-response)
         HttpResponse
         Url
         call-response/input-url
         call-response/input-json-url)


(struct http-response
  ([code : Positive-Integer]
   [headers : (HashTable String String)]
   [body : String]) #:transparent)

(struct json-response
  ([code : Positive-Integer]
   [headers : (HashTable String String)]
   [body : JSExpr]) #:transparent)

(define-type HttpResponse http-response)
(define-type JsonResponse json-response)
(define-type Url url)

(: not-newline? (-> Char Boolean))
(define (not-newline? char)
  (not (char=? #\newline char)))

(: not-whitespace? (-> Char Boolean))
(define (not-whitespace? char)
  (not (char-whitespace? char)))

(: split-combined-header (-> String (Values String String)))
(define (split-combined-header HTTP-header+MIME-headers)
  (define chars (string->list HTTP-header+MIME-headers))
  (define-values (http-chars mime-chars)
    (splitf-at chars not-newline?))
  (values (apply string http-chars)
          (apply string mime-chars)))

(: http-header-code (-> String Positive-Integer))
(define (http-header-code HTTP-header)
  (define chars (string->list HTTP-header))
  (define dropped-protocol (rest (dropf chars not-whitespace?)))
  (define code-chars (takef dropped-protocol not-whitespace?))
  (cast (string->number (apply string code-chars)) Positive-Integer))

(: impure-port->headers
   (-> Input-Port (Values Positive-Integer (HashTable String String))))
(define (impure-port->headers impure-port)
  (define HTTP-header+MIME-headers (purify-port impure-port))
  (define-values (HTTP-header MIME-headers)
    (split-combined-header HTTP-header+MIME-headers))
  (define status-code (http-header-code HTTP-header))
  (define headers
    (cast (make-hash (extract-all-fields MIME-headers))
          (HashTable String String)))
  (values status-code headers))

(: impure-port->http-response (-> Input-Port HttpResponse))
(define (impure-port->http-response impure-port)
  (define-values (status-code headers)
    (impure-port->headers impure-port))
  (define raw-body (port->string impure-port))
  (http-response status-code headers raw-body))

(: impure-port->json-response (-> Input-Port JsonResponse))
(define (impure-port->json-response impure-port)
  (define-values (status-code headers)
    (impure-port->headers impure-port))
  (define json-body (string->jsexpr (port->string impure-port)))
  (json-response status-code headers json-body))

(: call-response/input-url (-> Url (-> Url Input-Port) HttpResponse))
(define (call-response/input-url url connect)
  (call/input-url url connect impure-port->http-response))

(: call-response/input-json-url (-> Url (-> Url Input-Port) JsonResponse))
(define (call-response/input-json-url url connect)
  (call/input-url url connect impure-port->json-response))
