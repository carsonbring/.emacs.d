;; Java setup file -08-30-2024
(setenv "JAVA_HOME" "/usr/lib/jvm/jdk-22.0.2-oracle-x64")

;;; disable ring-bell when backspace key is pressed
(setq ring-bell-function 'ignore)

(setq whitespace-line-column 1000) 

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
