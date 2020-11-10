namespace Quantum.RubiqLib.Solver {

    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;

    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Logical;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Diagnostics;

    open Quantum.RubiqLib.Creation;
    open Quantum.RubiqLib.Moves;

    newtype Step = Qubit[]; 

    operation CheckIfSloved(cube : Cube, target : Qubit) : Unit is Adj + Ctl
    {
        Controlled X([cube::innerFace[1]], target);
        H(cube::innerFace[1]);
        H(target);
        Controlled X([cube::innerFace[1]], target);
        X(target);
    }
    
    operation ExecuteStep(cube : Cube, step :  Step) : Unit is Adj + Ctl
    {
        let stepQubits = step!;
        Fact(Length(stepQubits) == 2 , "Stop should be composed from two qubits");

        Controlled RotateTop(stepQubits, cube);

        within {
            X(stepQubits[1]);
        } 
        apply {
            Controlled RotateFront(stepQubits, cube);
        }

        within {
            X(stepQubits[0]);
        }        
        apply {
            Controlled RotateLeft(stepQubits, cube);
        }
    }

    operation ExecuteStepI(cube : Cube, step :  Int) : Unit is Adj + Ctl
    {
        Fact(step < 4 , "There are four possible moves in each step.");
        
        // if (step == 0) do nothiong
        if (step == 1) { RotateFront(cube); }
        if (step == 2) { RotateLeft(cube); }
        if (step == 3) { RotateTop(cube); }
    }

    operation ExacuteInstructions(cube : Cube, instructions :  Step[]) : Unit is Adj + Ctl
    {
        for (step in instructions)
        {
            ExecuteStep(cube, step);
        }
    }
}