(defconst smart-input-source-packages
  '(sis))

(defun fcitx5-dbus-call-method (method)
  (dbus-call-method :session
                    "org.fcitx.Fcitx5"
                    "/controller"
                    "org.fcitx.Fcitx.Controller1"
                    method))

(defun smart-input-source/init-sis ()
  (use-package sis
    :init
    (progn
      (setq sis-english-source 1)
      (setq-default sis-other-source 2))
    :config
    (progn
      (require 'dbus)
      (setq sis-do-get
            (lambda ()
              (fcitx5-dbus-call-method "State")))
      (setq sis-do-set
            (lambda (source)
              (pcase source
                (1 (fcitx5-dbus-call-method "Deactivate"))
                (2 (fcitx5-dbus-call-method "Activate")))))
      (setq sis-inline-tighten-head-rule 0)
      (sis-global-respect-mode t)
      (sis-global-follow-context-mode t)
      (sis-global-inline-mode t))
    ))
