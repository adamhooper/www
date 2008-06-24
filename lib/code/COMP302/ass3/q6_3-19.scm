; No extra programming needs to be done! The rest of this file is a copy of
; interp_3-5.scm

; Copied from EOPL, starting at page 73
; This one adds Section 3.3, Conditional Evaluation
; It also adds Section 3.4, Local binding
; It also adds Section 3.5, Procedures

(require (lib "eopl.ss" "eopl"))

; Copy the environment from q1_2-20.scm (any q1 or q2 answers would be fine)
(load "q1_2-20.scm")

(define-datatype program program?
  (a-program
    (exp expression?)))

(define-datatype expression expression?
  (lit-exp
    (datum number?))
  (var-exp
    (id symbol?))
  (primapp-exp
    (prim primitive?)
    (rands (list-of expression?)))
  (if-exp
    (test-exp expression?)
    (true-exp expression?)
    (false-exp expression?))
  (let-exp
    (ids (list-of symbol?))
    (rands (list-of expression?))
    (body expression?))
  (proc-exp
    (ids (list-of symbol?))
    (body expression?))
  (app-exp
    (rator expression?)
    (rands (list-of expression?)))
  )

(define-datatype primitive primitive?
  (add-prim)
  (subtract-prim)
  (mult-prim)
  (incr-prim)
  (decr-prim))

(define-datatype procval procval?
  (closure
    (ids (list-of symbol?))
    (body expression?)
    (env environment?)))

(define eval-program
  (lambda (pgm)
    (cases program pgm
      (a-program (body)
	(eval-expression body (init-env))))))

(define eval-expression
  (lambda (exp env)
    (cases expression exp
      (lit-exp (datum) datum)
      (var-exp (id) (apply-env env id))
      (primapp-exp (prim rands)
	(let ((args (eval-rands rands env)))
	  (apply-primitive prim args)))
      (if-exp (test-exp true-exp false-exp)
	(if (true-value? (eval-expression test-exp env))
	  (eval-expression true-exp env)
	  (eval-expression false-exp env)))
      (let-exp (ids rands body)
	(let ((args (eval-rands rands env)))
	  (eval-expression body (extend-env ids args env))))
      (proc-exp (ids body) (closure ids body env))
      (app-exp (rator rands)
	(let ((proc (eval-expression rator env))
	      (args (eval-rands rands env)))
	  (if (procval? proc)
	    (apply-procval proc args)
	    (eopl:error 'eval-expression
	      "Attempt to apply non-procedure ~s" proc))))
      )))

(define eval-rands
  (lambda (rands env)
    (map (lambda (x) (eval-rand x env)) rands)))

(define eval-rand
  (lambda (rand env)
    (eval-expression rand env)))

(define apply-primitive
  (lambda (prim args)
    (cases primitive prim
      (add-prim () (+ (car args) (cadr args)))
      (subtract-prim () (- (car args) (cadr args)))
      (mult-prim () (* (car args) (cadr args)))
      (incr-prim () (+ (car args) 1))
      (decr-prim () (- (car args) 1)))))

(define apply-procval
  (lambda (proc args)
    (cases procval proc
      (closure (ids body env)
	       (eval-expression body (extend-env ids args env))))))

(define init-env
  (lambda ()
    (extend-env
      '(i v x)
      '(1 5 10)
      (empty-env))))

(define true-value?
  (lambda (x)
    (not (zero? x))))

(define scanner-spec-3-1
  '((white-sp
      (whitespace)				skip)
    (comment
      ("%" (arbno (not #\newline)))		skip)
    (identifier
      (letter (arbno (or letter digit "?")))	symbol)
    (number
      (digit (arbno digit))			number)))

(define grammar-3-1
  '((program
      (expression)
      a-program)
    (expression
      (number)
      lit-exp)
    (expression
      (identifier)
      var-exp)
    (expression
      (primitive "(" (separated-list expression ",") ")" )
      primapp-exp)
    (expression
      ("if" expression "then" expression "else" expression)
      if-exp)
    (expression
      ("let" (arbno identifier "=" expression) "in" expression)
      let-exp)
    (expression
      ("proc" "(" (separated-list identifier ",") ")" expression)
      proc-exp)
    (expression
      ("(" expression (arbno expression) ")")
      app-exp)
    (primitive ("+")
      add-prim)
    (primitive ("-")
      subtract-prim)
    (primitive ("*")
      mult-prim)
    (primitive ("add1")
      incr-prim)
    (primitive ("sub1")
      decr-prim)))

(define scan&parse
  (sllgen:make-string-parser
    scanner-spec-3-1
    grammar-3-1))
;(sllgen:make-define-datatypes scanner-spec-3-1 grammar-3-1)
(define run
  (lambda (string)
    (eval-program
      (scan&parse string))))
(define read-eval-print
  (sllgen:make-rep-loop "--> " eval-program
    (sllgen:make-stream-parser
      scanner-spec-3-1
      grammar-3-1)))
