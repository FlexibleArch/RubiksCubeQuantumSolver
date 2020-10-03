from .Common import *


def rotate_polygon(polygon : np.array, rotation : Rot):
    for point_ind in range(polygon.shape[0]):
        polygon[point_ind] = rotation.apply(polygon[point_ind])
    return polygon

def normlize_polygon(polygon : np.array):
    return np.divide(polygon[:,:2].T, polygon[:,2].T).T



class Face():
    def __init__(self, stikers_colors): 
        st1 = stiker - np.array([-face_unit, -face_unit, 0], dtype=float) 
        st2 = stiker - np.array([face_unit, -face_unit, 0], dtype=float) 
        st3 = stiker - np.array([-face_unit, face_unit, 0], dtype=float) 
        st4 = stiker - np.array([face_unit, face_unit, 0], dtype=float)
        
        if isinstance(stikers_colors, list):
            self._stikers_colors = [colors[ind] for ind in stikers_colors]
        else:
            self._stikers_colors =  ["#ff6f00"]*4
        
        self._stikers = [st1, st2, st3, st4]
        self._frame = np.copy(face_frame)
        self._center = np.array([0, 0, 0],dtype=float)
        
    def render(self, axes : plt.Axes, txt=None):
        center = np.mean(self._frame[:],axis=0)
        x = center[0]
        y = center[1]
        z = center[2]
        layer0 = z
        layer1 = z + 0.001       
        layer2 = z + 0.002       
        
        background_polygon = normlize_polygon(self._frame)
        bg_plt_polygon = plt.Polygon(background_polygon, 
                                     facecolor="black", 
                                     zorder=layer0)
        
        axes.add_patch(bg_plt_polygon)

        for stiker,color in zip(self._stikers, self._stikers_colors):
            stiker_polygon = normlize_polygon(stiker)
            st_plt_polygon = plt.Polygon(stiker_polygon[:,:2], 
                                         facecolor=color, 
                                         zorder=layer1)
            axes.add_patch(st_plt_polygon)
        
        
        if txt is not None:
            axes.text( x/z, y/z, txt, 
                    fontsize=28, zorder=layer2,
                    color="#00ff00")
            
        
            
    def move(self, translation : np.array):
        self._center += translation
        self.move_without_center(translation)


    def move_without_center(self, translation : np.array):
        self._frame +=  translation
        for st in self._stikers:
            st += translation
    
    def rotate(self, axis : np.array, angle : float):
        R = Rot.from_rotvec(axis*angle)
        rot_center = self._center
        
        self._frame -= rot_center
        rotate_polygon(self._frame,R)
        self._frame += rot_center
        
        for stiker in self._stikers:
            stiker -= rot_center
            rotate_polygon(stiker,R)
            stiker += rot_center
