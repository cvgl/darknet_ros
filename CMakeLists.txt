cmake_minimum_required(VERSION 2.8.12)
project(darknet_ros)

if(CMAKE_SIZEOF_VOID_P EQUAL 8) 
    set(arch_64 TRUE) 
else() 
    set(arch_64 FALSE) 
endif() 

find_package(CUDA REQUIRED)
find_package(OpenCV REQUIRED)
find_package(catkin REQUIRED COMPONENTS
  cv_bridge
  roscpp
  rospy
  std_msgs
  image_transport
)

catkin_package()

if(arch_64)
  set(
       ARCH
      -gencode=arch=compute_20,code=sm_20 
      -gencode=arch=compute_30,code=sm_30 
      -gencode=arch=compute_50,code=sm_50 
      -gencode=arch=compute_52,code=sm_52 
      -gencode=arch=compute_52,code=compute_52 
# Uncomment below for GTX-1070
#      -gencode=arch=compute_60,code=sm_60 
#      -gencode=arch=compute_61,code=sm_61 
#      -gencode=arch=compute_62,code=sm_62
   )
   set(
      CUDA_NVCC_FLAGS
      ${CUDA_NVCC_FLAGS};
      -O3
      ${ARCH}
      )
else()
   set(
      CUDA_NVCC_FLAGS
      ${CUDA_NVCC_FLAGS};
      -O3 -gencode arch=compute_53,code=sm_53
      )
endif()

add_definitions(-DGPU -DOPENCV)

include_directories(
  include
  $ENV{CUDA_HOME}/include
  src
  ${catkin_INCLUDE_DIRS}
)

if(arch_64)
  link_directories(
    $ENV{CUDA_HOME}/lib64
  )
else()
  link_directories(
    $ENV{CUDA_HOME}/lib
  )
endif()

cuda_add_executable(ROS_interface 
  src/ROS_interface.cpp

  src/gemm.c 			src/utils.c 
  src/cuda.c 			src/deconvolutional_layer.c 
  src/convolutional_layer.c 	src/list.c 
  src/image.c 			src/activations.c 
  src/im2col.c 			src/col2im.c 
  src/blas.c 			src/crop_layer.c 
  src/dropout_layer.c 		src/maxpool_layer.c 
  src/softmax_layer.c 		src/data.c 
  src/matrix.c 			src/network.c 
  src/connected_layer.c 	src/cost_layer.c 
  src/parser.c 			src/option_list.c 
  src/detection_layer.c		src/tag.c 
  src/imagenet.c 		src/captcha.c 
  src/route_layer.c 		src/writing.c 
  src/box.c 			src/nightmare.c 
  src/normalization_layer.c 	src/avgpool_layer.c 
  src/coco.c 			src/dice.c 
  src/yolo.c 			src/layer.c 
  src/compare.c 		src/classifier.c  
  src/local_layer.c 		src/shortcut_layer.c 
  src/activation_layer.c	src/cifar.c
  src/coco_demo.c		src/swag.c
  src/crnn_layer.c		src/go.c
  src/rnn.c			src/rnn_layer.c
  src/rnn_vid.c			

  src/convolutional_kernels.cu  src/deconvolutional_kernels.cu 
  src/activation_kernels.cu 	src/im2col_kernels.cu 
  src/col2im_kernels.cu 	src/blas_kernels.cu 
  src/crop_layer_kernels.cu 	src/dropout_layer_kernels.cu 
  src/maxpool_layer_kernels.cu  src/softmax_layer_kernels.cu 
  src/network_kernels.cu 	src/avgpool_layer_kernels.cu 
  src/yolo_kernels.cu)

cuda_add_executable(yolo_object_detector
  src/YOLO_object_detector.cpp

  src/gemm.c                    src/utils.c
  src/cuda.c                    src/deconvolutional_layer.c
  src/convolutional_layer.c     src/list.c
  src/image.c                   src/activations.c
  src/im2col.c                  src/col2im.c
  src/blas.c                    src/crop_layer.c
  src/dropout_layer.c           src/maxpool_layer.c
  src/softmax_layer.c           src/data.c
  src/matrix.c                  src/network.c
  src/connected_layer.c         src/cost_layer.c
  src/parser.c                  src/option_list.c
  src/detection_layer.c         src/tag.c
  src/imagenet.c                src/captcha.c
  src/route_layer.c             src/writing.c
  src/box.c                     src/nightmare.c
  src/normalization_layer.c     src/avgpool_layer.c
  src/yolo_obj_detector.c      src/layer.c
  src/compare.c                 src/classifier.c
  src/local_layer.c             src/shortcut_layer.c
  src/activation_layer.c        src/cifar.c
  src/crnn_layer.c              src/go.c
  src/rnn.c                     src/rnn_layer.c
  src/rnn_vid.c

  src/convolutional_kernels.cu  src/deconvolutional_kernels.cu
  src/activation_kernels.cu     src/im2col_kernels.cu
  src/col2im_kernels.cu         src/blas_kernels.cu
  src/crop_layer_kernels.cu     src/dropout_layer_kernels.cu
  src/maxpool_layer_kernels.cu  src/softmax_layer_kernels.cu
  src/network_kernels.cu        src/avgpool_layer_kernels.cu
  src/yolo_kernels_ROSobj_detector.cu)

add_dependencies(yolo_object_detector
  darknet_msgs_generate_messages_cpp
  ${catkin_EXPORTED_TARGETS}
)


target_link_libraries(ROS_interface
   m
   pthread
   stdc++
   cuda 
   cudart 
   cublas 
   curand
   ${catkin_LIBRARIES}
)

add_dependencies(ROS_interface
  darknet_msgs_generate_messages_cpp 
  ${catkin_EXPORTED_TARGETS}
)

target_link_libraries(yolo_object_detector
   m
   pthread
   stdc++
   cuda
   cudart
   cublas
   curand
   ${catkin_LIBRARIES}
)

add_dependencies(yolo_object_detector
  darknet_msgs_generate_messages_cpp
  ${catkin_EXPORTED_TARGETS}
)

