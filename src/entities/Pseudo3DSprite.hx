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
    
    public var frames : Int;
    public var sprites : Array<Sprite>;
    public var rot(default, set): Float;
    public var size : Vector;
    public var texture : phoenix.Texture;
    
    override public function new(options : Pseudo3DOptions) {
        sprites = [];
        
        super(options);
        
        frames = options.frames;
        size = options.size;
        texture = options.texture;
        rot = 0;
        
        for (n in 0...frames) {
            var spr = new Sprite({
                parent: this,
                name: name + "." + n,
                pos: new Vector(0, -n),
                size: size,
                texture: texture
            });
            
            spr.uv = new luxe.Rectangle(size.x*n, 0, size.x, size.y);
            
            sprites.push(spr);
        }
    }
    
    function set_rot(val) {
        for (spr in sprites) {
            spr.rotation_z = val;
        }
        return rot = val;
    }

}
