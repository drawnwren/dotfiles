;; Initial Settings

;;   Initialization of Org Mode by hooking it into YASnippets, and other settings.


(use-package org
  :ensure t        ; But it comes with Emacs now!?
  :init
  (setq org-use-speed-commands t
        org-hide-emphasis-markers t
        org-src-fontify-natively t   ;; Pretty code blocks
        org-src-tab-acts-natively t
        org-confirm-babel-evaluate nil)
  (add-to-list 'auto-mode-alist '("\\.txt\\'" . org-mode))
  (add-to-list 'auto-mode-alist '(".*/[0-9]*$" . org-mode))   ;; Journal entries
  (add-hook 'org-mode-hook 'yas-minor-mode-on)
  :bind (("C-c l" . org-store-link)
         ("C-c a" . org-agenda)
         ("C-c c" . org-capture)
         ("C-M-|" . indent-rigidly))
  :config
  (define-key org-mode-map (kbd "M-C-n") 'org-end-of-item-list)
  (define-key org-mode-map (kbd "M-C-p") 'org-beginning-of-item-list)
  (define-key org-mode-map (kbd "M-C-u") 'outline-up-heading)
  (define-key org-mode-map (kbd "M-C-w") 'org-table-copy-region)
  (define-key org-mode-map (kbd "M-C-y") 'org-table-paste-rectangle)

  (define-key org-mode-map [remap org-return] (lambda () (interactive)
                                                (if (org-in-src-block-p)
                                                    (org-return)
                                                  (org-return-indent)))))



;; *Speed Commands:* If point is at the beginning of a headline or
;; code block in org-mode, single keys do fun things. See
;; =org-speed-command-help= for details (or hit the ? key at a
;; headline).

;; *Note*: For the most part, I like [[https://www.gnu.org/software/emacs/manual/html_node/emacs/Indent-Convenience.html][electric-indent-mode]], however, it
;; doesn't really play well with =org-mode=, so I just bind the Return
;; key to the ~org-return-indent~ function and get the same effect (but
;; only if I am /not/ in a source code block...which actually insert
;; multiple new lines).  This /return and indent/ feature is fine, since
;; when I save a file, I automatically strip off [[file:emacs.org::*Strip%20Whitespace%20on%20Save][trailing whitespace]].

;; We will use some of the packages from [[http://orgmode.org/worg/org-contrib/][org extras]], especially
;; [[http://orgmode.org/worg/org-contrib/org-drill.html][org-drill]] and [[http://orgmode.org/worg/org-contrib/org-mime.html][org-mime]] for HTML exports:


(use-package org-plus-contrib
  :ensure t)

;; Local Key Bindings

;;   A couple of short-cut keys to make it easier to edit text.


(defun org-text-bold () "Wraps the region with asterisks."
  (interactive)
  (surround-text "*"))
(defun org-text-italics () "Wraps the region with slashes."
  (interactive)
  (surround-text "/"))
(defun org-text-code () "Wraps the region with equal signs."
  (interactive)
  (surround-text "="))



;; Now we can associate some keystrokes to the org-mode:


(add-hook 'org-mode-hook
      (lambda ()
        (local-set-key (kbd "A-b") 'org-text-bold)
        (local-set-key (kbd "s-b") 'org-text-bold)    ;; For Linux
        (local-set-key (kbd "A-i") 'org-text-italics)
        (local-set-key (kbd "s-i") 'org-text-italics)
        (local-set-key (kbd "A-=") 'org-text-code)
        (local-set-key (kbd "s-=") 'org-text-code)))

;; Color and Display

;;   Displaying the headers using various bullets are nice for my presentations.


(use-package org-bullets
   :ensure t
   :init (add-hook 'org-mode-hook 'org-bullets-mode))



;; Here is my approach for quickly making the initial asterisks for
;; listing items and whatnot, appear as Unicode bullets (without
;; actually affecting the text file or the behavior).


(use-package org-mode
  :init
  (font-lock-add-keywords 'org-mode
   '(("^ +\\([-*]\\) "
          (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•")))))))

;; Journaling

;;   Didn't realize that [[http://www.emacswiki.org/emacs/OrgJournal][org-journal]] essentially does what I have been
;;   doing by hand. With a little customization, I don't have to change
;;   anything else:


(use-package org-journal
   :ensure t
   :init
   (setq org-journal-dir "~/journal/")
   (setq org-journal-date-format "#+TITLE: Journal Entry- %Y-%b-%d (%A)")
   (setq org-journal-time-format ""))



;; The time format is the heading for each section. I set it to a
;; blank since I really don't care about the time I add a section.

;; Nice to /automatically/ insert a specific header if the journal entry
;; file is empty using [[https://www.gnu.org/software/emacs/manual/html_node/autotype/Autoinserting.html][auto-insert]].

;; A function to easily load today (and yesterday's) journal entry.


(defun get-journal-file-today ()
  "Return filename for today's journal entry."
  (let ((daily-name (format-time-string "%Y%m%d")))
    (expand-file-name (concat org-journal-dir daily-name))))

(defun journal-file-today ()
  "Create and load a journal file based on today's date."
  (interactive)
  (find-file (get-journal-file-today)))

(global-set-key (kbd "C-c f j") 'journal-file-today)



;; Since I sometimes (not often) forget to create a journal entry,
;; and need to re-write history.


(defun get-journal-file-yesterday ()
  "Return filename for yesterday's journal entry."
  (let ((daily-name (format-time-string "%Y%m%d" (time-subtract (current-time) (days-to-time 1)))))
    (expand-file-name (concat org-journal-dir daily-name))))

(defun journal-file-yesterday ()
  "Creates and load a file based on yesterday's date."
  (interactive)
  (find-file (get-journal-file-yesterday)))

(global-set-key (kbd "C-c f y") 'journal-file-yesterday)



;; Seems like I need to have the inserted template match the file's
;; name, not necessarily today's date:


(defun journal-file-insert ()
  "Insert's the journal heading based on the file's name."
  (interactive)
  (when (string-match "\\(20[0-9][0-9]\\)\\([0-9][0-9]\\)\\([0-9][0-9]\\)" (buffer-name))
    (let ((year  (string-to-number (match-string 1 (buffer-name))))
          (month (string-to-number (match-string 2 (buffer-name))))
          (day   (string-to-number (match-string 3 (buffer-name))))
          (datim nil))
      (setq datim (encode-time 0 0 0 day month year))
      (insert (format-time-string org-journal-date-format datim))
      (insert "\n\n"))))  ; Start with a blank separating line

 (add-to-list 'auto-insert-alist '(".*/[0-9]*$" . journal-file-insert))



;; I really would really like to read what I did last year "at this
;; time", and by that, I mean, 365 days ago, plus or minus a few to get
;; to the same day of the week.


(defun journal-last-year-file ()
  "Returns the string corresponding to the journal entry that
happened 'last year' at this same time (meaning on the same day
of the week)."
(let* ((last-year-seconds (- (float-time) (* 365 24 60 60)))
       (last-year (seconds-to-time last-year-seconds))
       (last-year-dow (nth 6 (decode-time last-year)))
       (this-year-dow (nth 6 (decode-time)))
       (difference (if (> this-year-dow last-year-dow)
                       (- this-year-dow last-year-dow)
                     (- last-year-dow this-year-dow)))
       (target-date-seconds (+ last-year-seconds (* difference 24 60 60)))
       (target-date (seconds-to-time target-date-seconds)))
  (format-time-string "%Y%m%d" target-date)))

(defun journal-last-year ()
  "Loads last year's journal entry, which is not necessary the
same day of the month, but will be the same day of the week."
  (interactive)
  (let ((journal-file (concat org-journal-dir (journal-last-year-file))))
    (find-file journal-file)))

  (global-set-key (kbd "C-c f L") 'journal-last-year)

;; Taking Meeting Notes

;;    I've notice that while I really like taking notes in a meeting, I
;;    don't always like the multiple windows I have opened, so I created
;;    this function that I can easily call to eliminate distractions
;;    during a meeting.


(defun meeting-notes ()
  "Call this after creating an org-mode heading for where the notes for the meeting
should be. After calling this function, call 'meeting-done' to reset the environment."
  (interactive)
  (outline-mark-subtree)                              ;; Select org-mode section
  (narrow-to-region (region-beginning) (region-end))  ;; Only show that region
  (deactivate-mark)
  (delete-other-windows)                              ;; Get rid of other windows
  (text-scale-set 2)                                  ;; Text is now readable by others
  (fringe-mode 0)
  (message "When finished taking your notes, run meeting-done."))



;; Of course, I need an 'undo' feature when the meeting is over...


(defun meeting-done ()
  "Attempt to 'undo' the effects of taking meeting notes."
  (interactive)
  (widen)                                       ;; Opposite of narrow-to-region
  (text-scale-set 0)                            ;; Reset the font size increase
  (fringe-mode 1)
  (winner-undo))                                ;; Put the windows back in place

;; Specify the Org Directories

;;   I keep all my =org-mode= files in a few directories, and I would
;;   like them automatically searched when I generate agendas.


(setq org-agenda-files '("~/Dropbox/org/personal"
                         "~/Dropbox/org/technical"
                         "~/Dropbox/org/project"))

;; Auto Note Capturing

;;   Let's say you were in the middle of something, but would like to
;;   /take a quick note/, but without affecting the file you are
;;   working on. This is called a "capture", and is bound to the
;;   following key:

;;   General notes are stored in [[file:~/personal/@SUMMARY.org][@SUMMARY.org]], and tasks synced with my
;;   Google Task list are stored in [[file:~/personal/tasks.org][tasks.org]]:


(defvar org-default-notes-file "~/personal/@SUMMARY.org")
(defvar org-default-tasks-file "~/personal/tasks.org")



;; This will bring up a list of /note capturing templates/. I actually
;; override this in my [[file:emacs-local.org::*Org%20Configuration][system-specific "local" configuration]] file.


(defun ha/first-header ()
    (goto-char (point-min))
    (search-forward-regexp "^\* ")
    (beginning-of-line 1)
    (point))

(setq org-capture-templates
      '(("n" "Thought or Note"  entry
         (file org-default-notes-file)
         "* %?\n\n  %i\n\n  See: %a" :empty-lines 1)
        ("j" "Journal Note"     entry
         (file (get-journal-file-today))
         "* %?\n\n  %i\n\n  From: %a" :empty-lines 1)
        ("t" "Task Entry"        entry
         (file+function org-default-tasks-file ha/load-org-tasks)
         "* %?\n\n  %i\n\n  From: %a" :empty-lines 1)
        ("w" "Website Announcement" entry
         (file+function "~/website/index.org" ha/first-header)
         "* %?
  :PROPERTIES:
  :PUBDATE: %t
  :END:
  #+HTML: <div class=\"date\">%<%e %b %Y></div>

  %i

  [[%F][Read more...]" :empty-lines 1)))



;; The problem is the =--sync= doesn't work. So, whenever I read the
;; file, I pull it down first. On save, I push it:


(defun ha/load-org-tasks ()
   (interactive)
   (shell-command (format "/usr/local/bin/michel-orgmode --pull --orgfile %s" org-default-tasks-file))
   (find-file org-default-tasks-file)
   (ha/first-header)
   (add-hook 'after-save-hook 'ha/save-org-tasks t t))

(defun ha/save-org-tasks ()
   (save-buffer)
   (shell-command (format "/usr/local/bin/michel-orgmode --push --orgfile %s" org-default-tasks-file)))

;; Export Settings

;;   Seems some change now requires a direct load of HTML:

;;   To make the =org-mode= export defaults closer to my liking
;;   (without having to put specific #+PROPERTY commands), I get rid of
;;   the postamble, and then configure the default fonts.


(use-package ox-html
  :init
  (setq org-html-postamble nil)
  (setq org-export-with-section-numbers nil)
  (setq org-export-with-toc nil)
  (setq org-html-head-extra "
     <link href='http://fonts.googleapis.com/css?family=Source+Sans+Pro:400,700,400italic,700italic&subset=latin,latin-ext' rel='stylesheet' type='text/css'>
     <link href='http://fonts.googleapis.com/css?family=Source+Code+Pro:400,700' rel='stylesheet' type='text/css'>
     <style type='text/css'>
        body {
           font-family: 'Source Sans Pro', sans-serif;
        }
        pre, code {
           font-family: 'Source Code Pro', monospace;
        }
     </style>"))

;; Reveal

;;    Generate presentations from my org-mode files using
;;    [[https://github.com/yjwen/org-reveal][org-reveal]]. Just download and make the results available to the
;;    HTML output:


(use-package ox-reveal
   :init
   (setq org-reveal-root (concat "file://" (getenv "HOME") "/Public/js/reveal.js"))
   (setq org-reveal-postamble "Howard Abrams"))

;; Tree Slide

;;    A quick way to display an org-mode file is using [[https://github.com/takaxp/org-tree-slide][org-tree-slide]].

;;    * org-tree-slide-move-next-tree (C->)
;;    * org-tree-slide-move-previous-tree (C-<)
;;    * org-tree-slide-content (C-x s c)


(use-package org-tree-slide
   :ensure t
   :init
   (setq org-tree-slide-skip-outline-level 4)
   (org-tree-slide-simple-profile))

;; Literate Programming

;;   The trick to literate programming is in the [[http://orgmode.org/worg/org-contrib/babel/intro.html][Babel project]], which
;;   allows org-mode to not only interpret source code blocks, but
;;   evaluate them and tangle them out to a file.


(use-package org
  :config
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((sh         . t)
     (js         . t)
     (emacs-lisp . t)
     (perl       . t)
     (scala      . t)
     (clojure    . t)
     (python     . t)
     (ruby       . t)
     (dot        . t)
     (css        . t)
     (plantuml   . t))))



;; It seems to automatically recognize the language used in a source
;; block, but if not, call =org-babel-lob-ingest= to add all the
;; languages from the code blocks in a particular file into the list
;; that Babel supports.  Keystroke: =C-c C-v i=.

;; According to [[http://endlessparentheses.com/emacs-narrow-or-widen-dwim.html][the narrow-widen article]], we can have =C-x C-s= get
;; out of editing org-mode source code blocks:


(eval-after-load 'org-src
  '(define-key org-src-mode-map
     (kbd "C-x C-s") #'org-edit-src-exit))

;; Just Evaluate It

;;    I'm normally fine with having my code automatically evaluated.


(setq org-confirm-babel-evaluate nil)

;; Font Coloring in Code Blocks

;;    Once upon a time, fontifying individual code blocks made it
;;    impossible to edit the block without =org-edit-special=. Now that
;;    the syntax rendering is faster, I keep it on.


(setq org-src-fontify-natively t)
(setq org-src-tab-acts-natively t)

;; Technical Artifacts

;;   Need to provide the =init-org-mode= so that I can require this
;;   package.


(provide 'init-org-mode)
