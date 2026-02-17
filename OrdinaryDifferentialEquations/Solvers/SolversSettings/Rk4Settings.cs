namespace OrdinaryDifferentialEquations.Solvers.SolversSettings
{
    public class Rk4Settings(double step) : IOdeSolverSettings
    {
        public double Step { get; } = step;
    }
}
