package states;

import luxe.States;
import luxe.options.StateOptions;

import luxe.Input;

import luxe.Vector;
import phoenix.Texture;

class PlayState extends State {
    
    var snake : entities.Snake;
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
            size: new Vector(512, 512),
            texture: image,
            centered: false,
            batcher: Main.backgroundBatcher
        });
        
        snake = new entities.Snake({
            name: "Snake",
            pos: new Vector(128, 128)
        });
        
        altar = new entities.Altar({
            name: "Altar",
            pos: new Vector(20, 20)
        });
        
        var altar2 = new entities.Altar({
            name: "Altar2",
            pos: new Vector(61, 20)
        });
        
        head = new entities.Head({
            name: "Head",
            pos: new Vector(100, 50)
        });
    }
    
    override function update(delta:Float) {
        altar.rotation_z += 40*delta;
        head.rotation_z += 40*delta;
    }

}
