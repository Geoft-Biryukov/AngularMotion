namespace OrdinaryDifferentialEquations.Tests
{
    [TestFixture]
    public class Tests
    {
        [SetUp]
        public void Setup()
        {
        }

        [Test]
        public void CanCreateStateVariables()
        {
            //Arrange
            int n = 5;

            // Apply
            var v = new StateVector(n);

            // Assert
            Assert.That(v, Is.Not.Null);
        }

        [Test]
        public void MustThrow_CreateStateVariables_WithZero_Or_Negative()
        {
            //Arrange
            int n = 0;
            int m = -5;

            // Apply            

            // Assert
            Assert.Throws<ArgumentOutOfRangeException>(() => new StateVector(n));
            Assert.Throws<ArgumentOutOfRangeException>(() => new StateVector(m));
        }
    }
}