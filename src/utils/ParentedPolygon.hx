package utils;
import differ.math.*;
import differ.shapes.*;
import differ.data.*;
import differ.sat.*;
class ParentedPolygon extends differ.shapes.Polygon {
    public var parent : Null<entities.Pseudo3D> = null;
    
    public static function rectangle(x:Float, y:Float, width:Float, height:Float, centered:Bool = true):ParentedPolygon { // Stolen from differ's source
        var vertices:Array<Vector> = new Array<Vector>();

        if(centered) {
            vertices.push( new Vector( -width / 2, -height / 2) );
            vertices.push( new Vector(  width / 2, -height / 2) );
            vertices.push( new Vector(  width / 2,  height / 2) );
            vertices.push( new Vector( -width / 2,  height / 2) );
        } else {
            vertices.push( new Vector( 0, 0 ) );
            vertices.push( new Vector( width, 0 ) );
            vertices.push( new Vector( width, height) );
            vertices.push( new Vector( 0, height) );
        }

        return new ParentedPolygon(x,y,vertices); // only changed the return lol

    }
}
