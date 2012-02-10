;;;
;;; Copy this contents to "~/.mew.el".el;;;
;;; Or, copy this file to a file, say "~/.mew-theme.el" and
;;; put the following to "~/.mew.el".el;;;(setq mew-theme-file "~/.mew-theme.el")

;;;; COPY FROM HERE

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Highlight header
;;;

(mew-setface header-subject
  :tty "red" :light "Firebrick" :dark "OrangeRed")

(mew-setface header-from
  :tty "yellow" :light "DarkOrange4" :dark "Gold")

(mew-setface header-date
  :tty "green" :light "ForestGreen" :dark "LimeGreen")

(mew-setface header-to
  :tty "magenta" :light "DarkViolet" :dark "violet")

(mew-setface header-key
  :tty "green" :light "ForestGreen" :dark "LimeGreen")

(mew-setface header-private)

(mew-setface header-important
  :tty "cyan" :light "MediumBlue" :dark "SkyBlue")

(mew-setface header-marginal
  :light "gray50" :dark "gray50")

(mew-setface header-warning
  :tty "red" :light "red" :dark "red")

(mew-setface header-xmew
  :tty "yellow" :light "chocolate" :dark"chocolate")

(mew-setface header-xmew-bad
  :tty "red" :light "red" :dark "red")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Highlight body
;;;

(mew-setface-bold body-url
  :tty "red" :light "Firebrick" :dark "OrangeRed")

(mew-setface body-comment
  :tty "blue" :light "gray50" :dark "gray50")

(mew-setface body-cite1
  :tty "green" :light "ForestGreen" :dark "LimeGreen")

(mew-setface body-cite2
  :tty "cyan" :light "MediumBlue" :dark "SkyBlue")

(mew-setface body-cite3
  :tty "magenta" :light "DarkViolet" :dark "violet")

(mew-setface body-cite4
  :tty "yellow" :light "DarkOrange4" :dark "Gold")

(mew-setface body-cite5
  :tty "red" :light "Firebrick" :dark "OrangeRed")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Highlight mark
;;;

(mew-setface mark-review
  :tty "cyan" :light "MediumBlue" :dark "SkyBlue")

(mew-setface mark-escape
  :tty "magenta" :light "DarkViolet" :dark "violet")

(mew-setface mark-delete
  :tty "red" :light "Firebrick" :dark "OrangeRed")

(mew-setface mark-unlink
  :tty "yellow" :light "DarkOrange4" :dark "Gold")

(mew-setface mark-refile
  :tty "green" :light "ForestGreen" :dark "LimeGreen")

(mew-setface mark-unread)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Highlight eof
;;;

(mew-setface eof-message
  :tty "green" :light "ForestGreen" :dark "LimeGreen")

(mew-setface eof-part
  :tty "yellow" :light "DarkOrange4" :dark "Gold")

;;;; COPY TO HERE
