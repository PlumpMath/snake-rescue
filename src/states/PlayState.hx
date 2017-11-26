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
    collision: Array<{x:Float, y:Float, w:Float, h:Float, centered:Bool}>,
    ?x: Int, ?y: Int
}

class PlayState extends State {
    
    var ahuizotl : entities.Pseudo3D;
    
    override public function new(options : StateOptions){
        super(options);
        
        Luxe.renderer.clear_color = new luxe.Color().rgb(0x2D1F2B);
        
        createBackground();
        
        Main.player = new entities.Player({
            name: "Player",
            pos: new Vector(128, 128)
        });
        
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
        var mapmap = new maps.MapMap({
            x: 0,
            y: 0,
            w: 4,
            h: 4,
            map_width  : 9,
            map_height : 9
        });
        
        mapmap.addPiece("assets/rooms/room0.json", 0, 0);
        mapmap.addRoom("room0", 0, 1);
        mapmap.addRoom("room1", 1, 0);
        mapmap.addRoom("room2", 0, 2);
        mapmap.addRoom("room3", 2, 1);
        
        // for (entity in MapJSONa.entities) {
            // var spr = Main.creators[entity.type](cast {
                // name: entity.name,
                // pos: new Vector(entity.x, entity.y),
                // rotation_z: entity.rotation_z
            // });
            
            // Main.sprites.push(spr);
            // Main.colliders.push(spr.collider);
        // }
    }

}
