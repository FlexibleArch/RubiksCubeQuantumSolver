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
        Controlled X([cube::innerFace[0]], target);
        Controlled X([cube::innerFace[1]], target);
        X(target);
    }
    
    operation ExacuteStep(cube : Cube, step :  Step) : Unit is Adj + Ctl
    {
        Fact(Length(step!) == 2 , "Stop should be composed from two qubits");

        Controlled RotateTop(step!, cube);

        within {
            X(step[1]);
        } 
        apply {
            Controlled RotateFront(step!, cube);
        }

        within {
            X(step[0]);
        }        
        apply {
            Controlled RotateLeft(step!, cube);
        }
    }

    operation ExacuteStepI(cube : Cube, step :  Int) : Unit is Adj + Ctl
    {
        Fact(step < 4 , " There are four possible moves in each step.");
   
        ///if (step == 0) do nothiong
        if (step == 1) { RotateFront(cube); }
        if (step == 2) { RotateLeft(step!, cube); }
        if (step == 3) { RotateTop(step!, cube); }
    }

    operation ExacuteInstructions(cube : Cube, instructions :  Step[]) : Unit is Adj + Ctl
    {
        let stepsCount = Length(instructions);
        for (step in instructions)
        {
            ExacuteStep(cube, step);
        }
    }

}