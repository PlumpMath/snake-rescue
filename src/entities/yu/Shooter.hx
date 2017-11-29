package entities.yu;

using utils.ForceAngle;

import entities.Pseudo3D;
import AssetsLoader;
import luxe.Vector;

class Shooter extends Pseudo3D {
    
    override public function new(options : OptionalPseudo3DOptions) {
        var jsonOptions : EntJSONOptions = Luxe.resources.json("assets/entities.json").asset.json.yu_shooter;
        options.height = jsonOptions.h;
        options.size = new Vector(jsonOptions.w, jsonOptions.d);
        options.growing = jsonOptions.growing;
        options.texture = Luxe.resources.texture(jsonOptions.texture);
        
        super(options);
        
        Luxe.timer.schedule(1, function() {
            var dir = pos.clone().subtract(Main.player.pos);
            if (dir.getForce() < 100) {
                luxe.tween.Actuate.tween(this, 0.25, {rotation_z: dir.getAngle()});
                Luxe.timer.schedule(0.25, function() {
                    new Bullet({
                        name: "bull"+Math.random(),
                        rotation_z: dir.getAngle(),
                        parent: this
                    });
                });
            }
        }, true);
    }
    
    override function update(dt:Float) {
        
    }

}

class Bullet extends Pseudo3D {
    
    override public function new(options : OptionalPseudo3DOptions) {
        var jsonOptions : EntJSONOptions = Luxe.resources.json("assets/entities.json").asset.json.yu_bullet;
        options.height = jsonOptions.h;
        options.size = new Vector(jsonOptions.w, jsonOptions.d);
        options.growing = jsonOptions.growing;
        options.texture = Luxe.resources.texture(jsonOptions.texture);
        
        super(options);
    }
    
    override function update(dt:Float) {
        var move = (new Vector(32, rotation_z)).fromForceAngle().multiplyScalar(dt/0.2);
        x += move.x;
        y += move.y;
        
        if (pos.getForce() > 512) this.destroy();
    }

}
