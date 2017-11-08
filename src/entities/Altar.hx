package entities;

import entities.Pseudo3DSprite;

import phoenix.Texture;

import luxe.Vector;

class Altar extends Pseudo3DSprite {

    override public function new(options : OptionalPseudo3DOptions){
        options.frames = 14;
        options.size = new Vector(40, 40);
        
        var image = Luxe.resources.texture("assets/textures/Altar.png");
        image.filter_min = image.filter_mag = FilterType.nearest;
        options.texture = image;
        
        super(options);
    }

    override function update(dt:Float){
        
    }

}
