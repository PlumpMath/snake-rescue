package utils;

using utils.RadiansDegrees;

import luxe.Vector;

class ForceAngle {
    inline public static function getForce(v:Vector) {
        return Math.sqrt(v.x*v.x + v.y*v.y);
    }
    
    inline public static function getAngle(v:Vector) {
        return Math.atan(v.y/v.x).toDegrees() + (if (v.x >= 0) 180 else 0);
    }
}
