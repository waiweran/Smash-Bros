from PIL import Image
import numpy as np

im = Image.open("bowser1.png")
data = np.asarray(im, dtype=np.uint8)
np.savetxt("bowser1.txt", data.ravel(), fmt='%i')