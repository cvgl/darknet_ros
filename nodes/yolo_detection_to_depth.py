#!/usr/bin/env python

""" yolo_detection_to_depth.py - Version 1.1 2017-03-18

    Compute the average depth over each bounding boxe returned by YOLO
    
    Created for the Jackrabbot Project: http://cvgl.stanford.edu/projects/jackrabbot/
    Copyright (c) 2017 Patrick Goebel & Stanford University.  All rights reserved.

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
from darknet_msgs.msg import bbox_array_stamped
from people_msgs.msg import People, Person
from jsk_recognition_msgs.msg import BoundingBoxArray, BoundingBox
from tf2_geometry_msgs import PointStamped, PoseStamped
from geometry_msgs.msg import PoseArray
import tf2_ros
import numpy as np
from math import isnan, isinf
import os

class Detection2Depth():
    def __init__(self):
        rospy.init_node('yolo_detection_to_depth')
        
        rospy.on_shutdown(self.shutdown)
        
        # Displacement of the depth camera back from the front of the robot in meters
        self.camera_displacement = 0.612
        
        self.display_depth_image = False
        
        self.base_link = rospy.get_param('~base_link', 'sibot/base_link')
        
        self.depth_frame = rospy.get_param('~depth_frame', 'sibot/camera_rgb_optical_frame')

        self.tfBuffer = tf2_ros.Buffer()
        tf_listener = tf2_ros.TransformListener(self.tfBuffer)
        
        # Keep a list of peope as a People message
        self.people = People()
        self.people.header.frame_id = self.base_link
        
        # Publish results as people_msgs/People messages
        self.people_pub = rospy.Publisher("people", People, queue_size=5)
        
        # Keep a list of peope poses as PoseArray message
        self.people_poses = PoseArray()
        self.people_poses.header.frame_id = self.base_link

        # Publish detections as a pose array
        self.people_poses_pub = rospy.Publisher("people_poses", PoseArray, queue_size=5)
        
        # Keep a list of people 3D bounding boxes as a BoundingBoxArray message
        self.people_bounding_boxes = BoundingBoxArray()
        self.people_bounding_boxes.header.frame_id = self.depth_frame
        
        # Publish detections as a JSK BoundingBoxArray for viewing in RViz
        self.people_bounding_boxes_pub = rospy.Publisher("people_bounding_boxes", BoundingBoxArray, queue_size=5)

        # Publish person pointclouds
        #self.people_cloud_pub = rospy.Publisher("people_clouds", PointCloud2, queue_size=5)
        
        # Use message filters to time synchronize the bboxes and the pointcloud
        self.bbox_sub = message_filters.Subscriber("yolo_bboxes", bbox_array_stamped, queue_size=10)
        self.pointcloud_sub = message_filters.Subscriber('point_cloud', PointCloud2, queue_size=10)
        
        # Register the synchronized callback
        self.time_sync = message_filters.ApproximateTimeSynchronizer([self.bbox_sub, self.pointcloud_sub], 10, 2)
        self.time_sync.registerCallback(self.get_bbox_cog)
        
        rospy.loginfo("Getting detections from YOLO...")
        
    def get_bbox_cog(self, yolo_boxes, cloud):
        # Clear the people array
        self.people.people = list()
        
        # Clear the people pose array
        self.people_poses.poses = list()
        
        # Clear the bounding box array
        self.people_bounding_boxes.boxes = list()
    
        for detection in yolo_boxes.bboxes:
            if detection.Class == 'person':                
                bbox = [detection.xmin, detection.ymin, detection.xmax, detection.ymax]
                #try:
                person_pose, person_bounding_box = self.get_bbox_pose(bbox, cloud)
                if person_pose is None:
                    continue
                #except:
                #    print person_pose, person_bounding_box
                #    os._exit(1)
                
                self.people_poses.poses.append(person_pose.pose)
                self.people_bounding_boxes.boxes.append(person_bounding_box)
                
                person = Person()
                person.position = person_pose.pose.position
                #person.position.z = 0.0
                person.name = str(len(self.people.people))
                person.reliability = 1.0
                 
                self.people.people.append(person)
                
        self.people.header.stamp = rospy.Time.now()
        self.people_pub.publish(self.people)
        
        self.people_poses.header.stamp = rospy.Time.now()
        self.people_poses_pub.publish(self.people_poses)
        
        self.people_bounding_boxes.header.stamp = rospy.Time.now()
        self.people_bounding_boxes_pub.publish(self.people_bounding_boxes)
                        
    def get_bbox_pose(self, bbox, cloud):
        # Initialize variables
        n = 0
        cog = [0]*3
        min_dim = [None]*3
        max_dim = [None]*3
        cloud_dim = [0]*3
          
        # Get the width and height of the bbox
        width = bbox[2] - bbox[0]
        height = bbox[3] - bbox[1]

        # Shrink the bbox by 10% to minimize background points
        xmin = bbox[0] + int(0.1 * width)
        xmax = bbox[2] - int(0.1 * width)
        ymin = bbox[1] + int(0.1 * height)
        ymax = bbox[3] - int(0.1 * height)
        
        # Place all the box points in an array to be used by the read_points function below
        bbox_points = [[x, y] for x in range(xmin, xmax) for y in range(ymin, ymax)]
        
        # Clear the current list
        person_points = list()
        
        # Read in the x, y, z coordinates of all bbox points in the cloud
        for point in point_cloud2.read_points(cloud, skip_nans=True, uvs=bbox_points):
            try:
                for i in range(3):
                    if min_dim[i] is None or point[i] <  min_dim[i]:
                        min_dim[i] = point[i]

                    if max_dim[i] is None or point[i] >  max_dim[i]:
                        max_dim[i] = point[i]
                  
                    cog[i] += point[i]

                n += 1
                
                #person_points.append(point)
            except:
                pass
        
        # Publish the pointcloud for this person
        #person_cloud = point_cloud2.create_cloud(cloud.header, cloud.fields, person_points)
        #self.people_cloud_pub.publish(person_cloud)
          
        # If we don't have any points, just return empty handed
        if n == 0:
            return (None, None)
                
        # Compute the COG and dimensions of the bounding box
        for i in range(3):
            cog[i] /= n
            cloud_dim[i] = max_dim[i] - min_dim[i]
        
        # Fill in the person pose message
        person_cog = PoseStamped()
        person_cog.header.frame_id = self.depth_frame
        person_cog.header.stamp = rospy.Time.now()
        
        person_cog.pose.position.x = cog[0]
        person_cog.pose.position.y = cog[1]
        person_cog.pose.position.z = cog[2]
        
        # Project the COG onto the base frame
        try:
            person_in_base_frame = self.tfBuffer.transform(person_cog, self.base_link)
        except (tf2_ros.LookupException, tf2_ros.ConnectivityException, tf2_ros.ExtrapolationException) as e:
            return (None, None)
        
        # Set the person on the ground
        person_in_base_frame.pose.position.z = 0.0
        
        person_in_base_frame.pose.orientation.x = 0.707
        person_in_base_frame.pose.orientation.y = 0.0
        person_in_base_frame.pose.orientation.z = 0.707
        person_in_base_frame.pose.orientation.w = 0.0
        
        # Fill in the BoundBox message
        person_bounding_box = BoundingBox()
        person_bounding_box.header.frame_id = self.depth_frame
        person_bounding_box.header.stamp = rospy.Time.now()
        person_bounding_box.pose = person_in_base_frame.pose
        person_bounding_box.dimensions.x = cloud_dim[0]
        person_bounding_box.dimensions.y = cloud_dim[1]
        person_bounding_box.dimensions.z = cloud_dim[2]
        
        return (person_in_base_frame, person_bounding_box)

            
    def shutdown(self):
        pass
    
if __name__ == '__main__':
    try:
        Detection2Depth()
        rospy.spin()
    except rospy.ROSInterruptException:
        rospy.loginfo("YOLO detection to depth node shutdown.")
