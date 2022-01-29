package tiled;

class MapLayerBuilder {
    var mapRawData:MapRawData;
    var layerName:String;
    var tileImage:h2d.Tile;
    var coms:game.ComStore;
    var parent:h2d.Object;
    var parentLayer:Int;
    var assetService:heaps.AssetService;

    public function new(coms:game.ComStore, assetService:heaps.AssetService) {
        this.coms = coms;
        this.assetService = assetService;
    }

    public function loadText(text:String):MapLayerBuilder {
        mapRawData = haxe.Json.parse(text);
        return this;
    }

    public function selectLayerByName(name:String):MapLayerBuilder {
        layerName = name;
        return this;
    }

    public function setTileImage(tileImage:h2d.Tile):MapLayerBuilder {
        this.tileImage = tileImage;
        return this;
    }
    
    public function setParent(parent:h2d.Object, layer=0):MapLayerBuilder {
        this.parent = parent;
        this.parentLayer = layer;
        return this;
    }

    public function build() {
        if (parent == null) throw new haxe.Exception("must call setParent()");
        var scene = Std.downcast(parent, h2d.Scene);
        if (mapRawData == null) throw new haxe.Exception("must load map data");
        var layer:MapRawData.LayerData = null;
        for (v in mapRawData.layers) {
            if (v.name != layerName) continue;
            layer = v;
        }
        if (layer == null) throw new haxe.Exception('Could not find layer named ${layerName}.');
        switch layer.type {
            case "tilelayer": {
                if (tileImage == null) throw new haxe.Exception("must call setTileImage()");
                var tileGroup = new h2d.TileGroup(tileImage);
        
                if (scene != null) {
                    scene.addChildAt(tileGroup, parentLayer);
                }
                else {
                    parent.addChild(tileGroup);
                }
                var tw = mapRawData.tilewidth;
                var th = mapRawData.tileheight;
                var mw = mapRawData.width;
                var mh = mapRawData.height;
                var tiles = [
                    for (y in 0 ... Std.int(tileImage.height / th)) {
                        for (x in 0 ... Std.int(tileImage.width / tw)) {
                            tileImage.sub(x * tw, y * th, tw, th);
                        }
                    }
                ];
        
                for (layer in mapRawData.layers) {
                    if (layer.name != layerName) continue;
                    for (y in 0...mh) {
                        for (x in 0...mw) {
                            var tid = layer.data[x + y * mw];
                            if (tid != 0) {
                                tileGroup.add(x * tw, y * th, tiles[tid-1]);
                            }
                        }
                    }
                    var id = coms.getIntId();
                    coms.tileGroups[id] = tileGroup;
                    coms.objects[id] = tileGroup;
                    return;
                }
            }
            case "objectgroup": {
                for (mapObject in layer.objects) {
                    var id = coms.getIntId();

                    //collidable
                    switch mapObject.type {
                        case "barrier": {
                            var collidable = new col.Collidable(0, 0, 
                                mapObject.width, mapObject.height);
                            collidable.movable = false;
                            coms.collidables[id] = collidable;
                        }

                        case "hero": {
                            var collidable = new col.Collidable(0, 0, 
                                mapObject.width, mapObject.height);
                            collidable.movable = true;
                            coms.collidables[id] = collidable;
                        }
                    }

                    //heaps objects
                    switch mapObject.type {
                        case "barrier": {
                            var object = new h2d.Object();
                            object.setPosition(mapObject.x, mapObject.y);
                            coms.objects[id] = object;
                            if (scene != null) {
                                scene.addChildAt(object, parentLayer);
                            }
                            else {
                                parent.addChild(object);
                            }
                        }

                        case "hero": {
                            var tile = assetService.getTileFromSpriteKind(
                                RECT(0, 0, Std.int(mapObject.width), 
                                Std.int(mapObject.height), 0x0000FF, 1));
                            var bitmap = new h2d.Bitmap(tile);
                            bitmap.setPosition(mapObject.x, mapObject.y);
                            coms.bitmaps[id] = bitmap;
                            coms.objects[id] = bitmap;
                            if (scene != null) {
                                scene.addChildAt(bitmap, parentLayer);
                            }
                            else {
                                parent.addChild(bitmap);
                            }
                        }
                    }

                    //other
                    switch mapObject.type {
                        case "barrier": {
                            coms.kindComs[id] = com.Kind.BARRIER;
                        }
                        case "hero": {
                            coms.kindComs[id] = com.Kind.HERO;
                            coms.mass[id] = 20;
                            coms.velocities[id] = new com.Velocity(0, 0, 
                                mapObject.x, mapObject.y, 150, 150);
                            coms.heroStates[id] = new com.HeroState();
                        }
                    }
                }
            }
        }
    }
}