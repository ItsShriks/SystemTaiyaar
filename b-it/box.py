import cv2

def draw_box_and_get_center(image_path, box_start, box_end, box_color=(0, 255, 0), thickness=2):
    """
    Draws a box on an image and calculates its center, width, and height.

    Args:
    - image_path (str): Path to the input image.
    - box_start (tuple): Top-left corner of the box (x, y).
    - box_end (tuple): Bottom-right corner of the box (x, y).
    - box_color (tuple): Color of the box in BGR (default: green).
    - thickness (int): Thickness of the box lines.

    Returns:
    - center (tuple): Coordinates of the box center (x, y).
    - width (int): Width of the box.
    - height (int): Height of the box.
    """
    # Load the image
    image = cv2.imread(image_path)
    if image is None:
        print("Error: Could not load image.")
        return

    # Draw the box
    cv2.rectangle(image, box_start, box_end, box_color, thickness)

    # Calculate the center of the box
    center_x = (box_start[0] + box_end[0]) // 2
    center_y = (box_start[1] + box_end[1]) // 2
    center = (center_x, center_y)

    # Calculate width and height
    width = box_end[0] - box_start[0]
    height = box_end[1] - box_start[1]

    # Mark the center on the image
    cv2.circle(image, center, 5, (0, 0, 255), -1)  # Red dot for center

    # Save the modified image
    output_path = "output_image_with_box.jpg"
    cv2.imwrite(output_path, image)
    print(f"Image saved with box and center marked at: {output_path}")
    print(f"Center of the box: {center}")
    print(f"Width of the box: {width}, Height of the box: {height}")

    return center, width, height

# Example usage
video_path = "input_video.mp4"  # Replace with the path to your video file
output_image_path = "first_frame.jpg"  # Replace with your desired output image path
#get_first_frame(video_path, output_image_path)

# Example for drawing a box and getting center, width, and height
image_path = "first_frame.jpg"  # Image from video

box_start = (760, 80)  # Top-left corner of the box (x, y)
box_end = (1164, 1080)  # Bottom-right corner of the box (x, y)
draw_box_and_get_center(image_path, box_start, box_end)
