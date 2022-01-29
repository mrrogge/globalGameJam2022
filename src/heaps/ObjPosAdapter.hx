package heaps;

/**
 * An implementation of IPos for heaps 2D objects. Acts as a wrapper around any class extending the Object class.
 */
class ObjPosAdapter implements core.IPos {
    public var x(get, set):Float;
    public var y(get, set):Float;
    public var absX(get, never):Float;
    public var absY(get, never):Float;

    var obj:h2d.Object;
    
    public function new(obj:h2d.Object) {
        this.obj = obj;
    }

    function get_x():Float {
        return obj.x;
    }

    function get_y():Float {
        return obj.y;
    }

    function set_x(x:Float):Float {
        obj.x = x;
        return x;
    }

    function set_y(y:Float):Float {
        obj.y = y;
        return y;
    }

    function get_absX():Float {
        return obj.getAbsPos().x;
    }

    function get_absY():Float {
        return obj.getAbsPos().y;
    }
}