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
(define-key dashboard-mode-map (kbd "SPC cn") 'helm-find)
(define-key dashboard-mode-map (kbd "SPC ff") 'helm-find)
(define-key dashboard-mode-map (kbd "SPC fo") 'helm-find)
(define-key dashboard-mode-map (kbd "SPC fw") 'helm-find)
(define-key dashboard-mode-map (kbd "SPC sl") 'helm-find)
(define-key dashboard-mode-map (kbd "q") 'helm-find)
