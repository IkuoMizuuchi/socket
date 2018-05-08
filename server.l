;;
;;  $Id$
;;
;;  Ikuo Mizuuchi
;;
;;  - Scratch 2018/05/08
;;
;;  - Description
;;    This program is for TCP/IP communication


(defvar *default-port* 9000)
(defvar *server* nil)

(defun start-server (func &key
			  (host (unix:gethostname))
			  (port *default-port*))
  (setq *server* (instance SocketServer :init func :host host :port port)))

(defun stop-server (&optional (server *server*))
  (send server :stop))

(defun sample-func-server (strm)
  (let (line)
    (while t
      (setq line (read-line strm nil :eof))
      (when (eq line :eof)
	(warn ";; connection has been closed.~%")
	(return-from sample-func-server nil))
      (warn ";; sample-func-server received: ~S~%" line)
      (when (string= "end" (subseq line 0 3))
	(warn ";; client has sent \"end\"~%")
	(warn ";; sample-func-server finished.~%")
	(return-from sample-func-server t))
      )))

(defclass SocketServer
  :super propertied-object
  :slots (listener-thread
	  sockport
	  listener-running
	  client-no
	  exec-func
	  )
  )

(defmethod SocketServer

  ;;
  (:init (func &key (host (unix:gethostname)) (port *default-port*))
    (setq listener-running nil)
    (setq client-no 0)
    (setq sockport (make-server-socket-until-success host port))
    (when (null sockport)
      (warn ";; Couldn't started server (~S:~A)~%" host port)
      (return-from :init))
    (setq exec-func func)
    (warn ";; Server host:~S port:~A~%" host (cdr sockport))
    (need-thread 1)
    (setq listener-thread (sys:thread-no-wait #'send self :listener (car sockport)))
    (setf (get listener-thread :name) "listener-thread")
    self)

  ;;
  (:listener (sport)
    (setq listener-running t)
    (warn ";; [listener] started listening...~%")
    (let (thr strm)
      (while listener-running
	(setq strm (make-server-socket-stream sport)) ;; wait for connection
	(when (io-stream-p strm)
	  (warn ";; [listener] connected! executing ~A~%" exec-func)
	  (need-thread 1)
	  (setq thr (sys:thread-no-wait #'send self :execute-func strm))
	  (setf (get thr :stream)
		(format nil "executor-~A" (incf client-no)))
	  )
	)
      (close strm)
      (warn ";; [listener] finished listening.~%")
      ))

  ;;
  (:execute-func (strm)
    (funcall exec-func strm)
    (warn ";; exec-func finished.~%")
    (close strm))

  ;;
  (:stop ()
    (setq listener-running nil)
    (warn ";; server will stop after a while..~%"))

  ) ;; end of defmethod


(defun make-server-socket-until-success (host port)
  (let (saddr sport s max-port)
    (if (not host) (setq host (unix:gethostname)))
    (setq max-port (+ port 20))
    ;;
    (while (< port max-port)
      (setq saddr (make-socket-address :domain af_inet
					:host host
					:port port))
      ;;
      (if (derivedp (setq s (make-socket-port saddr)) socket-port) 
	  (return))
      (incf port))
    ;;
    (cond
	((< port max-port)
	 (warn ";;; Made a server socket: Port ~a~%" port)
	 (cons s port))
        (t
	 (warn ";;; Couldn't make a server socket.~%")
	 nil))
    ))


(provide :server)

