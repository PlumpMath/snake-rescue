package maps;

import luxe.tilemaps.Tilemap;
import luxe.tilemaps.Ortho;
import AssetsLoader;

import haxe.ds.Vector as HVector;

import differ.shapes.Polygon;

typedef MapMapOptions = {
    x: Float, y: Float,
    w: Int, h: Int,
    map_width: Int, map_height: Int
}

typedef MapJSONOptions = {
    entities: Array<{>EntJSONOptions, type:String, x:Float, y:Float}>,
    map: Array<Array<Int>>,
    tileset: String,
    collision: Array<{x:Float, y:Float, w:Float, h:Float, centered:Bool}>,
    left_wall: Bool, right_wall: Bool,
    ?tilemap: Tilemap
}

class MapMap {
    public var x : Float;
    public var y : Float;
    
    public var w : Int;
    public var h : Int;
    
    public var map_width : Int;
    public var map_height : Int;
    
    public var mapmap : HVector<HVector<Null<MapJSONOptions>>>;
    
    public function new(options : MapMapOptions) {
        x = options.x;
        y = options.y;
        
        w = options.w;
        h = options.h;
        
        map_width = options.map_width;
        map_height = options.map_height;
        
        mapmap = new HVector(h);
        for (y in 0...h) {
            mapmap[y] = new HVector(w);
            for (x in 0...w) {
                mapmap[y][x] = null;
            }
        }
    }
    
    public function addRoom(_room:String, x:Int, y:Int) : Bool {
        if(x < 0 || y < 0 || x >= w || y >= h) return false;
        if (mapmap[y][x] != null) return false;
        
        var room : Dynamic = Reflect.getProperty(Luxe.resources.json("assets/rooms.json").asset.json, _room);
        
        if (Std.is(room, String)) {
            return addPiece(room, x, y);
        } else {
            var room : Array<Array<String>> = cast room; // it can't be any other thing. It has already been checked in AssetsLoader.hx
            
            var couldPlace : Bool = false;
            var placed : Array<luxe.Vector> = [];
            for (yy in 0...room.length) {
                for (xx in 0...room[yy].length) {
                    couldPlace = addPiece(room[yy][xx], x+xx, y+yy);
                    
                    if (couldPlace) {
                        placed.push(new luxe.Vector(x+xx, y+yy));
                    } else { break; }
                }
                if (!couldPlace) break;
            }
            
            if (!couldPlace) {
                for (room in placed) {
                    removePiece(Std.int(room.x), Std.int(room.y));
                }
                return false;
            }
            return true;
        }
    }
    
    public function addPiece(asset:String, x:Int, y:Int) : Bool {
        if (x < 0 || y < 0 || x >= w || y >= h) return false;
        if (mapmap[y][x] != null) return false;
        
        var options : MapJSONOptions = Reflect.copy(Luxe.resources.json(asset).asset.json);
            // there can only be 1 reference alive to an instance!
            // So if I add the same room/piece in another place in the mapmap, the first one will disappear!
        
        var tilemap = new Tilemap({
            x: (32*map_width)*x,
            y: (32*map_height)*y,
            w: options.map[0].length,
            h: options.map.length,
            tile_width  : 32,
            tile_height : 32,
            orientation : TilemapOrientation.ortho
        });
        
        tilemap.add_tileset({
            name: options.tileset,
            texture: Luxe.resources.texture('assets/tilesets/${options.tileset}.png'),
            tile_width: 32, tile_height: 32
        });
        
        tilemap.add_layer({name:"0", layer:0, opacity:1, visible:true});
        tilemap.add_tiles_from_grid("0", options.map);
        
        options.tilemap = tilemap;
        mapmap[y][x] = options;
        
        return true;
    }
    
    public function getPiece(x:Int, y:Int) {
        return mapmap[y][x];
    }
    
    public function removePiece(x:Int, y:Int) {
        if (mapmap[y][x] != null) {
            mapmap[y][x].tilemap.destroy();
            mapmap[y][x] = null;
        }
    }
    
    public function display() {
        for (row in mapmap) {
            for (options in row) {
                if (options != null) {
                    options.tilemap.display({scale:1, batcher:Main.backgroundBatcher});
                    for (collider in options.collision) {
                        Main.colliders.push(Polygon.rectangle(options.tilemap.pos.x + collider.x,
                                                              options.tilemap.pos.y + collider.y,
                                                              collider.w, collider.h,
                                                              collider.centered));
                    }
                }
            }
        }
    }
    
    public function destroy() {
        for (y in 0...mapmap.length) {
            for (x in 0...mapmap[y].length) {
                removePiece(x, y);
            }
        }
    }
}
