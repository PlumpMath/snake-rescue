package states;

import luxe.States;
import luxe.options.StateOptions;

import luxe.Input;

import luxe.Vector;
import entities.Pseudo3D;
import phoenix.Texture;

import differ.shapes.Polygon;

class PlayState extends State {
    
    var background : luxe.Sprite;
    var overlay : luxe.Sprite;
    
    override public function new(options : StateOptions){
        super(options);
        
        createBackground();
        
        Main.player = new entities.Player({
            name: "Player",
            pos: new Vector(128, 128)
        });
        
        var ops : {entities:Array<Dynamic>} = Luxe.resources.json("assets/levels/level0.json").asset.json;
        
        for (entity in ops.entities) {
            var spr = Main.creators[entity.type](cast {
                name: entity.name,
                pos: new Vector(entity.x, entity.y)
            });
            Main.sprites.push(spr);
            Main.colliders.push(spr.collider);
        }
    }
    
    override function update(delta:Float) {
        
    }
    
    function createBackground() {
        background = new luxe.Sprite({
            name: "background",
            pos: new Vector(0, 0),
            size: new Vector(576, 608),
            texture: Luxe.resources.texture("assets/textures/Background.png"),
            centered: false,
            batcher: Main.backgroundBatcher
        });
        overlay = new luxe.Sprite({
            name: "overlay",
            pos: new Vector(0, 0),
            size: new Vector(576, 608),
            texture: Luxe.resources.texture("assets/textures/Overlay.png"),
            centered: false,
            batcher: Main.foregroundBatcher,
            depth: 1
        });
        Main.colliders.push(Polygon.rectangle(0, 0, 576, 64, false));
        Main.colliders.push(Polygon.rectangle(0, 32, 32, 544, false));
        Main.colliders.push(Polygon.rectangle(544, 32, 32, 544, false));
        Main.colliders.push(Polygon.rectangle(0, 576, 576, 32, false));
    }

}
