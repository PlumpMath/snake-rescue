package entities;

import entities.Pseudo3DSprite;

import phoenix.Texture;

import luxe.Vector;

class Head extends Pseudo3DSprite {

    override public function new(options : OptionalPseudo3DOptions){
        options.frames = 33;
        options.size = new Vector(41, 41);
        
        var image = Luxe.resources.texture("assets/textures/Head.png");
        image.filter_min = image.filter_mag = FilterType.nearest;
        options.texture = image;
        
        super(options);
    }

    override function update(dt:Float){
        
    }

}
