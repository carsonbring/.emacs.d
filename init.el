;; -*- lexical-binding: t -*-

;;; Custom Keymaps
(global-set-key (kbd "C-c i") 'insert-parentheses)

;;; Code:
(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")
;; font size
;; value is in 1/10pt
(set-face-attribute 'default nil :height 140)

(load (expand-file-name "mu4e.el" user-emacs-directory))






;; Add the melpa emacs repo, where most packages are
(require 'package)

;; Setting package archives
(setq package-archives
'(("GNU ELPA" . "https://elpa.gnu.org/packages/")
("MELPA Stable" . "https://stable.melpa.org/packages/")
("MELPA" . "https://melpa.org/packages/")
("GNU DEVEL" . "https://elpa.gnu.org/devel/"))
package-archive-priorities
'(("MELPA Stable" . 10)
  ("MELPA" . 5)
  ("GNU DEVEL" . 3)
("GNU ELPA" . 2)))
(package-initialize)

 (setq package-install-upgrade-built-in t)
;; custom startup screen into sicp due to me doing my practice
(setq inhibit-startup-screen t)
(setq initial-buffer-choice "~/projects")

;; Ensure package-list has been fetched
(when (not package-archive-contents)
  (package-refresh-contents))
(unless package-archive-contents
  (package-refresh-contents))
;; We want to use use-package, not the default emacs behavior
(setq package-enable-at-startup nil)

;; Install use-package if it hasn't been installed
(when (not (package-installed-p 'use-package)) (package-install 'use-package))
(require 'use-package)

;; ido-mode provides a better file/buffer-selection interface
(use-package ido
             :ensure t
             :config (ido-mode t))
             
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
               
;; Provides all the racket support
(use-package racket-mode
  :ensure t)

;; Provides multiple cursors
(use-package multiple-cursors
  :ensure t)

;; Syntax checking
(use-package flycheck
             :ensure t
             :config
             (global-flycheck-mode))

;; Autocomplete popups
(use-package company
             :ensure t
             :config
             (progn
               (setq company-idle-delay 0.2
                     ;; min prefix of 2 chars
                     company-minimum-prefix-length 2
                     company-selection-wrap-around t
                     company-show-numbers t
                     company-dabbrev-downcase nil
                     company-echo-delay 0
                     company-tooltip-limit 20
                     company-transformers '(company-sort-by-occurrence)
                     company-begin-commands '(self-insert-command)
                     )
               (global-company-mode))
             )
             
;; Lots of parenthesis and other delimiter niceties
(use-package paredit
             :ensure t
             :config
             (add-hook 'racket-mode-hook #'enable-paredit-mode))

;; Colorizes delimiters so they can be told apart
(use-package rainbow-delimiters
             :ensure t
             :config (add-hook 'prog-mode-hook 'rainbow-delimiters-mode))
;; Make buffer names unique
;; buffernames that are foo<1>, foo<2> are hard to read. This makes them foo|dir  foo|otherdir
(use-package uniquify
             :config (setq uniquify-buffer-name-style 'post-forward))

; Magit
(use-package magit
  :ensure t)

;; Highlight matching parenthesis
(show-paren-mode 1)
(setq show-paren-delay 0)

;; Allows moving through wrapped lines as they appear
(setq line-move-visual t)

;; lsp-mode setup
(use-package lsp-mode
  :ensure t
  :hook (python-mode . lsp)
  :commands lsp)
;; lsp-pyright setup
(use-package lsp-pyright
  :ensure t
  :hook (python-mode . (lambda ()
(require 'lsp-pyright)
(lsp)))
  :config
  (setq lsp-keymap-prefix "C-c l")
  )

;;pyvenv setup
(use-package pyvenv
  :ensure t
  :config
  ;; Set the default venv directory
  (setq pyvenv-workon ".venv")
  (pyvenv-mode 1))

;;Apheleia setup (prettier)
(use-package apheleia
  :ensure t)

;; envrc (determines project env varibales and sets those vars on per-buffer basis)
;; Create .envrc files to have processes in buffer launch with those env vars
(use-package envrc
  :ensure t)

;; Add node modules to path
;; Usage: M-x add-node-modules-path
(use-package add-node-modules-path
  :ensure t)

;;Treesitter
(use-package tree-sitter
  :ensure t)
(use-package tree-sitter-langs
  :ensure t)

;;Treesit-auto for ts grammar
(use-package treesit-auto
  :custom
  (treesit-auto-install 'prompt)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))

(setq treesit-auto-install 'prompt)


;;tide setup
(use-package tide
  :ensure t)

(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  ;; company is an optional dependency. You have to
  ;; install it separately via package-install
  ;; `M-x package-install [ret] company`
  (company-mode +1))

;; aligns annotation to the right hand side
(setq company-tooltip-align-annotations t)
;; formats the buffer before saving
(add-hook 'before-save-hook 'tide-format-before-save)
;; if you use treesitter based typescript-ts-mode (emacs 29+)
(add-hook 'typescript-ts-mode-hook #'setup-tide-mode)
(add-hook 'tsx-ts-mode-hook #'setup-tide-mode)
;;org-mode setup
(setq org-startup-indented t)
(setq org-hide-leading-stars t)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(treesit-auto spinner lsp-mode rainbow-delimiters paredit company flycheck racket-mode smex magit geiser-racket geiser-mit)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
