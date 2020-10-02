namespace Quantum.RubiqTests {
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Math;

    open Quantum.RubiqLib.Creation;


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
            DevidProbEqaullyToTheFist3Stages(register);
            AssertMeasurementProbability([PauliZ, PauliZ], register, Zero, 1./3., "ads", 0.1);

            ResetAll(register);
            Message("Succses!");
         }
     }
}