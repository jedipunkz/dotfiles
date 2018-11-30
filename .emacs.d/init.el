;;
;; init.el
;;

;; Language.
(set-language-environment 'Japanese)

;; Coding system.
(set-default-coding-systems 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8)
(prefer-coding-system 'utf-8)
;; display line number
;(global-linum-mode t)
(setq linum-format "%d ")

;; display current line
(global-hl-line-mode 1)
;;(set-face-attribute hl-line-face nil :underline t)
(setq hl-line-face 'underline)

;; tab
(setq-default tab-width 4)
(setq-default indent-tabs-mode nil)

;;parenthesis
(show-paren-mode t)

;; el-get
(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.githubusercontent.com/dimitri/el-get/master/el-get-install.el")
    (goto-char (point-max))
    (eval-print-last-sexp)))

(add-to-list 'el-get-recipe-path "~/.emacs.d/el-get-user/recipes")

(el-get-bundle helm)
; (el-get-bundle scala-mode2)
(el-get-bundle ensime)
(el-get-bundle helm-ls-git)
(el-get-bundle helm-ag)
(el-get-bundle web-mode)
(el-get-bundle go-mode)
(el-get-bundle auto-complete)
;(el-get-bundle company)
(el-get-bundle markdown-mode)
(el-get-bundle wgrep)
(el-get-bundle elpa:flycheck)
(el-get-bundle atom-dark-theme)
;(el-get-bundle elpa:color-theme-solarized)
(el-get-bundle color-theme-solarized)
(el-get-bundle elpa:color-theme)
(el-get-bundle ace-jump-mode)
(el-get-bundle neotree)
(el-get-bundle magit)
(el-get-bundle yasnippet)
(el-get-bundle ruby-mode)
(el-get-bundle ruby-block)
(el-get-bundle yaml-mode)
(el-get-bundle coffee-mode)

;;theme
(load-theme 'solarized t)
; (load-theme 'solarized-dark t)

;; for neotree
(require 'neotree)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" default)))
 '(frame-background-mode (quote dark))
 '(helm-delete-minibuffer-contents-from-point t)
 '(helm-mini-default-sources
   (quote
    (helm-source-buffers-list helm-source-recentf helm-source-files-in-current-dir helm-source-ls-git)))
 '(helm-truncate-lines t t)
 '(neo-vc-integration (quote (face))))
(global-set-key [f8] 'neotree-toggle)

;; for helm
(require 'helm)
(helm-mode 1)
(define-key global-map (kbd "C-x C-o") 'helm-mini)
(define-key global-map (kbd "C-x C-d") 'helm-browse-project)
(define-key global-map (kbd "C-x C-g") 'helm-ag)

;; turn off auto save and auto backup
(setq make-backup-files nil)
(setq auto-save-default nil)
;; (setq create-lockfiles nil)

;; for ace-jump
(require 'ace-jump-mode)
(global-set-key (kbd "C-c SPC") 'ace-jump-mode)

;; backspace
(keyboard-translate ?\C-h ?\C-?)

(electric-indent-mode 0)

;; for scala
(setenv "PATH" (concat "/usr/local/bin/sbt:" (getenv "PATH")))
(setenv "PATH" (concat "/usr/local/bin/scala:" (getenv "PATH")))

;; scala-mode2
;(require 'scala-mode2)

;; ensime
;(require 'ensime)
;(add-hook 'scala-mode-hook 'ensime-scala-mode-hook)
;(add-hook 'scala-mode-hook 'my-scala-mode-hook)

(setq ensime-sem-high-faces
 '((var . (:foreground "#ff2222"))
   (val . (:foreground "#dddddd"))
   (varField . (:foreground "#ff3333"))
   (valField . (:foreground "#dddddd"))
   (functionCall . (:foreground "#84BEE3"))
   (param . (:foreground "#ffffff"))
   (class . font-lock-type-face)
   (trait . (:foreground "#084EA8"))
   (object . (:foreground "#026DF7"))
   (package . font-lock-preprocessor-face)))

;(defun my-scala-mode-hook ()
;  (setq scala-indent:use-javadoc-style t)
;)

;; helm-mini
(progn
  (require 'helm-ls-git)
  (custom-set-variables
   '(frame-background-mode (quote dark))
   '(helm-truncate-lines t)
   '(helm-delete-minibuffer-contents-from-point t)
   '(helm-mini-default-sources '(helm-source-buffers-list
                                 helm-source-recentf
                                 helm-source-files-in-current-dir
                                 helm-source-ls-git
                                 ))))

;; web-mode 
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.html\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))

(defun my-web-mode-hook ()
  "Hooks for Web mode."
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
)
(add-hook 'web-mode-hook  'my-web-mode-hook)

;; go-mode
(require 'go-mode)
(add-hook 'before-save-hook 'gofmt-before-save)


;;;; auto-complete
(require 'auto-complete)
(require 'auto-complete-config)
(ac-config-default)
(global-auto-complete-mode t)
(add-to-list 'ac-modes 'text-mode)
(define-key ac-completing-map (kbd "M-n") 'ac-next)
(define-key ac-completing-map (kbd "M-p") 'ac-previous)
(setq-default ac-sources '(ac-source-filename ac-source-words-in-same-mode-buffers))
(add-hook 'emacs-lisp-mode-hook (lambda () (add-to-list 'ac-sources 'ac-source-symbols t)))
(setq ac-auto-start 2)
(ac-set-trigger-key "TAB")
(setq ensime-completion-style 'auto-complete)

;; company-mode
 (add-hook 'after-init-hook 'global-company-mode)
(global-company-mode 1)

;; markdown-mode
(autoload 'markdown-mode "markdown-mode"
   "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

;; coffee-mode
(custom-set-variables '(coffee-tab-width 2))

;; wgrep
;;; eでwgrepモードにする
(setf wgrep-enable-key "e")
;;; wgrep終了時にバッファを保存
(setq wgrep-auto-save-buffer t)
;;; read-only bufferにも変更を適用する
(setq wgrep-change-readonly-file t)

(put 'downcase-region 'disabled nil)

;; flycheck
;; (add-hook 'after-init-hook #'global-flycheck-mode)

;; window resizer
(defun window-resizer ()
  "Control window size and position."
  (interactive)
  (let ((window-obj (selected-window))
        (current-width (window-width))
        (current-height (window-height))
        (dx (if (= (nth 0 (window-edges)) 0) 1
              -1))
        (dy (if (= (nth 1 (window-edges)) 0) 1
              -1))
        action c)
    (catch 'end-flag
      (while t
        (setq action
              (read-key-sequence-vector (format "size[%dx%d]"
                                                (window-width)
                                                (window-height))))
        (setq c (aref action 0))
        (cond ((= c ?l)
               (enlarge-window-horizontally dx))
              ((= c ?h)
               (shrink-window-horizontally dx))
              ((= c ?j)
               (enlarge-window dy))
              ((= c ?k)
               (shrink-window dy))
              ;; otherwise
              (t
               (let ((last-command-char (aref action 0))
                     (command (key-binding action)))
                 (when command
                   (call-interactively command)))
               (message "Quit")
               (throw 'end-flag t)))))))
(global-set-key "\C-c\C-r" 'window-resizer)

;; yasnippet
;; download snippet
;; git clone https://github.com/AndreaCrotti/yasnippet-snippets.git

(add-to-list 'load-path "~/.emacs.d/yasnippet")
(require 'yasnippet)
(yas-global-mode 1)

(defun copy-from-osx ()
 (shell-command-to-string "pbpaste"))

(defun paste-to-osx (text &optional push)
 (let ((process-connection-type nil))
     (let ((proc (start-process "pbcopy" "*Messages*" "pbcopy")))
       (process-send-string proc text)
       (process-send-eof proc))))

(setq interprogram-cut-function 'paste-to-osx)
(setq interprogram-paste-function 'copy-from-osx)

;; helm-git
;;(add-hook 'emacs-startup-hook 'helm-ls-git-ls)
;; close helm-git mini buffer after launch
;;(setq close-buffer (listify-key-sequence "\C-g"))
;;(add-hook 'emacs-startup-hook 'close-buffer)

;; display column number
(column-number-mode t)

;; hilight space
(setq-default show-trailing-whitespace t)

;; display time
(display-time)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; scroll
(setq scroll-conservatively 1)
