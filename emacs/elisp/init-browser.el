;; EWW?

;;   For v24.4, I'm intrigued with EWW, but [[http://w3m.sourceforge.net][w3m]] works really well.
;;   The one I use is the one I've loaded ...


(use-package eww
  :commands eww eww-follow-link
  :init
  (setq browse-url-browser-function 'eww-browse-url)

  (defun eww-search (term)
    (interactive "sSearch terms: ")
    (eww-browse-url (concat "http://www.google.com/search?gbv=1&source=hp&hl=en&ie=ISO-8859-1&btnG=Google+Search&q=" term)))

  (defun eww-wiki (text)
    "Function used to search wikipedia for the given text."
    (interactive (list (read-string "Wiki for: ")))
    (eww (format "https://en.m.wikipedia.org/wiki/Special:Search?search=%s"
               (url-encode-url text))))

  (global-set-key (kbd "C-c w w") 'eww)
  (global-set-key (kbd "C-c w i") 'eww-wiki)
  (global-set-key (kbd "C-c w l") 'eww-follow-link)
  (global-set-key (kbd "C-c w g") 'eww-search))

;; External Web Browsing

;;   Need to be able to switch and have a link in an =org-mode= file show
;;   up in the default, graphical browser:


(defun ha-switch-default-browser ()
  "Switches the default browser between the internal and external web browser."
  (interactive)
  ;;         | Variable                  | Function
  (if (equal browse-url-browser-function 'browse-url-default-browser)
      (if (fboundp 'w3m)
          (setq browse-url-browser-function 'w3m-browse-url)
        (setq browse-url-browser-function 'eww-browse-url))
    (setq browse-url-browser-function 'browse-url-default-browser))

  ;; Now we need to display the current setting. The variables are
  ;; pretty typical and have the goodies, but I just need to get rid
  ;; of the word "url" or "browser", and the results are pretty close:
  (message "Browser set to: %s"
           (car
            (filter (lambda (x)
                      (if (or (equal "url" x)
                              (equal "browse" x)
                              (equal "browser" x))
                          nil
                        t))
                    (split-string (format "%s" browse-url-browser-function) "-")))))

(global-set-key (kbd "C-c w d") 'ha-switch-default-browser)

;; Google Search

;;   Don’t need to actually remove stuff when search in Google, as I
;;   really just need to jump ahead and skip the header:


(defun w3m-skip-in-google ()
  "For a Google Search, skip to the first result."
  (beginning-of-buffer)
  (search-forward-regexp "[0-9, ]+ results")
  (forward-line 2)
  (recenter-top-bottom 0))

;; Stack Overflow

;;    Without a clear enough label, searching for the start of content
;;    will always be fragile. We’ll look for the start of the first column.


(defun w3m-skip-in-stackoverflow ()
    (beginning-of-buffer)
    (search-forward-regexp "^   ")
    (forward-line -2)
    (recenter-top-bottom 0))

;; ClojureDocs

;;    The [[http://clojuredocs.org/][clojuredocs.org]] website has a big header, but doesn’t include a
;;    link to jump to the content, so let’s try to figure that out for
;;    most function definitions:


(defun w3m-skip-in-clojuredocs()
  "When viewing the Clojuredocs, we can skip to the meat of the
function description by looking for the label, ‘Available since’,
and finding the function name just before that."
  (beginning-of-buffer)
  (search-forward-regexp "Available since")
  (forward-line -4)
  (recenter-top-bottom 0))

;; Easier Link Selection

;;   [[https://github.com/abo-abo/ace-link][Ace-Link]] already supports EWW.


(use-package ace-link
  :ensure t
  :config
  (ace-link-setup-default))

;; Technical Artifacts

;;   Make sure that we can simply =require= this library.


(provide 'init-browser)
