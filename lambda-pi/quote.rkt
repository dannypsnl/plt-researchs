#lang typed/racket

(provide quote)

(require "term.rkt"
         "value.rkt")

(: quote (->* (value) (Integer) checkable-term))
(define (quote v [i : Integer 0])
  (match v
    [(v:λ f)
     (t:λ (quote (f (vfree (name:quote i))) (+ 1 i)))]
    [(v:neutral n)
     (neutral-quote v i n)]
    [(v:*) (t:*)]
    [(v:Π v f)
     (t:Π (quote v i)
          (quote (f (vfree (name:quote i)))
                 (+ 1 i)))]))
(define (neutral-quote [v : value]
                       [i : Integer]
                       [neu : neutral])
  : inferable-term
  (match neu
    [(neu:free name) (bound-free v i name)]
    [(neu:app n v)
     (t:app (neutral-quote v i n)
            (quote v i))]))
(define (bound-free [v : value]
                    [i : Integer]
                    [name : name])
  : inferable-term
  (match name
    [(name:quote k) (t:bound (- i k 1))]
    [x (t:free x)]))
