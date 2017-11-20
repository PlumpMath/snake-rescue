package states;

import luxe.States;
import luxe.options.StateOptions;

import luxe.Input;
import AssetsLoader;

import luxe.Vector;
import luxe.tilemaps.Tilemap;
import luxe.tilemaps.Ortho;

import differ.shapes.Polygon;

typedef MapJSONOptions = {
    entities: Array<{>EntJSONOptions, type:String, x:Float, y:Float}>,
    map: Array<Array<Int>>,
    tileset: String,
    collision: Array<{x:Float, y:Float, w:Float, h:Float, centered:Bool}>
}

class PlayState extends State {
    
    var backgrounda : Tilemap;
    var backgroundb : Tilemap;
    // var overlay : Tilemap;
    
    var ahuizotl : entities.Pseudo3D;
    
    var MapJSONa : MapJSONOptions;
    var MapJSONb : MapJSONOptions;
    
    override public function new(options : StateOptions){
        super(options);
        
        MapJSONa = Luxe.resources.json("assets/rooms/room1a.json").asset.json;
        MapJSONb = Luxe.resources.json("assets/rooms/room1b.json").asset.json;
        
        createBackground();
        
        Main.player = new entities.Player({
            name: "Player",
            pos: new Vector(128, 128)
        });
        
        for (entity in MapJSONa.entities) {
            var spr = Main.creators[entity.type](cast {
                name: entity.name,
                pos: new Vector(entity.x, entity.y),
                rotation_z: entity.rotation_z
            });
            
            Main.sprites.push(spr);
            Main.colliders.push(spr.collider);
        }
        
        ahuizotl = Main.creators["az-ahuizotl"](cast {
            name: "ah",
            pos: new Vector(200, 200)
        });
    }
    
    var total_time: Float = 0;
    override function update(delta:Float) {
        if(ahuizotl == null)return;
        total_time += delta/0.1;
        total_time = total_time%4;
        ahuizotl.frame = Math.floor(total_time);
        ahuizotl.rotation_z += 20*delta;
    }
    
    function createBackground() {
        
        backgrounda = new Tilemap({
            x: 0,
            y: 0,
            w: MapJSONa.map[0].length,
            h: MapJSONa.map.length,
            tile_width  : 32,
            tile_height : 32,
            orientation : TilemapOrientation.ortho
        });
        
        backgrounda.add_tileset({
            name: "yucatec",
            texture: Luxe.resources.texture('assets/tilesets/${MapJSONa.tileset}.png'),
            tile_width: 32, tile_height: 32
        });
        
        backgrounda.add_layer({name:"0", layer:0, opacity:1, visible:true});
        backgrounda.add_tiles_from_grid("0", MapJSONa.map);
        
        backgroundb = new Tilemap({
            x: 0,
            y: 288,
            w: MapJSONb.map[0].length,
            h: MapJSONb.map.length,
            tile_width  : 32,
            tile_height : 32,
            orientation : TilemapOrientation.ortho
        });
        
        backgroundb.add_tileset({
            name: "yucatec",
            texture: Luxe.resources.texture('assets/tilesets/${MapJSONb.tileset}.png'),
            tile_width: 32, tile_height: 32
        });
        
        backgroundb.add_layer({name:"0", layer:0, opacity:1, visible:true});
        backgroundb.add_tiles_from_grid("0", MapJSONb.map);
        
        backgroundb.display({scale:1, batcher:Main.backgroundBatcher});
        backgrounda.display({scale:1, batcher:Main.backgroundBatcher});
        
        for (collider in MapJSONa.collision) {
            Main.colliders.push(Polygon.rectangle(collider.x, collider.y, collider.w, collider.h, collider.centered));
        }
        for (collider in MapJSONb.collision) {
            Main.colliders.push(Polygon.rectangle(collider.x, collider.y+288, collider.w, collider.h, collider.centered));
        }
    }

}
