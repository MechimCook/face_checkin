import sys
import numpy as np
from PIL import Image
import face_recognition

img_path = sys.argv[1]
image = face_recognition.load_image_file(img_path)
encodings = face_recognition.face_encodings(image)
if encodings:
    print(",".join(str(x) for x in encodings[0]))
else:
    print("")