(defun config-file-path
  (filename)
  (concat "~/.config/emacs/config/" filename ".el"))

(setq custom-file (config-file-path "custom"))
(load custom-file)

(setq backup-directory-alist '(("." . "~/.local/share/emacs/backups"))
  backup-by-copying t    ; Don't delink hardlinks
  version-control t      ; Use version numbers on backups
  delete-old-versions t  ; Automatically delete excess backups
  kept-new-versions 20   ; how many of the newest versions to keep
  kept-old-versions 5    ; and how many of the old
  )

(require 'package)
(setq package-enable-at-startup nil)

(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/"))

(package-initialize)

(defun install (name)
  (unless (package-installed-p name)
    (package-refresh-contents)
    (package-install name)))

(install 'key-chord)
(install 'autothemer)
(install 'gruvbox-theme)
(install 'evil)
(install 'which-key)
(install 'dashboard)
(install 'helm)
(install 'cider)
(install 'clojure-mode)
(install 'lsp-mode)
(install 'lsp-treemacs)
(install 'flycheck)
(install 'company)
(add-hook 'clojure-mode-hook 'lsp)
(add-hook 'clojurescript-mode-hook 'lsp)
(add-hook 'clojurec-mode-hook 'lsp)
;; Helm
(require 'helm-config)
(helm-mode 1)

;; Mappings
(load (config-file-path "mappings"))

;; Theme and dashboard styles
(load (config-file-path "styles"))
