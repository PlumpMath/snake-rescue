package entities;

using utils.RadiansDegrees;

import entities.Pseudo3DSprite;

import luxe.Input;
import phoenix.Texture;

import luxe.Vector;

class Snake extends Pseudo3DSprite {
    
    public static var SNAKE_SPEED = 100;
    var target_rot : Float;
    var direction = {down:false, left:false, up:false, right:false};
    
    override public function new(options : OptionalPseudo3DOptions){
        options.frames = 23;
        options.size = new Vector(23, 23);
        
        var image = Luxe.resources.texture("assets/textures/Snake.png");
        image.filter_min = image.filter_mag = FilterType.nearest;
        options.texture = image;
        
        super(options);
    }

    override function update(dt:Float){
        // veryInefficient && iDontCare
        target_rot =
            if (direction.down && direction.left) 45 // down left
            else if (direction.down && direction.right) 315 // down right
            else if (direction.up && direction.left) 135 // up left
            else if (direction.up && direction.right) 225 // up right
            else if (direction.down) 0 // down
            else if (direction.left) 90 // left
            else if (direction.up) 180 // up
            else if (direction.right) 270 // down
            else Math.atan((pos.y-256)/(pos.x-256)).toDegrees() + (if (pos.x-256 >= 0) 90 else -90); // if nothing is pressed, look at center of map
        // opposite directions (ex. down && up) are handled by the onkeydown event
        
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
        if (direction.right) {
            pos.x += SNAKE_SPEED*dt;
            Luxe.camera.pos.x += SNAKE_SPEED*dt;
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
            case Key.right:
                if (direction.left)
                    direction.left = direction.right = false;
                else
                    direction.right = true;
        }
    }
    
    override function onkeyup(event : KeyEvent) {
        switch (event.keycode) {
            case Key.down:
                direction.down = false;
            case Key.left:
                direction.left = false;
            case Key.up:
                direction.up = false;
            case Key.right:
                direction.right = false;
        }
    }

}
