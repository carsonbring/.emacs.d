;; -*- lexical-binding: t -*-
;;; Emacs configuration entry point
;;; Commentary: Core Emacs setup, package management, and module loading

;; Security and file encryption
(require 'epa)
(epa-file-enable)

;; Basic UI preferences
(setq ring-bell-function 'ignore)
(setq whitespace-line-column 1000)

;; Set Delete key as Meta modifier in Emacs
;; This requires the Delete key to be used in combination with other keys
(defun setup-delete-as-meta ()
  "Configure Delete key to work as Meta modifier."
  (define-key input-decode-map (kbd "<delete>") (kbd "ESC"))
  ;; Alternative: use function-key-map for translation
  (define-key function-key-map (kbd "<delete>") (kbd "ESC")))

;; Apply the setup
(setup-delete-as-meta)

;; Sync the Emacs PATH with your shell's PATH
(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))



;;; Custom Keymaps
(global-set-key (kbd "C-c i") 'insert-parentheses)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-c C-f") 'org-roam-node-find)

;; Getting npm from the official path
(use-package exec-path-from-shell
  :config
  ;; Also import NVM_DIR and other shell vars
  (setq exec-path-from-shell-variables '("PATH" "NVM_DIR" "NODE_PATH"))
  (exec-path-from-shell-initialize))

;; expand-region configuration
(use-package expand-region
  :ensure t
  :bind ("C-=" . er/expand-region))

(setq EMACS_DIR "~/.emacs.d/")


(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")
;; font size
;; value is in 1/10pt
(set-face-attribute 'default nil :height 120)


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
  ("MELPA" . 10)
  ("GNU DEVEL" . 3)
("GNU ELPA" . 5)))
(package-initialize)
 (setq package-install-upgrade-built-in t)

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
;; Load custom modules
(add-to-list 'load-path (expand-file-name "~/.emacs.d/lisp/"))
(require 'preferences)
(require 'files)
(require 'lint-lsp)
(require 'languages)
(require 'qol)
(require 'java-config)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("5a0ddbd75929d24f5ef34944d78789c6c3421aa943c15218bac791c199fc897d"
	 "74e2ed63173b47d6dc9a82a9a8a6a9048d89760df18bc7033c5f91ff4d083e37"
	 default))
 '(package-selected-packages
   '(add-node-modules-path all-the-icons apheleia company elpy envrc
						   exec-path-from-shell expand-region
						   gruvbox-theme helm-lsp kaolin-themes
						   lsp-java lsp-pyright lsp-ui magit
						   markdown-preview-eww markdown-preview-mode
						   markdownfmt multi-vterm multiple-cursors
						   org-roam paredit pdf-tools projectile
						   pyvenv quickrun racket-mode
						   rainbow-delimiters smex tide
						   tree-sitter-langs treesit-auto use-package
						   which-key yasnippet-snippets)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
