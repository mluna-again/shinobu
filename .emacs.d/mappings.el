(setq key-chord-two-keys-delay 0.5)
(key-chord-define evil-insert-state-map "jj" 'evil-normal-state)
(key-chord-mode 1)

(define-key evil-normal-state-map (kbd "s") nil)
(define-key evil-normal-state-map (kbd "ss") 'save-buffer)
