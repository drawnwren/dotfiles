;; #+TITLE:  F2 Keybindings for Emacs
;; #+AUTHOR: Howard
;; #+EMAIL:  howard.abrams@gmail.com
;; #+DATE:   2015 Jan 04
;; #+TAGS:   technical emacs

;; The *F2* is used to enter odd characters not normally available or
;; phrases I want to type a bit too often.


(define-prefix-command 'f2-global-map)
(global-set-key (kbd "<f2>") 'f2-global-map)

;; Unicode Characters

;;   Some of my frequently used Unicode characters:


(define-key f2-global-map (kbd "<up>") "↑")
(define-key f2-global-map (kbd "<down>") "↓")
(define-key f2-global-map (kbd "<left>") "←")
(define-key f2-global-map (kbd "<right>") "→")
(define-key f2-global-map (kbd "S-<up>") "⇑")
(define-key f2-global-map (kbd "S-<down>") "⇓")
(define-key f2-global-map (kbd "S-<left>") "⇐")
(define-key f2-global-map (kbd "S-<right>") "⇒")

(define-key f2-global-map (kbd "p") "▯")   ;; Representation of a cursor

(define-key f2-global-map (kbd "'") "’")
(define-key f2-global-map (kbd "\"") "‘")

(define-key f2-global-map (kbd "8") "•")
(define-key f2-global-map (kbd "*") "°")
(define-key f2-global-map (kbd "d") "†")
(define-key f2-global-map (kbd "D") "‡")
(define-key f2-global-map (kbd "-") "—")
(define-key f2-global-map (kbd ".") "…")
(define-key f2-global-map (kbd ";") "😉")
(define-key f2-global-map (kbd ")") "☺")

(define-key f2-global-map (kbd "A") "α")   ;; Lowercase Greek is uppercase
(define-key f2-global-map (kbd "B") "β")
(define-key f2-global-map (kbd "E") "ε")
(define-key f2-global-map (kbd "L") "λ")
(define-key f2-global-map (kbd "P") "π")
(define-key f2-global-map (kbd "M") "μ")
(define-key f2-global-map (kbd "T") "θ")



;; Most key-bindings accept a string that will be inserted, but some
;; strings (notably those with Unicode symbols that refer to numbers),
;; actually become a prefix, so a little closure should do the trick:


(require 'cl)

(defun ha/insert (ch)
  (lexical-let ((chr ch))
    (lambda () (interactive) (insert chr))))



;; Key-bindings for special numeric symbols:


(define-key f2-global-map (kbd "!") (ha/insert "¹"))
(define-key f2-global-map (kbd "@") (ha/insert "²"))
(define-key f2-global-map (kbd "#") (ha/insert "³"))
(define-key f2-global-map (kbd "$") (ha/insert "⁴"))

(define-key f2-global-map (kbd "2") (ha/insert "½"))
(define-key f2-global-map (kbd "3") (ha/insert "⅓"))
(define-key f2-global-map (kbd "4") (ha/insert "¼"))

;; Italic and Bold Letters

;;   For mathematical and other equations, I like to be able to enter
;;   bold and italic letters, but instead of a series of calls and the
;;   matching glyph, I can create a function that uses the =lexical-let=
;;   to return a lambda expression suitable for passing on to =mapcar*=:


(defun ha/letter-mapping (key-prefix)
  (lexical-let ((keyprefix key-prefix))
    (lambda (chr glyph)
      (define-key f2-global-map
        (kbd (concat keyprefix (string chr))) (string glyph)))))



;; The mathematical italic Capital A in Unicode is U+1D434 and Z is U+1D44D.
;; A sequence mapping the letters ‘A’ to ‘Z’ are /zipped/ together:


(mapcar* (ha/letter-mapping "M-")
         (number-sequence 65 90)
         (number-sequence #x01D434 #x01D44D))



;; So 𝐴 is entered with a =F2 M-A=

;; Do the same thing with the lower case letters, were
;; Lowercase italic a is U+1D44E and z is U+1D467:


(mapcar* (ha/letter-mapping "M-")
         (number-sequence 97 122)
         (number-sequence #x01D44E #x01D467))



;; We’ll bind both the Meta and Control keys for the bold and italic expressions.
;; Where capital bold A is U+1D468, and lower bold a is U+1D482:


(mapcar* (ha/letter-mapping "C-M-")
         (number-sequence 65 90)
         (number-sequence #x01D468 #x01D481))

(mapcar* (ha/letter-mapping "C-M-")
         (number-sequence 97 122)
         (number-sequence #x01D482 #x01D49B))

;; Math Symbols

;;   I really don’t type that much math, but in trying to translate some
;;   mathematically-minded papers, I realize that I could use a few:


(define-key f2-global-map (kbd "=") "≡")
(define-key f2-global-map (kbd ":") "≔")
(define-key f2-global-map (kbd "~") "≝")



;; Most math, however, should be based on the meta prefix:


(define-key f2-global-map (kbd "M-.") "∴")  ; Therefore
(define-key f2-global-map (kbd "M-,") "∵")  ; Therefore
(define-key f2-global-map (kbd "M-t") "⊢")  ; Turnstile ... to assert
(define-key f2-global-map (kbd "M-T") "≜")  ; Should be a triangle over equal sign
(define-key f2-global-map (kbd "M-n") "∅")  ; Empty Set
(define-key f2-global-map (kbd "M-e") "∃")  ; There exists
(define-key f2-global-map (kbd "M-E") "∄")  ; There does not exist
(define-key f2-global-map (kbd "M-i") "∩")  ; Intersection
(define-key f2-global-map (kbd "M-u") "∪")  ; Union
(define-key f2-global-map (kbd "M-6") "⋀")  ; Conjunction
(define-key f2-global-map (kbd "M-^") "⋁")  ; Disjunction
(define-key f2-global-map (kbd "M-*") "✕")  ; Multiply
(define-key f2-global-map (kbd "M-/") "÷")  ; Divide
(define-key f2-global-map (kbd "M-!") "¬")  ; Logical Not

;; Favorite Phrases

;;   What do I really need to enter that often that auto-completion
;;   doesn’t immediately solve?


(define-key f2-global-map (kbd "D") "Drew Ulick")

;; Technical Artifacts

;;   Make sure that we can simply =require= this library.


(provide 'init-f2)
