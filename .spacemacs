;; -*- mode: emacs-lisp -*-

(defun dotspacemacs/layers ()
  (setq-default
   dotspacemacs-distribution 'spacemacs
   dotspacemacs-enable-lazy-installation 'unused
   dotspacemacs-ask-for-lazy-installation t
   dotspacemacs-configuration-layer-path '()
   dotspacemacs-configuration-layers
   '(
     auto-completion
     deft
     emacs-lisp
     git
     (go :variables
         go-tab-width 4
         gofmt-command "goimports")
     ivy
     html
     markdown
     osx
     spell-checking
     syntax-checking
     yaml
     version-control
     )
   dotspacemacs-additional-packages '()
   dotspacemacs-frozen-packages '()
   dotspacemacs-excluded-packages '()
   dotspacemacs-install-packages 'used-only))

(defun dotspacemacs/init ()
  (setq-default
   dotspacemacs-elpa-https t
   dotspacemacs-elpa-timeout 5
   dotspacemacs-check-for-update t
   dotspacemacs-elpa-subdirectory nil
   dotspacemacs-editing-style 'vim
   dotspacemacs-verbose-loading nil
   dotspacemacs-startup-banner 'official
   dotspacemacs-startup-lists '((recents . 5)
                                (projects . 7))
   dotspacemacs-startup-buffer-responsive t
   dotspacemacs-scratch-mode 'text-mode
   dotspacemacs-themes '(spacemacs-dark
                         spacemacs-light)
   dotspacemacs-colorize-cursor-according-to-state t
   dotspacemacs-default-font '("Fira Code"
                               :size 13
                               :weight normal
                               :width normal
                               :powerline-scale 1.1)
   dotspacemacs-leader-key "SPC"
   dotspacemacs-emacs-command-key "SPC"
   dotspacemacs-ex-command-key ":"
   dotspacemacs-emacs-leader-key "M-m"
   dotspacemacs-major-mode-leader-key ","
   dotspacemacs-major-mode-emacs-leader-key "C-M-m"
   dotspacemacs-distinguish-gui-tab nil
   dotspacemacs-remap-Y-to-y$ t
   dotspacemacs-retain-visual-state-on-shift t
   dotspacemacs-visual-line-move-text t
   dotspacemacs-ex-substitute-global nil
   dotspacemacs-default-layout-name "Default"
   dotspacemacs-display-default-layout nil
   dotspacemacs-auto-resume-layouts nil
   dotspacemacs-large-file-size 1
   dotspacemacs-auto-save-file-location 'cache
   dotspacemacs-max-rollback-slots 5
   dotspacemacs-helm-resize nil
   dotspacemacs-helm-no-header nil
   dotspacemacs-helm-position 'bottom
   dotspacemacs-helm-use-fuzzy 'always
   dotspacemacs-enable-paste-transient-state nil
   dotspacemacs-which-key-delay 0.4
   dotspacemacs-which-key-position 'bottom
   dotspacemacs-loading-progress-bar t
   dotspacemacs-fullscreen-at-startup nil
   dotspacemacs-fullscreen-use-non-native nil
   dotspacemacs-maximized-at-startup nil
   dotspacemacs-active-transparency 90
   dotspacemacs-inactive-transparency 90
   dotspacemacs-show-transient-state-title t
   dotspacemacs-show-transient-state-color-guide t
   dotspacemacs-mode-line-unicode-symbols t
   dotspacemacs-smooth-scrolling t
   dotspacemacs-line-numbers 'relative
   dotspacemacs-folding-method 'evil
   dotspacemacs-smartparens-strict-mode nil
   dotspacemacs-smart-closing-parenthesis t
   dotspacemacs-highlight-delimiters 'all
   dotspacemacs-persistent-server nil
   dotspacemacs-search-tools '("ag" "grep")
   dotspacemacs-default-package-repository nil
   dotspacemacs-whitespace-cleanup 'trailing
   ))

(defun dotspacemacs/user-init ())

(defun dotspacemacs/user-config ()
  ;; Keep notes in a sane location.
  (setq deft-directory "~/.notes")
  (setq deft-extensions '("md" "txt"))

  ;; Move by visual line.
  (define-key evil-normal-state-map (kbd "j") 'evil-next-visual-line)
  (define-key evil-normal-state-map (kbd "k") 'evil-previous-visual-line)

  ;; Always use spacemacs for git commits.
  (global-git-commit-mode t)
  )

;; Do not write anything past this comment. This is where Emacs will
;; auto-generate custom variable definitions.
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (wgrep smex ivy-hydra flyspell-correct-ivy counsel-projectile counsel swiper ivy yaml-mode which-key web-mode use-package toc-org restart-emacs pug-mode persp-mode osx-dictionary orgit org-plus-contrib neotree move-text mmm-mode markdown-toc markdown-mode link-hint info+ indent-guide hungry-delete highlight-indentation hide-comnt help-fns+ helm-projectile helm-make projectile helm-gitignore request helm-flx helm-company helm-c-yasnippet helm-ag go-eldoc gitattributes-mode git-timemachine git-link git-gutter-fringe eyebrowse expand-region exec-path-from-shell evil-surround evil-nerd-commenter evil-mc evil-matchit evil-escape evil-ediff evil-anzu dumb-jump company-statistics company-go auto-compile packed aggressive-indent ace-window ace-link auto-complete avy yasnippet company smartparens highlight f evil flycheck flyspell-correct go-mode helm helm-core magit magit-popup git-commit with-editor async hydra haml-mode dash ws-butler winum volatile-highlights vi-tilde-fringe uuidgen undo-tree tagedit spaceline smeargle slim-mode scss-mode sass-mode reveal-in-osx-finder rainbow-delimiters popwin pkg-info pcre2el pbcopy paradox osx-trash org-bullets open-junk-file magit-gitflow macrostep lorem-ipsum linum-relative less-css-mode launchctl hl-todo highlight-parentheses highlight-numbers helm-themes helm-swoop helm-mode-manager helm-descbinds helm-css-scss goto-chg google-translate golden-ratio go-guru gitignore-mode gitconfig-mode git-messenger git-gutter-fringe+ git-gutter gh-md fuzzy flyspell-correct-helm flycheck-pos-tip flx-ido fill-column-indicator fancy-battery evil-visualstar evil-visual-mark-mode evil-unimpaired evil-tutor evil-search-highlight-persist evil-numbers evil-magit evil-lisp-state evil-indent-plus evil-iedit-state evil-exchange evil-args eval-sexp-fu emmet-mode elisp-slime-nav diminish diff-hl deft company-web column-enforce-mode clean-aindent-mode bind-key auto-yasnippet auto-highlight-symbol auto-dictionary anzu adaptive-wrap ace-jump-helm-line ac-ispell))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
