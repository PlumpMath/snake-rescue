package utils;

class RadiansDegrees {
    inline public static function toDegrees(radians:Float):Float {
        return radians * 180 / Math.PI;
    }
    
    inline public static function toRadians(degrees:Float):Float {
        return degrees * Math.PI / 180;
    }
}
