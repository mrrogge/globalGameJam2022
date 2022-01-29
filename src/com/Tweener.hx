package com;

class Tweener extends Timer {
    public var easing:motion.easing.IEasing;
    public var current(default, null):Float;
    public var delta(default, null):Float;
    public var start:Float;
    public var diff:Float;

    override public function new(period:Float) {
        super(period);
        easing = motion.easing.Linear.easeNone;
    }

    override function update(dt:Float) {
        super.update(dt);
        var prev = current;
        current = easing.ease(acc, start, diff, period);
        delta = current-prev;
    }

    function updateTweenedVal() {
        var prev = current;
        current = easing.ease(acc, start, diff, period);
        delta = current-prev;
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