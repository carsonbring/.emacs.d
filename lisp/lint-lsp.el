;;;; LSP, linting, and development tools configuration
;;; Commentary: Core development tools - LSP, completion, syntax checking
(provide 'lint-lsp)

;; --- Ensure PATH from shell (Node, tsserver, eslint, etc.) ---
(use-package exec-path-from-shell
  :if (memq window-system '(mac ns x))
  :init
  (exec-path-from-shell-initialize))

;; Quick run for various languages
(use-package quickrun 
  :ensure t
  :bind ("C-c r" . quickrun))

;; Autocomplete popups
(use-package company
  :ensure t
  :config
  (setq company-idle-delay 0.2
        company-minimum-prefix-length 2
        company-selection-wrap-around t
        company-show-numbers t
        company-dabbrev-downcase nil
        company-echo-delay 0
        company-tooltip-limit 20
        company-transformers '(company-sort-by-occurrence)
        company-begin-commands '(self-insert-command))
  (global-company-mode))

;; Syntax checking (Flycheck as the display layer)
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
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package which-key
  :ensure t
  :config
  (which-key-mode))

;; --------------------------
;; LSP setup (TypeScript + ESLint via LSP, Flycheck UI)
;; --------------------------
;; Deno is giving me some issues with typescript. Whatever


(use-package lsp-mode
  :ensure t
  :hook ((lsp-mode . flycheck-mode)
         (lsp-mode . lsp-enable-which-key-integration)
         (java-mode . lsp-deferred)
         ;; Prefer tree-sitter modes; keep legacy ts-mode just in case
		 (python-mode . lsp-deferred)

         (typescript-mode . lsp-deferred)
         (typescript-ts-mode . lsp-deferred)
         (tsx-ts-mode . lsp-deferred)
         (rust-mode . lsp-deferred)
         (c++-mode . lsp-deferred)
         (c-mode . lsp-deferred)
         (c++-ts-mode . lsp-deferred)
         (c-ts-mode . lsp-deferred))
  :init
  (setq
   ;; UX / perf
   lsp-keymap-prefix "C-c l"
   read-process-output-max (* 1024 1024)      ; 1 MB
   lsp-idle-delay 0.50
   lsp-completion-provider :capf
   lsp-install-server-automatically t

   ;; File watchers ON so LSP sees eslint.config.js/tsconfig changes
   lsp-enable-file-watchers t
   lsp-file-watch-threshold 2000

   ;; Route diagnostics to Flycheck (not Flymake)
   lsp-prefer-flymake nil
   lsp-diagnostics-provider :flycheck

   ;; ESLint LSP (flat config)
   ;; Requires project devDep: `npm i -D vscode-eslint`
   lsp-eslint-enable t
   lsp-eslint-use-flat-config t
   lsp-eslint-validate '("javascript" "javascriptreact" "typescript" "typescriptreact")

   )
  :config
  ;; Keymap
  (define-key lsp-mode-map (kbd "C-c l") lsp-command-map)
    (setq lsp-clients-deno-enable nil)
	(add-to-list 'lsp-disabled-clients 'deno-ls)



  ;; If pylsp/jedi-language-server are installed, you can explicitly disable them:
  (add-to-list 'lsp-disabled-clients 'pylsp)
  (add-to-list 'lsp-disabled-clients 'jedi-language-server)
  
  ;; (Optional) limit multi-root for Intelephense if you use it
  (setq lsp-intelephense-multi-root nil)
  (with-eval-after-load 'lsp-intelephense
    (setf (lsp--client-multi-root (gethash 'iph lsp-clients)) nil))

  ;; Register tree-sitter modes with LSP
  (add-to-list 'lsp-language-id-configuration '(c++-ts-mode . "cpp"))
  (add-to-list 'lsp-language-id-configuration '(c-ts-mode   . "c"))
  (add-to-list 'lsp-language-id-configuration '(python-mode    . "python"))

  (add-to-list 'lsp-language-id-configuration '(typescript-mode    . "typescript"))
  (add-to-list 'lsp-language-id-configuration '(typescript-ts-mode . "typescript"))
  (add-to-list 'lsp-language-id-configuration '(tsx-ts-mode        . "typescriptreact")))

(with-eval-after-load 'lsp-mode
  ;; 1) Whitelist only the clients we want for JS/TS
  (setq lsp-enabled-clients '(ts-ls eslint pyright))

  ;; 2) Blacklist Deno just in case (belt + suspenders)
  (add-to-list 'lsp-disabled-clients 'deno-ls)

  ;; 3) Physically remove the Deno client so it can never auto-activate
  (when (boundp 'lsp-clients)
    (remhash 'deno-ls lsp-clients)
    ;; Some snapshots use a different key; remove both if present
    (remhash 'deno lsp-clients))
)

(use-package hydra)

;; UI sugar for LSP
(use-package lsp-ui
  :ensure t
  :after (lsp-mode)
  :bind (:map lsp-ui-mode-map
              ([remap xref-find-definitions] . lsp-ui-peek-find-definitions)
              ([remap xref-find-references]  . lsp-ui-peek-find-references))
  :init
  (setq lsp-ui-doc-delay 1.5
        lsp-ui-doc-position 'bottom
        lsp-ui-doc-max-width 100))

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

;; Apheleia (formatting)
(use-package apheleia :ensure t)

;; envrc (per-project env vars)
(use-package envrc :ensure t)

;; Ensure local node_modules/.bin is on PATH per buffer (eslint/tsserver/etc.)
(use-package add-node-modules-path
  :ensure t
  :hook ((typescript-ts-mode . add-node-modules-path)
         (tsx-ts-mode        . add-node-modules-path)
         (javascript-mode    . add-node-modules-path)
         (js-ts-mode         . add-node-modules-path)))

;; ---------------
;; Flycheck fallback for TS/TSX if ESLint-LSP isn't active
;; ---------------
(with-eval-after-load 'flycheck
  ;; Make the CLI eslint checker available in ts/tsx tree-sitter modes
  (flycheck-add-mode 'javascript-eslint 'typescript-ts-mode)
  (flycheck-add-mode 'javascript-eslint 'tsx-ts-mode)

  ;; If ESLint LSP isn't attached, fall back to the CLI checker for this buffer
  (defun cb/use-eslint-cli-when-no-eslint-lsp ()
    (when (and (derived-mode-p 'typescript-ts-mode 'tsx-ts-mode)
               (not (lsp-find-workspace 'eslint nil))
               (flycheck-may-use-checker 'javascript-eslint))
      (flycheck-select-checker 'javascript-eslint)))
  (add-hook 'typescript-ts-mode-hook #'cb/use-eslint-cli-when-no-eslint-lsp)
  (add-hook 'tsx-ts-mode-hook        #'cb/use-eslint-cli-when-no-eslint-lsp))

;; -------- Tree-sitter setup --------
(use-package treesit
  :mode (("\\.tsx\\'" . tsx-ts-mode)
         ("\\.js\\'"  . typescript-ts-mode)
         ("\\.mjs\\'" . typescript-ts-mode)
         ("\\.mts\\'" . typescript-ts-mode)
         ("\\.cjs\\'" . typescript-ts-mode)
         ("\\.ts\\'"  . typescript-ts-mode)
         ("\\.jsx\\'" . tsx-ts-mode)
         ("\\.json\\'" .  json-ts-mode)
         ("\\.Dockerfile\\'" . dockerfile-ts-mode)
         ("\\.prisma\\'" . prisma-ts-mode))
  :preface
  (defun os/setup-install-grammars ()
    "Install Tree-sitter grammars if they are absent."
    (interactive)
    (dolist (grammar
             '((css . ("https://github.com/tree-sitter/tree-sitter-css" "v0.20.0"))
               (bash "https://github.com/tree-sitter/tree-sitter-bash")
               (html . ("https://github.com/tree-sitter/tree-sitter-html" "v0.20.1"))
               (javascript . ("https://github.com/tree-sitter/tree-sitter-javascript" "v0.21.2" "src"))
               (json . ("https://github.com/tree-sitter/tree-sitter-json" "v0.20.2"))
               (python . ("https://github.com/tree-sitter/tree-sitter-python" "v0.20.4"))
               (go "https://github.com/tree-sitter/tree-sitter-go" "v0.20.0")
               (markdown "https://github.com/ikatyang/tree-sitter-markdown")
               (make "https://github.com/alemuller/tree-sitter-make")
               (elisp "https://github.com/Wilfred/tree-sitter-elisp")
               (cmake "https://github.com/uyha/tree-sitter-cmake")
               (c "https://github.com/tree-sitter/tree-sitter-c")
               (cpp "https://github.com/tree-sitter/tree-sitter-cpp")
               (toml "https://github.com/tree-sitter/tree-sitter-toml")
               (tsx . ("https://github.com/tree-sitter/tree-sitter-typescript" "v0.20.3" "tsx/src"))
               (typescript . ("https://github.com/tree-sitter/tree-sitter-typescript" "v0.20.3" "typescript/src"))
               (yaml . ("https://github.com/ikatyang/tree-sitter-yaml" "v0.5.0"))
               (prisma "https://github.com/victorhqc/tree-sitter-prisma")))
      (add-to-list 'treesit-language-source-alist grammar)
      (unless (treesit-language-available-p (car grammar))
        (treesit-install-language-grammar (car grammar)))))
  (dolist (mapping
           '(
			 (css-mode . css-ts-mode)
             (typescript-mode . typescript-ts-mode)
             (js-mode . typescript-ts-mode)
             (js2-mode . typescript-ts-mode)
             (c-mode . c-ts-mode)
             (c++-mode . c++-ts-mode)
             (c-or-c++-mode . c-or-c++-ts-mode)
             (bash-mode . bash-ts-mode)
             (css-mode . css-ts-mode)
             (json-mode . json-ts-mode)
             (js-json-mode . json-ts-mode)
             (sh-mode . bash-ts-mode)
             (sh-base-mode . bash-ts-mode)))
    (add-to-list 'major-mode-remap-alist mapping))
  :config
  (os/setup-install-grammars))


(use-package elpy
  :ensure t
  :init
  (elpy-enable))

(with-eval-after-load 'python
  ;; 1) Make sure Emacs does NOT remap python-mode → python-ts-mode
  (setq major-mode-remap-alist
        (assq-delete-all 'python-mode major-mode-remap-alist))

  ;; 2) Force .py files to open in classic python-mode
  (add-to-list 'auto-mode-alist '("\\.py\\'" . python-mode))

  ;; 3) Belt-and-suspenders: if something asks for python-ts-mode,
  ;;    turn it into python-mode instead.
  (add-to-list 'major-mode-remap-alist '(python-ts-mode . python-mode)))
