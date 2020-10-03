import numpy as np
import re
import matplotlib.pyplot as plt
from scipy.spatial.transform import Rotation as Rot


display_settings = dict(xticks=[], yticks= [], xlim=(-0.4,0.4), ylim=(-0.4,0.4), frameon=False)
colors = [ "#fafafa", "#ff6f00", "#009f0f", "#cf0000", "#00008f", "#ffcf00"]

x_axis = np.array([1.,0.,0.],dtype=float)
y_axis = np.array([0.,1.,0.],dtype=float)
z_axis = np.array([0.,0.,1.],dtype=float)

stikers_count = 24
def translate_quantum_phase_into_cube_state(cube_state_str):
    stikers_state_strs = cube_state_str[cube_state_str.find("∣ 0❭"):].splitlines()[:stikers_count]
    stikers_phases = [float(re.findall(r"\[([0-9.\- rad]+)\]", s)[1].split()[0]) for s in stikers_state_strs]
    stikers_color_nums = [int(np.round(3 * phase / np.pi + 3)) for phase in stikers_phases]

    return np.reshape(stikers_color_nums, (4, 6)).T.tolist()


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
