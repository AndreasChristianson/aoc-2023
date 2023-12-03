#lang racket
(define lines  null)

 (call-with-input-file "input.txt"
   (lambda (port)
     (for ([l (in-lines port)])
     (set! lines
       (cons (string->list l) lines)
       )
     )
   )
)
(set! lines (reverse lines))

;(displayln lines)

;(define (length lst)
;  (cond
;    [(empty? lst)  0]
;    [(cons? lst)   (+ 1 (length (rest lst)))]))

(define (isBlank input)
    (eqv? #\. input)
)

(define (gear? input)
    (eqv? #\* input)
)

(define width (length (car lines)))
(define height (length lines))

(define (get lst index)
  (cond
    [(= index 0)  (car lst)]
    [(get (rest lst) (- index 1))]))

(define (symb? input)
  ( not
    (or
      (isBlank input )
      (char-numeric? input)
    )
  )
)

(define (checkThreeLayers row col)
;  (displayln (list "checklayers" row col))
;  (displayln (get (get lines row) col))
;  (displayln (get (get lines (+ row 1)) col))
  (cond
    [(symb? (get (get lines row) col)) true]
    [(and (< 0 row) (symb? (get (get lines (- row 1)) col))) true]
    [(and (> (- height 1) row) (symb? (get (get lines (+ row 1)) col))) true]
    [else false]
  )
)

(define (shouldCount row col len)
;  (displayln (list "should count" row col len))
  (cond
    [(> 0 len) false]
    [(or (< (+ col len) 1) (> (+ col len) (- width 1))) (shouldCount row col (- len 1))]
    [(checkThreeLayers row (+ col len)) true]
    [else (shouldCount row col (- len 1))]
  )
)


(define (consumeNumber line row col digits)
;  (displayln (list "consuming number" row col digits ))
  (cond
    [(empty? line) (cond
      [(shouldCount row (- (- col (length digits)) 1) (+ (length digits) 1)) (list (string->number (list->string digits)))]
      [else empty]
    )]
    [(or (isBlank (first line)) (symb? (first line))) (cond
      [(shouldCount row (- (- col (length digits)) 1) (+ (length digits) 1)) (cons (string->number (list->string digits)) (alanyzeLine line row col))]
      [else (alanyzeLine line row col)]
    )]
    [else (consumeNumber (rest line) row (+ col 1) (append digits (list (first line))))]
  )
)
(define (alanyzeLine line row col)
;  (displayln (list "analyzing line" row col ))
  (cond
    [(empty? line) empty]
    [(isBlank (first line)) (alanyzeLine (rest line) row (+ col 1))]
    [(symb? (first line)) (alanyzeLine (rest line) row (+ col 1))]
    [else (consumeNumber (rest line) row (+ col 1) (list (first line)))]
  )
)

(define (analyze remainingLines row)
;  (displayln (list "analyzing row" row))
  (cond
    [(empty? remainingLines) empty]
    [else (append (alanyzeLine (first remainingLines) row 0) (analyze (rest remainingLines) (+ row 1)))]
  )
)


(define partNumbers (analyze lines 0))
(define (sum lst)
  (cond
    [(empty? lst) 0]
    [else (+ (first lst) (sum (rest lst)))]
  )
)

;(displayln partNumbers)
(displayln (list "partnumbers sum" (sum partNumbers)))

(define (rc row col)
  (get (get lines row) col)
)
(define (parseNumber row col digits)
  (cond
    [(or (= col (- width 1)) (not (char-numeric? (rc row (+ col 1))))) (string->number (list->string (reverse (cons (rc row col) digits ))))]
    [else  (parseNumber row (+ col 1) (cons (rc row col) digits))]
  )
)

(define (findFront row col)
  (cond
    [(or (= col 0) (not (char-numeric? (rc row (- col 1))))) (parseNumber row col empty)]
    [else (findFront row (- col 1))]
  )
)

(define (extractNumber row col)
;  (displayln (list "extractNumber" row col ))
  (findFront row col)
)

(define (checkUp row col)
;  (displayln (list "checkUp" row col ))
  (cond
;    [(= row 0) empty] ; not in the data
    [(not (char-numeric? (rc (- row 1) col))) empty]
    [else (extractNumber (- row 1) col)]
  )
)
(define (checkUpLeft row col)
;  (displayln (list "checkUpLeft" row col ))
  (cond
    [(not (char-numeric? (rc (- row 1) (- col 1)))) empty]
    [(char-numeric? (rc (- row 1) col)) empty]
    [else (extractNumber (- row 1) (- col 1))]
  )
)

(define (checkLeft row col)
;  (displayln (list "checkLeft" row col ))
  (cond
    [(not (char-numeric? (rc row (- col 1)))) empty]
    [else (extractNumber row (- col 1))]
  )
)
(define (checkDownLeft row col)
;  (displayln (list "checkDownLeft" row col ))
  (cond
    [(not (char-numeric? (rc (+ row 1) (- col 1)))) empty]
    [(char-numeric? (rc (+ row 1) col)) empty]
    [else (extractNumber (+ row 1) (- col 1))]
  )
)

(define (checkDown row col)
;  (displayln (list "checkDown" row col ))
  (cond
    [(not (char-numeric? (rc (+ row 1) col))) empty]
    [else (extractNumber (+ row 1) col)]
  )
)
(define (checkDownRight row col)
;  (displayln (list "checkDownRight" row col ))
  (cond
    [(not (char-numeric? (rc (+ row 1) (+ col 1)))) empty]
    [(char-numeric? (rc (+ row 1) col)) empty]
    [else (extractNumber (+ row 1) (+ col 1))]
  )
)
(define (checkRight row col)
;  (displayln (list "checkRight" row col ))
  (cond
    [(char-numeric? (rc row (+ col 1))) (extractNumber row (+ col 1))]
    [else empty]
  )
)
(define (checkUpRight row col)
;  (displayln (list "checkUpRight" row col ))
  (cond
    [(not (char-numeric? (rc (- row 1) (+ col 1)))) empty]
    [(char-numeric? (rc (- row 1) col)) empty]
    [else (extractNumber (- row 1) (+ col 1))]
  )
)
(define (analyzeGear row col)
;  (displayln (list "analyzeGear" row col ))
  (list
    (checkUp row col)
    (checkUpLeft row col)
    (checkLeft row col)
    (checkDownLeft row col)
    (checkDown row col)
    (checkDownRight row col)
    (checkRight row col)
    (checkUpRight row col)
  )
)

(define (findGearsInLine line row col)
;  (displayln (list "findGearsInLine" row col ))
  (cond
    [(empty? line) empty]
    [(gear? (first line)) (cons (analyzeGear row col) (findGearsInLine (rest line) row (+ col 1)))]
    [else (findGearsInLine (rest line) row (+ col 1))]
  )
)

(define (findGears remainingLines row)
;  (displayln (list "findGears" row))
  (cond
    [(empty? remainingLines) empty]
    [else (append (findGearsInLine (first remainingLines) row 0) (findGears (rest remainingLines) (+ row 1)))]
  )
)

(define gears (findGears lines 0))
(define (findNextNonEmpty lst)
  (cond
    [(empty? lst) 0]
    [(empty? (first lst)) (findNextNonEmpty (rest lst))]
    [else (first lst)]
  )
)
(define (calculateRatio lst)
  (cond
    [(empty? lst) 0]
    [(empty? (first lst)) (calculateRatio (rest lst))]
    [else (* (first lst) (findNextNonEmpty (rest lst)))]
  )
)
(define (cleanupGears lst)
  (cond
    [(empty? lst) 0]
    [else (+ (calculateRatio (first lst)) (cleanupGears (rest lst)))]
  )
)
(displayln (list "ratio sum " (cleanupGears gears)))
