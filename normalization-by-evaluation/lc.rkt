#lang racket

;;; lambda calculus
; T = X
;   | (λ (X) T)
;   | (T T)
;;; normal form
; NF = NEU
;    | (λ (X) NF)
; NEU = X
;    | (NEU NF)
;;; subst
(define (subst e x s)
  (match e
    [`(λ (,xi-1) ,b)
     (if (equal? `,xi-1 `,x)
         `,e
         `(λ (,xi-1)
            ,(subst b x s)))]
    [`(,e1 ,e2)
     `(,(subst e1 x s) ,(subst e2 x s))]
    [`,e
     (if (equal? `,e `,x)
         `,s
         `,e)]))
;;; evaluate : T → T
(define (evaluate e)
  (match e
    [`(,e1 ,e2)
     (match (evaluate e1)
       [`(lambda (,x) ,e2)
        (evaluate (subst e2 x e1))]
       [e1*
        `(,e1* ,e2)])]
    [e e]))
;;; normalize : T → NF
(define (normalize e)
  (match (evaluate e)
    [`(λ (,x) ,e)
     `(λ (,x) ,(normalize e))]
    [`(,e1 ,e2)
     `(,(normalize e1) ,(normalize e2))]
    [x x]))
