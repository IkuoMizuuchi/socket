;;
;;  client.l
;;  $Id$
;;
;;  Ikuo Mizuuchi
;;
;;  - Scratch 2018/05/08
;;
;;  - Description
;;    This program is for TCP/IP communication


(defvar *default-port* 9000)
(defvar *s* nil)

(defun connect-host (&key (host (unix:gethostname))
			  (port *default-port*))
  (setq *s* (connect-server-until-success host port)))

;; connect-server-until-success is defined in rbrapp/app/nerve/nerve.l
(if (not (fboundp 'connect-server-until-success))

(defun connect-server-until-success (host port)
  (let (s max-port)
    (setq max-port (+ port 20))
    (while (and (not (streamp (setq s (connect-server host port))))
		(< port max-port))
      (incf port))
    (cond ((< port max-port)
	   (warn ";;; Connected server: Port ~a~%" port)
	   s)
	  (t
	   (warn "Can't connect server.~%")
	   nil))
    ))
)

(provide :client)
