;;; packages.el --- provide package about tabnine
;;
;; Copyright (c) 2015-2019 Mephis Pheies
;;
;; Author: Mephis Pheies <mephistommm@gmail.com>
;; URL: https://github.com/MephistoMMM/memacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

(defconst tabnine-packages
  '(
    lsp-mode
    company-box
    company
    (company-tabnine :requires company)
    ))

(defun tabnine/post-init-lsp-mode ()
  (with-eval-after-load 'lsp-mode
    (advice-add 'lsp :after #'tabnine//merge-company-tabnine-to-company-lsp))
  )

(defun tabnine/post-init-company-box ()
  (spacemacs|use-package-add-hook company-box
    :post-config
    (progn
      (push #'tabnine//company-box-icons--tabnine
            company-box-icons-functions)
      (map-put company-box-backends-colors
               'company-tabnine  '(:all
                                   tabnine-company-box-backend-tabnine-face
                                   :selected
                                   tabnine-company-box-backend-tabnine-selected-face))
      )
    )
  )

(defun tabnine/post-init-company ()
  (unless (configuration-layer/layer-used-p 'lsp)
    (with-eval-after-load 'company
      (push #'company-tabnine company-backends)))
  )

(defun tabnine/init-company-tabnine ()
  (use-package company-tabnine
    :defer t
    :init
    (setq company-tabnine-binaries-folder "~/.tabnine")
    (setq company-tabnine-install-static-binary t)
    :config
    (progn
      ;; (setq company-tabnine-max-num-results 3)

      (add-to-list 'company-transformers 'tabnine//sort-by-tabnine t)
      ;; The free version of TabNine is good enough,
      ;; and below code is recommended that TabNine not always
      ;; prompt me to purchase a paid version in a large project.
      (defadvice company-echo-show (around disable-tabnine-upgrade-message activate)
        (let ((company-message-func (ad-get-arg 0)))
          (when (and company-message-func
                     (stringp (funcall company-message-func)))
            (unless (string-match "The free version of TabNine only indexes up to" (funcall company-message-func))
              ad-do-it))))
      ))
  )

;;; packages.el ends here
