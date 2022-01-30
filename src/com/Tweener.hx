package com;

class Tweener extends Timer {
    public var easing:motion.easing.IEasing;
    public var current(default, null):Null<Float>;
    var prev:Null<Float> = null;
    public var delta(default, null):Null<Float>;
    public var start:Null<Float>;
    public var diff:Null<Float>;

    override public function new(period:Float) {
        super(period);
        easing = motion.easing.Linear.easeNone;
    }

    public override function reset() {
        super.reset();
        updateTweenedVal();
    }

    function updateTweenedVal() {
        current = easing.ease(acc, start, diff, period);
        if (prev == null) prev = current;
        delta = current-prev;
        prev = current;
    }

    override function runningHandler() {
        updateTweenedVal();
        super.runningHandler();
    }

    override function doneHandler() {
        updateTweenedVal();
        super.doneHandler();
    }
}