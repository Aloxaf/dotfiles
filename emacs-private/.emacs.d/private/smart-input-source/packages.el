(defconst smart-input-source-packages
  '(smart-input-source))

(defun smart-input-source/init-smart-input-source ()
  (use-package smart-input-source
    :init
    (progn
      (setq smart-input-source-external-ism "fcitx5-remote")
      (setq smart-input-source-english 1)
      (setq-default smart-input-source-other 2))
    :config
    (progn
      (require 'dbus)
      (setq smart-input-source-do-get
            (lambda ()
              (dbus-call-method :session
                                "org.fcitx.Fcitx5"
                                "/controller"
                                "org.fcitx.Fcitx.Controller1"
                                "State")))
      (setq smart-input-source-do-set
            (lambda (source)
              (pcase source
                (1 (dbus-call-method :session
                                     "org.fcitx.Fcitx5"
                                     "/controller"
                                     "org.fcitx.Fcitx.Controller1"
                                     "Deactivate"))
                (2 (dbus-call-method :session
                                     "org.fcitx.Fcitx5"
                                     "/controller"
                                     "org.fcitx.Fcitx.Controller1"
                                     "Activate"))))))
    (smart-input-source-global-respect-mode t)
    (smart-input-source-global-follow-context-mode t)
    (smart-input-source-global-inline-english-mode t)
    ))
