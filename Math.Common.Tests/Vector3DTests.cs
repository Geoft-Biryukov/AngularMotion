using NUnit.Framework.Constraints;

namespace Math.Common.Tests
{
    public class Vector3DTests
    {
        private const double Tolerance = 1e-10;

        [SetUp]
        public void Setup()
        {
        }

        [Test]
        public void CanCreateVector3dWithoutParameters()
        {
            var v = new Vector3D();

            Assert.Multiple(() =>
            {
                Assert.That(v.X, Is.EqualTo(0.0).Within(Tolerance));
                Assert.That(v.Y, Is.EqualTo(0.0).Within(Tolerance));
                Assert.That(v.Z, Is.EqualTo(0.0).Within(Tolerance));
            });            
        }

        [Test]
        [TestCase(1.0, 2.0, 3.0)]
        [TestCase(154.0203, 22.125467, 534.00001)]
        [TestCase(double.NaN, double.NaN, double.NaN)]
        public void CanCreateVector3dWithParameters(double x, double y, double z)
        {
            var v = new Vector3D(x ,y, z);

            Assert.Multiple(() =>
            {
                Assert.That(v.X, Is.EqualTo(x).Within(Tolerance));
                Assert.That(v.Y, Is.EqualTo(y).Within(Tolerance));
                Assert.That(v.Z, Is.EqualTo(z).Within(Tolerance));
            });
        }

        #region Test operators
        [Test]
        [TestCase(2, 3, 4, 6, 7, 8, 8, 10, 12)]
        [TestCase( -2, -3, -4, 2, 3, 4, 0, 0, 0)]
        public void AdditionOperator_ValidVectors_ReturnsCorrectResult(
        double x1, double y1, double z1,
        double x2, double y2, double z2,
        double expectedX, double expectedY, double expectedZ)
        {
            // Arrange
            var v1 = new Vector3D(x1, y1, z1);
            var v2 = new Vector3D(x2, y2, z2);

            // Act
            var result = v1 + v2;

            // Assert
            Assert.Multiple(() =>
            {                
                Assert.That(result.X, Is.EqualTo(expectedX).Within(Tolerance));
                Assert.That(result.Y, Is.EqualTo(expectedY).Within(Tolerance));
                Assert.That(result.Z, Is.EqualTo(expectedZ).Within(Tolerance));
            });
        }

        [Test]
        [TestCase(6, 7, 8, 2, 3, 4, 4, 4, 4)]
        [TestCase(0, 0, 0, 2, 3, 4, -2, -3, -4)]
        public void SubtractionOperator_ValidVectors_ReturnsCorrectResult(
       double x1, double y1, double z1,
       double x2, double y2, double z2,
       double expectedX, double expectedY, double expectedZ)
        {
            // Arrange
            var v1 = new Vector3D(x1, y1, z1);
            var v2 = new Vector3D(x2, y2, z2);

            // Act
            var result = v1 - v2;

            // Assert
            Assert.Multiple(() =>
            {
                Assert.That(result.X, Is.EqualTo(expectedX).Within(Tolerance));
                Assert.That(result.Y, Is.EqualTo(expectedY).Within(Tolerance));
                Assert.That(result.Z, Is.EqualTo(expectedZ).Within(Tolerance));
            });
        }
        #endregion
    }
}