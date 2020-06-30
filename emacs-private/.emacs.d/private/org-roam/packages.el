(defconst org-roam-packages
  '((org-roam :location
        (recipe :fetcher github :repo "jethrokuan/org-roam" :branch "master"))))
(defun org-roam/init-org-roam ()
    (use-package org-roam
        :after org
        :hook
        ((org-mode . org-roam-mode)
         (after-init . org-roam--build-cache-async) ;; optional!
         )
        :custom
        (org-roam-directory "~/Documents/org-roam")
        :init
        (progn
          (spacemacs/declare-prefix "ar" "org-roam")
          (spacemacs/set-leader-keys
            "arl" 'org-roam
            "art" 'org-roam-today
            "arf" 'org-roam-find-file
            "arg" 'org-roam-show-graph)
          (spacemacs/declare-prefix-for-mode 'org-mode "mr" "org-roam")
          (spacemacs/set-leader-keys-for-major-mode 'org-mode
            "rl" 'org-roam
            "rt" 'org-roam-today
            "rf" 'org-roam-find-file
            "ri" 'org-roam-insert
            "rg" 'org-roam-show-graph)
          )))
