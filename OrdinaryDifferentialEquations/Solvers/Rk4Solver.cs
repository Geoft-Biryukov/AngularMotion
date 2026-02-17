using OrdinaryDifferentialEquations.Solvers.SolversSettings;

namespace OrdinaryDifferentialEquations.Solvers
{
    /// <summary>
    /// Метод Рунге-Кутта 4-го порядка
    /// </summary>
    public class Rk4Solver : IOdeSolver
    {
        public Rk4Solver(Rk4Settings settings)
        {
            Settings = settings ?? throw new ArgumentNullException(nameof(settings));            
        }

        /// <summary>
        /// Настройки метода Рунге-Кутта
        /// </summary>
        public Rk4Settings Settings { get; }

        /// <summary>
        /// Решает систему ОДУ методом Рунге-Кутта 4-го порядка точности
        /// </summary>
        /// <param name="problem">Решаемая задача Коши</param>
        /// <param name="finalTime">Конечное время</param>
        /// <returns>Коллекцию решений в точках по времени</returns>
        public IEnumerable<Variables> Solve(InitialValueProblem problem, double finalTime)
        {
            var equation = problem.Equation;
            
            var step = Settings.Step;
            var halfStep = 0.5 * step;
            var step6 = step / 6;

            var t = problem.InitialTime;
            var yn = problem.InitialStateVector;

            yield return new Variables(t, yn);

            while (t <= finalTime)
            {
                var k1 = equation.Evaluate(t, yn);
                var k2 = equation.Evaluate(t + halfStep, yn + halfStep * k1);
                var k3 = equation.Evaluate(t + halfStep, yn + halfStep * k2);
                var k4 = equation.Evaluate(t + step, yn + step * k3);

                yn = yn + step6 * (k1 + 2.0 * k2 + 2.0 * k3 + k4);
                
                t += step;
                                
                yield return new Variables(t, yn);
            }
        }
    }
}
