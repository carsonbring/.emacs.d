(provide 'qol)

;; Provides multiple cursors
(use-package multiple-cursors
  :ensure t)

;; ido for M-x
(use-package smex
             :ensure t
             :config
             (progn
               (smex-initialize)
               (global-set-key (kbd "M-x") 'smex)
               (global-set-key (kbd "M-X") 'smex-major-mode-commands)
               ;; This is your old M-x.
               (global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)))

;; Yasnippet abbreviations - pr for System.out.println()
(use-package yasnippet :config (yas-global-mode))
(use-package yasnippet-snippets :ensure t)
vv

;; Make buffer names unique
;; buffernames that are foo<1>, foo<2> are hard to read. This makes them foo|dir  foo|otherdir
(use-package uniquify
  :config (setq uniquify-buffer-name-style 'post-forward))


; Magit
(use-package magit
  :ensure t)

;;Cool beast theme aka TURQUOISE NINJA NIGHT WATER
(use-package kaolin-themes
  :config
   (load-theme 'kaolin-dark t))



;; Disables ansi color in compilation mode
(defun my/ansi-colorize-buffer ()
(let ((buffer-read-only nil))
(ansi-color-apply-on-region (point-min) (point-max))))

; yay colors
(use-package ansi-color
:ensure t
:config
(add-hook 'compilation-filter-hook 'my/ansi-colorize-buffer)
)

(use-package all-the-icons
  :if (display-graphic-p))

;;org-mode setup
(setq org-startup-indented t)
(setq org-hide-leading-stars t)

;;PDF VIEW
(use-package pdf-tools
  :ensure t)

