;; -*- lexical-binding: t -*-

(use-package evil
  :ensure t  )

(use-package key-chord
  :ensure t)

(defun my-move-key (keymap-from keymap-to key)
  "Moves key binding from one keymap to another, deleting from the old location. "
  (define-key keymap-to key (lookup-key keymap-from key))
  (define-key keymap-from key nil))

(my-move-key evil-motion-state-map evil-normal-state-map (kbd "RET"))

(key-chord-mode 1)
(key-chord-define evil-insert-state-map  "jk" 'evil-normal-state)

(defvar my-leader-map
  (make-sparse-keymap)
  "Keymap for 'leader key' shortcuts.")

(evil-define-key 'normal global-map " " my-leader-map)

(define-key my-leader-map "w" 'save-buffer)

(define-key my-leader-map "b" 'list-buffers)

(evil-mode)

(provide 'init-evil)
