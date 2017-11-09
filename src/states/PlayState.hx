package states;

import luxe.States;
import luxe.options.StateOptions;

import luxe.Input;

import luxe.Vector;
import entities.Pseudo3D;
import phoenix.Texture;

class PlayState extends State {
    
    var altar : Pseudo3D;
    var head : Pseudo3D;
    var background : luxe.Sprite;
    
    override public function new(options : StateOptions){
        super(options);
        
        var image = Luxe.resources.texture("assets/textures/Background.png");
        image.filter_min = image.filter_mag = FilterType.nearest;
        background = new luxe.Sprite({
            name: "background",
            pos: new Vector(0, 0),
            size: new Vector(640, 640),
            texture: image,
            centered: false,
            batcher: Main.backgroundBatcher
        });
        
        Main.player = new entities.Player({
            name: "Player",
            pos: new Vector(128, 128)
        });
        
        head = Main.creators["head"](cast {
            name: "Head",
            pos: new Vector(84, 124)
        });
        Main.sprites.push(head);
        
        altar = Main.creators["altar"](cast {
            name: "Altar",
            pos: new Vector(84, 84)
        });
        Main.sprites.push(altar);
        
        var altar2 = Main.creators["altar"](cast {
            name: "Altar2",
            pos: new Vector(124, 84)
        });
        Main.sprites.push(altar2);
    }
    
    override function update(delta:Float) {
        
    }

}
