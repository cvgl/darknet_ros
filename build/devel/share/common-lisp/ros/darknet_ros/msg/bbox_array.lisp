; Auto-generated. Do not edit!


(cl:in-package darknet_ros-msg)


;//! \htmlinclude bbox_array.msg.html

(cl:defclass <bbox_array> (roslisp-msg-protocol:ros-message)
  ((bboxes
    :reader bboxes
    :initarg :bboxes
    :type (cl:vector darknet_ros-msg:bbox)
   :initform (cl:make-array 0 :element-type 'darknet_ros-msg:bbox :initial-element (cl:make-instance 'darknet_ros-msg:bbox))))
)

(cl:defclass bbox_array (<bbox_array>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <bbox_array>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'bbox_array)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name darknet_ros-msg:<bbox_array> is deprecated: use darknet_ros-msg:bbox_array instead.")))

(cl:ensure-generic-function 'bboxes-val :lambda-list '(m))
(cl:defmethod bboxes-val ((m <bbox_array>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader darknet_ros-msg:bboxes-val is deprecated.  Use darknet_ros-msg:bboxes instead.")
  (bboxes m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <bbox_array>) ostream)
  "Serializes a message object of type '<bbox_array>"
  (cl:let ((__ros_arr_len (cl:length (cl:slot-value msg 'bboxes))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_arr_len) ostream))
  (cl:map cl:nil #'(cl:lambda (ele) (roslisp-msg-protocol:serialize ele ostream))
   (cl:slot-value msg 'bboxes))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <bbox_array>) istream)
  "Deserializes a message object of type '<bbox_array>"
  (cl:let ((__ros_arr_len 0))
    (cl:setf (cl:ldb (cl:byte 8 0) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 16) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 24) __ros_arr_len) (cl:read-byte istream))
  (cl:setf (cl:slot-value msg 'bboxes) (cl:make-array __ros_arr_len))
  (cl:let ((vals (cl:slot-value msg 'bboxes)))
    (cl:dotimes (i __ros_arr_len)
    (cl:setf (cl:aref vals i) (cl:make-instance 'darknet_ros-msg:bbox))
  (roslisp-msg-protocol:deserialize (cl:aref vals i) istream))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<bbox_array>)))
  "Returns string type for a message object of type '<bbox_array>"
  "darknet_ros/bbox_array")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'bbox_array)))
  "Returns string type for a message object of type 'bbox_array"
  "darknet_ros/bbox_array")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<bbox_array>)))
  "Returns md5sum for a message object of type '<bbox_array>"
  "613de85f8f2e98bde9842eeca3735a25")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'bbox_array)))
  "Returns md5sum for a message object of type 'bbox_array"
  "613de85f8f2e98bde9842eeca3735a25")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<bbox_array>)))
  "Returns full string definition for message of type '<bbox_array>"
  (cl:format cl:nil "bbox[] bboxes~%~%================================================================================~%MSG: darknet_ros/bbox~%string Class~%int64 xmin~%int64 ymin~%int64 xmax~%int64 ymax~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'bbox_array)))
  "Returns full string definition for message of type 'bbox_array"
  (cl:format cl:nil "bbox[] bboxes~%~%================================================================================~%MSG: darknet_ros/bbox~%string Class~%int64 xmin~%int64 ymin~%int64 xmax~%int64 ymax~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <bbox_array>))
  (cl:+ 0
     4 (cl:reduce #'cl:+ (cl:slot-value msg 'bboxes) :key #'(cl:lambda (ele) (cl:declare (cl:ignorable ele)) (cl:+ (roslisp-msg-protocol:serialization-length ele))))
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <bbox_array>))
  "Converts a ROS message object to a list"
  (cl:list 'bbox_array
    (cl:cons ':bboxes (bboxes msg))
))
