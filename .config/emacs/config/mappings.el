(require 'evil)
(evil-mode 1)

(setq key-chord-two-keys-delay 0.5)

;; Evil
(key-chord-define evil-insert-state-map "jj" 'evil-normal-state)
(key-chord-mode 1)
(define-key evil-normal-state-map (kbd "s") nil)
(define-key evil-normal-state-map (kbd "ss") 'save-buffer)

;; Helm
(global-set-key (kbd "C-x C-f") 'helm-find)
(define-key evil-normal-state-map (kbd "SPC ff") 'helm-find)
(define-key helm-map (kbd "TAB") #'helm-execute-persistent-action)
(define-key helm-map (kbd "<tab>") #'helm-execute-persistent-action)
(define-key helm-map (kbd "C-z") #'helm-select-action)

;; Dashboard
(defun toggle-dashboard-mappings ()
	(if (not (eq major-mode 'dashboard-mode))
		(progn
			(message "removing")
			(define-key evil-normal-state-map (kbd "SPC cn") nil)
			(define-key evil-normal-state-map (kbd "SPC ff") nil)
			(define-key evil-normal-state-map (kbd "SPC fo") nil)
			(define-key evil-normal-state-map (kbd "SPC fw") nil)
			(define-key evil-normal-state-map (kbd "SPC sl") nil)
			(define-key evil-normal-state-map (kbd "q") nil))

		(progn 
			(message "adding")
			(define-key evil-normal-state-map (kbd "SPC cn") 'helm-find)
			(define-key evil-normal-state-map (kbd "SPC ff") 'helm-find)
			(define-key evil-normal-state-map (kbd "SPC fo") 'helm-find)
			(define-key evil-normal-state-map (kbd "SPC fw") 'helm-find)
			(define-key evil-normal-state-map (kbd "SPC sl") 'helm-find)
			(define-key evil-normal-state-map (kbd "q") 'kill-emacs))))

(add-hook 'change-major-mode-hook 'toggle-dashboard-mappings)
