namespace Quantum.RubiqTests {
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Math;

    open Quantum.RubiqLib.Creation;
    open Quantum.RubiqLib.Moves;


    @Test("QuantumSimulator")
    operation BuildAndDestroyTest() : Unit {

        using (register = Qubit[5]) {
            let cube = InitCube(register);
            KillCube(cube);
            Message("Succses!");
        }
    }

    @Test("QuantumSimulator")
    operation EqualDistributionForEachStikerTest() : Unit {

        using (register = Qubit[5]) {
            let cube = InitCube(register);

            let face = cube::innerFace;

            let msg = "All the stikers in a face should have the probablity";
            AssertMeasurementProbability([PauliZ, PauliZ], face, One, 0.5, msg, 0.1);
            AssertMeasurementProbability([PauliZ, PauliX], face, One, 0.5, msg, 0.1);

            KillCube(cube);
            Message("Succses!");
        }
    }

    @Test("QuantumSimulator")
    operation DevidProbEqaullyToTheFist3StagesTest() : Unit {

        using (register = Qubit[2]) {
            DivideProbEquallyToTheFirst3Stages(register);
            AssertMeasurementProbability([PauliZ, PauliZ], register, Zero, 1./3., "ads", 0.1);

            ResetAll(register);
            Message("Succses!");
        }
    }

    internal operation DoNothing(register : Qubit[]) : Unit is Adj
    {
    }

    internal operation RollFaceTwaice(face : Qubit[]) : Unit is Adj
    {
        RotateFace(face);
        RotateFace(face);
    }

    @Test("QuantumSimulator")
    operation RollFace_180Deg_isEqualTo_180negTest(): Unit
    {
        AssertOperationsEqualInPlace(2, RollFaceTwaice, Adjoint RollFaceTwaice);
        Message("Succses!");
    }

    internal operation Apply4Times(register : Qubit[], flip : (Cube => Unit is Adj + Ctl)) : Unit is Adj + Ctl
    {
        let cube = Cube( register[...1] ,register[2...]);
        
        flip(cube);
        flip(cube);
        flip(cube);
        flip(cube);
    }

    @Test("QuantumSimulator")
    operation RotateFront4TimesShouldDoNothingTest(): Unit
    {
        let RotateFront4Times = Apply4Times(_, RotateFront);
        AssertOperationsEqualInPlace(5, RotateFront4Times, DoNothing);
        
        Message("Succses!");
    }

    @Test("QuantumSimulator")
    operation RotateLeft4TimesShouldDoNothingTest(): Unit
    {
        let RotateLeft4Times = Apply4Times(_, RotateLeft);
        AssertOperationsEqualInPlace(5, RotateLeft4Times, DoNothing);
        
        Message("Succses!");
    }

    // @Test("QuantumSimulator")
    // operation RotateTop4TimesShouldDoNothingTest(): Unit
    // {
    //     let RotateTop4Times = Apply4Times(_, RotateTop);
    //     AssertOperationsEqualInPlace(5, RotateTop4Times, DoNothing);
        
    //     Message("Succses!");
    // }
}