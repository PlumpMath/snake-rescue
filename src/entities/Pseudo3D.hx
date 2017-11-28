package entities;

import luxe.Sprite;
import luxe.Entity;
import luxe.options.EntityOptions;

import luxe.Vector;
import luxe.Color;
import differ.Collision;
import differ.shapes.*;

typedef Pseudo3DOptions = {
    > EntityOptions,
    
    height: Int,
    ?rotation_z: Float,
    size: Vector,
    ?color: Color,
    texture: phoenix.Texture,
    growing: Bool,
    ?frames: Int
};

typedef OptionalPseudo3DOptions = {
    > Pseudo3DOptions,
    
    ?height: Int,
    ?size: Vector,
    ?texture: phoenix.Texture,
    ?growing: Bool
};

class Pseudo3D extends Entity {
    
    public var rotation_z(default, set): Float = 0;
    public var x(default, set): Float = 0;
    public var y(default, set): Float = 0;
    
    public var height : Int;
    public var sprites : Array<Sprite>;
    public var size : Vector;
    public var color: Color;
    public var texture : phoenix.Texture;
    
    public var frames : Int;
    public var frame(default, set): Int;
    
    public var collider : differ.shapes.Polygon;
    
    override public function new(options : Pseudo3DOptions) {
        sprites = [];
        
        super(options);
        
        height = options.height;
        if (options.rotation_z != null) rotation_z = options.rotation_z;
        size = options.size;
        color = if (options.color != null) options.color else new Color(1, 1, 1, 1);
        texture = options.texture;
        x = pos.x;
        y = pos.y;
        
        frames = if (options.frames == null || options.frames < 1) 1 else options.frames;
        frame = 0;
        
        for (n in 0...height) {
            var spr = new Sprite({
                parent: this,
                name: name + "." + n,
                pos: new Vector(0, -n),
                rotation_z: rotation_z,
                size: size,
                color: color,
                texture: texture,
                depth: pos.y+(n+1)/1000
            });
            
            if (options.growing) {
                spr.pos.y = 0;
                spr.color = new Color(100, 100, 100, 1);
                luxe.tween.Actuate.tween(spr.pos, 1, {y: -n});
                spr.color.tween(1, {r: color.r, g: color.g, b: color.b});
            }
            
            spr.uv = new luxe.Rectangle(size.x*n, size.y*frame, size.x, size.y);
            
            sprites.push(spr);
        }
        
        
        collider = Polygon.rectangle(pos.x, pos.y, size.x, size.y);
        collider.rotation = rotation_z;
    }
    
    override public function ondestroy() {
        collider.destroy();
    }
    
    function set_rotation_z(val) {
        for (spr in sprites) {
            spr.rotation_z = val;
        }
        if (collider!=null) collider.rotation = val;
        return rotation_z = val;
    }
    
    function set_x(val) {
        pos.x = val;
        if (collider!=null) collider.x = val;
        return x = val;
    }
    
    function set_y(val) {
        var n:Float = 0;
        for (spr in sprites) {
            spr.depth = val+(n+1)/1000;
            n++;
        }
        pos.y = val;
        if (collider!=null) collider.y = val;
        return y = val;
    }
    
    function set_frame(val) {
        var actual = if(val < 0) 0 else val%frames;
        for (spr in sprites) {
            spr.uv.y = size.y*actual;
        }
        return frame = actual;
    }
    
    public static function newCreator(defOptions : Pseudo3DOptions) {
        var fields = Reflect.fields(defOptions);
        return function(options : OptionalPseudo3DOptions){
            for (field in fields) {
                var defValue = Reflect.getProperty(defOptions, field);
                if (defValue != null) Reflect.setProperty(options, field, defValue);
            }
            
            return new Pseudo3D(options);
        }
    }

}
