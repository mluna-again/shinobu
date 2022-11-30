;; Styles
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
 
(load-theme 'gruvbox-dark-medium)
(set-frame-font "Inconsolata Nerd Font 16" nil t)
; (set-frame-parameter (selected-frame) 'alpha '(85 . 50))
; (add-to-list 'default-frame-alist '(alpha . (85 . 50)))

;; Dashboard
(setq dashboard-startup-banner "~/.config/emacs/config/logo.png")
(setq dashboard-image-banner-max-width 200)
(require 'dashboard)
(dashboard-setup-startup-hook)
