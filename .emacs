;; $HOME の path 追加
(setq load-path (cons "~/.emacs.d/lisp" load-path))
(setq load-path (cons "~/.emacs.d/auto-install" load-path))
;(setq load-path (cons "/usr/share/emacs/site-lisp/mew" load-path))
(setq load-path (cons "/usr/local/share/emacs/site-lisp/mew/" load-path))

;; 基本の auto-install.
(setq load-path (cons "~/.emacs.d/auto-install" load-path))
(require 'auto-install)
(setq auto-install-directory "~/.emacs.d/auto-install/")
(auto-install-update-emacswiki-package-name t)
(auto-install-compatibility-setup) ; 互換性確保

;; anything.el
;(require 'anything-startup)
(require 'anything-config)
(define-key anything-map "\C-o" 'anything-next-source)
(define-key anything-map "\C-\M-n" 'anything-next-source)
(define-key anything-map "\C-\M-p" 'anything-previous-source)
(eval-after-load "anything"
  '(define-key anything-map (kbd "C-h") 'delete-backward-char))

; auto-complete.el
;(require 'auto-complete)
;(global-auto-complete-mode t)
;(define-key ac-complete-mode-map "\C-n" 'ac-next)     ; C-n で補完が打ち消されないよう
;(define-key ac-complete-mode-map "\C-p" 'ac-previous) ; C-n で補完が打ち消されないよう


;; sudo alias
(require 'tramp)
;(set-default 'tramp-default-proxies-alist (quote ((".*" "\\`root\\'" "/ssh:%h:"))))
(set-default 'tramp-default-proxies-alist (quote ((".*" "\\`root\\'" "/ssh:%u@%h:"))))

;; flymake-mode
; shell mode
(require 'flymake-shell)
(add-hook 'sh-mode-hook 'flymake-shell-load)
; perl mode
(require 'flymake)

;; set-perl5lib
;; 開いたスクリプトのパスに応じて、@INCにlibを追加してくれる
;; 以下からダウンロードする必要あり
;; http://svn.coderepos.org/share/lang/elisp/set-perl5lib/set-perl5lib.el
(require 'set-perl5lib)

;; エラー、ウォーニング時のフェイス
(set-face-background 'flymake-errline "red4")
(set-face-foreground 'flymake-errline "black")
(set-face-background 'flymake-warnline "yellow")
(set-face-foreground 'flymake-warnline "black")

;; エラーをミニバッファに表示
;; http://d.hatena.ne.jp/xcezx/20080314/1205475020
(defun flymake-display-err-minibuf ()
  "Displays the error/warning for the current line in the minibuffer"
  (interactive)
  (let* ((line-no             (flymake-current-line-no))
         (line-err-info-list  (nth 0 (flymake-find-err-info flymake-err-info line-no)))
         (count               (length line-err-info-list)))
    (while (> count 0)
      (when line-err-info-list        (let* ((file       (flymake-ler-file (nth (1- count) line-err-info-list)))
               (full-file  (flymake-ler-full-file (nth (1- count) line-err-info-list)))
               (text (flymake-ler-text (nth (1- count) line-err-info-list)))
               (line       (flymake-ler-line (nth (1- count) line-err-info-list))))
          (message "[%s] %s" line text)))
      (setq count (1- count)))))

;; Perl用設定
;; http://unknownplace.org/memo/2007/12/21#e001
(defvar flymake-perl-err-line-patterns
  '(("\\(.*\\) at \\([^ \n]+\\) line \\([0-9]+\\)[,.\n]" 2 3 nil 1)))

(defconst flymake-allowed-perl-file-name-masks
  '(("\\.pl$" flymake-perl-init)
    ("\\.pm$" flymake-perl-init)
    ("\\.t$" flymake-perl-init)))

(defun flymake-perl-init ()
  (let* ((temp-file (flymake-init-create-temp-buffer-copy
                     'flymake-create-temp-inplace))
         (local-file (file-relative-name
                      temp-file                      (file-name-directory buffer-file-name))))
    (list "perl" (list "-wc" local-file))))

(defun flymake-perl-load ()
  (interactive)
  (defadvice flymake-post-syntax-check (before flymake-force-check-was-interrupted)
    (setq flymake-check-was-interrupted t))
  (ad-activate 'flymake-post-syntax-check)
  (setq flymake-allowed-file-name-masks (append flymake-allowed-file-name-masks flymake-allowed-perl-file-name-masks))
  (setq flymake-err-line-patterns flymake-perl-err-line-patterns)
  (set-perl5lib)
  (flymake-mode t))

(add-hook 'cperl-mode-hook 'flymake-perl-load)

;; For MEW Setting
(autoload 'mew "mew" nil t)
(autoload 'mew-send "mew" nil t)
(setq mew-fcc "+outbox") ; 送信メールを保存
(setq exec-path (cons "/usr/bin" exec-path))

(add-to-list 'exec-path "/usr/share/emacs/site-lisp")

;; evernote mode
;(require 'evernote-mode)
;(global-set-key "\C-cec" 'evernote-create-note)
;(global-set-key "\C-ceo" 'evernote-open-note)
;(global-set-key "\C-ces" 'evernote-search-notes)
;(global-set-key "\C-ceS" 'evernote-do-saved-search)
;(global-set-key "\C-cew" 'evernote-write-note)

;; simplenote
(require 'simplenote)
(setq simplenote-email "tomokazu.hirai@gmail.com") ; ログイン用メールアドレス
;(setq simplenote-password "") ; ログイン用パスワード
(simplenote-setup)

;; color theme
(require 'color-theme)
(color-theme-initialize)
(color-theme-thirai)
;(color-theme-arjen)

;; ffap.el
(ffap-bindings)

;; rail
;(require 'rail)
;; w3m
;(require 'w3m-load)

(if (boundp 'read-mail-command)
    (setq read-mail-command 'mew))
(autoload 'mew-user-agent-compose "mew" nil t)
(if (boundp 'mail-user-agent)
    (setq mail-user-agent 'mew-user-agent))
(if (fboundp 'define-mail-user-agent)
    (define-mail-user-agent
      'mew-user-agent
      'mew-user-agent-compose
      'mew-draft-send-message
      'mew-draft-kill
      'mew-send-hook))

;; 2011-10-27

;; 空白や長すぎる行を視覚化する。
(require 'whitespace)
;; 1行が80桁を超えたら長すぎると判断する。
(setq whitespace-line-column 80)
(setq whitespace-style '(face              ; faceを使って視覚化する。
                         trailing          ; 行末の空白を対象とする。
                         lines-tail        ; 長すぎる行のうち
                                           ; whitespace-line-column以降のみを
                                           ; 対象とする。
                         space-before-tab  ; タブの前にあるスペースを対象とする。
                         space-after-tab)) ; タブの後にあるスペースを対象とする。
;; デフォルトで視覚化を有効にする。
(global-whitespace-mode 1)

;;; 現在行を目立たせる
(global-hl-line-mode)

;;; カーソルの位置が何文字目かを表示する
(column-number-mode t)

;;; カーソルの位置が何行目かを表示する
(line-number-mode t)

;;; カーソルの場所を保存する
(require 'saveplace)
(setq-default save-place t)

;;; 補完時に大文字小文字を区別しない
(setq completion-ignore-case t)
(setq read-file-name-completion-ignore-case t)

;;; 部分一致の補完機能を使う
;;; p-bでprint-bufferとか
(partial-completion-mode t)

;;; 補完可能なものを随時表示
;;; 少しうるさい
(icomplete-mode 1)

;; emacsclientで接続できるようにする。
;(server-start)

;; 行番号表示
(setq load-path (cons "~/.emacs.d/lisp" load-path))
(require 'linum)
;(global-linum-mode t) ;; 通常時、表示しない M-x linum-mode で表示
(setq linum-format "%5d")
;; 行数表示, 桁数表示
(line-number-mode t)
(column-number-mode t)

;; Shift + カーソルキーで領域を選択する
(setq pc-select-selection-keys-only t)
(pc-selection-mode 1)

;; color theme
;(require 'color-theme)

;; 現在桁をハイライト
;(require 'col-highlight)
; 1: 常にハイライト
;(column-highlight-mode 1) ; 1 or 2
; 2: 何もしないで居るとハイライトを始めるようにする
;(toggle-highlight-column-when-idle 1)
;(col-highlight-set-interval 6)
; 色選択
;(custom-set-faces
; '(col-highlight ((t (:background "#222244")))))
; 現在行をハイライト
;(require 'crosshairs)
;(crosshairs-mode 1)
; hl-line は crosshairs.el で load されている
;(require 'hl-line)
;(custom-set-faces 
; '(hl-line
;   ((((class color)
;      (background dark))
;     (:background "#222244"))
;    (((class color)
;      (background light))
;     (:background "#222244")))))
;(global-hl-line-mode)

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

;; タブ長の設定
(setq tab-width 4)

;; 矩形選択
(cua-mode t) ; cua-mode をオンにする
(setq cua-enable-cua-keys nil) ; CUA キーバインドを無効にする

;; タブをスペースに置き換え
;(setq indent-tabs-mode nil)

;; タブの幅を設定
(setq default-tab-width 2)

;; 対応する括弧をハイライト
(show-paren-mode 1)

;;C-h で削除
(global-set-key "\C-h" 'delete-backward-char)

;; C言語の表示を色分けする 
(global-font-lock-mode t)

;; 起動時のメッセージなくす
(setq inhibit-startup-message t)

;; (*~)ファイルを作らない
(setq make-backup-files nil)

;; 自動セーブを行わない
(setq auto-save-defalut nil)

;; ずるずるスクロールさせる
(setq scroll-conservatively 1)

;; バッファの最後の行で next-line しても新しい行を作らない
(setq next-line-add-newlines nil)

;; タイトルバーの文字設定
(setq frame-title-format "☆Emacs☆   %b ")

;; メニューバーの非表示
(menu-bar-mode -1)

;; browse-url の設定
(global-set-key "\C-c\C-n" 'browse-url)

;; カーソルの種類・色・高さ
(setq default-frame-alist
      (append (list
               '(cursor-type . box)      ; 種類
               '(cursor-color . "white") ; 色
               '(cursor-height . 4)      ; 高さ
               )
              default-frame-alist))

;; IME の ON/OFF でカーソルの色を変える
(add-hook 'mw32-ime-on-hook
          (lambda () (set-cursor-color "#14B6B4"))) ; ON
(add-hook 'mw32-ime-off-hook
          (lambda () (set-cursor-color "white"))) ; OFF

;; キー入力時にマウスを消す。
(setq w32-hide-mouse-on-key t) 

;; 行番号表示el M-x setnu-modeで実行
(autoload 'setnu-mode "setnu" nil t)

;; Key Bind
(global-set-key "\C-z" 'undo)
(global-set-key [f1] 'info)
(global-set-key "\C-c\C-l" 'goto-line)

(if (featurep 'meadow)
		(progn
;;;
;;; 印刷の設定
;;; この設定で M-x print-buffer RET などでの印刷ができるようになります
		(define-process-argument-editing
			"hidemaru"
			(lambda (x) (general-process-argument-editing-function x nil t)))
	(defun w32-print-region (start end
																 &optional lpr-prog delete-text buf display
																 &rest rest)
		(interactive)
		(let ((tmpfile (expand-file-name (make-temp-name "w32-print-")
																		 temporary-file-directory))
					(coding-system-for-write w32-system-coding-system))
			(write-region start end tmpfile nil 'nomsg)
			(call-process "hidemaru" nil nil nil "/p" tmpfile)
			(and (file-writable-p tmpfile) (delete-file tmpfile))))
	(setq print-region-function 'w32-print-region)))


;;;
;;; auto-fill（自動詰め込み）モードの設定
;;;

;; テキストモードで常に auto-fill
;(add-hook 'text-mode-hook
;					'(lambda () (auto-fill-mode 1)))

;; 折り返し桁数の初期値
;(setq-default fill-column 65)
; バッファごとに桁数を変更できるので setq じゃなくて setq-default 
; C-u 60 C-x f のようにして随時変更可能

; MEW で auto-fill-mode を有効にする
;(setq mew-draft-mode-hook (function (lambda () (auto-fill-mode 1))))


(setq fill-column 78)
;; 各Major Modeごとに変える場合
(setq text-mode-hook
      '(lambda () (auto-fill-mode 1) (setq fill-column 78)))
(setq tex-mode-hook
      '(lambda () (auto-fill-mode 1) (setq fill-column 70)))
(setq mew-draft-mode-hook
      '(lambda () (auto-fill-mode 1) (setq fill-column 68)))



;;; sdic-mode 用の設定
(setq load-path (cons "/usr/local/share/emacs/site-lisp" load-path))
(autoload 'sdic-describe-word "sdic" "英単語の意味を調べる" t nil)
(global-set-key "\C-cw" 'sdic-describe-word)
(autoload 'sdic-describe-word-at-point "sdic" "カーソルの位置の英単語の意味を調べる" t nil)
(global-set-key "\C-cW" 'sdic-describe-word-at-point)
