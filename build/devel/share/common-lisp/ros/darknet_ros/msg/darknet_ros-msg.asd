
(cl:in-package :asdf)

(defsystem "darknet_ros-msg"
  :depends-on (:roslisp-msg-protocol :roslisp-utils )
  :components ((:file "_package")
    (:file "bbox_array" :depends-on ("_package_bbox_array"))
    (:file "_package_bbox_array" :depends-on ("_package"))
    (:file "bbox" :depends-on ("_package_bbox"))
    (:file "_package_bbox" :depends-on ("_package"))
  ))