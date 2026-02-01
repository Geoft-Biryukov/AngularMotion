using Orientation.Core.OrientationRepresentations;

namespace Orientation.Core.Tests;

public class AnglesQuaternionConverterTests
{    
    [Test]
    [TestCase(0.0, 0.0, 0.0)]
    [TestCase(30.0, 0.0, 0.0)]
    [TestCase(30.0, 45.0, 60.0)]
    public void ToQuaternion_ClassicAngles_ReturnsCorrectValue(double psi, double theta, double phi)
    {
        // Arrange
        var psiAngle = Angle.FromDeg(psi);
        var thetaAngle = Angle.FromDeg(theta);
        var phiAngle = Angle.FromDeg(phi);

        var q1 = CreateRotationQuaternion(Angle.FromDegToRad(psi), 3);
        var q2 = CreateRotationQuaternion(Angle.FromDegToRad(theta), 1);
        var q3 = CreateRotationQuaternion(Angle.FromDegToRad(phi), 3);

        var expected_result = q1 * q2 * q3;

        var euler = EulerAngles.CreateClassic(psiAngle, thetaAngle, phiAngle);

        // Act
        var result = euler.ToQuaternion();

        // Assert
        Assert.That(result.Equals(expected_result, 1e-10), Is.True);
    }

    [Test]
    [TestCase(0.0, 0.0, 0.0)]
    [TestCase(30.0, 0.0, 0.0)]
    [TestCase(30.0, 45.0, 60.0)]
    public void ToQuaternion_KrylovAngles_ReturnsCorrectValue(double psi, double theta, double phi)
    {
        // Arrange
        var psiAngle = Angle.FromDeg(psi);
        var thetaAngle = Angle.FromDeg(theta);
        var phiAngle = Angle.FromDeg(phi);

        var q1 = CreateRotationQuaternion(Angle.FromDegToRad(psi), 2);
        var q2 = CreateRotationQuaternion(Angle.FromDegToRad(theta), 3);
        var q3 = CreateRotationQuaternion(Angle.FromDegToRad(phi), 1);

        var expected_result = q1 * q2 * q3;

        var euler = EulerAngles.CreateKrylov(psiAngle, thetaAngle, phiAngle);

        // Act
        var result = euler.ToQuaternion();

        // Assert
        Assert.That(result.Equals(expected_result, 1e-10), Is.True);
    }

    #region Helpers
    private static Quaternion CreateRotationQuaternion(double alpha, int axisIndex)
    {
        return axisIndex switch
        {
            1 => new Quaternion(Math.Cos(0.5 * alpha), Math.Sin(0.5 * alpha), 0.0, 0.0),
            2 => new Quaternion(Math.Cos(0.5 * alpha), 0.0, Math.Sin(0.5 * alpha), 0.0),
            3 => new Quaternion(Math.Cos(0.5 * alpha), 0.0, 0.0, Math.Sin(0.5 * alpha)),
            _ => throw new NotSupportedException(),
        };
    }
    #endregion
}
