;; Filter

;;   While Emacs Lisp has a =mapcar=, it doesn't have a =filter=
;;   function.


(defun filter (condp lst)
  "Emacs Lisp doesn’t come with a ‘filter’ function to keep
elements that satisfy a conditional and excise the elements that
do not satisfy it. One can use ‘mapcar’ to iterate over a list
with a conditional, and then use ‘delq’ to remove the ‘nil’
values."
  (delq nil
        (mapcar (lambda (x) (and (funcall condp x) x)) lst)))



;; Might as well have an =inverse-filter= to filter out everything
;; that /doesn't/ match the predicate function:


(defun inverse-filter (condp lst)
  "A filter function, but returns a list of the entries that
don't match the predicate."
  (delq nil
        (mapcar (lambda (x) (and (not (funcall condp x)) x)) lst)))



;; First, define the =curry= function:


(defsubst curry (function &rest arguments)
  (lexical-let ((function function)
                (arguments arguments))
    (lambda (&rest more) (apply function (append arguments more)))))



;; And the right-oriented =rcurry= function:


(defsubst rcurry (function &rest arguments)
  (lexical-let ((function function)
                (arguments arguments))
    (lambda (&rest more) (apply function (append more arguments)))))



;; And the =compose= function that can accept a number of functions:


(defsubst compose (function &rest more-functions)
  (cl-reduce (lambda (f g)
               (lexical-let ((f f) (g g))
                 (lambda (&rest arguments)
                   (funcall f (apply g arguments)))))))

;; Key Sequences

;;   As I wrote in [[http://www.howardism.org/Technical/Emacs/lists-and-key-sequences.html][key sequences essay]], the following macro makes it
;;   trivial to create a key sequence, like what I have in [[file:emacs-client.org::*Color%20Theme][emacs-client]]
;;   initialization file.


(defmacro define-sequence (map-name prefix func seqs)
  "Define a collection of key sequences associated with MAP-NAME
and begin with PREFIX that call a function, FUNC.  The SEQS is a
list where each element is a list that begins with a final key
binding. The rest of the list is given as parameters to the
function, FUNC."
  `(progn
     (define-prefix-command ,map-name)
     (global-set-key (kbd ,prefix) ,map-name)
     (dolist (el ,seqs)
       (lexical-let ((keystroke (car el))
                     (the-rest  (cdr el)))
         (define-key ,map-name (kbd keystroke)
           (lambda ()
             (interactive)
             (apply ,func the-rest)))))))

;; Technical Artifacts

;;   Make sure that we can simply =require= this library.


(provide 'init-support)
