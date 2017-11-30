package maps;

class MapGeneration {
    
    public static function createAztecMap() {
        var mapmap = new maps.MapMap({
            x: 0,
            y: 0,
            w: 6,
            h: 5,
            map_width  : 9,
            map_height : 9
        });
        
        mapmap.addRoom("az_room0", 0, 0);
        
        for (x in 0...3) {
            var size = x*2+1;
            var offset = Math.floor((mapmap.h - size)/2);
            
            if (size == 1) {
                mapmap.addPiece("aztec/room0.json", offset+1, offset);
                continue;
            }
            for (x in 0...size) {
                for (y in 0...size) {
                    if (x==0) {
                        if (y==0) {
                            mapmap.addPiece("aztec/room1a.json", offset+x+1, offset+y);
                        } else if (y==size-1) {
                            mapmap.addPiece("aztec/room1c.json", offset+x+1, offset+y);
                        } else {
                            mapmap.addPiece("aztec/room1b.json", offset+x+1, offset+y);
                        }
                    } else if (x==size-1) {
                        if (y==0) {
                            mapmap.addPiece("aztec/room1g.json", offset+x+1, offset+y);
                        } else if (y==size-1) {
                            mapmap.addPiece("aztec/room1i.json", offset+x+1, offset+y);
                        } else {
                            mapmap.addPiece("aztec/room1b.json", offset+x+1, offset+y);
                        }
                    } else if (y==0 || y==size-1) {
                        mapmap.addPiece("aztec/room1d.json", offset+x+1, offset+y);
                    }
                }
            }
        }
        
        return mapmap;
    }
    
    public static function createKicheMap() {
        var mapmap = new maps.MapMap({
            x: 0,
            y: 0,
            w: 5,
            h: 5,
            map_width  : 9,
            map_height : 9
        });
        
        mapmap.addRoom("ki_room0", 0, 0);
        mapmap.addRoom("ki_room0", 4, 4);
        
        mapmap.addRoom("ki_room1", 1, 0);
        mapmap.addRoom("ki_room1", 2, 2);
        mapmap.addRoom("ki_room1", 3, 0);
        
        for (y in 0...mapmap.h) {
            for (x in 0...mapmap.w) {
                var map = mapmap.getPiece(x, y);
                if (map == null) {
                    var placed;
                    do {
                        if (Math.floor(Math.random() * 1.99) == 0) {
                            placed = mapmap.addRoom("ki_room0", x, y);
                        } else {
                            placed = mapmap.addRoom("ki_room2", x, y);
                        }
                    } while (!placed);
                }
            }
        }
        
        return mapmap;
    }
    
    public static function createYucatecMap() {
        var mapmap = new maps.MapMap({
            x: 0,
            y: 0,
            w: 5,
            h: 5,
            map_width  : 9,
            map_height : 9
        });
        
        mapmap.addRoom("yu_room0", 0, 0);
        mapmap.addRoom("yu_room0", 4, 4);
        for (y in 0...mapmap.h) {
            if (y < mapmap.h-1) {
                var placedvert;
                do {
                    if (Math.floor(Math.random() * 1.99) == 0) {
                        placedvert = mapmap.addRoom("yu_room1", Math.floor(Math.random() * 4.99), y);
                    } else {
                        placedvert = mapmap.addRoom("yu_room3", Math.floor(Math.random() * 4.99), y);
                    }
                } while(!placedvert);
            }
            
            for (x in 0...mapmap.w) {
                var map = mapmap.getPiece(x, y);
                if (map == null) {
                    var placed;
                    do {
                        if (Math.floor(Math.random() * 1.99) == 0) {
                            placed = mapmap.addRoom("yu_room0", x, y);
                        } else {
                            placed = mapmap.addRoom("yu_room2", x, y);
                        }
                    } while (!placed);
                }
            }
        }
        
        return mapmap;
    }
    
}
