;; Completion that uses many different methods to find options.
(global-set-key (kbd "C-.") 'hippie-expand)

;; Expand region (increases selected region by semantic units)
(global-set-key (kbd "C-'") 'er/expand-region)

;; Repeat last command - too cumbersome with C-x z
(global-set-key (kbd "M-z") 'repeat)

;; Perform general cleanup.
(global-set-key (kbd "C-c n") 'cleanup-buffer)

;; Turn on the menu bar for exploring new modes
(global-set-key (kbd "C-<f10>") 'menu-bar-mode)

;; Killing text
(global-set-key (kbd "C-w") 'kill-region-or-backward-word)
(global-set-key (kbd "C-S-k") 'kill-and-retry-line)

;; Delete region (don't put it in the kill-ring)
(global-set-key (kbd "C-c C-w") 'delete-region)

;; Camel casing
(global-set-key (kbd "C-c C-c") 'replace-next-underscore-with-camel)

;; Use M-w for copy-line if no active region
(global-set-key (kbd "M-w") 'save-region-or-current-line)
(global-set-key (kbd "M-W") '(lambda () (interactive) (save-region-or-current-line 1)))

;; Make zap-to-char more convenient, and suspend-frame less
(global-set-key (kbd "C-z") 'zap-to-char)
(global-set-key (kbd "C-x C-z") 'suspend-frame)

;; M-m: Move to char - similar to "f" in vim
(global-set-key (kbd "M-m") 'iy-go-to-char)
(global-set-key (kbd "M-M") 'iy-go-to-char-backward)

;; Remap old M-m to M-i (better mnemonic for back-to-indentation)
;; We lose tab-to-tab-stop, which is no big loss in my use cases.
(global-set-key (kbd "M-i") 'back-to-indentation)

;; Font size
(define-key global-map (kbd "C-+") 'text-scale-increase)
(define-key global-map (kbd "C--") 'text-scale-decrease)

;; Jump to a definition in the current file. (This is awesome.)
(global-set-key (kbd "C-x C-i") 'ido-imenu)

;; File finding
(global-set-key (kbd "C-x M-f") 'ido-find-file-other-window)
(global-set-key (kbd "C-x C-M-f") 'find-file-in-project)
(global-set-key (kbd "C-x f") 'recentf-ido-find-file)
(global-set-key (kbd "C-x C-p") 'find-file-at-point)
(global-set-key (kbd "C-c y") 'bury-buffer)
(global-set-key (kbd "C-c r") 'revert-buffer)
(global-set-key (kbd "M-`") 'file-cache-minibuffer-complete)
(global-set-key (kbd "C-x C-b") 'ibuffer)

;; Edit file with sudo
(global-set-key (kbd "M-s e") 'sudo-edit)

;; Window switching. (C-x o goes to the next window)
(windmove-default-keybindings) ;; Shift+direction
(global-set-key (kbd "C-x O") (lambda () (interactive) (other-window -1))) ;; back one
(global-set-key (kbd "C-x C-o") (lambda () (interactive) (other-window 2))) ;; forward two
(global-set-key (kbd "C-x -") 'swap-windows)

;; Indentation help
(global-set-key (kbd "M-j") (lambda () (interactive) (join-line -1)))

;; Fetch the contents at a URL, display it raw.
(global-set-key (kbd "C-x h") 'view-url)

;; Help should search more than just commands
(global-set-key (kbd "<f1> a") 'apropos)

;; Should be able to eval-and-replace anywhere.
(global-set-key (kbd "C-c e") 'eval-and-replace)

;; Navigation bindings
(global-set-key (kbd "C-x g") 'goto-line)
(global-set-key (kbd "<home>") 'beginning-of-buffer)
(global-set-key (kbd "<end>") 'end-of-buffer)

;; Convenience on ThinkPad Keyboard: Use back/forward as pg up/down
(global-set-key (kbd "<XF86Back>") 'scroll-down)
(global-set-key (kbd "<XF86Forward>") 'scroll-up)
(global-set-key (kbd "<XF86WakeUp>") 'beginning-of-buffer)

;; Query replace regex key binding
(global-set-key (kbd "M-&") 'query-replace-regexp)

;; Comment out block
(global-set-key (kbd "C-c c") 'comment-or-uncomment-region)

;; Uncomment block
(global-set-key (kbd "C-c u") 'uncomment-region)

;; Indent region
(global-set-key (kbd "C-c M-i") 'indent-region)

;; Eval buffer
(global-set-key (kbd "C-c v") 'eval-buffer)

;; Move windows, even in org-mode
(global-set-key (kbd "<s-right>") 'windmove-right)
(global-set-key (kbd "<s-left>") 'windmove-left)
(global-set-key (kbd "<s-up>") 'windmove-up)
(global-set-key (kbd "<s-down>") 'windmove-down)

;; Mark all
(global-set-key (kbd "C-c a") 'mark-whole-buffer)

;; Eval lines
(global-set-key (kbd "C-c C-e") 'eval-current-line)
(global-set-key (kbd "C-c M-e") 'eval-output-marked-lines)

;; Git
(autoload 'magit-status "magit")
(global-set-key (kbd "C-x m") 'magit-status-fullscreen)
(define-key magit-status-mode-map (kbd "q") 'magit-quit-session)

;; Clever newlines
(global-set-key (kbd "<C-return>") 'new-line-below)
(global-set-key (kbd "<C-S-return>") 'new-line-above)
(global-set-key (kbd "<M-return>") 'new-line-in-between)

;; Duplicate region
(global-set-key (kbd "C-c d") 'duplicate-current-line-or-region)

;; Line movement
(global-set-key (kbd "<C-S-down>") 'move-line-down)
(global-set-key (kbd "C-S-n") 'move-line-down)
(global-set-key (kbd "<C-S-up>") 'move-line-up)
(global-set-key (kbd "C-S-p") 'move-line-up)
(global-set-key (kbd "M-p") 'backward-paragraph)
(global-set-key (kbd "M-n") 'forward-paragraph)

;; Fancy yank
(global-set-key (kbd "C-S-y") 'yank-indented)

;; Toggle quotes
(global-set-key (kbd "C-\"") 'toggle-quotes)

;; Sorting
(global-set-key (kbd "M-s l") 'sort-lines)

;; Paste URLs as HTML links
(global-set-key (kbd "C-c C-l") 'linkify-from-kill-ring)

;; Escape markup formatted as a string
(global-set-key (kbd "C-c h") 'html-from-console-string)

;; Toggle position
(global-set-key (kbd "C-c C-s") 'toggle-buffer-pos)

;; Buffer file functions
(global-set-key (kbd "C-x t") 'touch-buffer-file)
(global-set-key (kbd "C-x C-r") 'rename-current-buffer-file)
(global-set-key (kbd "C-x C-k") 'delete-current-buffer-file)

;; Easy-mode rgrep
(global-set-key (kbd "M-s s") 'rgrep)

;; Expand and contract JavaScript object
(global-set-key (kbd "C-S-e") 'js-expand-object)
(global-set-key (kbd "C-S-c") 'js-contract-object)

;; Extract JavaScript variables
(global-set-key (kbd "C-c x") 'js-extract-variable)

;; Mark multiple stuff
(global-set-key (kbd "C-x r t") 'inline-string-rectangle)
(global-set-key (kbd "C-<") 'mark-previous-like-this)
(global-set-key (kbd "C->") 'mark-next-like-this)
(global-set-key (kbd "C-M-m") 'mark-more-like-this)

;; Quickly jump in document with ace-jump-mode
(define-key global-map (kbd "C-ø") 'ace-jump-mode)

;; Count words
(define-key global-map (kbd "C-c w") 'wc-region)

(provide 'key-bindings)
