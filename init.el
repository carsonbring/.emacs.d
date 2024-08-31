;; -*- lexical-binding: t -*-

;;; Custom Keymaps
(global-set-key (kbd "C-c i") 'insert-parentheses)

(setq EMACS_DIR "~/.emacs.d/")
;;; Code:
(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")
;; font size
;; value is in 1/10pt
(set-face-attribute 'default nil :height 140)

(load (expand-file-name "mu4e.el" user-emacs-directory))


(setq user-cache-directory (concat EMACS_DIR "cache"))
(setq backup-directory-alist `(("." . ,(expand-file-name "backups" user-cache-directory)))
      url-history-file (expand-file-name "url/history" user-cache-directory)
      auto-save-list-file-prefix (expand-file-name "auto-save-list/.saves-" user-cache-directory)
      projectile-known-projects-file (expand-file-name "projectile-bookmarks.eld" user-cache-directory))

(global-display-line-numbers-mode)

;; Disable scrollbar and toolbar
(scroll-bar-mode -1)
(tool-bar-mode -1)

;; Automatically add ending brackets and braces
(electric-pair-mode 1)


;; Make sure tab-width is 4 and not 8
(setq-default tab-width 4)



;; Add the melpa emacs repo, where most packages are
(require 'package)


;; Setting package archives
(setq package-archives
'(("GNU ELPA" . "https://elpa.gnu.org/packages/")
("MELPA Stable" . "https://stable.melpa.org/packages/")
("MELPA" . "https://melpa.org/packages/")
("GNU DEVEL" . "https://elpa.gnu.org/devel/"))
package-archive-priorities
'(("MELPA Stable" . 7)
  ("MELPA" . 5)
  ("GNU DEVEL" . 3)
("GNU ELPA" . 10)))
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





;;;; PACKAGES

; Loading env variables properly 
(use-package exec-path-from-shell :ensure t)
(exec-path-from-shell-initialize)

;;Java setup
(load (expand-file-name "java.el" user-emacs-directory))

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

;; Disables ansi color in compilation mode
(defun my/ansi-colorize-buffer ()
(let ((buffer-read-only nil))
(ansi-color-apply-on-region (point-min) (point-max))))

(use-package ansi-color
:ensure t
:config
(add-hook 'compilation-filter-hook 'my/ansi-colorize-buffer)
)

(use-package kaolin-themes
  :config
  (load-theme 'kaolin-dark t)
  (kaolin-treemacs-theme))

;; Projectile - EZ navigation within project. ADD .projectile FILE AND USE C-c p
(use-package projectile 
:ensure t
:init (projectile-mode +1)
:config 
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
)

;; Quick run
(use-package quickrun 
:ensure t
:bind ("C-c r" . quickrun))
;; Yasnippet abbreviations - pr for System.out.println()
(use-package yasnippet :config (yas-global-mode))
(use-package yasnippet-snippets :ensure t)
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
;; Use C-c l to activate 
(use-package lsp-mode
:ensure t
:hook (
       (lsp-mode . lsp-enable-which-key-integration)
       (python-mode . lsp)
	   (java-mode . #'lsp-deferred)
)
:init (setq 
    lsp-keymap-prefix "C-c l"              ; this is for which-key integration documentation, need to use lsp-mode-map
    lsp-enable-file-watchers nil
    read-process-output-max (* 1024 1024)  ; 1 mb
    lsp-completion-provider :capf
    lsp-idle-delay 0.500
	lsp-headerline-breadcrumb-icons-enable nil
)
:config 
    (setq lsp-intelephense-multi-root nil) ; don't scan unnecessary projects
    (with-eval-after-load 'lsp-intelephense
    (setf (lsp--client-multi-root (gethash 'iph lsp-clients)) nil))
	(define-key lsp-mode-map (kbd "C-c l") lsp-command-map)
	)

(use-package lsp-java 
:ensure t
:config (add-hook 'java-mode-hook 'lsp))

;; lsp-pyright setup
(use-package lsp-pyright
  :ensure t
  :hook (python-mode . (lambda ()
(require 'lsp-pyright)
(lsp)))
  :config
  (setq lsp-keymap-prefix "C-c l")
  )
;Assign M-9 to show error list
(use-package lsp-treemacs
  :after (lsp-mode treemacs)
  :ensure t
  :commands lsp-treemacs-errors-list
  :bind (:map lsp-mode-map
         ("M-9" . lsp-treemacs-errors-list)))



(use-package treemacs
  :ensure t
  :commands (treemacs)
  :after (lsp-mode))

; C-c 1 T
(use-package lsp-ui
:ensure t
:after (lsp-mode)
:bind (:map lsp-ui-mode-map
         ([remap xref-find-definitions] . lsp-ui-peek-find-definitions)
         ([remap xref-find-references] . lsp-ui-peek-find-references))
:init (setq lsp-ui-doc-delay 1.5
      lsp-ui-doc-position 'bottom
	  lsp-ui-doc-max-width 100
))

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
   '(kaolin-themes posframe treesit-auto spinner lsp-mode rainbow-delimiters paredit company flycheck racket-mode smex magit geiser-racket geiser-mit)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
