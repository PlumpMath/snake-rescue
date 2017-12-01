package entities;

import entities.Pseudo3D;

import luxe.Input;
import phoenix.Texture;
import AssetsLoader;

import luxe.Vector;

class Player extends Pseudo3D {
    
    public static var SNAKE_TIME = 0.15;
    
    var initialx : Float;
    var initialy : Float;
    
    override public function new(options : OptionalPseudo3DOptions){
        var jsonOptions : EntJSONOptions = Luxe.resources.json("assets/entities.json").asset.json.snake;
        options.height = jsonOptions.h;
        options.size = new Vector(jsonOptions.w, jsonOptions.d);
        options.growing = jsonOptions.growing;
        options.texture = Luxe.resources.texture(jsonOptions.texture);
        
        super(options);
        
        initialx = options.pos.x;
        initialy = options.pos.y;
        
        events.listen("player.attacked", function(_){ cast(Luxe.core.game, Main).playState.mapreset(); });
    }
    
    var direction = {down:false, left:false, up:false, right:false};
    var target_rot : Float = 0;
    var tweening = false;
    override function update(dt:Float){
        if (!tweening) {
            if (target_rot == 0) { // right
                if (Main.solid(x+32, y)) {
                    var coll = Main.colliderAt(x+32, y);
                    if (coll != null && coll.parent != null && Type.getClass(coll.parent) == entities.yu.Shooter) {
                        coll.parent.destroy();
                        Luxe.audio.play(Luxe.resources.audio("assets/sfx/altar_destroyed.wav").source);
                    }
                } else {
                    tweening = true;
                    luxe.tween.Actuate.tween(this, SNAKE_TIME, {x: x+32});
                    Luxe.timer.schedule(SNAKE_TIME, function(){ tweening = false; });
                }
            } else if (target_rot == 90) { // down
                if (Main.solid(x, y+32)) {
                    var coll = Main.colliderAt(x, y+32);
                    if (coll != null && coll.parent != null && Type.getClass(coll.parent) == entities.yu.Shooter) {
                        coll.parent.destroy();
                        Luxe.audio.play(Luxe.resources.audio("assets/sfx/altar_destroyed.wav").source);
                    }
                } else {
                    tweening = true;
                    luxe.tween.Actuate.tween(this, SNAKE_TIME, {y: y+32});
                    Luxe.timer.schedule(SNAKE_TIME, function(){ tweening = false; });
                }
            } else if (target_rot == 180) { // left
                if (Main.solid(x-32, y)) {
                    var coll = Main.colliderAt(x-32, y);
                    if (coll != null && coll.parent != null && Type.getClass(coll.parent) == entities.yu.Shooter) {
                        coll.parent.destroy();
                        Luxe.audio.play(Luxe.resources.audio("assets/sfx/altar_destroyed.wav").source);
                    }
                } else {
                    tweening = true;
                    luxe.tween.Actuate.tween(this, SNAKE_TIME, {x: x-32});
                    Luxe.timer.schedule(SNAKE_TIME, function(){ tweening = false; });
                }
            } else if (target_rot == 270) { // up
                if (Main.solid(x, y-32)) {
                    var coll = Main.colliderAt(x, y-32);
                    if (coll != null && coll.parent != null && Type.getClass(coll.parent) == entities.yu.Shooter) {
                        coll.parent.destroy();
                        Luxe.audio.play(Luxe.resources.audio("assets/sfx/altar_destroyed.wav").source);
                    }
                } else {
                    tweening = true;
                    luxe.tween.Actuate.tween(this, SNAKE_TIME, {y: y-32});
                    Luxe.timer.schedule(SNAKE_TIME, function(){ tweening = false; });
                }
            }
        }
        
        luxe.tween.Actuate.tween(this, 0.1, {rotation_z: target_rot}).smartRotation(true);
        
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
    
    public function reset() {
        luxe.tween.Actuate.stop(this);
        x = initialx + 16;
        y = initialy + 16;
        target_rot = 0;
    }

}
