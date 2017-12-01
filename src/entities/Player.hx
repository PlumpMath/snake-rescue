package entities;

import entities.Pseudo3D;

import luxe.Input;
import phoenix.Texture;
import AssetsLoader;

import luxe.Vector;

class Player extends Pseudo3D {
    
    public static var SNAKE_TIME = 0.15;
    
    override public function new(options : OptionalPseudo3DOptions){
        var jsonOptions : EntJSONOptions = Luxe.resources.json("assets/entities.json").asset.json.snake;
        options.height = jsonOptions.h;
        options.size = new Vector(jsonOptions.w, jsonOptions.d);
        options.growing = jsonOptions.growing;
        options.texture = Luxe.resources.texture(jsonOptions.texture);
        
        super(options);
        
        events.listen("player.attacked", function(_){ this.destroy(); });
    }
    
    var direction = {down:false, left:false, up:false, right:false};
    var target_rot : Float = 0;
    var tweening = false;
    override function update(dt:Float){
        if (!tweening) {
            if (!Main.solid(x+32, y) && target_rot == 0) { // right
                tweening = true;
                luxe.tween.Actuate.tween(this, SNAKE_TIME, {x: x+32});
                Luxe.timer.schedule(SNAKE_TIME, function(){ tweening = false; });
                
            } else if (!Main.solid(x, y+32) && target_rot == 90) { // down
                tweening = true;
                luxe.tween.Actuate.tween(this, SNAKE_TIME, {y: y+32});
                Luxe.timer.schedule(SNAKE_TIME, function(){ tweening = false; });
                
            } else if (!Main.solid(x-32, y) && target_rot == 180) { // left
                tweening = true;
                luxe.tween.Actuate.tween(this, SNAKE_TIME, {x: x-32});
                Luxe.timer.schedule(SNAKE_TIME, function(){ tweening = false; });
                
            } else if (!Main.solid(x, y-32) && target_rot == 270) { // up
                tweening = true;
                luxe.tween.Actuate.tween(this, SNAKE_TIME, {y: y-32});
                Luxe.timer.schedule(SNAKE_TIME, function(){ tweening = false; });
            }
        }
        
        if  (rotation_z != target_rot) { // smooth turning
            var diff = target_rot-(rotation_z % 360);
            
            if (diff > 180) {
                diff -= 360;
            } else if (diff < -180) {
                diff += 360;
            }
            
            rotation_z += diff/15;
            rotation_z = rotation_z % 360;
        }
        
        Luxe.camera.center = pos.clone();
        Main.display_sprite.pos = pos.clone().subtractScalar(128);
    }
    
    override function onkeydown(event : KeyEvent) {
        switch (event.keycode) {
            case Key.right:
                target_rot = 0;
            case Key.down:
                target_rot = 90;
            case Key.left:
                target_rot = 180;
            case Key.up:
                target_rot = 270;
        }
    }

}
