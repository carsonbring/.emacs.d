;; -*- lexical-binding: t -*-
;; Java setup file -08-30-2024
(setenv "JAVA_HOME" "/usr/lib/jvm/jdk-22.0.2-oracle-x64")
(require 'epa)
(epa-file-enable)
;;; disable ring-bell when backspace key is pressed
(setq ring-bell-function 'ignore)

(setq whitespace-line-column 1000) 


;;; Custom Keymaps
(global-set-key (kbd "C-c i") 'insert-parentheses)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "M-x") 'helm-M-x)

(setq EMACS_DIR "~/.emacs.d/")


(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")
;; font size
;; value is in 1/10pt
(set-face-attribute 'default nil :height 140)

(load (expand-file-name "mu4e.el" user-emacs-directory))


;; Add the melpa emacs repo, where most packages are
(require 'package)

(require 'all-the-icons)
(add-to-list 'image-types 'svg)
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
(add-to-list 'load-path (expand-file-name "~/.emacs.d/lisp/"))
(require 'preferences)
(require 'files)
(require 'lint-lsp)
(require 'qol)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("74e2ed63173b47d6dc9a82a9a8a6a9048d89760df18bc7033c5f91ff4d083e37" default))
 '(package-selected-packages
   '(treemacs-nerd-icons treemacs-all-the-icons magit-file-icons ob-raku flycheck-raku helm-lsp all-the-icons-completion all-the-icons-dired all-the-icons-gnus all-the-icons-ibuffer all-the-icons-ivy all-the-icons-ivy-rich all-the-icons-nerd-fonts almost-mono-themes raku-mode kaolin-themes posframe treesit-auto spinner lsp-mode rainbow-delimiters paredit company flycheck racket-mode smex magit geiser-racket geiser-mit)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
