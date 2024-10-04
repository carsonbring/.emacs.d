;;; package --- Generic Preference
;;; Commentary: This is just for uncategorizable preferences for my based and redpilled emacs config
(provide 'preferences)

;Move backup files to seperate directory
(setq user-cache-directory (concat EMACS_DIR "cache"))
(setq backup-directory-alist `(("." . ,(expand-file-name "backups" user-cache-directory)))
      url-history-file (expand-file-name "url/history" user-cache-directory)
      auto-save-list-file-prefix (expand-file-name "auto-save-list/.saves-" user-cache-directory)
      projectile-known-projects-file (expand-file-name "projectile-bookmarks.eld" user-cache-directory))

;; Line numbers
(global-display-line-numbers-mode)

;; Highlight matching parenthesis
(show-paren-mode 1)
(setq show-paren-delay 0)

;; Disable scrollbar and toolbar
(scroll-bar-mode -1)
(tool-bar-mode -1)

;; Automatically add ending brackets and braces
(electric-pair-mode 1)

;; Make sure tab-width is 4 and not 8
(setq-default tab-width 4)

;; Allows moving through wrapped lines as they appear
(setq line-move-visual t)

;Setting font
(set-face-attribute 'default nil :font "0xProto Nerd Font Mono-17" )

;Killing toolbar
(tool-bar-mode -1)

;; custom startup screen into sicp due to me doing my practice
(setq inhibit-startup-screen t)
(setq initial-buffer-choice "~/projects")
