# RubiksCubeQuantumSolver

<span style="background-color:red"> *WIP*</span>

This project attempts to build a quantum solver for Rubik's Cube.

Currently, the focus is to solve a mini-cube 2x2x2. The cube is represented by a 5-qubit register; 2 qubits to represent the stickers on each face, and 3 qubits to differentiate between the different faces. The stickers of the cube are mapped to an integer state representation (see image) and the color of each sticker is determined by the phase of each state so the state ![formula](https://render.githubusercontent.com/render/math?math=j) and the amplitude ![formula](https://render.githubusercontent.com/render/math?math=r_{j}e^{i\theta_{j}}), ![formula](https://render.githubusercontent.com/render/math?math=theta_{j}=0,60,120,180,240,300) represent Rubik's six colors - White, Orange, Green, Red, Blue and Yellow respectively. The amplitude for each state is constant, and the state probability distributes evenly between the states ![formula](https://render.githubusercontent.com/render/math?math=r_{j}^2=1/24).



![img/CubeMapping.jpg](Resources/CubeMapping.jpg)

For 2x2x2 cube we can span all of its states by 3 moves (we only care about the relative movement): 
 - RotateLeft - while holding the cube when its front face is in front of us we spin its left side counter clockwise
 - RotateTop - while holding the cube when its front face is in front of us we spin its top side counter clockwise
 - RotateFace - while holding the cube when its front face is in front of us we spin its front side counter clockwise
