# generated from genmsg/cmake/pkg-genmsg.cmake.em

message(STATUS "darknet_ros: 2 messages, 0 services")

set(MSG_I_FLAGS "-Idarknet_ros:/home/ubuntu/catkin_ws/src/darknet_ros/msg;-Istd_msgs:/opt/ros/indigo/share/std_msgs/cmake/../msg")

# Find all generators
find_package(gencpp REQUIRED)
find_package(genlisp REQUIRED)
find_package(genpy REQUIRED)

add_custom_target(darknet_ros_generate_messages ALL)

# verify that message/service dependencies have not changed since configure



get_filename_component(_filename "/home/ubuntu/catkin_ws/src/darknet_ros/msg/bbox_array.msg" NAME_WE)
add_custom_target(_darknet_ros_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "darknet_ros" "/home/ubuntu/catkin_ws/src/darknet_ros/msg/bbox_array.msg" "darknet_ros/bbox"
)

get_filename_component(_filename "/home/ubuntu/catkin_ws/src/darknet_ros/msg/bbox.msg" NAME_WE)
add_custom_target(_darknet_ros_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "darknet_ros" "/home/ubuntu/catkin_ws/src/darknet_ros/msg/bbox.msg" ""
)

#
#  langs = gencpp;genlisp;genpy
#

### Section generating for lang: gencpp
### Generating Messages
_generate_msg_cpp(darknet_ros
  "/home/ubuntu/catkin_ws/src/darknet_ros/msg/bbox_array.msg"
  "${MSG_I_FLAGS}"
  "/home/ubuntu/catkin_ws/src/darknet_ros/msg/bbox.msg"
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/darknet_ros
)
_generate_msg_cpp(darknet_ros
  "/home/ubuntu/catkin_ws/src/darknet_ros/msg/bbox.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/darknet_ros
)

### Generating Services

### Generating Module File
_generate_module_cpp(darknet_ros
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/darknet_ros
  "${ALL_GEN_OUTPUT_FILES_cpp}"
)

add_custom_target(darknet_ros_generate_messages_cpp
  DEPENDS ${ALL_GEN_OUTPUT_FILES_cpp}
)
add_dependencies(darknet_ros_generate_messages darknet_ros_generate_messages_cpp)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/ubuntu/catkin_ws/src/darknet_ros/msg/bbox_array.msg" NAME_WE)
add_dependencies(darknet_ros_generate_messages_cpp _darknet_ros_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/ubuntu/catkin_ws/src/darknet_ros/msg/bbox.msg" NAME_WE)
add_dependencies(darknet_ros_generate_messages_cpp _darknet_ros_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(darknet_ros_gencpp)
add_dependencies(darknet_ros_gencpp darknet_ros_generate_messages_cpp)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS darknet_ros_generate_messages_cpp)

### Section generating for lang: genlisp
### Generating Messages
_generate_msg_lisp(darknet_ros
  "/home/ubuntu/catkin_ws/src/darknet_ros/msg/bbox_array.msg"
  "${MSG_I_FLAGS}"
  "/home/ubuntu/catkin_ws/src/darknet_ros/msg/bbox.msg"
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/darknet_ros
)
_generate_msg_lisp(darknet_ros
  "/home/ubuntu/catkin_ws/src/darknet_ros/msg/bbox.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/darknet_ros
)

### Generating Services

### Generating Module File
_generate_module_lisp(darknet_ros
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/darknet_ros
  "${ALL_GEN_OUTPUT_FILES_lisp}"
)

add_custom_target(darknet_ros_generate_messages_lisp
  DEPENDS ${ALL_GEN_OUTPUT_FILES_lisp}
)
add_dependencies(darknet_ros_generate_messages darknet_ros_generate_messages_lisp)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/ubuntu/catkin_ws/src/darknet_ros/msg/bbox_array.msg" NAME_WE)
add_dependencies(darknet_ros_generate_messages_lisp _darknet_ros_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/ubuntu/catkin_ws/src/darknet_ros/msg/bbox.msg" NAME_WE)
add_dependencies(darknet_ros_generate_messages_lisp _darknet_ros_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(darknet_ros_genlisp)
add_dependencies(darknet_ros_genlisp darknet_ros_generate_messages_lisp)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS darknet_ros_generate_messages_lisp)

### Section generating for lang: genpy
### Generating Messages
_generate_msg_py(darknet_ros
  "/home/ubuntu/catkin_ws/src/darknet_ros/msg/bbox_array.msg"
  "${MSG_I_FLAGS}"
  "/home/ubuntu/catkin_ws/src/darknet_ros/msg/bbox.msg"
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/darknet_ros
)
_generate_msg_py(darknet_ros
  "/home/ubuntu/catkin_ws/src/darknet_ros/msg/bbox.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/darknet_ros
)

### Generating Services

### Generating Module File
_generate_module_py(darknet_ros
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/darknet_ros
  "${ALL_GEN_OUTPUT_FILES_py}"
)

add_custom_target(darknet_ros_generate_messages_py
  DEPENDS ${ALL_GEN_OUTPUT_FILES_py}
)
add_dependencies(darknet_ros_generate_messages darknet_ros_generate_messages_py)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/ubuntu/catkin_ws/src/darknet_ros/msg/bbox_array.msg" NAME_WE)
add_dependencies(darknet_ros_generate_messages_py _darknet_ros_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/ubuntu/catkin_ws/src/darknet_ros/msg/bbox.msg" NAME_WE)
add_dependencies(darknet_ros_generate_messages_py _darknet_ros_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(darknet_ros_genpy)
add_dependencies(darknet_ros_genpy darknet_ros_generate_messages_py)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS darknet_ros_generate_messages_py)



if(gencpp_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/darknet_ros)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/darknet_ros
    DESTINATION ${gencpp_INSTALL_DIR}
  )
endif()
add_dependencies(darknet_ros_generate_messages_cpp std_msgs_generate_messages_cpp)

if(genlisp_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/darknet_ros)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/darknet_ros
    DESTINATION ${genlisp_INSTALL_DIR}
  )
endif()
add_dependencies(darknet_ros_generate_messages_lisp std_msgs_generate_messages_lisp)

if(genpy_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/darknet_ros)
  install(CODE "execute_process(COMMAND \"/usr/bin/python\" -m compileall \"${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/darknet_ros\")")
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/darknet_ros
    DESTINATION ${genpy_INSTALL_DIR}
  )
endif()
add_dependencies(darknet_ros_generate_messages_py std_msgs_generate_messages_py)
