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
    
    frames: Int,
    ?rotation_z: Float,
    size: Vector,
    ?color: Color,
    texture: phoenix.Texture
};

typedef OptionalPseudo3DOptions = {
    > Pseudo3DOptions,
    
    ?frames: Int,
    ?rotation_z: Float,
    ?size: Vector,
    ?texture: phoenix.Texture
};

class Pseudo3DSprite extends Entity {
    
    public var rotation_z(default, set): Float = 0;
    public var x(default, set): Float = 0;
    public var y(default, set): Float = 0;
    
    public var frames : Int;
    public var sprites : Array<Sprite>;
    public var size : Vector;
    public var color: Color;
    public var texture : phoenix.Texture;
    
    public var collider : differ.shapes.Shape;
    
    override public function new(options : Pseudo3DOptions) {
        sprites = [];
        
        super(options);
        
        frames = options.frames;
        if (options.rotation_z != null) rotation_z = options.rotation_z;
        size = options.size;
        if (options.color != null) color = options.color;
        texture = options.texture;
        x = pos.x;
        y = pos.y;
        
        for (n in 0...frames) {
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
            
            spr.uv = new luxe.Rectangle(size.x*n, 0, size.x, size.y);
            
            sprites.push(spr);
        }
        
        collider = Polygon.rectangle(pos.x, pos.y, size.x, size.y);
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

}
