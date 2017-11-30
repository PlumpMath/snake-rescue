package maps;

class MapGeneration {
    
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
