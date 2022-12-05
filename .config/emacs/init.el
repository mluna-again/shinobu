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
(install 'evil)
(install 'which-key)
(install 'dashboard)
(install 'helm)
(install 'doom-modeline)
(install 'treemacs)
(install 'treemacs-evil)
(install 'cider)
(install 'clojure-mode)
(install 'lsp-mode)
(install 'lsp-treemacs)
(install 'flycheck)
(install 'company)

;; Clojure
(add-hook 'clojure-mode-hook 'lsp)
(add-hook 'clojurescript-mode-hook 'lsp)
(add-hook 'clojurec-mode-hook 'lsp)
(setq gc-cons-threshold (* 100 1024 1024)
      read-process-output-max (* 1024 1024)
      treemacs-space-between-root-nodes nil
      company-minimum-prefix-length 1
      lsp-clojure-custom-server-command '("bash" "-c" "~/.local/bin/clojure_lsp/clojure-lsp")
      lsp-enable-indentation t
      lsp-enable-completion-at-point t)

;; Doomline
(require 'doom-modeline)
(doom-modeline-mode 1)

;; Helm
(require 'helm-config)
(helm-mode 1)

;; Theme and dashboard styles
(load (config-file-path "styles"))

;; Mappings
;; this has to be after styles
(load (config-file-path "mappings"))

;; Other config
(electric-pair-mode 1)

(setq debug-on-error nil)
