from PIL import Image
import numpy as np

file_path = "vga_controller\\output.txt"

def ppm_to_array_with_pillow(file_path):
    with Image.open(file_path) as img:
        # Convert the image to a numpy array
        rgb_array = np.array(img)

    return rgb_array

# Example usage
image_array = ppm_to_array_with_pillow(file_path)

image = Image.fromarray(image_array)
image.show()
image.save("image.png")
