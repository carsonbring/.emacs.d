;;;; This file is for linting and lsp (also debugging)
(provide 'lint-lsp)

;; Provides all the racket support
(use-package racket-mode
  :ensure t)

;; Quick run
(use-package quickrun 
:ensure t
:bind ("C-c r" . quickrun))

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
;; Syntax checking
(use-package flycheck
             :ensure t
             :config
             (global-flycheck-mode))

;; Lots of parenthesis and other delimiter niceties
(use-package paredit
             :ensure t
             :config
             (add-hook 'racket-mode-hook #'enable-paredit-mode))

;; Colorizes delimiters so they can be told apart
(use-package rainbow-delimiters
             :ensure t
             :config (add-hook 'prog-mode-hook 'rainbow-delimiters-mode))



(use-package which-key
  :ensure t
  :config
  (which-key-mode))

;; lsp-mode setup
;; Use C-c l to activate 

(use-package lsp-java 
:ensure t
:config (add-hook 'java-mode-hook 'lsp))

(use-package lsp-mode
:ensure t
:hook (
   (lsp-mode . lsp-enable-which-key-integration)
   (java-mode . #'lsp-deferred)
   (typescript-mode . lsp)
)
:init (setq 
    lsp-keymap-prefix "C-c l"              ; this is for which-key integration documentation, need to use lsp-mode-map
    lsp-enable-file-watchers nil
    read-process-output-max (* 1024 1024)  ; 1 mb
    lsp-completion-provider :capf
    lsp-idle-delay 0.500
)
:config 
    (setq lsp-intelephense-multi-root nil) ; don't scan unnecessary projects
    (with-eval-after-load 'lsp-intelephense
    (setf (lsp--client-multi-root (gethash 'iph lsp-clients)) nil))
	(define-key lsp-mode-map (kbd "C-c l") lsp-command-map)
	)

(use-package hydra)

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
(use-package dap-mode
  :ensure t
  :after (lsp-mode)
  :functions dap-hydra/nil
  :config
  (require 'dap-java)
  :bind (:map lsp-mode-map
         ("<f5>" . dap-debug)
         ("M-<f5>" . dap-hydra))
  :hook ((dap-mode . dap-ui-mode)
    (dap-session-created . (lambda (&_rest) (dap-hydra)))
    (dap-terminated . (lambda (&_rest) (dap-hydra/nil)))))

(use-package dap-java :ensure nil)

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
 
(use-package helm-lsp)

(use-package helm
  :config (helm-mode))
(helm-mode t)

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

;; TIDE CONFIG
;; aligns annotation to the right hand side
(setq company-tooltip-align-annotations t)
;; formats the buffer before saving
(add-hook 'before-save-hook 'tide-format-before-save)
;; if you use treesitter based typescript-ts-mode (emacs 29+)
(add-hook 'typescript-ts-mode-hook #'setup-tide-mode)
(add-hook 'tsx-ts-mode-hook #'setup-tide-mode)

