package ;

import entities.Pseudo3D;

import luxe.Parcel;

typedef EntJSONOptions = {
    ?name: String,
    ?texture: String,
    ?h: Int,
    ?w: Float, ?d: Float,
    ?rotation_z: Float,
    ?growing: Bool,
    ?frames: Int
}

class AssetsLoader {
    
    var entities : Dynamic;
    
    public function new() { }
    
    public function load(_, main) {
        var textures = [];
        entities = Luxe.resources.json("assets/entities.json").asset.json;
        
        var fields = Reflect.fields(entities);
        for (field in fields) {
            var entity: EntJSONOptions = Reflect.getProperty(entities, field);
            textures.push({id: entity.texture});
        }
        
        var jsons = [];
        var rooms: Dynamic = Luxe.resources.json("assets/rooms.json").asset.json;
        
        var failed = [];
        var fields = Reflect.fields(rooms);
        for (field in fields) {
            var room : Dynamic = Reflect.getProperty(rooms, field);
            
            if (Std.is(room, String)) {
                jsons.push({id: "assets/rooms/" + room});
            } else {
                try {
                    var room : Array<Array<Null<String>>> = cast room;
                        // bug: if the unsafe cast doesn't work, it silently crashes the game
                        // safe cast doesn't work for some strange reason I can't find the solution of :'( (Cast type parameters must be Dynamic)
                    for (y in room) {
                        for (x in y) {
                            if (x != null)
                                jsons.push({id: "assets/rooms/" + x});
                        }
                    }
                } catch(e:Dynamic) {
                    failed.push(field);
                    utils.Log.log('invalid format in: \'$field\'');
                }
            }
        }
        var failedString = failed.join(",");
        if (failed.length > 0) throw "invalid format in:\n" + failedString.substr(0,100) + (if (failedString.length > 100) "\n(check console)" else "");
        
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
                height: entity.h,
                size: new luxe.Vector(entity.w, entity.d),
                texture: Luxe.resources.texture(entity.texture),
                rotation_z: entity.rotation_z,
                growing: entity.growing,
                frames: entity.frames
            });
        }
        
        main.assets_loaded(_); // now we return to main
    }
}
