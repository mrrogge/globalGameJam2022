package com;

class Health {
    public var max(default, set):Float;
    public var current(default, set):Float;

    public function new(max:Float, ?current:Float) {
        this.max = max;
        if (current == null) this.current = this.max;
        else this.current = current;
    }

    function set_max(newVal:Float):Float {
        max = newVal;
        if (max < current) current = max;
        return max;
    }

    function set_current(newVal:Float):Float {
        current = newVal;
        if (current > max) current = max;
        return current;
    }
}