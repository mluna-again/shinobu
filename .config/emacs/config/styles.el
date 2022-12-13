;; Styles
(add-to-list 'custom-theme-load-path "~/.config/emacs/themes")
(tool-bar-mode -1)
(scroll-bar-mode -1)
(fringe-mode -1)
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
 
(load-theme 'kanagawa)
(set-frame-font "Inconsolata Nerd Font 16" nil t)
; (set-frame-parameter (selected-frame) 'alpha '(85 . 50))
; (add-to-list 'default-frame-alist '(alpha . (85 . 50)))

;; Dashboard
(require 'dashboard)
(setq dashboard-startup-banner "~/.config/emacs/config/logo.gif")
(setq dashboard-image-banner-max-width 200)
(setq dashboard-set-footer nil)
(setq dashboard-show-shortcuts nil)
(setq dashboard-items '())
(setq dashboard-banner-logo-title nil)
(setq dashboard-set-init-info nil)

(defun padding (text)
  (make-string (/ (- (frame-width) (length text)) 2) ?\s))

(defun centered (text)
  (concat (padding text) text (padding text) "\n"))

(defun recenter-dashboard ()
  (if (string= "*dashboard*" (buffer-name))
      (dashboard-refresh-buffer)))

(defun clear-messages-buffer ()
  (setq mode-line-format nil)
  (message ""))

(defun dashboard-insert-custom (list-size)
  (insert (centered "  New file               SPC c n\n"))
  (insert (centered "  Find file              SPC f f\n"))
  (insert (centered "  Recent files           SPC f o\n"))
  (insert (centered "  Find word              SPC f w\n"))
  (insert (centered "  Load last session      SPC s l\n"))
  (insert (centered "  Quit Emacs                   q\n")))

(add-to-list 'dashboard-item-generators  '(commands . dashboard-insert-custom))
(add-to-list 'dashboard-items '(commands) t)

(add-hook 'window-configuration-change-hook 'recenter-dashboard)
(add-hook 'dashboard-mode-hook 'clear-messages-buffer)
(dashboard-setup-startup-hook)


;; Org Mode
(add-hook 'org-mode-hook #'org-modern-mode)
(add-hook 'org-agenda-finalize-hook #'org-modern-agenda)

(setq
 ;; Edit settings
 org-auto-align-tags nil
 org-tags-column 0
 org-catch-invisible-edits 'show-and-error
 org-special-ctrl-a/e t
 org-insert-heading-respect-content t

 ;; Org styling, hide markup etc.
 org-hide-emphasis-markers t
 org-pretty-entities t
 org-ellipsis "…"

 ;; Agenda styling
 org-agenda-tags-column 0
 org-agenda-block-separator ?─
 org-agenda-time-grid
 '((daily today require-timed)
   (800 1000 1200 1400 1600 1800 2000)
   " ┄┄┄┄┄ " "┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄")
 org-agenda-current-time-string
 "⭠ now ─────────────────────────────────────────────────")

;; Lsp Mode
(setq lsp-headerline-breadcrumb-enable-diagnostics nil)
