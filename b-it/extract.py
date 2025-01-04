import cv2

def get_first_frame(video_path, output_image_path):
    # Open the video file
    cap = cv2.VideoCapture(video_path)

    if not cap.isOpened():
        print("Error: Could not open the video file.")
        return

    # Read the first frame
    ret, frame = cap.read()

    if ret:
        # Save the first frame as an image
        cv2.imwrite(output_image_path, frame)
        print(f"First frame saved to {output_image_path}")
    else:
        print("Error: Could not read the first frame.")

    # Release the video capture object
    cap.release()

# Example usage
video_path = "SAMURAI_Test.mp4"  # Replace with the path to your video file
output_image_path = "first_frame.jpg"  # Replace with your desired output image path
get_first_frame(video_path, output_image_path)
