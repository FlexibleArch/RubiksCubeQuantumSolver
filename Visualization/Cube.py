from .Common import *
from .Face import Face

class Cube():
    def __init__(self, stikers = None):
        
        self.__init_stikers(stikers)
        self.__reset_structure()
        self.__warp_to_3d_cube()
 
    def __init_stikers(self, stikers):
        if stikers is None:
            self._stikers = [[i]*4 for i in range(6)]
        else:
            self._stikers = stikers
        
    def __reset_structure(self):
        self._faces = [Face(face_stikers) for face_stikers in self._stikers]
        self._faces_names = ["Front", "Down", "Back", "Top", "Left", "Right"]
        self._center = np.array([0,0,0], dtype=float)
        
    def render(self, axes : plt.Axes):
        for face, name in zip(self._faces, self._faces_names):
            face.render(axes, name[0])
            
    def rotate(self, axis, angle):
        for face in self._faces:
            face.rotate(axis, angle)
    
    def move(self, translation):
        for face in self._faces:
            face.move(translation)
            
    def __tilt_to_present(self):
        self.rotate(x_axis, -0.4)
        self.rotate(y_axis, -0.6)
        self.rotate(x_axis, -0.2)
    
    def __untilt_to_present(self):
        self.rotate(x_axis, 0.2)
        self.rotate(y_axis, 0.6)
        self.rotate(x_axis, 0.4)
        
    def __warp_to_3d_cube(self):
        shift = face_unit*2
        
        # Front face
        self._faces[0].move_without_center(z_axis * shift)
        
        # Bottom face
        self._faces[1].rotate(x_axis, np.pi/2)
        self._faces[1].move_without_center(y_axis * shift)
        
        # Back face
        self._faces[2].rotate(x_axis, np.pi)
        self._faces[2].move_without_center(-z_axis * shift)
        
        # Top face
        self._faces[3].rotate(-x_axis, np.pi/2)
        self._faces[3].move_without_center(-y_axis * shift)
        
        # Left face
        self._faces[4].rotate(-y_axis, np.pi/2)
        self._faces[4].move_without_center(x_axis * shift)
        
        # Left Right
        self._faces[5].rotate(y_axis, np.pi/2)
        self._faces[5].move_without_center(-x_axis * shift)
        
    def plot_spread(self):
        raise "not implemented"
        
        
    def plot_3d_views(self):
        fig = plt.figure(figsize=(1.8, 1.8))
        ax_size = 2
        ax = plt.Axes(fig, rect=[0, 0, ax_size, ax_size], **display_settings)
        
        self.move(-z_axis*8)

        self.__tilt_to_present()
        self.render(ax)
        self.__untilt_to_present()
        
        fig.add_axes(ax)
        
        self._fig = fig
        self._ax1 = ax
        
        ax = plt.Axes(fig, rect=[ax_size, 0, ax_size, ax_size], **display_settings)
        
        self.rotate(x_axis, np.pi/2)
        
        
        self.__tilt_to_present()
        self.render(ax)
        self.__untilt_to_present()

        fig.add_axes(ax)
        
        self._ax2 = ax
        
        ax = plt.Axes(fig, rect=[2 * ax_size, 0, ax_size, ax_size], **display_settings)
        
        self.rotate(y_axis, np.pi/2)
        self.rotate(x_axis, np.pi/2)
        
        
        self.__tilt_to_present()
        self.render(ax)
        self.__untilt_to_present()

        fig.add_axes(ax)
        
        
        self._ax3 = ax
        
        plt.show()
        print("F-Front; D-Down; B-Back; T-Top; L-Left; R-Right")
        
        # Returning the cube to original position
        self.move(z_axis*8)
        self.rotate(x_axis, np.pi/2)
        self.rotate(y_axis, np.pi/2)
        self.rotate(x_axis, np.pi/2)
