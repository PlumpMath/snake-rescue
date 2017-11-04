package states;

import luxe.States;
import luxe.options.StateOptions;

import luxe.Input;

import luxe.Vector;
import phoenix.Texture;

class PlayState extends State {
    
    var snake : entities.Pseudo3DSprite;
    var barrel : entities.Pseudo3DSprite;
    var crate : entities.Pseudo3DSprite;
    var background : luxe.Sprite;
    
    override public function new(options : StateOptions){
        super(options);
        
        var image = Luxe.resources.texture("assets/textures/Background.png");
        image.filter_min = image.filter_mag = FilterType.nearest;
        background = new luxe.Sprite({
            name: "background",
            pos: new Vector(0, 0),
            size: new Vector(512, 512),
            texture: image,
            centered: false
        });
        
        snake = new entities.Snake({
            name: "Snake",
            pos: new Vector(100, 100)
        });
        
        barrel = new entities.Barrel({
            name: "Barrel",
            pos: new Vector(50, 50)
        });
        
        crate = new entities.Crate({
            name: "Crate",
            pos: new Vector(100, 50)
        });
    }
    
    override function update(delta:Float) {
        barrel.rot += 40*delta;
        crate.rot += 40*delta;
    }

}
