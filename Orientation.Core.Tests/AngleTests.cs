namespace Orientation.Core.Tests
{
    public class AngleTests
    {
        [SetUp]
        public void Setup()
        {
        }

        [Test]
        public void CanCreateFromDegrees()
        {
            var alpha = Angle.FromDeg(10);
            Assert.That(alpha.Deg, Is.EqualTo(10));
        }
    }
}