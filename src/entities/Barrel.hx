package entities;

import entities.Pseudo3DSprite;

import phoenix.Texture;

import luxe.Vector;

class Barrel extends Pseudo3DSprite {

    override public function new(options : OptionalPseudo3DOptions){
        options.frames = 11;
        options.size = new Vector(9, 9);
        
        var image = Luxe.resources.texture("assets/textures/Barrel.png");
        image.filter_min = image.filter_mag = FilterType.nearest;
        options.texture = image;
        
        super(options);
    }

    override function update(dt:Float){
        
    }

}
