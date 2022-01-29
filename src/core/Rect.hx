package core;

typedef RectStruct = {
    public var x(default, null):Float;
    public var y(default, null):Float;
    public var w(default, null):Float;
    public var h(default, null):Float;
}

/**
    An immutable rectangle instance.
**/
class Rect {
    public var x(default, null):Float;
    public var y(default, null):Float;
    public var w(default, null):Float;
    public var h(default, null):Float;

    static inline final EPSILON = 1e-7;

    public static function s_toString(x:Float, y:Float, w:Float, h:Float):String {
        return 'Rect(x:$x,y:$y,w:$w,h:$h)';
    }

    public static function s_overlaps(r1:RectStruct, r2:RectStruct):Bool {
        return (r1.x <= r2.x + r2.w)
        && (r2.x <= r1.x + r1.w)
        && (r1.y <= r2.y + r2.h)
        && (r2.y <= r1.y + r1.h);
    }

    public static function s_isAlike(r1:RectStruct, r2:RectStruct):Bool {
        return r1.x == r2.x && r1.y == r2.y && r1.w == r2.w && r1.h == r2.h;
    }

    public static function s_containsPoint(r:RectStruct, x:Float, y:Float, eps:Float=EPSILON):Bool {
        return x-r.x > eps && y-r.y > eps && r.x+r.w-x > eps 
            && r.y+r.h-y > eps;
    }

    public function new(x=0., y=0., w=0., h=0.) {
        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h;
    }

    public function toString():String {
        return Rect.s_toString(x, y, w, h);
    }

    public function toMutable(?dest:MutRect):MutRect {
        if (dest == null) dest = new MutRect();
        dest.x = this.x;
        dest.y = this.y;
        dest.w = this.w;
        dest.h = this.h;
        return dest;
    }

    public static function fromMutable(source:MutRect):Rect {
        return new Rect(source.x, source.y, source.w, source.h);
    }

    public function isAlike(other:RectStruct):Bool {
        return Rect.s_isAlike(this, other);
    }

    public function overlaps(other:RectStruct):Bool {
        return Rect.s_overlaps(this, other);
    }

    public function diff(other:Rect):Rect {
        return new Rect(other.x - this.x - this.w, other.y - this.y - this.h,
            this.w + other.w, this.h + other.h);
    }

    public function getOverlap(other:Rect):haxe.ds.Option<Rect> {
        if (!this.overlaps(other)) return None;
        var x = Math.max(this.x, other.x);
        var y = Math.max(this.y, other.y);
        var w = Math.min(this.x+this.w, other.x+other.w) - x;
        var h = Math.min(this.y+this.h, other.y+other.h) - y;
        return Some(new Rect(x, y, w, h));
    }

    public function containsPoint(x:Float, y:Float, ?eps:Float):Bool {
        return Rect.s_containsPoint(this, x, y, eps);
    }
}