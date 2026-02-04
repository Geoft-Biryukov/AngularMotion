using System;
using System.Collections;

namespace OrdinaryDifferentialEquations
{
    /// <summary>
    /// Вектор состояния системы дифференциальных уравнений
    /// </summary>
    public class StateVector : IEnumerable<double>
    {        
        private readonly double[] vector;

        /// <summary>
        /// Создает вектор состояний для системы заданного порядка
        /// </summary>
        /// <param name="order">Порядок системы дифф. ур-ий</param>
        /// <exception cref="ArgumentOutOfRangeException">Возникает, если order <= 0</exception>
        public StateVector(int order)
        {
            if (order <= 0) 
                throw new ArgumentOutOfRangeException(nameof(order));

            Order = order;
            vector = new double[order];
        }

        /// <summary>
        /// Создаёт вектор состояний с заданными значениями
        /// </summary>
        /// <param name="values">Значения вектора состояния</param>
        /// <exception cref="ArgumentNullException">Возникает, если передаваемый массив null</exception>
        /// <exception cref="ArgumentException">Возникает, если передаваемый массив не содержит элементов</exception>
        public StateVector(double[] values)
        {
            if (values == null)
                throw new ArgumentNullException(nameof(values));
            if (values.Length == 0)
                throw new ArgumentException("Array cannot be empty", nameof(values));

            Order = values.Length;
            vector = (double[])values.Clone(); // Защита от внешних изменений
        }

        /// <summary>
        /// Порядок системы дифференциальных уравнений
        /// </summary>
        public int Order { get; }

        /// <summary>
        /// Возвращает или устанавливает значение по заданному индекс
        /// </summary>
        /// <param name="index"></param>
        /// <returns></returns>
        /// <exception cref="ArgumentOutOfRangeException"></exception>
        public double this[int index]
        {
            get
            {
                if (!CheckIndex(index))
                    throw new ArgumentOutOfRangeException(nameof(index));

                return vector[index];
            }

            set
            {
                if (!CheckIndex(index))
                    throw new ArgumentOutOfRangeException(nameof(index));

                vector[index] = value;
            }
        }

        /// <summary>
        /// Создает и возвращает копию вектора состояния в виде массива
        /// </summary>
        /// <returns>Новый массив double со значениями вектора состояния</returns>
        public double[] ToArray() 
            => (double[])vector.Clone();

        /// <summary>
        /// Копирует вектор состояния в заданный массив 
        /// </summary>
        /// <param name="array">Массив для копирования</param>
        /// <param name="index">Начальный индекс</param>
        public void CopyTo(double[] array, int index)
        {
            if (array == null)
                throw new ArgumentNullException(nameof(array));
            
            if (index < 0 || index >= array.Length)
                throw new ArgumentOutOfRangeException(nameof(index));

            vector.CopyTo(array, index);
        }

        /// <summary>
        /// Заполняет вектор состояния заданным значением
        /// </summary>
        /// <param name="value">Значение для заполнения</param>
        public void Fill(double value) 
            => Array.Fill(vector, value);

        private bool CheckIndex(int index)
            => index >= 0 && index < Order;

        public IEnumerator<double> GetEnumerator()
        {
            foreach (var value in vector)
                yield return value;
        }

        IEnumerator IEnumerable.GetEnumerator()
        {
            return GetEnumerator();
        }
    }
}
