;;;; LSP, linting, and development tools configuration
;;; Commentary: Core development tools - LSP, completion, syntax checking
(provide 'lint-lsp)

;; Quick run for various languages
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


(use-package lsp-mode
:ensure t
:hook (
   (lsp-mode . lsp-enable-which-key-integration)
   (java-mode . #'lsp-deferred)
   (typescript-mode . lsp)
   (rust-mode . lsp)
   (c++-mode . lsp)
   (c-mode . lsp)
   (c++-ts-mode . lsp)
   (c-ts-mode . lsp)
)
:init (setq 
    lsp-keymap-prefix "C-c l"              ; this is for which-key integration documentation, need to use lsp-mode-map
    lsp-enable-file-watchers nil
    read-process-output-max (* 1024 1024)  ; 1 mb
    lsp-completion-provider :capf
    lsp-idle-delay 0.500
    lsp-install-server-automatically t     ; Enable automatic server installation
)
:config 
    (setq lsp-intelephense-multi-root nil) ; don't scan unnecessary projects
    (with-eval-after-load 'lsp-intelephense
    (setf (lsp--client-multi-root (gethash 'iph lsp-clients)) nil))
	(define-key lsp-mode-map (kbd "C-c l") lsp-command-map)
	;; Register tree-sitter modes with LSP
	(add-to-list 'lsp-language-id-configuration '(c++-ts-mode . "cpp"))
	(add-to-list 'lsp-language-id-configuration '(c-ts-mode . "c"))
	;; Ensure Python modes use pyright
	(add-to-list 'lsp-language-id-configuration '(python-mode . "python"))
	(add-to-list 'lsp-language-id-configuration '(python-ts-mode . "python"))
	)

(use-package hydra)



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
