(use-package js2-mode
  :ensure t
  :init
  (setq js-basic-indent 2)
  (setq-default js2-basic-indent 2 js2-basic-offset 2
                js2-auto-indent-p t js2-cleanup-whitespace t
                js2-enter-indents-newline t
                js2-indent-on-enter-key t
                js2-global-externs (list "window" "module" "require" "buster" "sinon" "assert" "refute" "setTimeout" "clearTimeout" "setInterval" "clearInterval" "location" "__dirname" "console" "JSON" "jQuery" "$"))
  (add-to-list 'auto-mode-alist '("\\.js$" . js2-mode)))

(add-hook 'j2-mode-hook
          (lambda ()
            (add-to-list (make-local-variable 'paredit-space-for-delimiter-predicates)
                         (lambda _ _ nil))
            (enable-paredit-mode)))

(add-hook 'js2-mode-hook
          (lambda ()
            (push '("function" . ?ƒ) prettify-symbols-alist)))

(add-hook 'js2-mode-hook
          (lambda () (flycheck-select-checker "javascript-eslint")))

(use-package color-identifiers-mode
  :ensure t
  :init
  (add-hook 'js2-mode-hook 'color-identifiers-mode))



(use-package js2-refactor
  :ensure t
  :init   (add-hook 'js2-mode-hook 'js2-refactor-mode)
  :config (js2r-add-keybindings-with-prefix "C-c ."))

(use-package tern
  :ensure t
  :init
  (add-hook 'js2-mode-hook (lambda () (tern-mode t))))

(use-package skewer-mode
  :ensure t
  :init (add-hook 'js2-mode-hook 'skewer-mode))

(provide 'init-javascript)
