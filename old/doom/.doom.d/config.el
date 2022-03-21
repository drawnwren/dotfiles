;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-
(setq
 prettier-js-args '("--single-quote")
 display-line-numbers-type 'relative
 projectile-project-search-path '("~/code/")
 )
;; (add-hook 'python-mode-hook 'guess-style-guess-tabs-mode)
;; (add-hook 'python-mode-hook (lambda ()
;;                               (guess-style-guess-tab-width)))
(setq doom-theme 'doom-tomorrow-night)
;; Place your private configuration here
;;
;; Enable which-key for lsp-mode
(with-eval-after-load 'lsp-mode (add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration))
;; Set pyls config options
;;
(use-package! lsp
  :init
  (setq lsp-pyls-plugins-pylint-enabled t
        lsp-pyls-plugins-autopep8-enabled nil
        lsp-pyls-plugins-pyflakes-enabled nil
        lsp-pyls-plugins-jedi-completion-enabled t
        lsp-pyls-plugins-jedi-completion-include-params t
        lsp-pyls-plugins-yapf-enabled t)
  )
