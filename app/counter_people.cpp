#include <opencv2/opencv.hpp>
#include <syslog.h>
#include <thread>
#include <atomic>
#include <iostream>

class Detector {
public:
    Detector() : people_count(0) {
        // Load the pre-trained Haar Cascade classifier for full body detection
        body_cascade.load("../opencv-4.10.0/data/haarcascades/haarcascade_fullbody.xml");

        // Initialize the RTSP stream (replace with your camera URL)
        capture.open("rtsp://127.0.0.1/axis-media/media.amp");

        if (!capture.isOpened()) {
            std::cerr << "Error: Could not open RTSP stream" << std::endl;
        }
    }

    // Detect people in the frame
    cv::Mat detect_people(cv::Mat& frame) {
        cv::Mat gray;
        cv::cvtColor(frame, gray, cv::COLOR_BGR2GRAY); // Convert to grayscale

        std::vector<cv::Rect> bodies;
        body_cascade.detectMultiScale(gray, bodies, 1.1, 5, 0, cv::Size(30, 30));

        people_count = bodies.size(); // Update the count

        // Draw rectangles around detected people
        for (const auto& body : bodies) {
            cv::rectangle(frame, body, cv::Scalar(0, 255, 0), 2);
        }

        return frame;
    }

    // Capture a single frame from the RTSP stream
    bool get_frame(cv::Mat& processed_frame) {
        cv::Mat frame;
        if (!capture.read(frame)) {
            std::cerr << "Error: Failed to capture frame" << std::endl;
            return false;
        }

        processed_frame = detect_people(frame); // Detect people in the frame
        return true;
    }

    int get_people_count() const {
        return people_count;
    }

private:
    int people_count;
    cv::CascadeClassifier body_cascade;
    cv::VideoCapture capture;
};

int main() {
    // Initialize the detector
    Detector detector;

    // Open the syslog to report messages for "people_counter"
    openlog("people_counter", LOG_PID | LOG_CONS, LOG_USER);

    // Loop to process video frames
    while (true) {
        cv::Mat frame;
        bool success = detector.get_frame(frame);

        if (!success) {
            std::cerr << "Error: Failed to capture frame" << std::endl;
            break;
        }

        // Log the current people count to syslog
        int count = detector.get_people_count();
        syslog(LOG_INFO, "People count: %d", count); // Log the people count

        // Optionally, display the frame with detected people (for debugging)
        cv::imshow("People Detection", frame);

        // Exit if 'q' is pressed
        if (cv::waitKey(1) == 'q') {
            break;
        }
    }

    // Close syslog when done
    closelog();

    cv::destroyAllWindows();
    return 0;
}
