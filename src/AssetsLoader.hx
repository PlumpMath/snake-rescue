package ;

import entities.Pseudo3D;

import luxe.Parcel;

typedef EntJSONOptions = {
    name: String,
    texture: String,
    frames: Int,
    w: Float, h: Float,
    growing: Bool
}

class AssetsLoader {
    
    var entities : Dynamic;
    
    public function new() { }
    
    public function load(_, main) {
        var textures = [];
        entities = Luxe.resources.json("assets/entities.json").asset.json;
        
        var fields = Reflect.fields(entities);
        for (field in fields) {
            var entity = Reflect.getProperty(entities, field);
            textures.push({id: entity.texture});
        }
        
        var jsons = [];
        var rooms: Array<String> = Luxe.resources.json("assets/rooms.json").asset.json;
        
        for (room in rooms) {
            jsons.push({id: room});
        }
        
        var parcel = new Parcel({textures: textures, jsons: jsons});
        
        new DestroyParcelProgress({
            parcel: parcel,
            secondHalf: true,
            oncomplete: createCreators.bind(_, main)
        });
        
        parcel.load();
    }
    
    function createCreators(_, main) {
        var fields = Reflect.fields(entities);
        for (field in fields) {
            var entity = Reflect.getProperty(entities, field);
            
            Main.creators[field] = Pseudo3D.newCreator({
                frames: entity.frames,
                size: new luxe.Vector(entity.w, entity.h),
                texture: Luxe.resources.texture(entity.texture),
                growing: entity.growing
            });
        }
        
        main.assets_loaded(_); // now we return to main
    }
}
