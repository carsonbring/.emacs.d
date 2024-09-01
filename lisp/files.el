(provide 'files)

;; Projectile - EZ navigation within project. ADD .projectile FILE AND USE C-c p
(use-package projectile 
:ensure t
:init (projectile-mode +1)
:config 
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
)

;; ido-mode provides a better file/buffer-selection interface
(use-package ido
             :ensure t
             :config (ido-mode t))


