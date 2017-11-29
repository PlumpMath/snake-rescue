package utils;

using utils.RadiansDegrees;

import luxe.Vector;

class ForceAngle {
    inline public static function getForce(v:Vector):Float {
        return Math.sqrt(v.x*v.x + v.y*v.y);
    }
    
    inline public static function getAngle(v:Vector):Float {
        return Math.atan(v.y/v.x).toDegrees() + (if (v.x >= 0) 180 else 0);
    }
    
    inline public static function fromForceAngle(v:Vector):Vector {
        return new Vector(Math.cos(v.y.toRadians())*v.x, Math.sin(v.y.toRadians())*v.x);
    }
}
