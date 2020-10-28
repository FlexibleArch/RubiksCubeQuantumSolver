namespace Quantum.Rubiq.SolverTests {
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Arithmetic;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Preparation;

    open Quantum.RubiqLib.Creation;
    open Quantum.RubiqLib.Moves;
    open Quantum.RubiqLib.Solver;

    @Test("QuantumSimulator")
    operation CubeShoudStartyInAValidSolution_Test() : Unit {

        using ((register, target) = (Qubit[5], Qubit())) {
            let cube = InitCube(register);
            
            CheckIfSloved(cube, target);

            AssertQubit(One, target); // The initial state should be valid
            // @TODO this test is failing for a reason
            
            ResetAll(register);
            Reset(target);
        }
        Message("Succses!");
    }

    operation prepaeQubitStep(stepQubits : Qubit[], step : Int) : Unit is Adj + Ctl
    {
        mutable state = [0., 0., 0., 0.];
        state[step] = 1.0;
        let op = StatePreparationPositiveCoefficients(state);
        op(LittleEndian(stepQubits));
    }

    @Test("QuantumSimulator")
    operation ControllredStepShoudBeIdenticalToRegularExaction_Test() : Unit {

        using ((register, stepQubits) = (Qubit[5], Qubit[2])) {
            for (step in 0 .. 4)
            {
                Message("Running {step}");
                let cube = InitCube(register);

                within {
                    prepaeQubitStep(stepQubits, step);
                }
                apply
                {
                    ExecuteStep(cube,stepQubits);
                    Adjoint ExecuteStepI(cube, step);
                }
                // @TODO: check state is back 

                ResetAll(register);
                ResetAll(step);
            }
        }
        Message("Succses!");
    }




}