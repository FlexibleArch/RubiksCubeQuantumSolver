namespace Quantum.RubiqLib.Creation {

    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Math;


    newtype Cube = (innerFace: Qubit[], interFace: Qubit[]);

    operation DevidProbEqaullyToTheFist3Stages(q : Qubit[]) : Unit is Adj + Ctl
    {
            H(q[0]);
            CNOT(q[1], q[0]);
            H(q[0]);
            
            Rx(ArcTan(2.8284), q[0]);
            CNOT(q[1], q[0]);
            X(q[0]);
            Controlled H([q[0]],q[1]);
            X(q[0]);
            Controlled Rz([q[0]],(-PI(),q[1]));
    }
    
    operation ColorFaces(cube : Cube) : Unit is Adj + Ctl
    {
        Rz(PI()/3.,cube::interFace[2]);
        Rz(PI()*2./3.,cube::interFace[1]);
        Rz(PI(),cube::interFace[0]);
    }
    
    operation ColorEachStiker(innerFace : Qubit[]) : Unit is Adj + Ctl
    {
        Rz(PI()/2., innerFace[0]);
        Rz(PI(), innerFace[1]);
    }
    
    operation SetEqualProbabiltyToEachStiker(cube : Cube) : Unit is Adj + Ctl
    {
        let interFace = cube::interFace;
        
        DevidProbEqaullyToTheFist3Stages(interFace[1...]);
        H(interFace[0]);
           
        ApplyToEachCA(H(_), cube::innerFace);
    }
    
    operation InitCube(reg : Qubit[]) : Cube
    {
        mutable cube = Cube( reg[...1] ,reg[2...]);

        SetEqualProbabiltyToEachStiker(cube);
        ColorFaces(cube);
        
        return cube;
    }
    
    operation KillCube(cube : Cube) : Unit 
    {
        ResetAll(cube::innerFace);
        ResetAll(cube::interFace);
    }

    operation GenerateCube() : Qubit[] 
    {
        using (qs = Qubit[3] )
        {
            H(qs[0]);            
            return qs;
        }
    }
}
