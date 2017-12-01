package entities.yu;

using utils.ForceAngle;

import entities.Pseudo3D;
import AssetsLoader;
import luxe.Vector;

class HuayChivo extends Pseudo3D {
    
    override public function new(options : OptionalPseudo3DOptions) {
        var jsonOptions : EntJSONOptions = Luxe.resources.json("assets/entities.json").asset.json.yu_huay_chivo;
        options.frames = jsonOptions.frames;
        options.height = jsonOptions.h;
        options.size = new Vector(jsonOptions.w, jsonOptions.d);
        options.growing = jsonOptions.growing;
        options.texture = Luxe.resources.texture(jsonOptions.texture);
        
        super(options);
    }
    
    var total_time : Float = 0;
    override function update(dt:Float) {
        if(!Main.running)return;
        
        total_time+=dt/0.25;
        frame = Math.floor(total_time);
        rotation_z += 30*dt;
        
        var move = (new Vector(2, rotation_z)).fromForceAngle().multiplyScalar(dt/0.25);
        x += move.x;
        y += move.y;
        
        if (pos.clone().subtract(Main.player.pos).getForce() < 32) {
            cast(Luxe.core.game, Main).playState.mapreset();
        }
    }
    
}
