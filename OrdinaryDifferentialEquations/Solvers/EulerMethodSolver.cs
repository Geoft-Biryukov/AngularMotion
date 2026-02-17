

using OrdinaryDifferentialEquations.Solvers.SolversSettings;

namespace OrdinaryDifferentialEquations.Solvers
{
    /// <summary>
    /// Метод Эйлера для решения ОДУ
    /// </summary>
    public class EulerMethodSolver : IOdeSolver
    {
        private readonly EulerMethodSettings settings;        

        /// <summary>
        /// Создает решатель методом Эйлера с заданными настройками
        /// </summary>
        /// <param name="settings">Настройки метода Эйлера</param>
        /// <exception cref="ArgumentNullException"></exception>
        public EulerMethodSolver(EulerMethodSettings settings)
        {
            this.settings = settings ?? throw new ArgumentNullException(nameof(settings));            
        }

        /// <summary>
        /// Решает систему ОДУ методом Эйлера
        /// </summary>
        /// <param name="finalTime">конечное время</param>        
        /// <returns>Коллекцию решений в точках по времени</returns>
        public IEnumerable<Variables> Solve(InitialValueProblem problem, double finalTime)
        {
            ArgumentNullException.ThrowIfNull(problem);

            var equation = problem.Equation;

            var step = settings.Step;
            var t = problem.InitialTime;
            var currentState = problem.InitialStateVector;

            yield return new Variables(t, currentState);

            while (t <= finalTime)
            {                                                              
                currentState = currentState + step * equation.Evaluate(t, currentState);
                
                t += step; 
                
                yield return new Variables(t, currentState);                                               
            }
        }                        
    }
}
