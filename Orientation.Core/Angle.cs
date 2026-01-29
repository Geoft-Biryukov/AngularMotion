namespace Orientation.Core
{
    /// <summary>
    /// Структура для хранения угла
    /// </summary>
    public struct Angle : IComparable, IComparable<Angle>, IEquatable<Angle>
    {
        private const double degToRad = Math.PI / 180.0;
        private const double radToDeg = 180.0 / Math.PI;

        public static readonly Angle Zero = new(0);
        public static readonly Angle Perigon = new(2 * Math.PI);

        public static readonly Angle Deg0 = Zero;
        public static readonly Angle Deg90 = new(0.5 * Math.PI);
        public static readonly Angle Deg180 = new(Math.PI);
        public static readonly Angle Deg270 = new(1.5 * Math.PI);
        public static readonly Angle Deg360 = Perigon;

        public static readonly Angle NaN = new(double.NaN);
        public static readonly Angle PositiveInfinity = new(double.PositiveInfinity);
        public static readonly Angle NegativeInfinity = new(double.NegativeInfinity);

        /// <summary>
        /// Угол в радианах
        /// </summary>
        public double Rad { get; }


        /// <summary>
        /// Угол в градусах
        /// </summary>
        public readonly double Deg => Rad * radToDeg;

        public static Angle FromRad(double radians) => new(radians);

        public static Angle FromDeg(double degrees) => new(degrees * degToRad);


        private Angle(double radians) => Rad = radians;

        #region IComparable<Angle>

        public int CompareTo(Angle other) => Rad.CompareTo(other.Rad);

        #endregion


        #region IComparable

        public int CompareTo(object obj)
        {
            if (obj is Angle other)
                return CompareTo(other);

            return 1;
        }

        #endregion


        public override readonly string ToString()
            => string.Format(System.Globalization.CultureInfo.CurrentCulture, "{0} Degrees", Deg);

        public readonly bool Equals(Angle other) => Rad.Equals(other.Rad);

        public override bool Equals(object obj)
        {
            if (obj == null)
                return false;

            return obj is Angle other && Equals(other);
        }

        public override int GetHashCode() => Rad.GetHashCode();

        /// <summary>
        /// Если includePerigon == false, сворачивает в [0, 2pi)
        /// Если includePerigon == true, сворачивает в [0, 2pi]
        /// </summary>
        public static Angle FoldPerigon(Angle angle, bool includePerigon = false)
        {
            if (includePerigon && angle.Rad == Perigon.Rad)
                return angle;

            var folded = angle.Rad % Perigon.Rad;
            if (folded < 0)
                folded += Perigon.Rad;

            return new Angle(folded);
        }


        public static bool IsZero(Angle angle)
            => angle.Rad == 0;


        public static bool IsNaN(Angle angle)
            => double.IsNaN(angle.Rad);


        public static bool IsInfinity(Angle angle)
            => double.IsInfinity(angle.Rad);


        public static double FromDegToRad(double degrees)
            => degrees * degToRad;


        public static double FromRadToDeg(double radians)
            => radians * radToDeg;


        public static Angle operator +(Angle p1, Angle p2) => new Angle(p1.Rad + p2.Rad);


        public static Angle operator -(Angle p1, Angle p2) => new Angle(p1.Rad - p2.Rad);


        public static Angle operator +(Angle a) => a;


        public static Angle operator -(Angle a) => new Angle(-a.Rad);


        public static Angle operator *(double scale, Angle a) => new Angle(scale * a.Rad);


        public static Angle operator *(Angle a, double scale) => new Angle(scale * a.Rad);


        public static Angle operator /(Angle a, double divisor) => new Angle(a.Rad / divisor);


        public static double operator /(Angle a, Angle b) => a.Rad / b.Rad;


        public static Angle operator %(Angle a1, Angle a2) => new Angle(a1.Rad % a2.Rad);


        public static bool operator ==(Angle left, Angle right) => left.Rad == right.Rad;


        public static bool operator !=(Angle left, Angle right) => left.Rad != right.Rad;


        public static bool operator <(Angle left, Angle right) => left.Rad < right.Rad;
        public static bool operator <=(Angle left, Angle right) => left.Rad <= right.Rad;


        public static bool operator >(Angle left, Angle right) => left.Rad > right.Rad;
        public static bool operator >=(Angle left, Angle right) => left.Rad >= right.Rad;
    }
}
