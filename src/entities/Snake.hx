package entities;

using utils.ForceAngle;

import entities.Pseudo3DSprite;

import luxe.Input;
import phoenix.Texture;

import luxe.Vector;

class Snake extends Pseudo3DSprite {
    
    public static var SNAKE_SPEED = 100;
    var target_rot : Float;
    var direction = {down:false, left:false, up:false, right:false};
    
    override public function new(options : OptionalPseudo3DOptions){
        options.frames = 19;
        options.size = new Vector(21, 9);
        
        var image = Luxe.resources.texture("assets/textures/Snake.png");
        image.filter_min = image.filter_mag = FilterType.nearest;
        options.texture = image;
        
        super(options);
    }

    override function update(dt:Float){
        // veryInefficient && iDontCare
        target_rot =
            if (direction.right && direction.down) 45 // down left
            else if (direction.right && direction.up) 315 // down right
            else if (direction.left && direction.down) 135 // up left
            else if (direction.left && direction.up) 225 // up right
            else if (direction.right) 0 // down
            else if (direction.down) 90 // left
            else if (direction.left) 180 // up
            else if (direction.up) 270 // down
            else pos.clone().subtractScalar(256).getAngle(); // if nothing is pressed, look at center of map
                    // clone because subtractScalar and friends are not functional
        // opposite directions (ex. down && up) are handled by the onkeydown event
        
        
        if (direction.right) {
            pos.x += SNAKE_SPEED*dt;
            Luxe.camera.pos.x += SNAKE_SPEED*dt;
        }
        if (direction.down) {
            pos.y += SNAKE_SPEED*dt;
            Luxe.camera.pos.y += SNAKE_SPEED*dt;
        }
        if (direction.left) {
            pos.x -= SNAKE_SPEED*dt;
            Luxe.camera.pos.x -= SNAKE_SPEED*dt;
        }
        if (direction.up) {
            pos.y -= SNAKE_SPEED*dt;
            Luxe.camera.pos.y -= SNAKE_SPEED*dt;
        }
        
        if  (rot != target_rot) {
            var diff = target_rot-(rot % 360);
            
            if (diff > 180) {
                diff -= 360;
            } else if (diff < -180) {
                diff += 360;
            }
            
            rot += diff/20;
            rot = rot % 360;
        }
    }
    
    override function onkeydown(event : KeyEvent) {
        switch (event.keycode) {
            case Key.right:
                if (direction.left)
                    direction.left = direction.right = false;
                else
                    direction.right = true;
            case Key.down:
                if (direction.up) // for each case, if the opposite direction is true, turn both false
                    direction.up = direction.down = false;
                else
                    direction.down = true;
            case Key.left:
                if (direction.right)
                    direction.right = direction.left = false;
                else
                    direction.left = true;
            case Key.up:
                if (direction.down)
                    direction.down = direction.up = false;
                else
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

}
