namespace Quantum.RubiqLib.Moves {

    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;

    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Logical;
    open Microsoft.Quantum.Math;

    open Quantum.RubiqLib.Creation;

    operation ChooseFace(cube : Cube, faceIndex : Int) : Unit is Adj + Ctl
    {
        body (...)
        {
            let ind = 7 - faceIndex;

            if ((ind &&& 0x1) != 0)
            {
                X(cube::interFace[0]);
            }

            if ((ind &&& 0x2) != 0)
            {
                X(cube::interFace[1]);
            }

            if ((ind &&& 0x4) != 0)
            {
                X(cube::interFace[2]);
            }
        }
    }

    operation RotateFace(face : Qubit[]) : Unit is Adj + Ctl
    {
        //  Clockwise rotation:
        //   [0   1]   ==>   [2   0]
        //   [2   3]   ==>   [3   1]

        //  for counter-clockwise rotation use "Adjoint rotateFace"

        body (...)
        {
            CNOT(face[1],face[0]);
            CNOT(face[0],face[1]);
            X(face[1]);
            CNOT(face[1],face[0]);
            X(face[1]);
        }
    }

   operation RotateAFace(cube : Cube, faceIndex : Int) : Unit is Adj + Ctl
   {
       body (...)
       {
           within {
               ChooseFace(cube, faceIndex);
           }
           apply {
               Controlled RotateFace(cube::interFace, cube::innerFace);
           }
       }
   }

   operation prepareForFrontRotation(cube : Cube) : Unit is Adj + Ctl
   {
       body (...)
       {
            let face = cube::innerFace;
            let faceInd = cube::interFace;

            // Prepare face 1
            within {
               ChooseFace(cube, 1);
            }
            apply {
               Controlled X(faceInd, face[1]);
               Controlled X(faceInd, face[0]);
            }

            // Prepare face 4
            within {
                ChooseFace(cube, 4);
            }
            apply {
               Controlled X(faceInd + [face[1]], face[0]);
               Controlled X(faceInd + [face[0]], face[1]);
               Controlled X(faceInd + [face[1]], face[0]);
            }

            // Prepare face 5
            within {
                ChooseFace(cube, 5);
            }
            apply {
                Controlled X(faceInd + [face[1]], face[0]);
                X(face[0]);
                Controlled X(faceInd + [face[0]], face[1]);
                X(face[0]);
            }
       }
   }


   operation RotateFront(cube : Cube) : Unit is Adj + Ctl
   {
       body (...)
       {
           let face = cube::innerFace;
           let faceInd = cube::interFace;

           within {
               prepareForFrontRotation(cube);
           }
           apply {
              X(faceInd[1]);
               Controlled X([faceInd[0], face[1]], faceInd[2]);
               Controlled X([faceInd[1], faceInd[2], face[1]], faceInd[0]);
               X(faceInd[1]);
               Controlled X([faceInd[0], faceInd[2], face[1]],faceInd[1]);
               Controlled X([faceInd[0], faceInd[1], face[1]],faceInd[2]);
            }

            RotateAFace(cube, 0);
       }
   }


   operation RotateLeft(cube : Cube) : Unit is Adj + Ctl
   {
       body (...)
       {
           let face = cube::innerFace;
           let faceInd = cube::interFace;

           within {
               X(face[0]);
               X(faceInd[2]);
           }
           apply {
                Controlled X([faceInd[2], faceInd[1], face[0]], faceInd[0]);
                Controlled X([faceInd[2], faceInd[0], face[0]], faceInd[1]);
                X(faceInd[1]);
                Controlled X([faceInd[2], faceInd[1], face[0]], faceInd[0]);
                X(faceInd[1]);
            }

            RotateAFace(cube, 4);
       }
   }

   operation RotateTop(cube : Cube) : Unit is Adj + Ctl
   {
       body (...)
       {
           let face = cube::innerFace;
           let faceInd = cube::interFace;

           within {
                RotateAFace(cube, 2);
                RotateAFace(cube, 2);

                X(face[1]);
           }
           apply {
                Controlled X([face[1], faceInd[2]], faceInd[1]);
                Controlled X([face[1], faceInd[2], faceInd[0]], faceInd[1]);
                Controlled X([face[1], faceInd[2], faceInd[1]], faceInd[0]);
                Controlled X([face[1], faceInd[2], faceInd[0]], faceInd[1]);
                Controlled X([face[1], faceInd[0]], faceInd[2]);
                
                Controlled X([face[1], faceInd[2], faceInd[1]], faceInd[0]);
                Controlled X([face[1], faceInd[2], faceInd[0]], faceInd[1]);
                Controlled X([face[1], faceInd[2]], faceInd[1]);
            }

            RotateAFace(cube, 3);
       }
   }
}
