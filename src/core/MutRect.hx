package core;

/**
 * Mutable rectangle.
 */
@:access(core.Rect)
class MutRect {
    public var x:Float;
    public var y:Float;
    public var w:Float;
    public var h:Float;

    public function new(x=0., y=0., w=0., h=0.) {
        this.init(x, y, w, h);
    }

    public function init(x=0., y=0., w=0., h=0.):MutRect {
        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h;
        return this;
    }

    public function applyTo(target:MutRect):MutRect {
        target.x = this.x;
        target.y = this.y;
        target.w = this.w;
        target.h = this.h;
        return this;
    }

    public function applyFrom(source:MutRect):MutRect {
        this.x = source.x;
        this.y = source.y;
        this.w = source.w;
        this.h = source.h;
        return this;
    }

    public function toImmutable():Rect {
        return new Rect(this.x, this.y, this.w, this.h);
    }

    public static function fromImmutable(source:Rect):MutRect {
        return new MutRect(source.x, source.y, source.w, source.h);
    }

    public function clone():MutRect {
        return new MutRect(this.x, this.y, this.w, this.h);
    }

    public function overlaps(other:Rect.RectStruct):Bool {
        return Rect.s_overlaps(this, other);
    }

    /**
        Calculates the Minkowski difference of two MutRects, which is another MutRect.
    **/
    public function diff(other:MutRect):MutRect {
        return new MutRect(other.x - this.x - this.w, other.y - this.y - this.h,
            this.w + other.w, this.h + other.h);
    }

    public function getOverlap(other:MutRect):haxe.ds.Option<MutRect> {
        if (!this.overlaps(other)) return None;
        var overlap = new MutRect();
        overlap.x = Math.max(this.x, other.x);
        overlap.y = Math.max(this.y, other.y);
        overlap.w = Math.min(this.x+this.w, other.x+other.w) - overlap.x;
        overlap.h = Math.min(this.y+this.h, other.y+other.h) - overlap.y;
        return Some(overlap);
    }

    public function toString():String {
        return Rect.s_toString(this.x, this.y, this.w, this.h);
    }

    public function isAlike(other:Rect.RectStruct):Bool {
        return Rect.s_isAlike(this, other);
    }

    public function containsPoint(x:Float, y:Float, ?eps:Float):Bool {
        return Rect.s_containsPoint(this, x, y, eps);
    }
}
