;;; funcs.el --- provide functions about tabnine
;;
;; Copyright (c) 2015-2019 Mephis Pheies
;;
;; Author: Mephis Pheies <mephistommm@gmail.com>
;; URL: https://github.com/MephistoMMM/memacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

(defun tabnine//merge-company-tabnine-to-company-lsp ()
  (when (memq 'company-lsp company-backends)
    (setq-local company-backends (remove 'company-lsp company-backends))
    (add-to-list 'company-backends '(company-lsp :with company-tabnine :separate)))
  )

(defun tabnine//company-box-icons--tabnine (candidate)
  (when (eq (get-text-property 0 'company-backend candidate)
            'company-tabnine)
    'Reference))

(defun tabnine//sort-by-tabnine (candidates)
  "The first two candidates will be from company-lsp, the following two
candidates will be from company-tabnine, others keeping their own origin order."
  (if (or (functionp company-backend)
         (not (and (listp company-backend) (memq 'company-tabnine company-backend))))
      candidates
    (let ((candidates-table (make-hash-table :test #'equal))
          candidates-1
          candidates-2)
      (dolist (candidate candidates)
        (if (eq (get-text-property 0 'company-backend candidate)
                'company-tabnine)
            (unless (gethash candidate candidates-table)
              (push candidate candidates-2))
          (push candidate candidates-1)
          (puthash candidate t candidates-table)))
      (setq candidates-1 (nreverse candidates-1))
      (setq candidates-2 (nreverse candidates-2))
      (nconc (seq-take candidates-1 2)
             (seq-take candidates-2 2)
             (seq-drop candidates-1 2)
             (seq-drop candidates-2 2)))))

;;; funcs.el ends here
