(setq inhibit-startup-message t)
(setq visible-bell t)
(setq ring-bell-function 'ignore)
(setq mac-option-key-is-meta nil)
(setq mac-command-key-is-meta t)
(setq mac-command-modifier 'meta)
(setq mac-option-modifier nil)

(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

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
(install 'cider)
(install 'clojure-mode)

;; Evil mode
(require 'evil)
(evil-mode 1)

(load-theme 'gruvbox-dark-medium)
(load "~/.emacs.d/mappings.el")
