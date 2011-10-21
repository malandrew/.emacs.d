;; mode colors in rhtml mode
;;(custom-set-faces '(erb-face ((t (:background nil)))))

(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "Black" :foreground "White" :inverse-video nil :box nil :strike-t*hrough nil :overline nil :underline nil :slant normal :weight normal :width normal :height 105))))
 '(fill-column 80)
 '(highlight ((((class color) (min-colors 88) (background dark)) (:background "#111111"))))
 '(mumamo-background-chunk-submode ((((class color) (min-colors 88) (background dark)) nil))))

(set-face-background 'region "#464740")

;; Highlight current line
(global-hl-line-mode 1)

;; Customize background color of lighlighted line
(set-face-background 'hl-line "#222222")

(if (eq window-system nil)
    ((set-face-foreground 'hl-line "#ffcccc")
     (set-face-background 'hl-line "#000000")))

;; org-mode colors
(setq org-todo-keyword-faces
      '(
        ("INPR" . (:foreground "yellow" :weight bold))
        ("DONE" . (:foreground "green" :weight bold))
        ("IMPEDED" . (:foreground "red" :weight bold))
        ))

;; Highlight matching parentheses when the point is on them.
(show-paren-mode 1)

;; No menu bars
(menu-bar-mode -1)

(when window-system
  (setq frame-title-format '(buffer-file-name "%f" ("%b")))
  (turn-off-tool-bar)
  (tooltip-mode -1)
  (turn-off-tool-bar)
  (blink-cursor-mode -1))

(add-hook 'before-make-frame-hook 'turn-off-tool-bar)

;; Scrollbars to the right
;;(setq scroll-bar-mode-explicit t)
;;(set-scroll-bar-mode `right)

;; Ditch them scrollbars
(scroll-bar-mode -1)

(provide 'appearance)
