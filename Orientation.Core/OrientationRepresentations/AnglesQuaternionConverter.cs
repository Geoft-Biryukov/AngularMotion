using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Orientation.Core.OrientationRepresentations
{
    public static class AnglesQuaternionConverter
    {
        #region ToQuaternion
        /// <summary>
        /// Преобразует углы Эйлера в кватернион
        /// </summary>
        /// <param name="angles">Углы Эйлера</param>
        /// <returns>Нормализованный кватернион</returns>
        public static Quaternion ToQuaternion(this EulerAngles angles)
        {
            var psi = angles.Psi;
            var theta = angles.Theta;
            var phi = angles.Phi;

            return angles.AnglesType switch
            {
                EulerAnglesTypes.Classic => FromClassicalEulerAngles(psi, theta, phi),
                EulerAnglesTypes.Krylov => FromKrylovEulerAngles(psi, theta, phi),
                _ => throw new NotSupportedException($"Неизвестный тип углов Эйлера: {angles.AnglesType}"),
            };
        } 
        
        private static Quaternion FromClassicalEulerAngles(Angle psi, Angle theta, Angle phi)
        {
            var halfPsi = 0.5 * psi;
            var halfTheta = 0.5 * theta;
            var halfPhi = 0.5 * phi;

            double cosHalfTheta = MathAngle.Cos(halfTheta);
            double sinHalfTheta = MathAngle.Sin(halfTheta);
            
            double cosHalfPsi = MathAngle.Cos(halfPsi);
            double sinHalfPsi = MathAngle.Sin(halfPsi);
           
            double cosHalfPhi = MathAngle.Cos(halfPhi);
            double sinHalfPhi = MathAngle.Sin(halfPhi);

            // Умножение кватернионов: q = q_z(psi) * q_x(theta) * q_z(phi)
            double w = cosHalfPsi * cosHalfTheta * cosHalfPhi - sinHalfPsi * cosHalfTheta * sinHalfPhi;
            double x = cosHalfPsi * sinHalfTheta * cosHalfPhi + sinHalfPsi * sinHalfTheta * sinHalfPhi;
            double y = sinHalfPsi * sinHalfTheta * cosHalfPhi - cosHalfPsi * sinHalfTheta * sinHalfPhi;
            double z = cosHalfPsi * cosHalfTheta * sinHalfPhi + sinHalfPsi * cosHalfTheta * cosHalfPhi;

            return new Quaternion(w, x, y, z);
        }

       
        private static Quaternion FromKrylovEulerAngles(Angle psi, Angle theta, Angle phi)
        {
            var halfPsi = 0.5 * psi;
            var halfTheta = 0.5 * theta;
            var halfPhi = 0.5 * phi ;      
            
            double cosHalfPsi = MathAngle.Cos(halfPsi);
            double sinHalfPsi = MathAngle.Sin(halfPsi);

            double cosHalfTheta = MathAngle.Cos(halfTheta);
            double sinHalfTheta = MathAngle.Sin(halfTheta);

            double cosHalfPhi = MathAngle.Cos(halfPhi);
            double sinHalfPhi = MathAngle.Sin(halfPhi);

            // Умножение кватернионов: q = q_y(yaw) * q_z(pitch) * q_x(roll)
            double w = cosHalfPsi * cosHalfTheta * cosHalfPhi - sinHalfPsi * sinHalfTheta * sinHalfPhi;
            double x = sinHalfPsi * sinHalfTheta * cosHalfPhi + cosHalfPsi * cosHalfTheta * sinHalfPhi;
            double y = sinHalfPsi * cosHalfTheta * cosHalfPhi + cosHalfPsi * sinHalfTheta * sinHalfPhi;
            double z = cosHalfPsi * sinHalfTheta * cosHalfPhi - sinHalfPsi * cosHalfTheta * sinHalfPhi;

            return new Quaternion(w, x, y, z);
        }
        #endregion
    }
}
