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
    
    var huay_chivo : entities.Pseudo3D;
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
        
        huay_chivo = Main.creators["yu_huay_chivo"]({
            name: "ah",
            pos: new Vector(200, 200)
        });
        Main.running = true;
    }
    
    override function update(dt:Float) {
        
    }
    
    function createBackground() {
        mapmap = maps.MapGeneration.createYucatecMap();
        
        for (x in 0...100) {
            var x : Float;
            var y : Float;
            var enemy : entities.Pseudo3D;
            if (Math.floor(Math.random()*2.99) > 0) {
                do {
                    x = Math.floor(Math.random()*(mapmap.w*9+1));
                    y = Math.floor(Math.random()*(mapmap.h*9+1));
                    x = x*32+16;
                    y = y*32+16;
                } while((x < 288 && y < 288) || Main.solid(x, y, 16));
                
                enemy = new entities.yu.Shooter({
                    pos: new Vector(x, y),
                    rotation_z: Math.floor(Math.random()*3.99)*90
                });
            } else {
                do {
                    x = Math.random()*(mapmap.w*9*32);
                    y = Math.random()*(mapmap.h*9*32);
                } while((x < 288 && y < 288) || Main.solid(x, y-16, 48));
                
                enemy = new entities.yu.HuayChivo({
                    pos: new Vector(x, y)
                });
            }
            Main.sprites.push(enemy);
            Main.colliders.push(enemy.collider);
        }
    }
    
    public function mapreset() {
        Main.running = false;
        mapmap.destroy();
        
        Main.colliders = [];
        for (sprite in Main.sprites) {
            if(!sprite.destroyed) sprite.destroy();
        }
        Main.sprites = [];
        createBackground();
        
        Main.player.reset();
        Main.running = true;
    }
    
    override public function onkeydown(event:KeyEvent) {
        if (event.keycode == Key.key_r) {
            mapreset();
        }
    }

}
