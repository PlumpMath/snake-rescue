package entities;

import entities.Pseudo3DSprite;

import phoenix.Texture;

import luxe.Vector;

class Snake extends Pseudo3DSprite {
    
    override public function new(options : OptionalPseudo3DOptions){
        options.frames = 19;
        options.size = new Vector(22, 7);
        
        var image = Luxe.resources.texture("assets/textures/Snake.png");
        image.filter_min = image.filter_mag = FilterType.nearest;
        options.texture = image;
        
        super(options);
    }

    override function update(dt:Float){
        
    }

}
