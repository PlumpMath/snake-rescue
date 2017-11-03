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

class Pseudo3DSprite extends Entity {
    
    public var frames : Int;
    public var sprites : Array<Sprite>;
    public var rotation_z: Float;
    public var size : Vector;
    public var texture : phoenix.Texture;
    
    override public function new(options : Pseudo3DOptions) {
        sprites = [];
        
        super(options);
        
        frames = options.frames;
        size = options.size;
        texture = options.texture;
        rotation_z = 0;
        
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

    override function update(dt:Float) {
        for (spr in sprites) {
            spr.rotation_z = rotation_z;
        }
    }

}
