;; set up use-package. Allows for configuration and loading of installed packages
(require 'package)
(add-to-list 'package-archives '("gnu"   . "https://elpa.gnu.org/packages/"))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-and-compile
  (setq use-package-always-ensure t
        use-package-expand-minimally t))
;;some styling for code
(setq c-default-style "bsd"
      c-basic-offset 8
      tab-width 8
      indent-tabs-mode t)
(require 'whitespace)
(setq whitespace-style '(face empty lines-tail trailing))
(global-whitespace-mode t)
(defun my-line-numbers-hook ()
  (display-line-numbers-mode 1))
(add-hook 'prog-mode-hook 'my-line-numbers-hook)
(add-hook 'text-mode-hook 'my-line-numbers-hook)
(define-key global-map (kbd "RET") 'newline-and-indent)
;;2 spaces for js files
(add-hook 'js-mode-hook
	  (lambda () (setq-local indent-tabs-mode nil)
	    (setq-local tab-width 2)))
;; Set 2 spaces for indentation in TypeScript files
(add-hook 'typescript-mode-hook
          (lambda () (setq-local typescript-indent-level 2))
	  )

(load-theme 'wombat)
;;Initialize org mode package sources
;;(require 'package)
;;(setq package-archives '(("melpa" , "https://melpa.org/packages/")
;;			 ("org" , "https://orgmode.org/elpa/")
;;			 ("elpa" , "https://elpa.gnu.org/packages/")))
;;(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))
(use-package org)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(js-indent-level 2)
 '(package-selected-packages
   (quote
    (eslintd-fix typescript-mode tide flycheck use-package markdown-mode))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Disable line-numbers for org mode
(dolist (mode '(org-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))
;;Browse URL in Emacs under WSL. I visisted https://hungyi.net/posts/browse-emacs-urls-wsl/ foe this help
(when (and (eq system-type 'gnu/linux)
           (string-match
            "Linux.*Microsoft.*Linux"
            (shell-command-to-string "uname -a")))
  (setq
   browse-url-generic-program  "/mnt/c/Windows/System32/cmd.exe"
   browse-url-generic-args     '("/c" "start")
   browse-url-browser-function #'browse-url-generic))

;; Add language support
(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t)
   (C . t)))

(require 'htmlize)

(require 'ox-md)

;; use flycheck

(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))
(flycheck-add-mode 'javascript-eslint 'web-mode)
(flycheck-add-mode 'javascript-eslint 'typescript-mode)

(flycheck-define-checker python-pycodestyle
  "A Python syntax and style checker using pycodestyle (former pep8)."

  :command ("pycodestyle" source-inplace)
  :error-patterns
  ((error line-start (file-name) ":" line ":" column ":" (message) line-end))
  :modes python-mode)

(add-to-list 'flycheck-checkers 'python-pycodestyle)

(provide 'flycheck-pycodestyle)
