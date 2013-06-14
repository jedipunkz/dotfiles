;; $HOME の path 追加
(setq load-path (cons "~/.emacs.d/elisp" load-path))
(setq load-path (cons "~/.emacs.d/elpa" load-path))
(setq load-path (cons "/usr/local/share/emacs/site-lisp/mew/" load-path))

;; Mew
(autoload 'mew "mew" nil t)
(autoload 'mew-send "mew" nil t)
(setq mew-fcc "+outbox") ; 送信メールを保存
(setq exec-path (cons "/usr/bin" exec-path))

;; package.el
(require 'package)
;;リポジトリにMarmaladeを追加
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
;;インストールするディレクトリを指定
(setq package-user-dir (concat user-emacs-directory "elpa"))
;;インストールしたパッケージにロードパスを通してロードする
(package-initialize)
(package-activate 'quickrun '(1 1 1))

(require 'anything)
(global-set-key (kbd "C-]") 'anything-for-files )
;(define-key anything-map (kbd "C-p") 'anything-previous-line)
;(define-key anything-map (kbd "C-n") 'anything-next-line)
;(define-key anything-map (kbd "C-v") 'anything-next-source)
;(define-key anything-map (kbd "M-v") 'anything-previous-source)
(eval-after-load "anything"
    '(define-key anything-map (kbd "C-h") 'delete-backward-char))
(define-key global-map (kbd "C-x b") 'anything-for-files)

; auto-complete.el
(require 'auto-complete)
(global-auto-complete-mode t)
(define-key ac-complete-mode-map "\C-n" 'ac-next)     ; C-n で補完が打ち消されないよう
(define-key ac-complete-mode-map "\C-p" 'ac-previous) ; C-n で補完が打ち消されないよう

;; markdown mode
(autoload 'markdown-mode "markdown-mode.el"
	"Major mode for editing Markdown files" t)
(setq auto-mode-alist 
			(cons '("\\.md" . markdown-mode) auto-mode-alist))
(setq auto-mode-alist 
			(cons '("\\.markdown" . markdown-mode) auto-mode-alist))

;; simplenote
(require 'simplenote)
(setq simplenote-email "tomokazu.hirai@gmail.com") ; ログイン用メールアドレス
;(setq simplenote-password "") ; ログイン用パスワード
(simplenote-setup)

;; color theme
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
(load-theme 'solarized-dark t)
;(load-theme 'pastels-on-dark t)
;(load-theme 'tango-2 t)
;(load-theme 'twilight t)

;; コメント
(global-set-key (kbd "C-c ;") 'comment-or-uncomment-region)

;;; カーソルの位置が何文字目かを表示する
(column-number-mode t)
;;; カーソルの位置が何行目かを表示する
(line-number-mode t)
;;; カーソルの場所を保存する
(require 'saveplace)
(setq-default save-place t)

;; インデント
(global-set-key (kbd "C-m") 'newline-and-indent)

;;; 補完時に大文字小文字を区別しない
(setq completion-ignore-case t)
(setq read-file-name-completion-ignore-case t)

;;; 補完可能なものを随時表示
;;; 少しうるさい
;(icomplete-mode 1)

;; emacsclientで接続できるようにする。
;(server-start)

;; Shift + カーソルキーで領域を選択する
;(setq pc-select-selection-keys-only t)
;(pc-selection-mode 1)

;; 日本語設定
(set-language-environment 'Japanese)
(set-terminal-coding-system 'utf-8)
(setq file-name-coding-system 'utf-8)
(set-clipboard-coding-system 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)
(setq coding-system-for-read 'mule-utf-8-unix)
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8-unix)

;; dark か light か,通常は手動で入れない
(setq frame-background-mode 'dark)

;; 矩形選択
;(cua-mode t) ; cua-mode をオンにする
;(setq cua-enable-cua-keys nil) ; CUA キーバインドを無効にする

;; タブ長の設定
;(setq tab-width 2)
;; タブをスペースに置き換え
;(setq indent-tabs-mode nil)
;; タブの幅を設定
;(setq default-tab-width 2)
(setq-default tab-width 4 indent-tabs-mode nil)

;; 対応する括弧をハイライト
(show-paren-mode 1)

;;C-h で削除
(global-set-key "\C-h" 'delete-backward-char)

;; C言語の表示を色分けする 
(global-font-lock-mode t)

;; (*~)ファイルを作らない
(setq make-backup-files nil)

;; 自動セーブを行わない
(setq auto-save-defalut nil)

;; ずるずるスクロールさせる
(setq scroll-conservatively 1)

;; バッファの最後の行で next-line しても新しい行を作らない
(setq next-line-add-newlines nil)

;; メニューバーの非表示
(menu-bar-mode -1)

;; Key Bind
(global-set-key "\C-z" 'undo)
(global-set-key [f1] 'info)
(global-set-key "\C-c\C-l" 'goto-line)

;; fill-column
(setq fill-column 78)
;; 各Major Modeごとに変える場合
(setq text-mode-hook
      '(lambda () (auto-fill-mode 1) (setq fill-column 78)))
(setq tex-mode-hook
      '(lambda () (auto-fill-mode 1) (setq fill-column 70)))
(setq mew-draft-mode-hook
      '(lambda () (auto-fill-mode 1) (setq fill-column 68)))


