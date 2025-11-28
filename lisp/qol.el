;;; Quality of life improvements
;;; Commentary: UI themes, productivity tools, and general enhancements
(provide 'qol)

;; Provides multiple cursors
(use-package multiple-cursors
  :ensure t)

;; ;; ido for M-x
;; (use-package smex
;;              :ensure t
;;              :config
;;              (progn
;;                (smex-initialize)
;;                (global-set-key (kbd "M-x") 'smex)
;;                (global-set-key (kbd "M-X") 'smex-major-mode-commands)
;;                ;; This is your old M-x.
;;                (global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)))

;; Yasnippet abbreviations - pr for System.out.println()
(use-package yasnippet :config (yas-global-mode))
(use-package yasnippet-snippets :ensure t)


;; Make buffer names unique
;; buffernames that are foo<1>, foo<2> are hard to read. This makes them foo|dir  foo|otherdir
(use-package uniquify
  :config (setq uniquify-buffer-name-style 'post-forward))


; Magit
(use-package magit
  :ensure t)

;;Cool beast theme aka TURQUOISE NINJA NIGHT WATER
(use-package gruvbox-theme
  :config
  (load-theme 'gruvbox-dark-medium :no-confirm))

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

;; org-roam
(use-package org-roam
  :ensure t)

(setq org-roam-directory (file-truename "~/org-roam"))
(org-roam-db-autosync-mode)

;;PDF VIEW
(use-package pdf-tools
  :ensure t)

;; Terminal emulator - multi-vterm for multiple terminals
(use-package multi-vterm
  :ensure t
  :config
  (setq vterm-max-scrollback 10000)
  (setq multi-vterm-buffer-name "vterm")
  :bind (("C-c t" . multi-vterm)
         ("C-c T" . multi-vterm-dedicated-toggle)))
