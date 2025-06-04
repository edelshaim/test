;; init.el -- Emacs initialization file
;; Improved configuration based on baseline and user preferences.

;;; Package Management
(require 'package)
(setq package-archives
      '(("melpa" . "https://melpa.org/packages/")
        ("gnu"   . "https://elpa.gnu.org/packages/")))
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))
(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

;; keep customization data out of this file
(setq custom-file (locate-user-emacs-file "custom.el"))
(when (file-exists-p custom-file)
  (load custom-file))

;;; Basic UI and behavior
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(setq inhibit-startup-screen t)
(global-display-line-numbers-mode t)
(show-paren-mode 1)
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq initial-scratch-message "")
(setq ring-bell-function 'ignore)
(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))
(setq auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-saves/" t)))
(setq create-lockfiles nil)
(put 'erase-buffer 'disabled nil)
(put 'narrow-to-region 'disabled nil)
(set-face-attribute 'default nil :height 120)
(load-theme 'wheatgrass t)

;;; Spell checking
(use-package ispell
  :ensure nil
  :config
  (setq ispell-program-name "aspell"
        ispell-dictionary "en_CA"))

;;; Completion and search
(use-package ivy
  :diminish
  :init (ivy-mode 1)
  :config
  (setq ivy-use-virtual-buffers t
        ivy-count-format "(%d/%d) "))

(use-package counsel
  :after ivy
  :config (counsel-mode 1))

(use-package swiper
  :after ivy
  :bind (("C-s" . swiper)))

;;; UI enhancements
(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 15)))

(use-package all-the-icons
  :if (display-graphic-p))

(use-package which-key
  :init (which-key-mode))

;;; File and project management
(use-package neotree
  :after all-the-icons
  :bind ([f8] . neotree-toggle)
  :config
  (setq neo-theme 'icons
        neo-smart-open t))

(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode +1)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap ("C-c p" . projectile-command-map))

;;; Version control
(use-package magit
  :bind (("C-x g" . magit-status)))

;;; Language/File type support
(use-package markdown-mode
  :mode "\\.md\\'"
  :commands (markdown-mode gfm-mode))

(use-package editorconfig
  :config (editorconfig-mode 1))

(use-package csv-mode
  :mode "\\.csv\\'")

(use-package org
  :ensure nil
  :custom (org-default-notes-file "~/org/inbox.org"))

;;; Custom helper functions
(defun de/append-snippet-to-daily-log ()
  "Append selected text to today's DE_log.txt in MatterManagement folder."
  (interactive)
  (if (use-region-p)
      (let* ((text (buffer-substring-no-properties (region-beginning) (region-end)))
             (today (format-time-string "%Y-%m-%d"))
             (log-dir (expand-file-name today "~/Documents/MatterManagement/"))
             (log-file (expand-file-name "DE_log.txt" log-dir)))
        (make-directory log-dir :parents)
        (with-temp-buffer
          (insert (format-time-string "\n\n** %H:%M **\n"))
          (insert text)
          (append-to-file (point-min) (point-max) log-file))
        (message "Appended to %s" log-file))
    (message "No region selected.")))

(defun de/open-today-symlink ()
  "Open the ~/today symlink in dired."
  (interactive)
  (dired "~/today"))

(defun de/jq-clean-content ()
  "Extract .content from JSON and format paragraphs, inserting into a new buffer."
  (interactive)
  (let* ((json-file (read-file-name "Select JSON file: "))
         (output-buffer "*Cleaned JSON Output*")
         (cmd (format "jq -r '.content' %s | awk 'BEGIN{RS=\"\"; ORS=\"\\n\\n\"} {print}'" (shell-quote-argument json-file))))
    (with-current-buffer (get-buffer-create output-buffer)
      (erase-buffer)
      (insert (shell-command-to-string cmd))
      (goto-char (point-min))
      (display-buffer (current-buffer)))))

(defun de/extract-plain-text-from-eml ()
  "Extract and display plain text body from a .eml file."
  (interactive)
  (let ((buffer-read-only nil))
    (goto-char (point-min))
    (when (re-search-forward "^\\s-*$" nil t)
      (let ((start (point)))
        (goto-char (point-max))
        (narrow-to-region start (point))
        (if (re-search-forward "<html\\|<body" nil t)
            (progn
              (goto-char (point-min))
              (require 'shr)
              (shr-render-region (point-min) (point-max)))
          (message "Plain text content displayed (or no HTML found)."))))))

(provide 'init)
;;; init.el ends here
