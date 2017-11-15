package states;

import luxe.States;
import luxe.options.StateOptions;

import luxe.Input;

import luxe.Vector;
import luxe.tilemaps.Tilemap;
import luxe.tilemaps.Ortho;

import differ.shapes.Polygon;

class PlayState extends State {
    
    var background : Tilemap;
    // var overlay : Tilemap;
    
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
        
        var json : {map:Array<Array<Int>>, tileset: String} = Luxe.resources.json("assets/levels/level0.json").asset.json;
        background = new Tilemap({
            x: 0,
            y: 0,
            w: json.map[0].length,
            h: json.map.length,
            tile_width  : 32,
            tile_height : 32,
            orientation : TilemapOrientation.ortho
        });
        
        background.add_tileset({
            name: "yucatec",
            texture: Luxe.resources.texture('assets/tilesets/${json.tileset}.png'),
            tile_width: 32, tile_height: 32
        });
        
        background.add_layer({name:"0", layer:0, opacity:1, visible:true});
        background.add_tiles_from_grid("0", json.map);
        
        background.display({scale:1, batcher:Main.backgroundBatcher});
        
        // Main.colliders.push(Polygon.rectangle(0, 0, 576, 64, false));
        // Main.colliders.push(Polygon.rectangle(0, 32, 32, 544, false));
        // Main.colliders.push(Polygon.rectangle(544, 32, 32, 544, false));
        // Main.colliders.push(Polygon.rectangle(0, 576, 576, 32, false));
    }

}
