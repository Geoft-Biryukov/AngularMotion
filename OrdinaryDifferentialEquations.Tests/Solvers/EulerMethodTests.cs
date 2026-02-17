using Moq;
using OrdinaryDifferentialEquations.Solvers;
using OrdinaryDifferentialEquations.Solvers.SolversSettings;
using OrdinaryDifferentialEquations.Tests.Solvers;

namespace OrdinaryDifferentialEquations.Tests;

[TestFixture]
public class EulerMethodTests
{
    private InitialValueProblem problem;

    private InitialValueProblem problemHarmonic;

    [SetUp]
    public void Setup()
    {
        double initTime = 0;
        var initCond = new StateVector([0.1, 0]);
        var eqns = new SecondOrderAutonomousEquation(initTime, initCond);
        problem = new InitialValueProblem(initTime, initCond, eqns);

        var eqnsHarm = new HarmonicOscillatorEquation(1);
        problemHarmonic = new InitialValueProblem(initTime, initCond, eqnsHarm);
    }

    [Test]
    public void Constructor_ThrowsArgumentNullException()
    {
        // Apply
        // Assert
        Assert.Throws<ArgumentNullException>(() => {new EulerMethodSolver(null); });     
    }

    [Test]
    public void Constructor_CanCreateSolver()
    {
        // Arrange
        var init = new StateVector(2);        
        var settings = new EulerMethodSettings(0.1);        

        // Apply
        var solver = new EulerMethodSolver(settings);

        // Assert
        Assert.That(solver, Is.Not.Null);

    }

    //[Test]
    //[TestCase(0.1, 10.0)]
    //[TestCase(0.01, 10.0)]
    //public void Solve_ShouldSolveOde_ReturnSolution(double step, double finalTime)
    //{
    //    // Arrange        
    //    var settings = new EulerMethodSettings(step);
    //    var slnProvider = problem.Equation as IAnalyticalSolutionProvider;

    //    var slnFinal = slnProvider.GetAnalyticalSolution(finalTime);

    //    // Apply
    //    var solver = new EulerMethodSolver(settings);
    //    var numSln = solver.Solve(problem, finalTime).ToArray();

    //    // Assert
    //    Assert.Multiple(() =>
    //    {
    //        Assert.That(numSln.Last().Time, Is.EqualTo(finalTime).Within(step));
    //        Assert.That(numSln.Last().State[0], Is.EqualTo(slnProvider.GetAnalyticalSolution(numSln.Last().Time)[0]).Within(step));
    //    });
       

    //}

    [Test]
    [TestCase(0.1, 10.0)]
    [TestCase(0.01, 10.0)]
    public void Solve_ShouldSolveOdeHarmonic_ReturnSolution(double step, double finalTime)
    {
        // Arrange        
        var settings = new EulerMethodSettings(step);
        var slnProvider = problemHarmonic.Equation as IAnalyticalSolutionProvider;

        var slnFinal = slnProvider.GetAnalyticalSolution(finalTime);

        // Apply
        var solver = new EulerMethodSolver(settings);
        var numSln = solver.Solve(problemHarmonic, finalTime).ToArray();

        // Assert
        Assert.Multiple(() =>
        {
            Assert.That(numSln.Last().Time, Is.EqualTo(finalTime).Within(step));
            Assert.That(numSln.Last().State[0], Is.EqualTo(slnProvider.GetAnalyticalSolution(numSln.Last().Time)[0]).Within(step));
        });


    }
}
