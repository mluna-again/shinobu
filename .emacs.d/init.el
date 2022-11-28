(tool-bar-mode -1)
(scroll-bar-mode -1)
(setq inhibit-startup-message nil)
(setq visible-bell t)
(setq ring-bell-function 'ignore)
(setq mac-option-key-is-meta nil
      mac-command-key-is-meta t
      mac-command-modifier 'meta
      mac-option-modifier 'none)
(setq frame-title-format "Emacs")
(global-display-line-numbers-mode)
(setq display-line-numbers-type 'relative)
(add-hook 'window-setup-hook 'toggle-frame-maximized t)
 
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

;; Mappings
(load "~/.emacs.d/mappings.el")

;; Theme
(load-theme 'gruvbox-dark-medium)
(set-frame-font "Inconsolata Nerd Font 16" nil t)
(set-frame-parameter (selected-frame) 'alpha '(85 . 50))
(add-to-list 'default-frame-alist '(alpha . (85 . 50)))
