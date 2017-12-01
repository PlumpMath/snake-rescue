package entities.yu;

using utils.ForceAngle;

import entities.Pseudo3D;
import AssetsLoader;
import luxe.Vector;

class Shooter extends Pseudo3D {
    
    var loop : snow.api.Timer;
    override public function new(options : OptionalPseudo3DOptions) {
        var jsonOptions : EntJSONOptions = Luxe.resources.json("assets/entities.json").asset.json.yu_shooter;
        options.height = jsonOptions.h;
        options.size = new Vector(jsonOptions.w, jsonOptions.d);
        options.growing = jsonOptions.growing;
        options.texture = Luxe.resources.texture(jsonOptions.texture);
        
        super(options);
        
        loop = Luxe.timer.schedule(1, function() {
            var dir = pos.clone().subtract(Main.player.pos);
            if (dir.getForce() < 100) {
                Luxe.audio.play(Luxe.resources.audio("assets/sfx/altar_rotation.wav").source);
                luxe.tween.Actuate.tween(this, 0.25, {rotation_z: dir.getAngle()}).smartRotation(true);
                Luxe.timer.schedule(0.25, function() {
                    if (!this.destroyed) new Bullet({
                        name: "bull"+Math.random(),
                        rotation_z: dir.getAngle(),
                        pos: pos.clone()
                    });
                });
            }
        }, true);
    }
    
    override function ondestroy() {
        super.ondestroy();
        loop.stop();
        luxe.tween.Actuate.stop(this);
    }
    
    override function update(dt:Float) {
        
    }

}

class Bullet extends Pseudo3D {
    
    var initialpos : Vector;
    override public function new(options : OptionalPseudo3DOptions) {
        var jsonOptions : EntJSONOptions = Luxe.resources.json("assets/entities.json").asset.json.yu_bullet;
        options.height = jsonOptions.h;
        options.size = new Vector(jsonOptions.w, jsonOptions.d);
        options.growing = jsonOptions.growing;
        options.texture = Luxe.resources.texture(jsonOptions.texture);
        
        super(options);
        
        initialpos = options.pos;
        
        var move = (new Vector(16, rotation_z)).fromForceAngle();
        x += move.x;
        y += move.y;
    }
    
    override function update(dt:Float) {
        var move = (new Vector(32, rotation_z)).fromForceAngle().multiplyScalar(dt/0.2);
        x += move.x;
        y += move.y;
        
        if (pos.clone().subtract(initialpos).getForce() > 512) {
            this.destroy();
        } else {
            var collision = differ.Collision.shapeWithShape(collider, Main.player.collider);
            if (collision != null) {
                Main.player.events.fire("player.attacked", {by:"bullet"});
                this.destroy();
            } else {
                var collision = differ.Collision.shapeWithShapes(collider, cast Main.colliders);
                if (collision.length > 0)
                    this.destroy();
            }
        }
    }

}
