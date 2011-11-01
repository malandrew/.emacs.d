(require 'imenu)

;; Network

(defun view-url ()
  "Open a new buffer containing the contents of URL."
  (interactive)
  (let* ((default (thing-at-point-url-at-point))
         (url (read-from-minibuffer "URL: " default)))
    (switch-to-buffer (url-retrieve-synchronously url))
    (rename-buffer url t)
    ;; TODO: switch to nxml/nxhtml mode
    (cond ((search-forward "<?xml" nil t) (xml-mode))
          ((search-forward "<html" nil t) (html-mode)))))

;; Buffer-related

(defun ido-imenu ()
  "Update the imenu index and then use ido to select a symbol to navigate to.
Symbols matching the text at point are put first in the completion list."
  (interactive)
  (imenu--make-index-alist)
  (let ((name-and-pos '())
        (symbol-names '()))
    (flet ((addsymbols (symbol-list)
                       (when (listp symbol-list)
                         (dolist (symbol symbol-list)
                           (let ((name nil) (position nil))
                             (cond
                              ((and (listp symbol) (imenu--subalist-p symbol))
                               (addsymbols symbol))

                              ((listp symbol)
                               (setq name (car symbol))
                               (setq position (cdr symbol)))

                              ((stringp symbol)
                               (setq name symbol)
                               (setq position (get-text-property 1 'org-imenu-marker symbol))))

                             (unless (or (null position) (null name))
                               (add-to-list 'symbol-names name)
                               (add-to-list 'name-and-pos (cons name position))))))))
      (addsymbols imenu--index-alist))
    ;; If there are matching symbols at point, put them at the beginning of `symbol-names'.
    (let ((symbol-at-point (thing-at-point 'symbol)))
      (when symbol-at-point
        (let* ((regexp (concat (regexp-quote symbol-at-point) "$"))
               (matching-symbols (delq nil (mapcar (lambda (symbol)
                                                     (if (string-match regexp symbol) symbol))
                                                   symbol-names))))
          (when matching-symbols
            (sort matching-symbols (lambda (a b) (> (length a) (length b))))
            (mapc (lambda (symbol) (setq symbol-names (cons symbol (delete symbol symbol-names))))
                  matching-symbols)))))
    (let* ((selected-symbol (ido-completing-read "Symbol? " symbol-names))
           (position (cdr (assoc selected-symbol name-and-pos))))
      (goto-char position))))

;;; These belong in coding-hook:

;; We have a number of turn-on-* functions since it's advised that lambda
;; functions not go in hooks. Repeatedly evaling an add-to-list with a
;; hook value will repeatedly add it since there's no way to ensure
;; that a lambda doesn't already exist in the list.

(defun local-column-number-mode ()
  (make-local-variable 'column-number-mode)
  (column-number-mode t))

(defun local-comment-auto-fill ()
  (set (make-local-variable 'comment-auto-fill-only-comments) t)
  (auto-fill-mode t))

(defun turn-on-hl-line-mode ()
  (if window-system (hl-line-mode t)))

(defun turn-on-save-place-mode ()
  (setq save-place t))

(defun turn-on-whitespace ()
  (whitespace-mode t))

(defun turn-off-tool-bar ()
  (tool-bar-mode -1))

(add-hook 'coding-hook 'local-column-number-mode)
(add-hook 'coding-hook 'local-comment-auto-fill)
(add-hook 'coding-hook 'turn-on-hl-line-mode)

(defun untabify-buffer ()
  (interactive)
  (untabify (point-min) (point-max)))

(defun indent-buffer ()
  (interactive)
  (indent-region (point-min) (point-max)))

(defun cleanup-buffer ()
  "Perform a bunch of operations on the whitespace content of a buffer."
  (interactive)
  (indent-buffer)
  (untabify-buffer)
  (delete-trailing-whitespace))

(defun recentf-ido-find-file ()
  "Find a recent file using ido."
  (interactive)
  (let ((file (ido-completing-read "Choose recent file: " recentf-list nil t)))
    (when file
      (find-file file))))

;; Other

(defun eval-and-replace ()
  "Replace the preceding sexp with its value."
  (interactive)
  (backward-kill-sexp)
  (condition-case nil
      (prin1 (eval (read (current-kill 0)))
             (current-buffer))
    (error (message "Invalid expression")
           (insert (current-kill 0)))))

(defun recompile-init ()
  "Byte-compile all your dotfiles again."
  (interactive)
  (byte-recompile-directory dotfiles-dir 0)
  ;; TODO: remove elpa-to-submit once everything's submitted.
  (byte-recompile-directory (concat dotfiles-dir "elpa-to-submit/" 0)))

(defun sudo-edit (&optional arg)
  (interactive "p")
  (if (or arg (not buffer-file-name))
      (find-file (concat "/sudo:root@localhost:" (ido-read-file-name "File: ")))
    (find-alternate-file (concat "/sudo:root@localhost:" buffer-file-name))))

(defun esk-paredit-nonlisp ()
  "Turn on paredit mode for non-lisps."
  (set (make-local-variable 'paredit-space-for-delimiter-predicate)
       (lambda (endp delimiter)
         (equal (char-syntax (char-before)) ?\")))
  (paredit-mode 1))

(defun new-line-below ()
  (interactive)
  (if (eolp)
      (newline)
    (end-of-line)
    (newline)
    (indent-for-tab-command)))

(defun new-line-in-between ()
  (interactive)
  (newline)
  (save-excursion
    (newline)
    (indent-for-tab-command))
  (indent-for-tab-command))

(defun duplicate-line ()
  (interactive)
  (save-excursion
    (beginning-of-line)
    (let ((line (buffer-substring
                 (point)
                 (progn (end-of-line) (point)))))
      (end-of-line)
      (insert (concat "\n" line))))
  (next-line))

(defun add-find-file-hook-with-pattern (pattern fn &optional contents)
  "Add a find-file-hook that calls FN for files where PATTERN
matches the file name, and optionally, where CONTENT matches file contents.
Both PATTERN and CONTENTS are matched as regular expressions."
  (lexical-let ((re-pattern pattern)
                (fun fn)
                (re-content contents))
    (add-hook 'find-file-hook
              (lambda ()
                (if (and
                     (string-match re-pattern (buffer-file-name))
                     (or (null re-content)
                         (string-match re-content
                                       (buffer-substring (point-min) (point-max)))))
                    (apply fun ()))))))

(defun move-line-down ()
  (interactive)
  (let ((col (current-column)))
    (save-excursion
      (next-line)
      (transpose-lines 1))
    (next-line)
    (move-to-column col)))

(defun move-line-up ()
  (interactive)
  (let ((col (current-column)))
    (save-excursion
      (next-line)
      (transpose-lines -1))
    (move-to-column col)))

(defvar mark-whole-word-thing nil)
(defvar mark-whole-word-original-pos nil)

(defun mark-whole-word-command ()
  (interactive)
  (if (or (eq last-command 'mark-whole-word-command)
          (eq last-command 'mark-whole-word))
      nil
    (setq mark-whole-word-command nil)
    (setq mark-whole-word-original-pos nil))
  (if mark-whole-word-original-pos (goto-char mark-whole-word-original-pos))
  (cond
   ((eq mark-whole-word-thing :word) (mark-whole-sentence))
   ((eq mark-whole-word-thing :sentence) (mark-whole-paragraph))
   (t (mark-whole-word))))

(defun mark-whole-word ()
  (interactive)
  (setq mark-whole-word-original-pos (point))
  (backward-word)
  (set-mark (point))
  (forward-word)
  (setq mark-whole-word-thing :word))

(defun mark-whole-sentence ()
  (backward-sentence)
  (set-mark (point))
  (forward-sentence)
  (setq mark-whole-word-thing :sentence))

(defun mark-whole-paragraph ()
  (backward-paragraph)
  (set-mark (point))
  (forward-paragraph)
  (setq mark-whole-word-thing :paragraph))

(defun yank-as-line ()
  (interactive)
  (save-excursion
    (insert "\n")
    (indent-for-tab-command))
  (yank))

;; toggle quotes

(defun point-is-in-string-p ()
  (nth 3 (syntax-ppss)))

(defun move-point-forward-out-of-string ()
  (while (point-is-in-string-p) (forward-char)))

(defun move-point-backward-out-of-string ()
  (while (point-is-in-string-p) (backward-char)))

(defun alternate-quotes-char ()
  (if (= 34 (nth 3 (syntax-ppss)))
      "'"
    "\""))

(defun toggle-quotes ()
  (interactive)
  (when (point-is-in-string-p)
    (let ((new-quotes (alternate-quotes-char)))
      (save-excursion
        (move-point-forward-out-of-string)
        (backward-delete-char 1)
        (insert new-quotes)
        (move-point-backward-out-of-string)
        (delete-char 1)
        (insert new-quotes)))))

;; Select text in quotes
(defun select-text-in-quotes ()
 (interactive)
 (let (b1 b2)
   (move-point-backward-out-of-string)
   (forward-char)
   (setq b1 (point))
   (move-point-forward-out-of-string)
   (backward-char)
   (setq b2 (point))
   (set-mark b1)))

(defun linkify-region-from-kill-ring (start end)
  (interactive "r")
  (let ((text (buffer-substring start end)))
    (delete-region start end)
    (insert "<a href=\"")
    (yank)
    (insert (concat "\">" text "</a>"))))

(defun html-from-console-string (start end)
  "Turn a string output from e.g. a test runner into unescaped markup."
  (interactive "r")
  (query-replace-all "\\\"" "\"" start end)
  (query-replace-all "\\n" "\n" start end))

(defun query-replace-all (from-string to-string start end)
  (save-excursion
    (goto-char start)
    (while (search-forward from-string end t)
      (replace-match to-string))))

;; kill region if active, otherwise kill backward word

(defun kill-region-or-backward-word ()
  (interactive)
  (if (region-active-p)
      (kill-region (region-beginning) (region-end))
    (backward-kill-word 1)))

;; copy region if active
;; otherwise copy to end of current line
;;   * with prefix, copy N whole lines

(defun copy-to-end-of-line ()
  (interactive)
  (kill-ring-save (point)
                  (line-end-position))
  (message "Copied to end of line"))

(defun copy-whole-lines (arg)
  "Copy lines (as many as prefix argument) in the kill ring"
  (interactive "p")
  (kill-ring-save (line-beginning-position)
                  (line-beginning-position (+ 1 arg)))
  (message "%d line%s copied" arg (if (= 1 arg) "" "s")))

(defun copy-line (arg)
  "Copy to end of line, or as many lines as prefix argument"
  (interactive "P")
  (if (null arg)
      (copy-to-end-of-line)
    (copy-whole-lines (prefix-numeric-value arg))))

(defun save-region-or-current-line (arg)
  (interactive "P")
  (if (region-active-p)
      (kill-ring-save (region-beginning) (region-end))
    (copy-line arg)))

(defun touch-buffer-file ()
  (interactive)
  (insert " ")
  (backward-delete-char 1)
  (save-buffer))

(provide 'defuns)
