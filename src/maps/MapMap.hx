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
    ?tilemap: Tilemap, ?colliders: Array<differ.shapes.Shape>,
    ?left_collider: differ.shapes.Shape, ?right_collider: differ.shapes.Shape
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
        if (getPiece(x, y) != null) return false;
        
        var room : Dynamic = Reflect.getProperty(Luxe.resources.json("assets/rooms.json").asset.json, _room);
        
        if (Std.is(room, String)) {
            return addPiece(room, x, y);
        } else {
            var room : Array<Array<String>> = cast room; // it can't be any other thing. It has already been checked in AssetsLoader.hx
            
            var couldPlace : Bool = false;
            var placed : Array<luxe.Vector> = [];
            for (yy in 0...room.length) {
                for (xx in 0...room[yy].length) {
                    var nx = x+xx;
                    var ny = y+yy;
                    couldPlace = addPiece(room[yy][xx], nx, ny);
                    
                    if (couldPlace) {
                        placed.push(new luxe.Vector(nx, ny));
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
        if (getPiece(x, y) != null) return false;
        
        var resource = Luxe.resources.json("assets/rooms/" + asset);
        if (resource == null) return false;
        var options : MapJSONOptions = Reflect.copy(resource.asset.json);
            // there can only be 1 reference alive to an instance!
            // So if I add the same room/piece in another place in the mapmap, the first one will disappear!
        options.colliders = [];
        
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
        
        tilemap.display({scale:1, batcher:Main.backgroundBatcher});
        var offset = Math.ceil((map_height - 5) / 2)+3;
        for (collider in options.collision) {
            var coll = Polygon.rectangle(tilemap.pos.x + collider.x,
                                         tilemap.pos.y + collider.y,
                                         collider.w, collider.h,
                                         collider.centered);
            Main.colliders.push(coll);
            options.colliders.push(coll); // what i explained above at the start of this function doesn't apply here???
        }
            
        options.left_collider = Polygon.rectangle(tilemap.pos.x,
                                                  tilemap.pos.y + offset*32,
                                                  32, 32, false);
        options.right_collider = Polygon.rectangle(tilemap.pos.x + (map_width-1)*32,
                                                  tilemap.pos.y + offset*32,
                                                  32, 32, false);
        Main.colliders.push(options.left_collider);
        Main.colliders.push(options.right_collider);
        
        options.tilemap = tilemap;
        mapmap[y][x] = options;
        
        addDoorways(x, y);
        
        return true;
    }
    
    public function getPiece(x:Int, y:Int) {
        if (x < 0 || y < 0 || x >= w || y >= h) return null;
        return mapmap[y][x];
    }
    
    public function removePiece(x:Int, y:Int) {
        var piece = getPiece(x, y);
        if (piece != null) {
            piece.tilemap.destroy();
            for (collider in piece.colliders) {
                Main.colliders.remove(collider);
                collider.destroy();
            }
            
            Main.colliders.remove(piece.left_collider);
            Main.colliders.remove(piece.right_collider);
            if (piece.left_collider != null) piece.left_collider.destroy();
            if (piece.right_collider != null) piece.right_collider.destroy();
            
            mapmap[y][x] = null;
        }
    }
    
    public function destroy() {
        for (y in 0...mapmap.length) {
            for (x in 0...mapmap[y].length) {
                removePiece(x, y);
            }
        }
    }
    
    function addDoorways(x : Int, y : Int) {
        var current = getPiece(x, y);
        
        var offset = Math.ceil((map_height - 5) / 2);
        var side = getPiece(x-1, y);
        if (side != null) {
            if (current.left_wall && side.right_wall) {
                current.tilemap.tile_at("0", 0, offset).id = 15;
                current.tilemap.tile_at("0", 0, offset+1).id = 6;
                current.tilemap.tile_at("0", 0, offset+2).id = 12;
                current.tilemap.tile_at("0", 0, offset+3).id = 50;
                current.tilemap.tile_at("0", 0, offset+4).id = 3;
                current.tilemap.tile_at("0", 1, offset+3).id = 41;
                
                side.tilemap.tile_at("0", map_width-1, offset).id = 13;
                side.tilemap.tile_at("0", map_width-1, offset+1).id = 6;
                side.tilemap.tile_at("0", map_width-1, offset+2).id = 12;
                side.tilemap.tile_at("0", map_width-1, offset+3).id = 50;
                side.tilemap.tile_at("0", map_width-1, offset+4).id = 1;
                side.tilemap.tile_at("0", map_width-2, offset+3).id = 40;
            }
            
            if (current.left_wall == side.right_wall) {
                Main.colliders.remove(current.left_collider);
                if (current.left_collider != null) current.left_collider.destroy();
                current.left_collider = null;
                    
                Main.colliders.remove(side.right_collider);
                if (side.right_collider != null) side.right_collider.destroy();
                side.right_collider = null;
            }
        }
        
        var side = getPiece(x+1, y);
        if (side != null) {
            if (current.right_wall && side.left_wall) {
                side.tilemap.tile_at("0", 0, offset).id = 15;
                side.tilemap.tile_at("0", 0, offset+1).id = 6;
                side.tilemap.tile_at("0", 0, offset+2).id = 12;
                side.tilemap.tile_at("0", 0, offset+3).id = 50;
                side.tilemap.tile_at("0", 0, offset+4).id = 3;
                side.tilemap.tile_at("0", 1, offset+3).id = 41;
                
                current.tilemap.tile_at("0", map_width-1, offset).id = 13;
                current.tilemap.tile_at("0", map_width-1, offset+1).id = 6;
                current.tilemap.tile_at("0", map_width-1, offset+2).id = 12;
                current.tilemap.tile_at("0", map_width-1, offset+3).id = 50;
                current.tilemap.tile_at("0", map_width-1, offset+4).id = 1;
                current.tilemap.tile_at("0", map_width-2, offset+3).id = 40;
            }
            
            if (current.right_wall == side.left_wall) {
                Main.colliders.remove(side.left_collider);
                if (side.left_collider != null) side.left_collider.destroy();
                side.left_collider = null;
                
                Main.colliders.remove(current.right_collider);
                if (current.right_collider != null) current.right_collider.destroy();
                current.right_collider = null;
            }
        }
    }
}
