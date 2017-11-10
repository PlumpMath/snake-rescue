package ;

import entities.Pseudo3D;

import luxe.Parcel;

typedef EntityOptions = {
    name: String,
    texture: String,
    frames: Int,
    w: Float, h: Float,
    growing: Bool
}

class EntitiesLoader {
    
    var entities : Array<EntityOptions>;
    
    public function new() { }
    
    public function load(_, main) {
        var textures = [];
        entities = Luxe.resources.json("assets/entities.json").asset.json;
        
        for (entity in entities) {
            textures.push({id: entity.texture});
        }
        
        var parcel = new Parcel({ textures: textures });
        
        new DestroyParcelProgress({
            parcel: parcel,
            secondHalf: true,
            oncomplete: createCreators.bind(_, main)
        });
        
        parcel.load();
    }
    
    function createCreators(_, main) {
        for (entity in entities) {
            Main.creators[entity.name] = Pseudo3D.newCreator({
                frames: entity.frames,
                size: new luxe.Vector(entity.w, entity.h),
                texture: Luxe.resources.texture(entity.texture),
                growing: entity.growing
            });
        }
        
        main.assets_loaded(_); // now we return to main
    }
}
