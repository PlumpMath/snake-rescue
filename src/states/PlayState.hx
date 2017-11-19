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
    
    var background : Tilemap;
    // var overlay : Tilemap;
    
    var ahuizotl : entities.Pseudo3D;
    
    var MapJSON : MapJSONOptions;
    
    override public function new(options : StateOptions){
        super(options);
        
        MapJSON = Luxe.resources.json("assets/rooms/room0.json").asset.json;
        
        createBackground();
        
        Main.player = new entities.Player({
            name: "Player",
            pos: new Vector(128, 128)
        });
        
        for (entity in MapJSON.entities) {
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
        
        background = new Tilemap({
            x: 0,
            y: 0,
            w: MapJSON.map[0].length,
            h: MapJSON.map.length,
            tile_width  : 32,
            tile_height : 32,
            orientation : TilemapOrientation.ortho
        });
        
        background.add_tileset({
            name: "yucatec",
            texture: Luxe.resources.texture('assets/tilesets/${MapJSON.tileset}.png'),
            tile_width: 32, tile_height: 32
        });
        
        background.add_layer({name:"0", layer:0, opacity:1, visible:true});
        background.add_tiles_from_grid("0", MapJSON.map);
        
        background.display({scale:1, batcher:Main.backgroundBatcher});
        
        for (collider in MapJSON.collision) {
            Main.colliders.push(Polygon.rectangle(collider.x, collider.y, collider.w, collider.h, collider.centered));
        }
    }

}
