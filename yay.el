;;; yay.el --- Interface to yay package manager -*- lexical-binding: t -*-

;; Author: HackTheOxidation
;; URL: https://github.com/HackTheOxidation/yay.el
;; Keywords: filename, convenience
;; Version: 0.1.0
;; Package-Requires: ((emacs "26.1") (transient "0.3.7"))

;; This file is NOT part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Commentary:

;; This package allows you to use yay (https://github.com/Jguer/yay) for arch linux inside Emacs.

;;; Code:

(require 'term)
(require 'transient)

(defgroup yay nil
  "Options for yay."
  :group 'convenience)

(defcustom yay-command "yay"
  "Path to yay."
  :type 'string
  :group 'yay)

(defconst yay-buffer-name "*yay*"
  "Buffer name for yay session.")

(defun yay-sync-run (&optional args)
  "Run \"yay --Sync\" with ARGS."
  (interactive
   (list (transient-args 'yay-sync)))
  (let* ((buf (get-buffer-create yay-buffer-name))
	 (target-package (read-string "Target: "))
	 (yay-args (format "%s" args)))
    (make-term yay-command "sh" nil "-c" yay-command yay-args target-package)
    (switch-to-buffer buf)
    (message "Running yay --Sync - switching to buffer.")))

(transient-define-prefix yay-sync ()
  "Transient for  \"yay -S\""
  ["Arguments"
   ("u" "Upgrade" "-u")
   ("y" "Sync package database" "-y")
   ("s" "Search" "-s")
   ("-a" "AUR" "-a")
   ("-r" "Repositories" "--repo")]
  ["Actions"
   ("S" "Install Package" yay-sync-run)])

(defun yay-upgrade ()
  "Run \"yay -Syyu\"."
  (interactive)
  (let* ((buf (get-buffer-create yay-buffer-name)))
    (make-term yay-command "sh" nil "-c" yay-command "-Syyu")
    (switch-to-buffer buf)
    (message "Running yay -Syyu - switching to buffer.")))

;;;###autoload (autoload 'yay "yay" nil t)
(transient-define-prefix yay ()
  "Transient for yay."
  ["Arguments"
   ()]
  [["Packages"
    ("S" "Synchronize" yay-sync)
    ("U" "Upgrade All" yay-upgrade)]])

(provide 'yay)

;;; yay.el ends here
