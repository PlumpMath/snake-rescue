package entities;

using utils.ForceAngle;

import entities.Pseudo3D;

import luxe.Input;
import phoenix.Texture;
import EntitiesLoader;

import luxe.Vector;
import differ.Collision;

class Player extends Pseudo3D {
    
    public static var SNAKE_SPEED = 100;
    var target_rot : Float;
    var direction = {down:false, left:false, up:false, right:false};
    
    override public function new(options : OptionalPseudo3DOptions){
        var jsonOptions : EntJSONOptions = Luxe.resources.json("assets/entities.json").asset.json.player;
        options.frames = jsonOptions.frames;
        options.size = new Vector(jsonOptions.w, jsonOptions.h);
        options.growing = jsonOptions.growing;
        options.texture = Luxe.resources.texture(jsonOptions.texture);
        
        super(options);
    }

    override function update(dt:Float){
        // veryInefficient && iDontCare
        target_rot =
            if (direction.right && direction.down) 45 // down left
            else if (direction.right && direction.up) 315 // down right
            else if (direction.left && direction.down) 135 // up left
            else if (direction.left && direction.up) 225 // up right
            else if (direction.right && !direction.left) 0 // down
            else if (direction.down && !direction.up) 90 // left
            else if (direction.left && !direction.right) 180 // up
            else if (direction.up && !direction.down) 270 // down
            else pos.clone().subtractScalar(320).getAngle(); // if nothing is pressed, look at center of map
                    // clone because subtractScalar and friends are not functional
        
        if (direction.right && !direction.left) {
            x += SNAKE_SPEED*dt;
        }
        if (direction.down && !direction.up) {
            y += SNAKE_SPEED*dt;
        }
        if (direction.left && !direction.right) {
            x -= SNAKE_SPEED*dt;
        }
        if (direction.up && !direction.down) {
            y -= SNAKE_SPEED*dt;
        }
        Luxe.camera.pos = pos.clone().subtractScalar(256);
        Main.display_sprite.pos = Luxe.camera.pos.clone().addScalar(128);
            // use camera pos because camera cannot got offscreen, and the display shouldn't either
        
        if  (rotation_z != target_rot) { // smooth turning
            var diff = target_rot-(rotation_z % 360);
            
            if (diff > 180) {
                diff -= 360;
            } else if (diff < -180) {
                diff += 360;
            }
            
            rotation_z += diff/20;
            rotation_z = rotation_z % 360;
        }
        
        collide();
    }
    
    override function onkeydown(event : KeyEvent) {
        switch (event.keycode) {
            case Key.right:
                direction.right = true;
            case Key.down:
                direction.down = true;
            case Key.left:
                direction.left = true;
            case Key.up:
                direction.up = true;
        }
    }
    
    override function onkeyup(event : KeyEvent) {
        switch (event.keycode) {
            case Key.right:
                direction.right = false;
            case Key.down:
                direction.down = false;
            case Key.left:
                direction.left = false;
            case Key.up:
                direction.up = false;
        }
    }
    
    function collide() { // collision - very straightforward
        for (spr in Main.colliders) {
            var coll = Collision.shapeWithShape(collider, spr);
            if (coll != null) {
                x += coll.separationX;
                y += coll.separationY;
            }
        }
    }

}
