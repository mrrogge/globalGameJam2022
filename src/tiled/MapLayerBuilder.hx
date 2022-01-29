package tiled;

class MapLayerBuilder {
    var mapRawData:MapRawData;
    var layerName:String;
    var tileImage:h2d.Tile;
    var coms:game.ComStore;
    var parent:h2d.Object;
    var parentLayer:Int;

    public function new(coms:game.ComStore) {
        this.coms = coms;
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
        if (tileImage == null) throw new haxe.Exception("must call setTileImage()");
        var tileGroup = new h2d.TileGroup(tileImage);
        if (parent == null) throw new haxe.Exception("must call setParent()");
        var scene = Std.downcast(parent, h2d.Scene);
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

        throw new haxe.Exception('Could not find layer named ${layerName}.');
    }
}