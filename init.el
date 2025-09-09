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

;; expand-region configuration
(use-package expand-region
  :ensure t
  :bind ("C-=" . er/expand-region))

(setq EMACS_DIR "~/.emacs.d/")


(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")
;; font size
;; value is in 1/10pt
(set-face-attribute 'default nil :height 160)


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
   '("74e2ed63173b47d6dc9a82a9a8a6a9048d89760df18bc7033c5f91ff4d083e37" default))
 '(package-selected-packages
   '(expand-region multi-vterm catppuccin-theme vterm lsp-javacomp helm-z flycheck-rust toml-mode treemacs-nerd-icons treemacs-all-the-icons magit-file-icons ob-raku flycheck-raku helm-lsp all-the-icons-completion all-the-icons-dired all-the-icons-gnus all-the-icons-ibuffer all-the-icons-ivy all-the-icons-ivy-rich all-the-icons-nerd-fonts almost-mono-themes raku-mode kaolin-themes posframe treesit-auto spinner lsp-mode rainbow-delimiters paredit company flycheck racket-mode smex magit geiser-racket geiser-mit)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
