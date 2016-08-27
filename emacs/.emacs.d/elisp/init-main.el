;; My Directory Location

;;    Normally, the =user-emacs-directory= stores everything in a
;;    =.emacs.d= directory in the home directory, however, Aquamacs
;;    overrides that, and since I now feel the need to use these settings
;;    for both editors (sure feels like XEmacs all over again).

;;    Any way, I have a new global variable for that:


(defconst ha/emacs-directory (concat (getenv "HOME") "/.emacs.d/"))

(defun ha/emacs-subdirectory (d) (expand-file-name d ha/emacs-directory))

;; Directory Structure

;;    In case this is the first time running this on a computer, we need
;;    to make sure the following directories have been created.


(let* ((subdirs '("elisp" "backups" "snippets" "ac-dict"))
       (fulldirs (mapcar (lambda (d) (ha/emacs-subdirectory d)) subdirs)))
  (dolist (dir fulldirs)
    (when (not (file-exists-p dir))
      (message "Make directory: %s" dir)
      (make-directory dir))))

;; Customization Section

;;    While I would rather program my configurations, sometimes the Emacs
;;    menu system is "good enough", but I want it in its own file:


(setq custom-file (expand-file-name "custom.el" ha/emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

;; Setting up the Load Path

;;    Extra packages not available via the package manager go in my
;;    personal stash at: =$HOME/.emacs.d/elisp=


(add-to-list 'load-path (ha/emacs-subdirectory "elisp"))



;; Load up my special collection of enhancements to Emacs Lisp:


(require 'cl)
(require 'init-support)


;; Package Manager

;;    Emacs has become like every other operating system, and now has a
;;    [[http://tromey.com/elpa/][package manager]] with its own collection repository, but since it is
;;    so conservative, we need to add more repositories to get all the
;;    sweet goodness, I demand.

;; And set all encoding vars to UTF-8

(setq current-language-environment "UTF-8"
      default-process-coding-system '(utf-8 . utf-8)
      default-buffer-file-coding-system 'utf-8
      coding-system-for-read 'utf-8
      coding-system-for-write 'utf-8
      locale-coding-system 'utf-8
      x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING))

(modify-coding-system-alist 'process "*" 'utf-8)
(prefer-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8)
(set-clipboard-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-file-name-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-language-environment 'utf-8)
(set-selection-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(setq-default pathname-coding-system 'utf-8)

(require 'package)

(setq package-archives '(("org"       . "http://orgmode.org/elpa/")
                         ("gnu"       . "http://elpa.gnu.org/packages/")
                         ("melpa"     . "http://melpa.milkbox.net/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")))

(package-initialize)



;; The package management system doesn't come with a
;; programmatic way to specify what packages /should/ be
;; installed. Here is my solution until I convert to [[Use-Package][use-package]].


(defun packages-install (packages)
  "Given a list of packages, this will install them from the standard locations."
  (let ((to-install (inverse-filter 'package-installed-p packages)))
    (when to-install
      (package-refresh-contents)
      (dolist (it to-install)
        (package-install it)
        (delete-other-windows)))))

;; Use-Package

;;    Using [[https://github.com/jwiegley/use-package][use-package]] to automatically install certain packages, as
;;    well as the ease of lazily loading them.


(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)

;; Tabs vs Spaces

;;    I have learned to distrust tabs in my source code, so let's make
;;    sure that we only have spaces. See [[http://ergoemacs.org/emacs/emacs_tabs_space_indentation_setup.html][this discussion]] for details.

(setq-default indent-tabs-mode nil)
(setq tab-width 2)

;; Make tab key do indent first then completion.

(setq-default tab-always-indent 'complete)



;; Now, any file loaded with a =gpg= extension, e.g. =some.org.gpg=,
;; will prompt for a password (and then use =org-mode=).  Since these
;; files are for my eyes only, I don’t need the key-ring prompt:

(setq epa-file-select-keys 2)

;; Display Settings

(setq initial-scratch-message "") ;; Uh, I know what Scratch is for
(setq visible-bell t)             ;; Get rid of the beeps

(when (window-system)
  (tool-bar-mode 0)               ;; Toolbars were only cool with XEmacs
  (when (fboundp 'horizontal-scroll-bar-mode)
    (horizontal-scroll-bar-mode -1))
  (scroll-bar-mode -1))            ;; Scrollbars are waste screen estate

;; Mode Line
;;    My [[file:emacs-mode-line.org][mode-line code]] is now more complex in order to make it more simpler.
;;(require 'init-mode-line)

;; Whitespace Mode

;;    You don't want this on all the time, but nice to turn it on every
;;    now and then:


(use-package whitespace
  :bind ("C-c T w" . whitespace-mode)
  :init
  (setq whitespace-line-column nil
        whitespace-display-mappings '((space-mark 32 [183] [46])
                                      (newline-mark 10 [9166 10])
                                      (tab-mark 9 [9654 9] [92 9])))
  :config
  (set-face-attribute 'whitespace-space       nil :foreground "#666666" :background nil)
  (set-face-attribute 'whitespace-newline     nil :foreground "#666666" :background nil)
  (set-face-attribute 'whitespace-indentation nil :foreground "#666666" :background nil)
  :diminish whitespace-mode)

;; Fill Mode

;;    Automatically wrapping when you get to the end of a line (or the
;;    fill-region):


(use-package fill
  :bind ("C-c T f" . auto-fill-mode)
  :init (add-hook 'org-mode-hook 'turn-on-auto-fill)
  :diminish auto-fill-mode)

;; Hydra Sequences

;;    I’m starting to appreciate the [[https://github.com/abo-abo/hydra][Hydra project]].
;;    Moved to its own file.

(require 'init-hydra)

;; Easily manipulate the size of the windows using the arrow keys in a
;; particular buffer window.

;; Displaying Command Sequences

;;    Many command sequences may be logical, but who can remember them
;;    all? Use [[https://github.com/kai2nenobu/guide-key][guide-key]] to display the final function name. This isn't
;;    as nice as Hydra, but useful for built-in key sequences:

(use-package guide-key
  :ensure t
  :init    (setq guide-key/guide-key-sequence
                 '("C-x r"     ; rectanges and registers
                   "C-x 4"     ; window commands
                   "M-s h"     ; hi-lock highlighting
                   "C-x w"     ; alternative to M-s ...
                   "C-c @"     ; hs-hide-show mode
                   "C-c p"     ; projectile
                   "<f2>"
                   "<f9>"
                   (org-mode "C-c C-x")))
  :config  (guide-key-mode 1)
  :diminish guide-key-mode)

;; Function Key Definitions

;;    Emacs has never seen a need for function keys, and I agree...for
;;    the most part. For things really /away from the flow/, they don't
;;    seem to bad. But what are those?

;;    - *F1* - Help? Isn't Control-H good enough?
;;    - *F2* - Special odd, little-used characters that I have to think
;;             about before remembering what its binding.
;;    - *F3* - Define a keyboard macro
;;    - *F4* - Replay a keyboard macro
;;    - *F5* - Use org-mode’s Mark Ring feature globally
;;    - *F6* - Open to temporary, changeable commands...
;;    - *F7* - Switch to another window ... Control goes the other way.
;;    - *F8* - Switch to buffer
;;    - *F9* - My extension (replacement?) for =C-c= for changing colors
;;      and other odd bindings that I actually don't use that often.


(global-set-key (kbd "<f5>") 'org-mark-ring-push)
(global-set-key (kbd "C-<f5>") 'org-mark-ring-goto)
(global-set-key (kbd "<f7>") 'other-window)
(global-set-key (kbd "C-<f7>") (lambda () (interactive) (other-window -1)))

;; F2 and F9 Helpers


;; Unlike the *F9* bindings, all the *F2* key-bindings happen in a
;; single [[file:emacs-f2.org][library file]]:


(require 'init-f2)

;; Highlighting and Narrowing

;;    I like the ability to highlight random text.

;;    - =M-s h .= :: highlight-symbol-at-point
;;    - =M-s h l= :: highlight-lines-matching-regexp
;;    - =M-s h p= :: highlight-phrase
;;    - =M-s h r= :: highlight-regexp
;;    - =M-s h u= :: unhighlight-regexp

;;    May get specific highlights automatically for certain files. We
;;    begin by highlighting lines in *.log files.


(defun ha/highlite-logs ()
  "Highlight certain lines in specific files. Currently, only log files are supported."
  (interactive)
  (when (equal "log" (file-name-extension (buffer-file-name)))
    (hi-lock-mode 1)
    (highlight-lines-matching-regexp "ERROR:" 'hi-red-b)
    (highlight-lines-matching-regexp "NOTE:" 'hi-blue-b)))



;; Turn on specific word groupings for specific occasions. We begin
;; with highlighting keywords I use during note-taking sessions at
;; the end of a sprint.


(defun ha/sprint-retrospective-highlighting ()
  "Highlights the good, the bad and the improvements to make when taking notes."
  (interactive)
  (hi-lock-mode t)
  (highlight-lines-matching-regexp "^   [-*] " 'hi-black-b)
  (highlight-phrase "TODO:?" 'hi-black-b)
  (highlight-regexp "(?Good)?:?" 'hi-green-b)
  (highlight-regexp "(?Bad)?:?" 'hi-red-b)
  (highlight-regexp "Imp\\(rove\\)?:" 'hi-blue-b))



;; This works really well with other commands, including
;; [[https://github.com/Bruce-Connor/fancy-narrow][fancy-narrow]], where I can visually high-light a section of a
;; buffer. Great for code-reviews and other presentations.


(use-package fancy-narrow
  :ensure t
  :config
  (defun ha/highlight-block ()
    "Highlights a 'block' in a buffer defined by the first blank
     line before and after the current cursor position. Uses the
     'fancy-narrow' mode to high-light the block."
    (interactive)
    (let (cur beg end)
      (setq cur (point))
      (setq end (or (re-search-forward  "^\s*$" nil t) (point-max)))
      (goto-char cur)
      (setq beg (or (re-search-backward "^\s*$" nil t) (point-min)))
      (fancy-narrow-to-region beg end)
      (goto-char cur)))

  (defun ha/highlight-section (num)
    "If some of the buffer is highlighted with the `fancy-narrow'
     mode, then un-highlight it by calling `fancy-widen'.

     If region is active, call `fancy-narrow-to-region'.

     If NUM is 0, highlight the current block (delimited by blank
     lines). If NUM is positive or negative, highlight that number
     of lines.  Otherwise, called `fancy-narrow-to-defun', to
     highlight current function."
    (interactive "p")
    (cond
     ((fancy-narrow-active-p)  (fancy-widen))
     ((region-active-p)        (fancy-narrow-to-region (region-beginning) (region-end)))
     ((= num 0)                (ha/highlight-block))
     ((= num 1)                (fancy-narrow-to-defun))
     (t                        (progn (ha/expand-region num)
                                      (fancy-narrow-to-region (region-beginning) (region-end))))))

  :bind ("C-M-+" . ha/highlight-section))



;; This nifty function from [[http://endlessparentheses.com/emacs-narrow-or-widen-dwim.html][Endless Parenthesis]] is a nice replacement
;; for many other narrowing keybindings that I use:


(defun narrow-or-widen-dwim (p)
  "If the buffer is narrowed, it widens. Otherwise, it narrows intelligently.
Intelligently means: region, subtree, or defun, whichever applies
first.

With prefix P, don't widen, just narrow even if buffer is already
narrowed."
  (interactive "P")
  (declare (interactive-only))
  (cond ((and (buffer-narrowed-p) (not p)) (widen))
        ((region-active-p)
         (narrow-to-region (region-beginning) (region-end)))
        ((derived-mode-p 'org-mode) (org-narrow-to-subtree))
        (t (narrow-to-defun))))

(global-set-key (kbd "C-x n x") 'narrow-or-widen-dwim)

;; Jumping to Windows

;;   Set up [[https://github.com/abo-abo/ace-window][ace-window]] mode:


(use-package ace-window
  :ensure t
  :init
  (setq aw-keys '(?a ?s ?d ?f ?j ?k ?l ?o))
  (global-set-key (kbd "C-x o") 'ace-window)
  :diminish ace-window-mode)

;; Selecting a Buffer

;;    I like =IDO= for switching buffers since I typically know what I'm after:


(global-set-key (kbd "<f8>") 'ido-switch-buffer)
(global-set-key (kbd "S-<f8>") 'ibuffer)



;; I like [[https://github.com/KMahoney/kpm-list][kpm-list]] a bit better than =ibuffer=, but I really don’t use
;; either more than =ido-switch-buffer=. Still:


(use-package kpm-list
  :ensure t
  :bind ("S-<f8>" . kpm-list)
  ("C-x C-b" . kpm-list))

;; Controlling Window Size

;;    Often, while on my laptop, I want the current window to be ‘large
;;    enough for work’, and this is bound to =<f9> .= (period).


(global-unset-key (kbd "C-c w"))
(global-set-key (kbd "C-c w r") 'ha/window-standard-size)



;; If I've enlarged the window, I can restore that window to its
;; original size, so this requires a /buffer local variable/:


(make-variable-buffer-local 'window-width-original)



;; Now a function that either changes the width to 80, or back to the
;; original size if already at 80.


(defun ha/window-standard-size (arg)
  "Sets the size of the current window to 80 characters, unless
it already is 80 characters, in which case, set it back to its
previous size. A prefix ARG can be given to set the window to a
particular width."
  (interactive "p")

  ;; If not already set, let's store the current window width in our
  ;; buffer-local variable.
  (if (not (local-variable-p 'window-width-original))
      (setq window-width-original (window-width)))

  ;; The 'goal' is 80 unless we get a better argument, C-u 60 ...
  (let* ((goal-width (if (> arg 8) arg 80))
         (new-width (- goal-width (window-width))))

    (if (= new-width 0)    ; Already enlarged? Restore:
        (enlarge-window-horizontally (- window-width-original goal-width))
      (enlarge-window-horizontally new-width))))

;; Controlling Window Placement

;;    Change window configuration and then return to the old
;;    configuration with [[http://www.emacswiki.org/emacs/WinnerMode][winner-mode]].  Use =Control-C Arrow= keys to
;;    cycle through window/frame configurations.


(use-package winner
  :ensure t
  :init (winner-mode 1))



;; While =winner-mode= is easy to keep the current window configuration
;; /clean/, the [[https://github.com/wasamasa/eyebrowse][eyebrowse]] project seems to have a good approach to
;; managing multiple configurations.


(use-package eyebrowse
  :ensure t
  :init   (eyebrowse-mode t))

;; Better Jumping

;;    Mostly using the [[https://github.com/abo-abo/avy][avy]] project's [[help:avy-goto-word-1][avy-goto-word-1]] function, so I bind
;;    that to =C-c j=, but the recent update to include a timer feature,
;;    seems awful sweet:


(use-package avy
  :ensure t
  :commands avy-goto-word-1 avy-goto-char-1 avy-goto-line avy-goto-char-timer
  :bind
  ("C-o"   . avy-goto-word-1)
  ("C-c k k" . avy-goto-char-timer)
  ("C-c k j" . avy-goto-word-1)
  ("C-c k c" . avy-goto-char-1)
  ("C-c k l" . avy-goto-line))

;; Unfill Paragraph

;;    Unfilling a paragraph joins all the lines in a paragraph into a
;;    single line. Taken from [[http://www.emacswiki.org/UnfillParagraph][here]].


(defun unfill-paragraph ()
  "Takes a multi-line paragraph and makes it into a single line of text."
  (interactive)
  (let ((fill-column (point-max)))
    (fill-paragraph nil)))

;; Handy key definition
(define-key global-map "\M-Q" 'unfill-paragraph)

;; General Behavior Fixes

;;    The subtle changes I've been making to Emacs behavior has grown
;;    until I felt I should move it into [[file:emacs-fixes.org][its
;;    own source file]].


(require 'init-fixes)
n
;; Multiple Cursors

;;    While I'm not sure how often I will use [[https://github.com/emacsmirror/multiple-cursors][multiple-cursors]] project,
;;    I'm going to try to remember it is there. It doesn't have any
;;    default keybindings, so I set up the suggested:


(use-package multiple-cursors
  :ensure t
  :config
  (global-set-key
   (kbd "C-c C-.")
   (defhydra hydra-multiple-cursors ()
     "multiple-cursors"
     ("." mc/mark-all-dwim                   "all-dwim")
     ("C-." mc/mark-all-like-this-dwim       "all-like-dwim")
     ("n" mc/mark-next-like-this             "next")
     ("p" mc/mark-previous-like-this         "previous")
     ("a" mc/mark-all-like-this              "mark-all")
     ("N" mc/mark-next-symbol-like-this      "next-symbol")
     ("P" mc/mark-previous-symbol-like-this  "previous-symbol")
     ("A" mc/mark-all-symbols-like-this      "all-symbols")
     ("f" mc/mark-all-like-this-in-defun     "in-func")
     ("l" mc/edit-lines                      "all-lines")
     ("e" mc/edit-ends-of-lines              "end-lines"))))

;; Expand Region

;;    Wherever you are in a file, and whatever the type of file, you can
;;    slowly increase a region selection by logical segments by using
;;    Magnar's [[https://github.com/magnars/expand-region.el][expand-region]] project.

;;    However, the normal experience for =expand-region= is interactive,
;;    expected to be called repeatedly to expand and contract the regions
;;    based on syntax, and whatnot. Since I am seldom sure what I will
;;    select if I give this function a numeric prefix, I created a
;;    wrapper function that will (when given a number), just select the
;;    number of lines for the region. Select the current line with a 0
;;    argument. No argument (well, =lines= is given 1 with no argument),
;;    then it just calls =expand-region=:


(use-package expand-region
  :ensure t
  :config
  (defun ha/expand-region (lines)
    "Prefix-oriented wrapper around Magnar's `er/expand-region'.

Call with LINES equal to 1 (given no prefix), it expands the
region as normal.  When LINES given a positive number, selects
the current line and number of lines specified.  When LINES is a
negative number, selects the current line and the previous lines
specified.  Select the current line if the LINES prefix is zero."
    (interactive "p")
    (cond ((= lines 1)   (er/expand-region 1))
          ((< lines 0)   (ha/expand-previous-line-as-region lines))
          (t             (ha/expand-next-line-as-region (1+ lines)))))

  (defun ha/expand-next-line-as-region (lines)
    (message "lines = %d" lines)
    (beginning-of-line)
    (set-mark (point))
    (end-of-line lines))

  (defun ha/expand-previous-line-as-region (lines)
    (end-of-line)
    (set-mark (point))
    (beginning-of-line (1+ lines)))

  :bind ("C-=" . ha/expand-region))

;; Block Wrappers

;;    While the =M-(= binding to =insert-pair= is great, I often need to
;;    wrap with other characters:


(global-set-key (kbd "M-[") 'insert-pair)
(global-set-key (kbd "M-{") 'insert-pair)
(global-set-key (kbd "M-<") 'insert-pair)
(global-set-key (kbd "M-'") 'insert-pair)
(global-set-key (kbd "M-`") 'insert-pair)
(global-set-key (kbd "M-\"") 'insert-pair)



;; But [[https://github.com/rejeep/wrap-region.el][wrap-region]] is even more flexible. In most editors, selecting
;; text and typing anything replaces the selected text (see the
;; [[info:emacs#Using%20Region][delete-selection-mode]]), but in this case, we can do something
;; different... like wrapping:


(use-package wrap-region
  :ensure   t
  :config
  (wrap-region-global-mode t)
  (wrap-region-add-wrappers
   '(("(" ")")
     ("[" "]")
     ("{" "}")
     ("<" ">")
     ("'" "'")
     ("\"" "\"")
     ("‘" "’"   "q")
     ("“" "”"   "Q")
     ("*" "*"   "b"   org-mode)                 ; bolden
     ("*" "*"   "*"   org-mode)                 ; bolden
     ("/" "/"   "i"   org-mode)                 ; italics
     ("/" "/"   "/"   org-mode)                 ; italics
     ("~" "~"   "c"   org-mode)                 ; code
     ("~" "~"   "~"   org-mode)                 ; code
     ("=" "="   "v"   org-mode)                 ; verbatim
     ("=" "="   "="   org-mode)                 ; verbatim
     ("_" "_"   "u" '(org-mode markdown-mode))  ; underline
     ("**" "**" "b"   markdown-mode)            ; bolden
     ("*" "*"   "i"   markdown-mode)            ; italics
     ("`" "`"   "c" '(markdown-mode ruby-mode)) ; code
     ("`" "'"   "c"   lisp-mode)                ; code
     ))
  :diminish wrap-region-mode)



;; But in order to wrap text in a more general way (with just about
;; any textual string), we need something more. Especially with the
;; =expand-region= command, wrapping a logical block of text with a
;; beginning and ending string really makes sense.


(defun surround (start end txt)
  "Wraps the specified region (or the current 'symbol / word'
with some textual markers that this function requests from the
user. Opening-type text, like parens and angle-brackets will
insert the matching closing symbol.

This function also supports some org-mode wrappers:

  - `#s` wraps the region in a source code block
  - `#e` wraps it in an example block
  - `#q` wraps it in an quote block"
  (interactive "r\nsEnter text to surround: " start end txt)

  ;; If the region is not active, we use the 'thing-at-point' function
  ;; to get a "symbol" (often a variable or a single word in text),
  ;; and use that as our region.

  (if (not (region-active-p))
      (let ((new-region (bounds-of-thing-at-point 'symbol)))
        (setq start (car new-region))
        (setq end (cdr new-region))))

  ;; We create a table of "odd balls" where the front and the end are
  ;; not the same string.
  (let* ((s-table '(("#e" . ("#+BEGIN_EXAMPLE\n" "\n#+END_EXAMPLE") )
                    ("#s" . ("#+BEGIN_SRC \n"    "\n#+END_SRC") )
                    ("#q" . ("#+BEGIN_QUOTE\n"   "\n#+END_QUOTE"))
                    ("<"  . ("<" ">"))
                    ("("  . ("(" ")"))
                    ("{"  . ("{" "}"))
                    ("["  . ("[" "]"))))    ; Why yes, we'll add more
         (s-pair (assoc-default txt s-table)))

    ;; If txt doesn't match a table entry, then the pair will just be
    ;; the text for both the front and the back...
    (unless s-pair
      (setq s-pair (list txt txt)))

    (save-excursion
      (narrow-to-region start end)
      (goto-char (point-min))
      (insert (car s-pair))
      (goto-char (point-max))
      (insert (cadr s-pair))
      (widen))))

(global-set-key (kbd "C-+") 'surround)



;; To make it easier to call from other functions, let's wrap that
;; wrapper:


(defun surround-text (txt)
  (if (region-active-p)
      (surround (region-beginning) (region-end) txt)
    (surround nil nil txt)))



;; This function returns an interactive lambda expression, suitable
;; for adding to a key-binding:


(defun surround-text-with (surr-str)
  "Returns an interactive function that when called, will surround the region (or word) with the SURR-STR string."
  (lexical-let ((text surr-str))
    (lambda ()
      (interactive)
      (surround-text text))))

;; Projectile

;;    The [[https://github.com/bbatsov/projectile][Projectile]] project is a nifty way to run commands and search
;;    for files in a particular "project". Its necessity is less now that
;;    IDO with flexible matching seems to always just find what I need.


(use-package projectile
  :ensure t
  :init (projectile-global-mode 1)
  :commands projectile-ag
  :config
  (progn
    (setq projectile-completion-system 'ido)
    (add-to-list 'projectile-globally-ignored-files ".DS_Store")))

;; Dired Options

;;    Between =M-!= and starting [[Eshell][Eshell]], comes =dired= (=C-x d=).


(setq ls-lisp-use-insert-directory-program nil)



;; This enhancement to dired hides the ugly details until you hit
;; '(' and shows the details with ')'. I also change the [...] to a
;; simple asterisk.


(use-package dired-details
  :ensure t
  :init   (setq dired-details-hidden-string "* ")
  :config (dired-details-install))



;; The ability to create a dired buffer based on searching for files
;; in a directory tree with =find-name-dired= is fantastic. The
;; [[http://www.masteringemacs.org/articles/2011/03/25/working-multiple-files-dired/][following magic]] optimizes this approach:


(use-package find-dired
  :ensure t
  :init (setq find-ls-option '("-print0 | xargs -0 ls -od" . "-od")))



;; The [[http://www.masteringemacs.org/articles/2014/04/10/dired-shell-commands-find-xargs-replacement/][dired-x project]] seems useful:


(require 'dired-x)

;; Tramp

;;    The ability to edit files on remote systems is a wonderful win,
;;    since it means I don't need to have my Emacs environment running on
;;    remote machines (still a possibility, just not a requirement).

;;    According to [[http://www.gnu.org/software/emacs/manual/html_node/tramp/Filename-Syntax.html][the manual]], I can access a file over SSH, via:

;;    #+BEGIN_EXAMPLE
;;    /ssh:10.52.224.67:blah
;;    #+END_EXAMPLE

;;    If I set the default method to SSH, I can do this:

;;    #+BEGIN_EXAMPLE
;;    /10.52.224.67:blah
;;    #+END_EXAMPLE

;;    So, let's do it...


(setq tramp-default-method "ssh")

;; Editing Root Files

;;    According to [[http://emacs-fu.blogspot.com/2013/03/editing-with-root-privileges-once-more.html][Emacs Fu]], we can use the wonderful Tramp to edit
;;    Root-owned files, as in:


(defun ha/find-file-as-root ()
  "Like `ido-find-file, but automatically edit the file with
root-privileges (using tramp/sudo), if the file is not writable by
user."
  (interactive)
  (let ((file (ido-read-file-name "Edit as root: ")))
    (unless (file-writable-p file)
      (setq file (concat "/sudo:root@localhost:" file)))
    (find-file file)))



;; The trick, as always, is finding the correct keybinding... but I
;; have the =C-c f= as prefix for loading all sorts of files...


(global-set-key (kbd "C-c f r") 'ha/find-file-as-root)

;; IDO (Interactively DO Things)

;;    According to [[http://www.masteringemacs.org/articles/2010/10/10/introduction-to-ido-mode/][Mickey]], IDO is the greatest thing.


(use-package ido
  :ensure t
  :init  (setq ido-enable-flex-matching t
               ido-everywhere t)
  :config
  (ido-mode 1)
  (ido-everywhere 1))



;; Add to IDO, the [[https://github.com/lewang/flx][FLX]] package:


(use-package flx-ido
  :ensure t
  :init (setq ido-enable-flex-matching t
              ido-use-faces nil)
  :config (flx-ido-mode 1))



;; According to [[https://gist.github.com/rkneufeld/5126926][Ryan Kneufeld]], we could make IDO work vertically,
;; which is much easier to read. For this, I use [[https://github.com/gempesaw/ido-vertical-mode.el][ido-vertically]]:


(use-package ido-vertical-mode
  :ensure t
  :init               ; I like up and down arrow keys:
  (setq ido-vertical-define-keys 'C-n-C-p-up-and-down)
  :config
  (ido-vertical-mode 1))

;; SMEX

;;    Built using [[*IDO%20(Interactively%20DO%20Things)][IDO]] to do something similar but with =M-x= commands:


(use-package smex
  :ensure t
  :init (smex-initialize)
  :bind ("M-x" . smex)
  ("M-X" . smex-major-mode-commands))

;; Helm

;;    Obviously, Helm would be helpful if I can learn all the bindings,
;;    so:


(use-package helm
  :ensure t
  :init (add-to-list 'guide-key/guide-key-sequence "C-x c")
  (use-package helm-config));; Binds C-x c to the helm bidness.



;; Using the latest version of =ag=? Highlight the keywords:


(use-package ag
  :ensure    t
  :commands  ag
  :init      (setq ag-highlight-search t)
  :config    (add-to-list 'ag-arguments "--word-regexp"))

;; Spotlight

;;     However, I also need a global /indexing/ approach to searching
;;     through my notes, and since I'm usually on a Mac, I might as well
;;     use the /Spotlight/ service that is already running:


(setq locate-command "mdfind")  ;; Use Mac OS X's Spotlight
(global-set-key (kbd "C-c f l") 'locate)



;; The following function wraps =locate-with-filter= to only grab
;; =org-mode= files:


(defun locate-org-files (search-string)
  (interactive "sSearch string: ")
  (locate-with-filter search-string ".org$"))

(global-set-key (kbd "C-c f o") 'locate-org-files)



;; However, the problem with locate, is it doesn't show me any
;; context. My [[file:bin/find-notes][find-notes]] script uses both =mdfind= and =grep= to both
;; better search and display some useful context.

;; Just need to wrap that in a function:


(defun find-notes (words)
  "Uses my 'find-notes' shell script as a better grep
utility. Not only does it show the results in a clickable list,
it also highlights the result, allowing us to put more context in
the output."
  (interactive "sSearch for words:")
  (let ((program (concat (getenv "HOME") "/bin/find-notes"))
        (buffer-name (concat "*find-notes: " words "*")))
    (call-process program nil buffer-name t words)
    (switch-to-buffer buffer-name)
    (read-only-mode 1)
    (grep-mode)
    (toggle-truncate-lines)
    (beginning-of-buffer)
    (dolist (word (split-string words))
      (highlight-regexp word))))

(global-set-key (kbd "C-x C-n") 'find-notes)
(global-set-key (kbd "C-c f n") 'find-notes)

;; Recent File List

;;    According to [[http://www.emacswiki.org/emacs-es/RecentFiles][this article]], Emacs already has the recent file
;;    listing available, just not turned on.


(use-package recentf
  :init
  (setq recentf-max-menu-items 25)
  (setq recentf-auto-cleanup 'never)
  ;; (setq recentf-keep '(file-remote-p file-readable-p))
  (recentf-mode 1)
  :bind ("C-c f f" . recentf-open-files))

;; Backup Settings

;;    This setting moves all backup files to a central location.
;;    Got it from [[http://whattheemacsd.com/init.el-02.html][this page]].


(setq backup-directory-alist
      `(("." . ,(expand-file-name
                 (ha/emacs-subdirectory "backups")))))



;; Make backups of files, even when they're in version control


(setq vc-make-backup-files t)



;; And let’s make sure our files are saved if we wander off and
;; defocus the Emacs application:


(defun save-all ()
  "Saves all dirty buffers without asking for confirmation."
  (interactive)
  (save-some-buffers t))

(add-hook 'focus-out-hook 'save-all)

;; Auto Insertion

;;    Just beginning to get a collection of templates to automatically
;;    insert if a blank file is loaded.


(use-package autoinsert
  :init
  (setq auto-insert-directory (ha/emacs-subdirectory "templates/"))
  ;; Don't want to be prompted before insertion:
  (setq auto-insert-query nil)

  (add-hook 'find-file-hook 'auto-insert)
  (auto-insert-mode 1))



;; However, auto insertion requires entering data for particular fields,
;; and for that Yasnippet is better, so in this case, we combine them:


(defun ha/autoinsert-yas-expand()
  "Replace text in yasnippet template."
  (yas-expand-snippet (buffer-string) (point-min) (point-max)))



;; Now bind many of the templates for auto-insert and field expansion:


(use-package autoinsert
  :config
  (define-auto-insert "\\.el$" ["default-lisp.el" ha/autoinsert-yas-expand])
  (define-auto-insert "\\.sh$" ["default-sh.sh" ha/autoinsert-yas-expand])
  (define-auto-insert "/bin/"  ["default-sh.sh" ha/autoinsert-yas-expand])
  (define-auto-insert "\\.html?$" ["default-html.html" ha/autoinsert-yas-expand]))

;; Auto Complete

;;    Using [[http://company-mode.github.io/][company-mode]] for all my auto completion needs.

;;    Like [[https://github.com/vspinu/company-math][this idea]] of being able to easily insert math
;;    symbols based on LaTeX keywords. Start typing a backslash.


(use-package company
  :ensure t
  :init
  (add-hook 'after-init-hook 'global-company-mode)
  :config
  (add-to-list 'company-backends 'company-math-symbols-unicode)
  :diminish company-mode)



;; Take advantage of idle time by displaying some documentation
;; using [[https://www.github.com/expez/company-quickhelp][company-quickhelp]] project.


(use-package company-quickhelp
  :ensure t
  :config
  (company-quickhelp-mode 1))

;; Yasnippets

;;    The [[https://github.com/capitaomorte/yasnippet][yasnippet project]] allows me to create snippets of code that
;;    can be brought into a file, based on the language.


(use-package yasnippet
  :ensure t
  :init
  (yas-global-mode 1)
  :config
  (add-to-list 'yas-snippet-dirs (ha/emacs-subdirectory "snippets")))

;; Spelling Correction with Abbreviation Mode

;;    According to [[http://endlessparentheses.com/ispell-and-abbrev-the-perfect-auto-correct.html][this discussion]], we can correct a misspelled word
;;    with =C-x C-i= and it will use the abbreviation mode to
;;    automatically correct that word...as long as you misspell it the
;;    same way each time.


(defun ha/ispell-word-then-abbrev (p)
  "Call `ispell-word'. Then create an abbrev for the correction made.
With prefix P, create local abbrev. Otherwise it will be global."
  (interactive "P")
  (let ((bef (downcase (or (thing-at-point 'word) ""))) aft)
    (call-interactively 'ispell-word)
    (setq aft (downcase (or (thing-at-point 'word) "")))
    (unless (string= aft bef)
      (message "\"%s\" now expands to \"%s\" %sally"
               bef aft (if p "loc" "glob"))
      (define-abbrev
        (if p global-abbrev-table local-abbrev-table)
        bef aft))))

(global-set-key (kbd "C-x C-i") 'ha/ispell-word-then-abbrev)



;; Need to turn on the mode, but not necessarily show it:


(use-package abbrev
  :bind ("C-c T a" . abbrev-mode)
  :init (setq save-abbrevs t)
  (setq-default abbrev-mode t)
  :diminish abbrev-mode)



;; Start for all text modes (but not for log files):


(use-package flyspell
  :ensure t
  :diminish flyspell-mode
  :init
  (add-hook 'prog-mode-hook 'flyspell-prog-mode)

  (dolist (hook '(text-mode-hook org-mode-hook))
    (add-hook hook (lambda () (flyspell-mode 1))))

  (dolist (hook '(change-log-mode-hook log-edit-mode-hook org-agenda-mode-hook))
    (add-hook hook (lambda () (flyspell-mode -1))))

  :config
  (setq ispell-program-name "/usr/local/bin/aspell"
        ispell-dictionary "american" ; better for aspell
        ispell-extra-args '("--sug-mode=ultra" "--lang=en_US")
        ispell-list-command "--list")

  (add-to-list 'ispell-local-dictionary-alist '(nil
                                                "[[:alpha:]]"
                                                "[^[:alpha:]]"
                                                "['‘’]"
                                                t
                                                ("-d" "en_US")
                                                nil
                                                utf-8)))

;; If we make the line numbers a fixed size, then increasing or
;; decreasing the font size doesn't truncate the numbers:


(defun fix-linum-size ()
  (interactive)
  (set-face-attribute 'linum nil :height 110))

(add-hook 'linum-mode-hook 'fix-linum-size)



;; If we alternate between line numbers and no-line numbers, I also
;; have to turn on/off the fringe. Actually, this is really only
;; useful when giving presentations.


(defun linum-off-mode ()
  "Toggles the line numbers as well as the fringe. This allows me
to maximize the screen estate."
  (interactive)
  (if linum-mode
      (progn
        (fringe-mode '(0 . 0))
        (linum-mode -1))
    (fringe-mode '(8 . 0))
    (linum-mode 1)))

(global-set-key (kbd "A-C-K") 'linum-off-mode)
(global-set-key (kbd "s-C-K") 'linum-off-mode)  ;; For Linux



;; I'm intrigued with the [[https://github.com/coldnew/linum-relative][linum-relative]] mode (especially since I can
;; toggle between them). The idea is that I can see the line that I
;; want to jump to (like one 9 lines away), and then =C-9 C-n= to
;; quickly pop to it.


(use-package linum-relative
  :ensure t
  :config
  ;; Otherwise, let's take advantage of the relative line numbering:
  (defun linum-new-mode ()
    "If line numbers aren't displayed, then display them.
     Otherwise, toggle between absolute and relative numbers."
    (interactive)
    (if linum-mode
        (linum-relative-toggle)
      (linum-mode 1)))

  :bind ("A-k" . linum-new-mode)
  ("S-k" . linum-new-mode))   ;; For Linux

;; Breadcrumbs

;;    I often flubber my attempts at walking back through the movements
;;    with those two key sequences. Better to set this variable so that
;;    repeated =C-SPC= continue to pop back through the ring:


(setq set-mark-command-repeat-pop t)



;; More than the breadcrumbs left by marking, the [[http://www.emacswiki.org/emacs/GotoChg][goto-chg]] project
;; let's me walk back to where I last edited, which is usually more
;; accurate:


(use-package goto-chg
  :ensure t
  :bind (("M-p" . goto-last-change)
         ("M-n" . goto-last-change-reverse)))


;; Use =C-u 0 M-p= shows a description of the change you made at each point.

;; However, if walking back through your /historical trail/ crosses
;; files, then dropping some phat marks is the correct approach.

;; Leave a mark every time I re-center the screen. Then, walk back and
;; forth through its history (using the [[https://github.com/pheaver/breadcrumb][breadcrumb]] project):


(use-package breadcrumb
  :load-path "~/Other/breadcrumb/"
  :commands bc-set bc-previous bc-next
  :init (defun ha/mark-and-center ()
          "Recenter the display and drops a breadcrumb."
          (interactive)
          (bc-set)
          (recenter-top-bottom))
  :config (unbind-key "A-." mac-key-mode-map)
  :bind (("C-l" . ha/mark-and-center)
         ("A-," . bc-previous)
         ("A-." . bc-next)))

;; Strip Whitespace on Save

;;    When I save, I want to always, and I do mean always strip all
;;    trailing whitespace from the file.


(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Save File Position

;;    Save the point position for every file, and restore it when that
;;    file is reloaded.


(require 'saveplace)
(setq-default save-place t)
(setq save-place-forget-unreadable-files t)
(setq save-place-skip-check-regexp "\\`/\\(?:cdrom\\|floppy\\|mnt\\|/[0-9]\\|\\(?:[^@/:]*@\\)?[^@/:]*[^@/:.]:\\)")

;; Better Searching and Visual Regular Expressions

;;    Searching is quite good in Emacs. Let's add a few extra keys:


(bind-keys :map isearch-mode-map
           ("<left>"  . isearch-repeat-backward)
           ("<right>" . isearch-repeat-forward)
           ("<up>"    . isearch-ring-retreat)
           ("<down>"  . isearch-ring-advance))



;; Easier replacement of my [[http://www.masteringemacs.org/articles/2011/01/14/effective-editing-movement/][Smart Scan]] for searching forward/backward
;; for the current word. This is now bound to =M-s .= (in Emacs 24.4),
;; but I then have to hit =C-s= or =C-r= ... nicer to use the period/comma.

;; Flycheck

;;    [[https://github.com/flycheck/flycheck][Flycheck]] seems to be quite superior to good ol' Flymake.


(use-package flycheck
  :ensure t
  :init
  (add-hook 'after-init-hook 'global-flycheck-mode)
  :config
  (setq-default flycheck-disabled-checkers '(emacs-lisp-checkdoc)))

;; ElDoc

;;     I like ElDoc support (when I can get it), but not needed in the
;;     mode line:


(use-package eldoc
  :diminish eldoc-mode)



;; We access stuff by loading the =etags= package:


(require 'etags)



;; Now, use the following keys:

;; - M-. :: To find the tag at point to jump to the function’s
;;          definition when the point is over a function call. It is a
;;          dwim-type function.
;; - M-, :: jump back to where you were.
;; - M-? :: find a tag, that is, use the Tags file to look up a
;;          definition. If there are multiple tags in the project with
;;          the same name, use `C-u M-.’ to go to the next match.
;; - =M-x tags-search= :: regexp-search through the source files
;;      indexed by a tags file (a bit like =grep=)
;; - =M-x tags-query-replace= :: query-replace through the source files
;;      indexed by a tags file
;; - =M-x tags-apropos= :: list all tags in a tags file that match a
;;      regexp
;; - =M-x list-tags= :: list all tags defined in a source file

;; With the fancy new [[https://marmalade-repo.org/packages/ctags-update][ctags-update]] package, we can update the tags file
;; whenever we save a file:


(use-package ctags-update
  :ensure t
  :config
  (add-hook 'prog-mode-hook  'turn-on-ctags-auto-update-mode)
  :diminish ctags-auto-update-mode)



;; While, I like =imenu=, [[https://github.com/vspinu/imenu-anywhere][combining it]] with an IDO interface nicely
;; lists the headings/functions in the current buffer:


(use-package idomenu
  :ensure t
  :bind ("C-c i" . idomenu))



;; And if I'm lazy and willing to use the mouse:


(use-package imenu+
  :ensure t
  :init (add-hook 'prog-mode-hook 'imenup-add-defs-to-menubar)
  (add-hook 'org-mode-hook  'imenup-add-defs-to-menubar))



;; If I don't know what I'm after, Helm is better:


(use-package helm
  :bind (("C-c M-i" . helm-imenu)))



;; Notice that I don't set Helm for everything. Obviously, Helm would
;; be helpful if I can learn all the bindings, so:


(use-package guide-key
  :init (add-to-list 'guide-key/guide-key-sequence "C-x c"))



;; However, I need to use [[http://www.emacswiki.org/emacs/EtagsSelect#toc3][this function]] to use IDO in conjunctions
;; with the TAGS file for all functions in the project:






;; Note: This prompt needs to go away:


(setq tags-add-tables nil)

;; Code Block Folding

;;     The [[info:emacs#Hideshow][Hide Show Minor]] mode allows us to /fold/ all functions
;;     (hidden), showing only the header lines. We need to turn on the
;;     mode, so wrappers are in order:


(defun ha/hs-show-all ()
  (interactive)
  (hs-minor-mode 1)
  (hs-show-all))

(defun ha/hs-hide-all ()
  (interactive)
  (hs-minor-mode 1)
  (hs-hide-all))

(defun ha/hs-toggle-hiding ()
  (interactive)
  (hs-minor-mode 1)
  (hs-toggle-hiding))



;; Seems that =C-c @= is too obnoxious to use, so I'll put my
;; favorite on the =C-c h= prefix:


(use-package hs-minor-mode
  :bind
  ("C-c T h" . hs-minor-mode)
  ("C-c h a" . ha/hs-hide-all)
  ("C-c h s" . ha/hs-show-all)
  ("C-c h h" . ha/hs-toggle-hiding))

;; Aggressive Auto Indention

;;     Automatically indent without use of the tab found in [[http://endlessparentheses.com/permanent-auto-indentation.html][this article]],
;;     and seems to be quite helpful for many types of programming
;;     languages.

;;     To begin, we create a function that can indent a function by
;;     calling =indent-region= on the beginning and ending points of a
;;     function.


(defun indent-defun ()
  "Indent current defun.
Do nothing if mark is active (to avoid deactivaing it), or if
buffer is not modified (to avoid creating accidental
modifications)."
  (interactive)
  (unless (or (region-active-p)
              buffer-read-only
              (null (buffer-modified-p)))
    (let ((l (save-excursion (beginning-of-defun 1) (point)))
          (r (save-excursion (end-of-defun 1) (point))))
      (cl-letf (((symbol-function 'message) #'ignore))
        (indent-region l r)))))



;; Next, create a hook that will call the =indent-defun= with every
;; command call:


(defun activate-aggressive-indent ()
  "Locally add `ha/indent-defun' to `post-command-hook'."
  (add-hook 'post-command-hook
            'indent-defun nil 'local))

;; Red Warnings

;;     Various keywords (in comments) are now flagged in a Red Error font:


(add-hook 'prog-common-hook
          (lambda ()
            (font-lock-add-keywords nil
                                    '(("\\<\\(FIX\\|FIXME\\|TODO\\|BUG\\|HACK\\):" 1 font-lock-warning-face t)))))

;; Shell Scripts

;;    Files in my =bin= directory (but /only/ if it doesn't have any
;;    other extension), should start in =sh-mode=:


(add-to-list 'auto-mode-alist '("/bin/" . sh-mode))

;; Emacs Lisp

;;    Sure, everything here is in Emacs Lisp, but this section helps me
;;    write more of that... like making snazzy symbols and colorizing the
;;    variables.

;;    The [[https://github.com/ankurdave/color-identifiers-mode][color-identifiers]] project (unlike [[https://github.com/Fanael/rainbow-identifiers][others]]), downplay the
;;    keywords, and increase the colorizing of the variables.


(use-package color-identifiers-mode
  :ensure t
  :init
  (add-hook 'emacs-lisp-mode-hook 'color-identifiers-mode)
  :diminish color-identifiers-mode)



;; The only real snazzy symbol that I like is replacing the =lambda=
;; with λ:


(use-package lisp-mode
  :init
  (defconst lisp--prettify-symbols-alist
    '(("lambda"  . ?λ)
      ("."       . ?•)))
  :config
  (add-hook 'emacs-lisp-mode-hook 'global-prettify-symbols-mode)
  (add-hook 'emacs-lisp-mode-hook 'activate-aggressive-indent))

;; Paredit

;;     One of the cooler features of Emacs is the [[http://emacswiki.org/emacs/ParEdit][ParEdit mode]] which
;;     keeps all parenthesis balanced in Lisp-oriented languages.
;;     See this [[http://www.emacswiki.org/emacs/PareditCheatsheet][cheatsheet]].


(use-package paredit
  :ensure t
  :diminish paredit-mode
  :init
  (add-hook 'emacs-lisp-mode-hook 'paredit-mode))

;; Colored Variables

;;     Color each variable, and downplay standard key words:


(use-package color-identifiers-mode
  :ensure t
  :init
  (add-hook 'emacs-lisp-mode-hook 'color-identifiers-mode))

;; Nicer Paren Matching

;;     The reverse mode of the default parenthesis matching doesn’t match
;;     as well, so [[http://www.emacswiki.org/emacs/ShowParenMode][this code]] just makes it bold and more obvious:


(use-package paren
  :init
  (set-face-background 'show-paren-match (face-background 'default))
  (set-face-foreground 'show-paren-match "#afa")
  (set-face-attribute  'show-paren-match nil :weight 'black)
  (set-face-background 'show-paren-mismatch (face-background 'default))
  (set-face-foreground 'show-paren-mismatch "#c66")
  (set-face-attribute  'show-paren-mismatch nil :weight 'black))



;; While we are at it, let's dim the parens:


(use-package paren-face
  :ensure t
  :init
  (global-paren-face-mode))

;; Insert Comment of Eval

;;     While writing and documenting Emacs Lisp code, it would be helpful
;;     to insert the results of evaluation of an s-expression directly
;;     into the code as a comment:


(use-package lisp-mode
  :config (defun eval-and-comment-output ()
            "Add the output of the sexp as a comment after the sexp"
            (interactive)
            (save-excursion
              (end-of-line)
              (condition-case nil
                  (princ (concat " ; -> " (pp-to-string (eval (preceding-sexp))))
                         (current-buffer))
                (error (message "Invalid expression")))))

  :bind ("C-x e" . eval-and-comment-output))

;; Org-Mode

;;   See [[file:emacs-org.org][emacs-org-mode.el]] for details on my [[http://www.orgmode][Org-Mode]] settings.


(require 'init-org-mode)

;; Git

;;    I like [[https://github.com/syohex/emacs-git-gutter-fringe][git-gutter-fringe]]:


(use-package git-gutter-fringe
  :ensure t
  :config (git-gutter-mode 1))



;; I want to have special mode for Git's =configuration= file:


(use-package gitconfig-mode
  :ensure t)

(use-package gitignore-mode
  :ensure t)



;; What about being able to see the [[https://github.com/voins/mo-git-blame][Git blame]] in a buffer?


(use-package mo-git-blame
  :ensure t)

;; Magit

;;    Git is [[http://emacswiki.org/emacs/Git][already part of Emacs]]. However, [[http://philjackson.github.com/magit/magit.html][Magit]] is sweet.
;;    Don't believe me? Check out [[https://www.youtube.com/watch?v=vQO7F2Q9DwA][this video]].


(use-package magit
  :ensure t
  :commands magit-status magit-blame
  :init
  (defadvice magit-status (around magit-fullscreen activate)
    (window-configuration-to-register :magit-fullscreen)
    ad-do-it
    (delete-other-windows))
  :config
  (setq magit-branch-arguments nil
        ;; use ido to look for branches
        magit-completing-read-function 'magit-ido-completing-read
        ;; don't put "origin-" in front of new branch names by default
        magit-default-tracking-name-function 'magit-default-tracking-name-branch-only
        magit-push-always-verify nil
        ;; Get rid of the previous advice to go into fullscreen
        magit-restore-window-configuration t)

  :bind ("C-x g" . magit-status))

;; Load the [[https://github.com/wildsoul/plantuml-mode][mode for PlantUML]] and reference its jar:


(let ((plantuml-jar (car (file-expand-wildcards "/usr/local/Cellar/plantuml/*/plantuml*.jar"))))
  (if plantuml-jar
      (use-package plantuml-mode
        :ensure t
        :init
        (setq plantuml-jar-path     plantuml-jar
              org-plantuml-jar-path plantuml-jar))))



;; And the [[http://ppareit.github.com/graphviz-dot-mode/][mode for Graphviz]]:


(use-package graphviz-dot-mode
  :ensure t)

;; Web Browsing

;;    This section became involved, and has moved on to [[file:emacs-browser.org][emacs-browser]]
;;    file.


(require 'init-browser)

;; EShell

;;    See [[file:emacs-eshell.org][emacs-eshell.el]] for details of configuring and using EShell.


(require 'init-eshell)


;; Setting up the Exec Path

;;    Make sure that =PATH= variable for finding binary files can is the
;;    same as what Emacs will look for binary files. This little magic,
;;    starts up a shell, gets its path, and then uses that for the
;;    =exec-path=:


(when window-system
  (let ((path-from-shell (shell-command-to-string "/bin/bash -l -c 'echo $PATH'")))
    (setenv "PATH" path-from-shell)
    (setq exec-path (split-string path-from-shell path-separator))))

;; Configure the Graphical Settings

;;    If we are running in a windowed environment where we can set up
;;    fonts and whatnot, call the 'mac' stuff... which will still work
;;    for Linux too.

(if (window-system)
    (require 'init-client)
  (require 'init-server))

;;Require Clojure settings
(require 'init-clojure)

;; After the first load, we can reload this with a require:
(provide 'init-main)
