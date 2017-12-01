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
        mapmap = maps.MapGeneration.createYucatecMap();
        
        for (x in 0...(Math.floor(Math.random()*(50-25+0.99))+25)) {
            var x;
            var y;
            do {
                x = Math.floor(Math.random()*(mapmap.w*9+1));
                y = Math.floor(Math.random()*(mapmap.h*9+1));
                x = x*32+16;
                y = y*32+16;
            } while(Main.solid(x, y, 16));
            
            var shooter = new entities.yu.Shooter({
                pos: new Vector(x, y)
            });
            Main.sprites.push(shooter);
            Main.colliders.push(shooter.collider);
        }
    }
    
    override public function onkeydown(event:KeyEvent) {
        if (event.keycode == Key.key_r) {
            mapmap.destroy();
            
            createBackground();
            for (sprite in Main.sprites) {
                sprite.destroy();
            }
            
            Main.player.x = 128 + 32/2; // center the player
            Main.player.y = 160 + 32/2; // inside the tiles
        }
    }

}
