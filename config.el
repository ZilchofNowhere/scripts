;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Arda Eren Kartal"
      user-mail-address "aekmanisa@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;; (setq doom-font (font-spec :family "RecMono Flat NF" :size 12 :weight 'semi-light)
;;     doom-variable-pitch-font (font-spec :family "Inter" :size 13))
(setq doom-font "RecMonoFlat NF-10")
(setq doom-unicode-font "RecMonoFlat NF-10")
(setq doom-variable-pitch-font "Inter-13")

;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; Turns the menu bar on
(menu-bar-mode 1)

;; Sets the window size to what I like
(if (window-system)
    (set-frame-size (selected-frame) 110 40))

;; Creates a file in ~/Desktop/Temp
(evil-define-command create-temp-file ()
  (interactive) (doom-project-find-file "~/Desktop/Temp/"))

(map! :leader :desc "Create file in temp folder" :n "ft" #'create-temp-file)

;; Eliminates common sources of frustration
(evil-ex-define-cmd "W" #'evil-write)
(evil-ex-define-cmd "Q" #'evil-quit)
(evil-ex-define-cmd "Wq" #'evil-save-and-quit)
(evil-ex-define-cmd "wQ" #'evil-save-and-quit)

;; Opens Emacs in home directory instead of where its binary is
(setq default-directory (concat (getenv "HOME") "/"))

;; Not working eshell prompt customizer
;; (setq eshell-prompt-function
;;       (lambda ()
;;         (concat (propertize (concat (format-time-string "%R") "") 'face `(:foreground "yellow"))
;;                 " -> "
;;                 (propertize (concat user-login-name "@" (system-name)) 'face `(:foreground "green"))
;;                 ": "
;;                 (propertize (concat (if (string= (eshell/pwd) (getenv "HOME")) "~" (eshell/basename (eshell/pwd))) "") 'face `(:foreground "purple"))
;;                 (propertize " λ " 'face `(:foreground "blue" :weight "bold")))))
;; (setq eshell-highlight-prompt nil)

;; Checking internet connection
(setq my-onlinep nil)
(unless
    (condition-case nil
        (delete-process
         (make-network-process
          :name "elcord-checker"
          :host "discord.com"
          :service 80))
      (error t))
  (setq my-onlinep t))

(print (if my-onlinep "Up" "Down"))

;; Turning extensions on
(if my-onlinep (elcord-mode))
(beacon-mode 1)

;; Elcord config
(after! elcord
  (setq elcord-editor-icon "emacs_material_icon")
  (setq elcord-use-major-mode-as-main-icon 1))

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' )block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
