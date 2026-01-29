namespace Orientation.Core.Tests
{
    public class AngleTests
    {
        private const double toleranceRad = 1e-14;

        [SetUp]
        public void Setup()
        {
        }

        [Test]
        public void CanCreateFromDegrees()
        {
            double angleDeg = 180.0;
            double angleRad = angleDeg * Math.PI / 180.0;

            var alpha = Angle.FromDeg(angleDeg);
            Assert.Multiple(() =>
            {
                Assert.That(alpha.Deg, Is.EqualTo(angleDeg));
                Assert.That(alpha.Rad, Is.EqualTo(angleRad).Within(toleranceRad));
            });
        }

        [Test]
        public void CanCreateFromRadian()
        {
            double angleDeg = 180.0;
            double angleRad = angleDeg * Math.PI / 180.0;

            var alpha = Angle.FromRad(angleRad);
            Assert.Multiple(() =>
            {
                Assert.That(alpha.Deg, Is.EqualTo(angleDeg));
                Assert.That(alpha.Rad, Is.EqualTo(angleRad).Within(toleranceRad));
            });
        }
    }
}