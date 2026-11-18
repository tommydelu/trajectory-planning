/*---------------------------------------------------------------------------------------------------------------------------------------------------------------
/ Scanning node: design a trajectory that scan all the cubes from the top, by exploiting the fact that when a cube is inside the camera's FOV, its position will / be automaticaly published thanks to a lua script attached to the camera.
/ Steps:
/ 1) Create a subscriber: subscribe to /current_pose a get the current pose of the attachpoint/end-effector
/ 2) Check that current pose is w.r.t the correct frame, otherwise use tf to get the correct one
/ 3) Once we have the starting point of the trajectory, looking at the scene understand where you want the trajectory to pass through
/ 4) Design the trajectory using composition of geometric primitives (rectilinear and circular paths) with a trapezoidale time law
/ 5) Define a time vector with Fc = simulation step, and at each step publish on /desired_pose the Pose for the EE to reach
/ 6) When the trajectory is completed, send a message so that other tasks can start
/ 7) Handle case of cubes not found
---------------------------------------------------------------------------------------------------------------------------------------------------------------*/
#include <memory>
#include "rclcpp/rclcpp.hpp"

using std::placeholders::_1;

class Scanner: public rclcpp::Node
{
    public:
        Scanner(): Node("scanner"){
            subscription_ = this->create_subscription<>("/current_pose", 10, std::bind(&Scanner::topic_callback, this, _1)); //Insert current_pose msg type
        }

    private:
        void topic_callback(const ){
            RCLCPP_INFO(this->get_logger(), "I heard: '%s'", msg->data.c_str()); //Insert current_pose msg type
        }
        rclcpp::Subscription<>SharedPtr subscription_; //Insert current_pose msg type
}

int main(int argc, char * argv[]){
    rclcpp::init(argc, argv);
    rclcpp::spin(std::make_shared<Scanner>());
    rclcpp::shutdown();
    return 0;
}
