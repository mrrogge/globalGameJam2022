package heaps;

import com.AnimDef;
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

    /**
        Used to resolve prototype chains of definition resources. A given resource can define a prototype path string, which will inherit any properties from that prototype rather than needing to duplicate the values. A resource can override any prototype properties in its own definition.
    **/
    function resolvePrototypes<T:com.BaseDef>(?def:T, ?result:T):T {
        if (result == null) result = def;
        if (def == null) return result;
        if (def.meta != null && def.meta.prototype != null) {
            var protoRes = getResFromString(def.meta.prototype);
            var def:com.BaseDef = parseJsonRes(protoRes);
            //Json merge is dynamic, resulting in what should be an equivalent structure with prototype's props, however this is not type-safe (prototype could be invalid).
            result = cast MergeJson.merge(def, result);
        }
        else {
            def = null;
        }
        return resolvePrototypes(def, result);
    }

    /**
        Loads a definition resource of type T from the specified haxe resource res.

        This resolves any prototype chains defined in the resource, resulting in a complete structure with all properties.
    **/
    function loadDef<T:com.BaseDef>(res:hxd.res.Resource):T {
        var def:T = parseJsonRes(res);
        def = resolvePrototypes(def);
        return def;
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

    /**
        Returns an array of tiles corresponding to an AnimDef.
    **/
    public function getAnimFrames(def:com.AnimDef):Array<h2d.Tile> {
        var frames = new Array<h2d.Tile>();
        var img = getImageFromString(def.image);
        var imgTile = getImageTile(img);
        var tileCountX = Math.floor(imgTile.width / def.frameWidth);
        var tileCountY = Math.floor(imgTile.height / def.frameHeight);
        for (row in 0...tileCountX) {
            for (col in 0...tileCountY) {
                frames.push(getTileFromSpriteKind(IMG(img, row*def.frameWidth,
                    col*def.frameHeight, def.frameWidth, def.frameHeight,
                    def.offsetX, def.offsetY)));
            }
        }
        return frames;
    }
}