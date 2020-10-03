import numpy as np
import matplotlib.pyplot as plt
from scipy.spatial.transform import Rotation as Rot


display_settings = dict(xticks=[], yticks= [], xlim=(-0.4,0.4), ylim=(-0.4,0.4), frameon=False)
 

colors = [ "#fafafa", "#ff6f00", "#009f0f", "#cf0000", "#00008f", "#ffcf00"]

square_polygon = np.array([[1, 1, 0],
                   [1, -1, 0],
                   [-1, -1, 0],
                   [-1, 1, 0],
                   [1, 1, 0]], dtype=float)

margin = 0.05 # precent
face_size = 1.
face_unit = face_size / 2
sitker_size = (1 - margin) * face_unit

face_frame = np.copy(square_polygon)
face_frame[:,:2] *= face_size

stiker = np.copy(square_polygon)
stiker[:,:2] *= sitker_size

x_axis = np.array([1.,0.,0.],dtype=float)
y_axis = np.array([0.,1.,0.],dtype=float)
z_axis = np.array([0.,0.,1.],dtype=float)