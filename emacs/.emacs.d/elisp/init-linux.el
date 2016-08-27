;; Key Bindings


(global-set-key (kbd "s-z") 'undo-tree-undo)
(global-set-key (kbd "s-y") 'undo-tree-redo)
(global-set-key (kbd "s-Z") 'undo-tree-redo)
(global-set-key (kbd "s-x") 'kill-region)
(global-set-key (kbd "s-c") 'kill-ring-save)
(global-set-key (kbd "s-v") 'yank)

(global-set-key (kbd "s-a") 'mark-whole-buffer)
(global-set-key (kbd "s-f") 'isearch-forward-regexp)

(global-set-key (kbd "s-o") 'ido-find-file)
(global-set-key (kbd "s-s") 'save-buffer)
(global-set-key (kbd "s-+") 'text-scale-increase)
(global-set-key (kbd "s--") 'text-scale-decrease)
(global-set-key (kbd "s-l") 'goto-line)
(global-set-key (kbd "s-w") 'bury-buffer)
(global-set-key (kbd "s-M-w") 'kill-this-buffer)

(global-set-key (kbd "s-<up>") 'beginning-of-buffer)
(global-set-key (kbd "s-<down>") 'end-of-buffer)
(global-set-key (kbd "s-<left>") 'smarter-move-beginning-of-line)
(global-set-key (kbd "s-<right>") 'move-end-of-line)

(global-set-key (kbd "M-<up>") 'backward-page)
(global-set-key (kbd "M-<down>") 'forward-page)
(global-set-key (kbd "M-<left>") 'backward-word)
(global-set-key (kbd "M-<right>") 'forward-word)

;; Locate

;;   While I use Apple Spotlight for indexing my text files on the Mac,
;;   on Linux, we use =recoll= ...


(setq locate-command "recoll")

;; Technical Artifacts

;;   Make sure that we can simply =require= this library.


(provide 'init-linux)
