(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#242424" "#e5786d" "#95e454" "#cae682" "#8ac6f2" "#333366" "#ccaa8f" "#f6f3e8"])
 '(current-language-environment "Chinese-GB")
 '(custom-enabled-themes (quote (wheatgrass)))
 '(ede-project-directories (quote ("/Users/MacPro_huyubing/Documents/colorclib/src"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;; for slime
(add-to-list 'load-path "/usr/local/bin/slime-2.14/") 
(require 'slime-autoloads)
(require 'slime)
(slime-setup)

;;; for common lisp 
(setq inferior-lisp-program "/usr/local/bin/clisp/")

(add-to-list 'load-path "~/.emacs.d/auto-save-list")
(autoload 'markdown-mode "markdown-mode.el"
   "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
(put 'upcase-region 'disabled nil)


(global-linum-mode t)

(require 'cc-mode)
(load-file "/Users/MacPro_huyubing/opts/cscope/xcscope.el")
(require 'xcscope)

;;; Emacs 23.2 中已经自带了Cedet，所以无需再单独安装，直接启用即可：
(require 'cedet)

;;; 如果你想使用Cedet的工程管理功能，可以启用EDE Mode
(global-ede-mode t)


;;;Emacs 23.2中自带的Cedet中，去掉了原来的诸如 semantic-load-enable-minimum-features, semantic-load-enable-code-helpers 等等的命令，而是通过定制子模式（semantic-default-submodes）来确 定使;;;; 用哪些辅助功能，最后使用semantic-mode 来启用这些功能。
;;;;  Helper tools.
(custom-set-variables
 '(semantic-default-submodes (quote (global-semantic-decoration-mode global-semantic-idle-completions-mode
                                     global-semantic-idle-scheduler-mode global-semanticdb-minor-mode
                                     global-semantic-idle-summary-mode global-semantic-mru-bookmark-mode)))
 '(semantic-idle-scheduler-idle-time 3))

(semantic-mode)


;; semantic/ia 提供了机遇semantic的自动补齐，Tag信息显示等功能， Semantic/ia 可通过下面的代码来启用和优化

;; smart complitions
(require 'semantic/ia)
(setq-mode-local c-mode semanticdb-find-default-throttle
                 '(project unloaded system recursive))
(setq-mode-local c++-mode semanticdb-find-default-throttle
                 '(project unloaded system recursive))


;;;; Include settings
(require 'semantic/bovine/gcc)
(require 'semantic/bovine/c)

(defconst cedet-user-include-dirs
  (list ".." "../include" "../inc" "../common" "../public" "."
        "../.." "../../include" "../../inc" "../../common" "../../public"))

(setq cedet-sys-include-dirs (list
                              "/usr/include"
                              "/usr/include/bits"
                              "/usr/include/glib-2.0"
                              "/usr/include/gnu"
                              "/usr/include/gtk-2.0"
                              "/usr/include/gtk-2.0/gdk-pixbuf"
                              "/usr/include/gtk-2.0/gtk"
                              "/usr/local/include"
                              "/usr/local/include"))

(let ((include-dirs cedet-user-include-dirs))
  (setq include-dirs (append include-dirs cedet-sys-include-dirs))
  (mapc (lambda (dir)
          (semantic-add-system-include dir 'c++-mode)
          (semantic-add-system-include dir 'c-mode))
        include-dirs))

(setq semantic-c-dependency-system-include-path "/usr/include/")



;;;; TAGS Menu
(defun my-semantic-hook ()
  (imenu-add-to-menubar "TAGS"))

(add-hook 'semantic-init-hooks 'my-semantic-hook)



;;;; Semantic DataBase存储位置
(setq semanticdb-default-save-directory
      (expand-file-name "~/.emacs.d/semanticdb"))

;; 使用 gnu global 的TAGS。
(require 'semantic/db-global)
(semanticdb-enable-gnu-global-databases 'c-mode)
(semanticdb-enable-gnu-global-databases 'c++-mode)

;;;;  缩进或者补齐
;;; hippie-try-expand settings
(setq hippie-expand-try-functions-list
      '(
        yas/hippie-try-expand
        semantic-ia-complete-symbol
        try-expand-dabbrev
        try-expand-dabbrev-visible
        try-expand-dabbrev-all-buffers
        try-expand-dabbrev-from-kill
        try-complete-file-name-partially
        try-complete-file-name
        try-expand-all-abbrevs))

(defun indent-or-complete ()
  "Complete if point is at end of a word, otherwise indent line."
  (interactive)
  (if (looking-at "\\>")
      (hippie-expand nil)
    (indent-for-tab-command)
    ))

(defun yyc/indent-key-setup ()
  "Set tab as key for indent-or-complete"
  (local-set-key  [(tab)] 'indent-or-complete)
  )


;;;; C-mode-hooks .
(defun yyc/c-mode-keys ()
  "description"
  ;; Semantic functions.
  (semantic-default-c-setup)
  (local-set-key "\C-c?" 'semantic-ia-complete-symbol-menu)
  (local-set-key "\C-cb" 'semantic-mrub-switch-tags)
  (local-set-key "\C-cR" 'semantic-symref)
  (local-set-key "\C-cj" 'semantic-ia-fast-jump)
  (local-set-key "\C-cp" 'semantic-ia-show-summary)
  (local-set-key "\C-cl" 'semantic-ia-show-doc)
  (local-set-key "\C-cr" 'semantic-symref-symbol)
  (local-set-key "\C-c/" 'semantic-ia-complete-symbol)
  (local-set-key [(control return)] 'semantic-ia-complete-symbol)
  (local-set-key "." 'semantic-complete-self-insert)
  (local-set-key ">" 'semantic-complete-self-insert)
  ;; Indent or complete
  (local-set-key  [(tab)] 'indent-or-complete)
  )
(add-hook 'c-mode-common-hook 'yyc/c-mode-keys)


;;;; C-mode-hooks .
(defun yyc/c-mode-keys ()
  "description"
  ;; Semantic functions.
  (semantic-default-c-setup)
  (local-set-key "\C-c?" 'semantic-ia-complete-symbol-menu)
  (local-set-key "\C-cb" 'semantic-mrub-switch-tags)
  (local-set-key "\C-cR" 'semantic-symref)
  (local-set-key "\C-cj" 'semantic-ia-fast-jump)
  (local-set-key "\C-cp" 'semantic-ia-show-summary)
  (local-set-key "\C-cl" 'semantic-ia-show-doc)
  (local-set-key "\C-cr" 'semantic-symref-symbol)
  (local-set-key "\C-c/" 'semantic-ia-complete-symbol)
  (local-set-key [(control return)] 'semantic-ia-complete-symbol)
  (local-set-key "." 'semantic-complete-self-insert)
  (local-set-key ">" 'semantic-complete-self-insert)
  ;; Indent or complete
  (local-set-key  [(tab)] 'indent-or-complete)
  )
(add-hook 'c-mode-common-hook 'yyc/c-mode-keys)


(defadvice push-mark (around semantic-mru-bookmark activate)
  "Push a mark at LOCATION with NOMSG and ACTIVATE passed to `push-mark'.
If `semantic-mru-bookmark-mode' is active, also push a tag onto
the mru bookmark stack."
  (semantic-mrub-push semantic-mru-bookmark-ring
                      (point)
                      'mark)
  ad-do-it)
