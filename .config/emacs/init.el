(defun config-file-path
  (filename)
  (concat "~/.config/emacs/config/" filename ".el"))

(setq custom-file (config-file-path "custom"))
(load custom-file)

(setq make-backup-files nil)

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

;; Theme and dashboard styles
(load (config-file-path "styles"))

;; Mappings
;; this has to be after styles
(load (config-file-path "mappings"))
