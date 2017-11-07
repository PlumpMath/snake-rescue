package entities;

import luxe.Sprite;
import luxe.Entity;
import luxe.options.EntityOptions;

import luxe.Vector;

typedef Pseudo3DOptions = {
    > EntityOptions,
    
    frames: Int,
    size: Vector,
    texture: phoenix.Texture
};

typedef OptionalPseudo3DOptions = {
    > Pseudo3DOptions,
    
    ?frames: Int,
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
    public var texture : phoenix.Texture;
    
    override public function new(options : Pseudo3DOptions) {
        sprites = [];
        
        super(options);
        
        frames = options.frames;
        size = options.size;
        texture = options.texture;
        x = pos.x;
        y = pos.y;
        
        for (n in 0...frames) {
            var spr = new Sprite({
                parent: this,
                name: name + "." + n,
                pos: new Vector(0, -n),
                size: size,
                texture: texture,
                depth: pos.y+(n+1)/1000
            });
            
            spr.uv = new luxe.Rectangle(size.x*n, 0, size.x, size.y);
            
            sprites.push(spr);
        }
    }
    
    function set_rotation_z(val) {
        for (spr in sprites) {
            spr.rotation_z = val;
        }
        return rotation_z = val;
    }
    
    function set_x(val) {
        pos.x = val;
        return x = val;
    }
    
    function set_y(val) {
        var n:Float = 0;
        for (spr in sprites) {
            spr.depth = val+(n+1)/1000;
            n++;
        }
        pos.y = val;
        return y = val;
    }

}
