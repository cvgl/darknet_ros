#!/usr/bin/env python

""" yolo_detection_to_depth.py - Version 1.1 2017-03-18

    Compute the average depth over each bounding boxe returned by YOLO
    
    Created for the Pi Robot Project: http://www.pirobot.org
    Copyright (c) 2017 Patrick Goebel.  All rights reserved.

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.
    
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details at:
    
    http://www.gnu.org/licenses/gpl.html
"""

import rospy
import message_filters
from sensor_msgs import point_cloud2
from sensor_msgs.msg import PointCloud2
from darknet_ros.msg import bbox_array_stamped
from people_msgs.msg import People, Person
from tf2_geometry_msgs import PointStamped, PoseStamped
import tf2_ros
import numpy as np
from math import isnan, isinf

class Detection2Depth():
    def __init__(self):
        rospy.init_node('yolo_detection_to_depth')
        
        rospy.on_shutdown(self.shutdown)
        
        # Displacement of the depth camera back from the front of the robot in meters
        self.camera_displacement = 0.612
        
        self.display_depth_image = False
        
        self.base_link = 'sibot/base_link'
        
        self.depth_frame = 'sibot/camera_rgb_optical_frame'

        self.tfBuffer = tf2_ros.Buffer()
        tf_listener = tf2_ros.TransformListener(self.tfBuffer)
        
        self.people = People()
        self.people.header.frame_id = self.base_link
        
        self.people_pub = rospy.Publisher("people", People, queue_size=5)
        
        self.people_cloud_pub = rospy.Publisher("people_clouds", PointCloud2, queue_size=5)
        
        # Use message filters to time synchronize the bboxes and the pointcloud
        self.bbox_sub = message_filters.Subscriber("yolo_bboxes", bbox_array_stamped, queue_size=10)
        self.pointcloud_sub = message_filters.Subscriber('point_cloud', PointCloud2, queue_size=10)
        
        self.time_sync = message_filters.ApproximateTimeSynchronizer([self.bbox_sub, self.pointcloud_sub], 10, 2)
        self.time_sync.registerCallback(self.get_bbox_cog)
        
        rospy.loginfo("Getting detections from YOLO...")
        
    def get_bbox_cog(self, yolo_boxes, cloud):
        # Clear the people array
        self.people.people = list()
        
        for detection in yolo_boxes.bboxes:
            if detection.Class == 'person':                
                bbox = [detection.xmin, detection.ymin, detection.xmax, detection.ymax]
                cog = self.get_bbox_cloud(bbox, cloud)
                try:
                    if cog == PointCloud2():
                        continue
                except:
                    continue
                 
                person = Person()
                person.position = cog.pose.position
                person.name = str(len(self.people.people))
                 
                self.people.people.append(person)
        
        self.people.header.stamp = rospy.Time.now()
        self.people_pub.publish(self.people)
                        
    def get_bbox_cloud(self, bbox, cloud):
        # Initialize the centroid coordinates point count
        x = y = z = n = 0
          
        # Shrink the bbox by 10% to minimize background points
        width = bbox[2] - bbox[0]
        height = bbox[3] - bbox[1]
           
        xmin = bbox[0] + int(0.1 * width)
        xmax = bbox[2] - int(0.1 * width)
        ymin = bbox[1] + int(0.1 * height)
        ymax = bbox[3] - int(0.1 * height)
        
        # Place all the box points in an array to be used by the read_points function below
        bbox_points = [[x, y] for x in range(xmin, xmax) for y in range(ymin, ymax)]
        
        person_points = list()
        
        # Read in the x, y, z coordinates of all bbox points in the cloud
        for point in point_cloud2.read_points(cloud, skip_nans=True, uvs=bbox_points):
            try:
                pt_x = point[0]
                pt_y = point[1]
                pt_z = point[2]
                  
                x += pt_x
                y += pt_y
                z += pt_z
                n += 1
                
                person_points.append(point)
            except:
                pass
            
        person_cloud = point_cloud2.create_cloud(cloud.header, cloud.fields, person_points)
        
        self.people_cloud_pub.publish(person_cloud)
          
        # If we have points, compute the centroid coordinates
        if n == 0:
            rospy.logwarn("NO POINTS!")
            return PointStamped()
        
        x /= n 
        y /= n 
        z /= n
        
        # Transform the COG into the base frame
        cog = PoseStamped()
        cog.header.frame_id = self.depth_frame
        cog.header.stamp = rospy.Time.now()
        
        cog.pose.position.x = x
        cog.pose.position.y = y
        cog.pose.position.z = z
        
        cog.pose.orientation.w = 1.0
        
        # Project the COG onto the base frame
        try:
            cog_in_base_frame = self.tfBuffer.transform(cog, self.base_link)
        except (tf2_ros.LookupException, tf2_ros.ConnectivityException, tf2_ros.ExtrapolationException) as e:
            return PoseStamped()
        
        return cog_in_base_frame

            
    def shutdown(self):
        pass
    
if __name__ == '__main__':
    try:
        Detection2Depth()
        rospy.spin()
    except rospy.ROSInterruptException:
        rospy.loginfo("YOLO detection to depth node shutdown.")