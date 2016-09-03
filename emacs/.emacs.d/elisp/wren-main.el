;;Everything stolen pretty much directly from Howard Abrams : github.com/howardabrams/dot-files
(defconst wr/emacs-directory (concat (getenv "HOME") "/.emacs.d/"))

(defun wr/emacs-subdirectory (d) (expand-file-name d wr/emacs-directory))

(setq custom-file (expand-file-name "custom.el" wr/emacs-directory))

(when (file-exists-p custom-file)
  (load custom-file))

(add-to-list 'load-path (wr/emacs-subdirectory "elisp"))

(require 'cl)

(require 'init-support)

(package-initialize)

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




(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)


(setq-default indent-tabs-mode nil)
(setq tab-width 2)

(setq-default tab-always-indent 'complete)

;; Display Settings

(setq initial-scratch-message "") ;; Uh, I know what Scratch is for
(setq visible-bell t)             ;; Get rid of the beeps

(when (window-system)
  (tool-bar-mode 0)               ;; Toolbars were only cool with XEmacs
  (when (fboundp 'horizontal-scroll-bar-mode)
    (horizontal-scroll-bar-mode -1))
  (scroll-bar-mode -1))            ;; Scrollbars are waste screen estate

(require 'init-hydra)

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

(use-package ace-window
  :ensure t
  :init
  (setq aw-keys '(?a ?s ?d ?f ?j ?k ?l ?o))
  (global-set-key (kbd "C-x o") 'ace-window)
  :diminish ace-window-mode)

(use-package kpm-list
  :ensure t
  :bind ("S-<f8>" . kpm-list)
  ("C-x C-b" . kpm-list))

(use-package avy
  :ensure t
  :commands avy-goto-word-1 avy-goto-char-1 avy-goto-line avy-goto-char-timer
  :bind
  ("C-o"   . avy-goto-word-1)
  ("C-c k k" . avy-goto-char-timer)
  ("C-c k j" . avy-goto-word-1)
  ("C-c k c" . avy-goto-char-1)
  ("C-c k l" . avy-goto-line))

(require 'init-fixes)

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

(setq ls-lisp-use-insert-directory-program nil)

(use-package dired-details
  :ensure t
  :init   (setq dired-details-hidden-string "* ")
  :config (dired-details-install))

(use-package find-dired
  :ensure t
  :init (setq find-ls-option '("-print0 | xargs -0 ls -od" . "-od")))

(require 'dired-x)

(setq tramp-default-method "ssh")

(defun wr/find-file-as-root ()
  "Like `ido-find-file, but automatically edit the file with
root-privileges (using tramp/sudo), if the file is not writable by
user."
  (interactive)
  (let ((file (ido-read-file-name "Edit as root: ")))
    (unless (file-writable-p file)
      (setq file (concat "/sudo:root@localhost:" file)))
    (find-file file)))

(global-set-key (kbd "C-c f r") 'wr/find-file-as-root)

(use-package ido
  :ensure t
  :init  (setq ido-enable-flex-matching t
               ido-everywhere t)
  :config
  (ido-mode 1)
  (ido-everywhere 1))

(use-package ido-ubiquitous
  :ensure t
  :init (ido-ubiquitous-mode 1))

(use-package flx-ido
  :ensure t
  :init (setq ido-enable-flex-matching t
              ido-use-faces nil)
  :config (flx-ido-mode 1))

(use-package ido-vertical-mode
  :ensure t
  :init               ; I like up and down arrow keys:
  (setq ido-vertical-define-keys 'C-n-C-p-up-and-down)
  :config
  (ido-vertical-mode 1))

(use-package smex
  :ensure t
  :init (smex-initialize)
  :bind ("M-x" . smex)
  ("M-X" . smex-major-mode-commands))

(use-package helm
  :ensure t
  :init
  (use-package helm-config))

(use-package ag
  :ensure    t
  :commands  ag
  :init      (setq ag-highlight-search t)
  :config    (add-to-list 'ag-arguments "--word-regexp"))

(setq locate-command "mdfind")  ;; Use Mac OS X's Spotlight
(global-set-key (kbd "C-c f l") 'locate)

(use-package recentf
  :init
  (setq recentf-max-menu-items 25)
  (setq recentf-auto-cleanup 'never)
  ;; (setq recentf-keep '(file-remote-p file-readable-p))
  (recentf-mode 1)
  :bind ("C-c f f" . recentf-open-files))

(setq backup-directory-alist
      `(("." . ,(expand-file-name
                 (wr/emacs-subdirectory "backups")))))

(setq vc-make-backup-files t)

(defun save-all ()
  "Saves all dirty buffers without asking for confirmation."
  (interactive)
  (save-some-buffers t))

(add-hook 'focus-out-hook 'save-all)

(use-package company
  :ensure t
  :init
  (add-hook 'after-init-hook 'global-company-mode)
  :config
  (add-to-list 'company-backends 'company-math-symbols-unicode)
  :diminish company-mode)

(use-package company-quickhelp
  :ensure t
  :config
  (company-quickhelp-mode 1))

(use-package yasnippet
  :ensure t
  :init
  (yas-global-mode 1)
  :config
  (add-to-list 'yas-snippet-dirs (wr/emacs-subdirectory "snippets")))

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

(use-package goto-chg
  :ensure t
  :bind (("M-p" . goto-last-change)
         ("M-n" . goto-last-change-reverse)))

(add-hook 'before-save-hook 'delete-trailing-whitespace)


(require 'saveplace)
(setq-default save-place t)
(setq save-place-forget-unreadable-files t)
(setq save-place-skip-check-regexp "\\`/\\(?:cdrom\\|floppy\\|mnt\\|/[0-9]\\|\\(?:[^@/:]*@\\)?[^@/:]*[^@/:.]:\\)")

(bind-keys :map isearch-mode-map
           ("<left>"  . isearch-repeat-backward)
           ("<right>" . isearch-repeat-forward)
           ("<up>"    . isearch-ring-retreat)
           ("<down>"  . isearch-ring-advance))

(use-package flycheck
  :ensure t
  :init
  (add-hook 'after-init-hook 'global-flycheck-mode)
  :config
  (setq-default flycheck-disabled-checkers '(emacs-lisp-checkdoc)))

(use-package eldoc
  :diminish eldoc-mode)

(use-package idomenu
  :ensure t
  :bind ("C-c i" . idomenu))

(use-package imenu+
  :ensure t
  :init (add-hook 'prog-mode-hook 'imenup-add-defs-to-menubar)
  (add-hook 'org-mode-hook  'imenup-add-defs-to-menubar))

(use-package helm
  :bind (("C-c M-i" . helm-imenu)))

(add-to-list 'auto-mode-alist '("/bin/" . sh-mode))

(use-package color-identifiers-mode
  :ensure t
  :init
  (add-hook 'emacs-lisp-mode-hook 'color-identifiers-mode)
  :diminish color-identifiers-mode)

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

(defun activate-aggressive-indent ()
  "Locally add `ha/indent-defun' to `post-command-hook'."
  (add-hook 'post-command-hook
            'indent-defun nil 'local))

(use-package lisp-mode
  :init
  (defconst lisp--prettify-symbols-alist
    '(("lambda"  . ?λ)
      ("."       . ?•)))
  :config
  (add-hook 'emacs-lisp-mode-hook 'global-prettify-symbols-mode)
  (add-hook 'emacs-lisp-mode-hook 'activate-aggressive-indent))

(use-package paredit
  :ensure t
  :diminish paredit-mode
  :init
  (add-hook 'emacs-lisp-mode-hook 'paredit-mode))

(use-package color-identifiers-mode
  :ensure t
  :init
  (add-hook 'emacs-lisp-mode-hook 'color-identifiers-mode))

(use-package paren
  :init
  (set-face-background 'show-paren-match (face-background 'default))
  (set-face-foreground 'show-paren-match "#afa")
  (set-face-attribute  'show-paren-match nil :weight 'black)
  (set-face-background 'show-paren-mismatch (face-background 'default))
  (set-face-foreground 'show-paren-mismatch "#c66")
  (set-face-attribute  'show-paren-mismatch nil :weight 'black))

(use-package paren-face
  :ensure t
  :init
  (global-paren-face-mode))

(use-package git-gutter-fringe
  :ensure t
  :config (git-gutter-mode 1))


(use-package gitconfig-mode
  :ensure t)

(use-package gitignore-mode
  :ensure t)

(use-package mo-git-blame
  :ensure t)

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

(require 'init-browser)
(require 'init-evil)
(require 'init-eshell)

(when window-system
  (let ((path-from-shell (shell-command-to-string "/bin/bash -l -c 'echo $PATH'")))
    (setenv "PATH" path-from-shell)
    (setq exec-path (append exec-path (split-string path-from-shell path-separator)))))

(if (window-system)
    (require 'init-client)
  (require 'init-server))

(require 'init-clojure)

(require 'init-javascript)

(provide 'init-main)
