package entities;

using utils.ForceAngle;

import entities.Pseudo3D;

import luxe.Input;
import phoenix.Texture;
import AssetsLoader;

import luxe.Vector;
import differ.Collision;

class Player extends Pseudo3D {
    
    public static var SNAKE_SPEED = 100;
    var target_rot : Float;
    var direction = {down:false, left:false, up:false, right:false};
    
    override public function new(options : OptionalPseudo3DOptions){
        var jsonOptions : EntJSONOptions = Luxe.resources.json("assets/entities.json").asset.json.snake;
        options.height = jsonOptions.h;
        options.size = new Vector(jsonOptions.w, jsonOptions.d);
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
            else target_rot; // if nothing is pressed, last direction
        
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
        
        Luxe.camera.center = pos.clone();
        Main.display_sprite.pos = pos.clone().subtractScalar(128);
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
