;; Emacs Email file
;;configuration heavily based on https://f-santos.gitlab.io/2020-04-24-mu4e.html (Thanks!)
(provide 'mu4e-config)
(add-to-list 'load-path "/usr/local/share/emacs/site-lisp/mu4e")
(require 'mu4e)
(require 'smtpmail)



(defun get-gpg-password (file)
  "Decrypt and return the password stored in FILE."
  (with-temp-buffer
    (call-process "gpg" nil t nil "-q" "--for-your-eyes-only" "--no-tty" "-d" file)
    (buffer-string)))
(setq my-smtp-password (get-gpg-password "~/.emacs.d/.mbsyncpass.gpg"))

(setq user-mail-address "carsonbring@gmail.com")
(setq user-full-name "Carson Bring")
(setq message-send-mail-function 'smtpmail-send-it
      starttls-use-gnutls t
      smtpmail-starttls-credentials
      '(("smtp.gmail.com" 587 nil nil))
      smtpmail-default-smtp-server "smtp.gmail.com"
      smtpmail-smtp-server "smtp.gmail.com"
      smtpmail-smtp-service 587
      smtpmail-debug-info t)
(setq smtpmail-auth-credentials (expand-file-name "~/.authinfo.gpg"))
 (setq auth-source-debug t)

(setq mu4e-user-mail-address-list '("carsonbring@gmail.com"))

(setq smtpmail-smtp-user "carsonbring@gmail.com")



;; Mail folders:
(setq mu4e-drafts-folder "/\[Gmail\]/Drafts")
(setq mu4e-sent-folder   "/\[Gmail\]/Sent Mail")
(setq mu4e-trash-folder  "/\[Gmail\]/Trash")

(setq mu4e-get-mail-command "mbsync --config ~/.emacs.d/.mbsyncrc personalaccount")


(setq mu4e-html2text-command "w3m -T text/html" ; how to hanfle html-formatted emails
      mu4e-update-interval 300                  ; seconds between each mail retrieval
      mu4e-headers-auto-update t                ; avoid to type `g' to update
      mu4e-view-show-images t                   ; show images in the view buffer
      mu4e-compose-signature-auto-include nil   ; I don't want a message signature
      mu4e-use-fancy-chars nil)                   ; allow fancy icons for mail threads


(setq mu4e-compose-reply-ignore-address '("no-?reply" "carsonbring@gmail.com"))



;; Do not use auto-fill-mode for emails:
(defun auto-fill-mode-off ()
  (auto-fill-mode 0))
(add-hook 'mu4e-compose-mode-hook 'auto-fill-mode-off)

