;;; Language-specific configurations
;;; Commentary: Programming language modes and their configurations
(provide 'languages)

;; Racket support
(use-package racket-mode
  :ensure t)


(use-package lsp-pyright
  :ensure t
  :config
  (setq lsp-pyright-auto-import-completions t
        lsp-pyright-auto-search-paths t)
  ;; Disable other Python language servers to ensure pyright is used
  (setq lsp-disabled-clients '(pylsp pyls semgrep-ls ruff-lsp)))

(add-hook 'python-mode-hook #'lsp-deferred)

;; Force Python files to use python-mode AFTER treesit-auto loads
(with-eval-after-load 'treesit-auto
  (setq auto-mode-alist (assq-delete-all "\\.py\\'" auto-mode-alist))
  (add-to-list 'auto-mode-alist '("\\.py\\'" . python-mode)))

(use-package pyvenv
  :ensure t
  :config
  (setq pyvenv-workon ".venv")
  (pyvenv-mode 1))


(setq company-tooltip-align-annotations t)

;; Tree-sitter for modern syntax highlighting
(use-package tree-sitter
  :ensure t)

(use-package tree-sitter-langs
  :ensure t)

;; Disable treesit-auto temporarily to fix Python LSP
;; (use-package treesit-auto
;;   :custom
;;   (treesit-auto-install 'prompt)
;;   :config
;;   (treesit-auto-add-to-auto-mode-alist 'all)
;;   (global-treesit-auto-mode))

;; (setq treesit-auto-install 'prompt)


(use-package lsp-mode
  :ensure t
  :config
  (setq lsp-auto-install-server t))

;; C/C++ configuration
;; Force C++ files to use regular mode instead of tree-sitter mode for LSP compatibility
(add-to-list 'auto-mode-alist '("\\.cc\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.cpp\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-ts-mode))
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . tsx-ts-mode))

(add-hook 'c-mode-hook 'lsp)
(add-hook 'c++-mode-hook 'lsp)
(add-hook 'c-ts-mode-hook 'lsp)
(add-hook 'c++-ts-mode-hook 'lsp)

;; Ensure Python files use python-mode (not python-ts-mode) for LSP compatibility
(add-to-list 'auto-mode-alist '("\\.py\\'" . python-mode) t)
