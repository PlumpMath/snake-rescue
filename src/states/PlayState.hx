package states;

import luxe.States;
import luxe.options.StateOptions;

import luxe.Input;
import AssetsLoader;

import luxe.Vector;
import luxe.tilemaps.Tilemap;
import luxe.tilemaps.Ortho;

import utils.ParentedPolygon;

typedef MapJSONOptions = {
    entities: Array<{>EntJSONOptions, type:String, x:Float, y:Float}>,
    map: Array<Array<Int>>,
    tileset: String,
    collision: Array<{x:Float, y:Float, w:Float, h:Float, centered:Bool}>,
    ?x: Int, ?y: Int
}

class PlayState extends State {
    
    var shooter : entities.Pseudo3D;
    var mapmap : maps.MapMap;
    
    override public function init(){
        Luxe.renderer.clear_color = new luxe.Color().rgb(0x2D1F2B);
        
        createBackground();
        
        Main.player = new entities.Player({
            name: "Player",
            pos: new Vector(128, 160) // top left corner of center tile in top left room. mouthful
        });
        
        Main.player.x += 32/2; // center the player
        Main.player.y += 32/2; // inside the tiles
        
        shooter = new entities.yu.Shooter({
            name: "ah",
            pos: new Vector(200, 200)
        });
    }
    
    override function update(delta:Float) {
        
    }
    
    function createBackground() {
        createYucatecMap();
        
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
    
    function createYucatecMap() {
        mapmap = new maps.MapMap({
            x: 0,
            y: 0,
            w: 5,
            h: 5,
            map_width  : 9,
            map_height : 9
        });
        
        mapmap.addRoom("yu_room0", 0, 0);
        mapmap.addRoom("yu_room0", 9, 9);
        for (y in 0...mapmap.h) {
            if (y < mapmap.h-1) {
                var placedvert;
                do {
                    if (Math.floor(Math.random() * 1.99) == 0) {
                        placedvert = mapmap.addRoom("yu_room1", Math.floor(Math.random() * 4.99), y);
                    } else {
                        placedvert = mapmap.addRoom("yu_room3", Math.floor(Math.random() * 4.99), y);
                    }
                } while(!placedvert);
            }
            
            for (x in 0...mapmap.w) {
                var map = mapmap.getPiece(x, y);
                if (map == null) {
                    var placed;
                    do {
                        if (Math.floor(Math.random() * 1.99) == 0) {
                            placed = mapmap.addRoom("yu_room0", x, y);
                        } else {
                            placed = mapmap.addRoom("yu_room2", x, y);
                        }
                    } while (!placed);
                }
            }
        }
    }
    
    override public function onkeydown(event:KeyEvent) {
        if (event.keycode == Key.key_r) {
            mapmap.destroy();
            
            createBackground();
            
            Main.player.x = 128 + 32/2; // center the player
            Main.player.y = 160 + 32/2; // inside the tiles
        }
    }

}
