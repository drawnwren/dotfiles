;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-
(setq
 prettier-js-args '("--single-quote")
 display-line-numbers-type 'relative
 projectile-project-search-path '("~/code/"))
(add-hook 'python-mode-hook 'guess-style-guess-tabs-mode)
(add-hook 'python-mode-hook (lambda ()
                              (guess-style-guess-tab-width)))
;; Place your private configuration here
