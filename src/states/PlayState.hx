package states;

import luxe.States;
import luxe.options.StateOptions;

import luxe.Input;

import luxe.Vector;
import phoenix.Texture;

class PlayState extends State {
    
    var altar : entities.Altar;
    var head : entities.Head;
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
        
        head = new entities.Head({
            name: "Head",
            pos: new Vector(84, 124)
        });
        Main.sprites.push(head);
        
        altar = new entities.Altar({
            name: "Altar",
            pos: new Vector(84, 84)
        });
        Main.sprites.push(altar);
        
        var altar2 = new entities.Altar({
            name: "Altar2",
            pos: new Vector(124, 84)
        });
        Main.sprites.push(altar2);
    }
    
    override function update(delta:Float) {
        
    }

}
