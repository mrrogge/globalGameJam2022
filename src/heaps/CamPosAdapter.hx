package heaps;

/**
 * An implementation of IPos for heaps 2D cameras. Acts as a wrapper around a camera instance.
 */
class CamPosAdapter implements core.IPos {
    public var x(get, set):Float;
    public var y(get, set):Float;
    public var absX(get, never):Float;
    public var absY(get, never):Float;

    var cam:h2d.Camera;
    
    public function new(cam:h2d.Camera) {
        this.cam = cam;
    }

    function get_x():Float {
        return cam.x;
    }

    function get_y():Float {
        return cam.y;
    }

    function set_x(x:Float):Float {
        cam.x = x;
        return x;
    }

    function set_y(y:Float):Float {
        cam.y = y;
        return y;
    }

    function get_absX():Float {
        return cam.x;
    }

    function get_absY():Float {
        return cam.y;
    }
}