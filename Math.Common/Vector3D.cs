namespace Math.Common
{
    /// <summary>
    /// Вектор в 3-х мерном пространстве
    /// </summary>
    public struct Vector3D
    {        
        /// <summary>
        /// Создает вектор с компонентами x, y, z
        /// </summary>
        /// <param name="x">Компонента x</param>
        /// <param name="y">Компонента y</param>
        /// <param name="z">Компонента z</param>
        public Vector3D(double x, double y, double z)
        {
            X = x;
            Y = y;
            Z = z;
        }

        /// <summary>
        /// Компонента x
        /// </summary>
        public double X { get; }

        /// <summary>
        /// Компонента y
        /// </summary>
        public double Y { get; }

        /// <summary>
        /// Компонента z
        /// </summary>
        public double Z { get; }

        #region Operators

        /// <summary>
        /// Унарный плюс
        /// </summary>
        /// <param name="v">Вектор, к которому применяется операция</param>
        /// <returns>Копия исходного вектора</returns>
        public static Vector3D operator +(Vector3D v) => new(v.X, v.Y, v.Z);

        /// <summary>
        /// Унарный минус
        /// </summary>
        /// <param name="v">Вектор, к которому применяется операция</param>
        /// <returns>Вектор, противоположный исходному</returns>
        public static Vector3D operator -(Vector3D v) => new(-v.X, -v.Y, -v.Z);

        /// <summary>
        /// Сумма двух векторов
        /// </summary>
        /// <param name="v1">Первое слагаемое</param>
        /// <param name="v2">Второе слагаемое</param>
        /// <returns>Результат сложения</returns>
        public static Vector3D operator+(Vector3D v1, Vector3D v2)
            => new Vector3D(v1.X + v2.X, v1.Y + v2.Y, v1.Z + v2.Z);

        /// <summary>
        /// Разность двух векторов
        /// </summary>
        /// <param name="v1">Уменьшаемое</param>
        /// <param name="v2">Вычитаемое</param>
        /// <returns>Результат вычитания (разность)</returns>
        public static Vector3D operator -(Vector3D v1, Vector3D v2)
            => new Vector3D(v1.X - v2.X, v1.Y - v2.Y, v1.Z - v2.Z);

        /// <summary>
        /// Умножение вектора на число
        /// </summary>
        /// <param name="d">Скалярный сомножитель</param>
        /// <param name="v">Векторный сомножитель</param>
        /// <returns>Результат умножения (произведение)</returns>
        public static Vector3D operator *(double d, Vector3D v)
           => new(d * v.X, d * v.Y, d * v.Z);

        /// <summary>
        /// Умножение вектора на число
        /// </summary>        
        /// <param name="v">Векторный сомножитель</param>
        /// <param name="d">Скалярный сомножитель</param>
        /// <returns>Результат умножения (произведение)</returns>
        public static Vector3D operator *(Vector3D v, double d)
           => new(d * v.X, d * v.Y, d * v.Z);

        /// <summary>
        /// Деление ветора на число
        /// </summary>
        /// <param name="v">Делимое (вектор)</param>
        /// <param name="d">Делитель (скаляр)</param>
        /// <returns>Результат деления (вектор)</returns>
        public static Vector3D operator /(Vector3D v, double d)
        {
            double m = 1.0 / d;
            return new Vector3D(v.X * m, v.Y * m, v.Z * m);
        }
        #endregion

        #region Multiplication

        /// <summary>
        /// Скалярное произведение двух векторов
        /// </summary>
        /// <param name="v1">Первый сомножитель</param>
        /// <param name="v2">Второй сомножитель</param>
        /// <returns>Результат умножения (скаляр)</returns>
        public static double DotProduct(Vector3D v1, Vector3D v2)
            => v1.X * v2.X + v1.Y * v2.Y + v1.Z * v2.Z;

        public double DotProduct(Vector3D v)
            => X * v.X + Y * v.Y + Z * v.Z;

        /// <summary>
        /// Векторное произведение двух векторов
        /// </summary>
        /// <param name="v1">Левый сомножитель</param>
        /// <param name="v2">Правый сомножитель</param>
        /// <returns>Результат умножения (вектор)</returns>
        public static Vector3D CrossProduct(Vector3D v1, Vector3D v2)
        {
            double x = v1.Y * v2.Z - v1.Z * v2.Y;
            double y = v1.Z * v2.X - v1.X * v2.Z;
            double z = v1.X * v2.Y - v1.Y * v2.X;

            return new Vector3D(x, y, z);
        }


        #endregion
    }
}
