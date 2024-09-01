;; -*- lexical-binding: t -*-
(setenv "JAVA_HOME" "/usr/lib/jvm/java-22-openjdk")
(require 'epa)
(epa-file-enable)
(setq EMACS_DIR "~/.emacs.d/")

; Loading env variables properly
(use-package exec-path-from-shell :ensure t)
(exec-path-from-shell-initialize)

;;; Custom Keymaps
(global-set-key (kbd "C-c i") 'insert-parentheses)

;;; Code:
(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")
;; font size
;; value is in 1/10pt
(set-face-attribute 'default nil :height 120)

; (load (expand-file-name "mu4e.el" user-emacs-directory))
; (load (expand-file-name "java.el" user-emacs-directory))

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
(add-to-list 'load-path "~/.emacs.d/lisp")
(require 'preferences)
(require 'mu4e-config)
(require 'files)
(require 'lint-lsp)
(require 'qol)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(kaolin-themes helm-lsp helm posframe markdownfmt markdown-preview-mode markdown-preview-eww treesit-auto spinner lsp-mode rainbow-delimiters paredit company flycheck racket-mode smex magit geiser-racket geiser-mit)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
