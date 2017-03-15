#include "ROS_interface.h"
#include <ros/ros.h>
#include <image_transport/image_transport.h>
#include <cv_bridge/cv_bridge.h>
#include <sensor_msgs/image_encodings.h>
#include <sensor_msgs/Image.h>
#include <ros/package.h>

extern "C" void demo_yolo();
extern "C" void load_network(const char *cfgfile, const char *weightfile, float thresh);

cv::Mat cam_image_copy;
const std::string cfg_file = ros::package::getPath("darknet_ros") + "/cfg/tiny-yolo.cfg";
const std::string weights_file = ros::package::getPath("darknet_ros") + "/weights/tiny-yolov1.weights";

const char *cfg = cfg_file.c_str();
const char *weights = weights_file.c_str();

float thresh = 0.3;
const std::string CAMERA_TOPIC_NAME = "/camera/rgb/image_raw";

IplImage* get_Ipl_image()
{
   IplImage* ROS_img = new IplImage(cam_image_copy);
   return ROS_img;
}

class ROS_interface
{
   ros::NodeHandle _nh;
   image_transport::ImageTransport _it;
   image_transport::Subscriber _image_sub;

public:
   ROS_interface() : _it(_nh)
   {
      _image_sub = _it.subscribe(CAMERA_TOPIC_NAME, 1, &ROS_interface::cameraCallback, this);
   }

private:
   void cameraCallback(const sensor_msgs::ImageConstPtr& msg)
   {
      std::cout << "usb image received" << std::endl;
      cv_bridge::CvImagePtr cam_image;

      try
      {
         cam_image = cv_bridge::toCvCopy(msg, sensor_msgs::image_encodings::BGR8);
      }
      catch (cv_bridge::Exception& e)
      {
         ROS_ERROR("cv_bridge exception: %s", e.what());
         return;
      }

      if (cam_image) {
         cam_image_copy = cam_image->image.clone();
         demo_yolo();
      }
      return;
   }
};

int main(int argc, char** argv)
{
   ros::init(argc, argv, "ROS_interface");

   load_network(cfg, weights, thresh);

   ROS_interface ri;
   ros::spin();
   return 0;
}
