package heaps;

import com.SpriteKind;

/**
    Manages assets built on top of the heaps resource system.
**/
class AssetService {
    var tileCache = new Map<SpriteKind, h2d.Tile>();
    var fontCache = new Map<String, Map<Int, h2d.Font>>();
    var imageTileCache = new Map<hxd.res.Image, h2d.Tile>();

    /**
        Parses a resource file consisting of JSON text. Returns a structure or array of structures according to the content of res. The JSON parsing is currently dynamic and will not flag a mismatch between the content and expected type T.
    **/
    static inline function parseJsonRes<T>(res:hxd.res.Resource):T {
        var result:T = haxe.Json.parse(res.entry.getText());
        return result;
    }

    /**
        Looks up a resource from a path string. If resource doesn't exist a runtime error will be raised.
    **/
    public static inline function getResFromString(path:String):hxd.res.Resource {
        return hxd.Res.loader.load(path).toPrefab();
    }

    public function new() {
        
    }

    public function getImageFromString(path:String):hxd.res.Image {
        return hxd.Res.loader.load(path).toImage();
    }

    /**
        Returns a Tile for the entire image resource. Results are cached so only one tile instance exists per image resource.
    **/
    public function getImageTile(img:hxd.res.Image):h2d.Tile {
        if (imageTileCache.exists(img)) return imageTileCache[img];
        var tile = img.toTile();
        imageTileCache[img] = tile;
        return tile;
    }

    /**
        Returns a Tile corresponding to the SpriteKind. This can be a simple rectangle of one color or a region of an image resource.
    **/
    public function getTileFromSpriteKind(spriteKind:SpriteKind):h2d.Tile {
        if (tileCache.exists(spriteKind)) return tileCache[spriteKind];
        var tile = switch spriteKind {
            case RECT(x, y, w, h, color, alpha): {
                var tile = h2d.Tile.fromColor(color, w, h, alpha);
                tile.dx = -x;
                tile.dy = -y;
                tile;
            }
            case IMG(img, x, y, w, h, dx, dy): {
                var imgTile = getImageTile(img);
                var tile = imgTile.sub(x, y, w, h, -dx, -dy);
                tile;
            }
        }
        tileCache[spriteKind] = tile;
        return tile;
    }

    /**
        Returns a font object based on an id string and size.
    **/
    public function getFontFromString(id:String, size:Int):h2d.Font {
        if (fontCache.exists(id) && fontCache[id].exists(size)) return fontCache[id][size];
        //just using default font for now
        var font = hxd.res.DefaultFont.get().clone();
        font.resizeTo(size);
        if (!fontCache.exists(id)) fontCache[id] = new Map<Int, h2d.Font>();
        fontCache[id][size] = font;
        return font;
    }
}