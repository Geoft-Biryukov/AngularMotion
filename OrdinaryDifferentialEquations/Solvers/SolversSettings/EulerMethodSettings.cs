namespace OrdinaryDifferentialEquations.Solvers.SolversSettings
{
    public class EulerMethodSettings(double step) : IOdeSolverSettings
    {
        public double Step { get; } = step;        
    }    
}
