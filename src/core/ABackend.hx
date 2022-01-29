package core;

import input.*;

/**
    The driving force behind an App. An ABackend handles all the low-level engine actions. It's responsible for calling the update logic, rendering the objects defined in scenes, and generating input events.
**/
abstract class ABackend {
    @:allow(core.App) var keyEventSignal(default, null):heat.event.ISignal<EKey>;
    @:allow(core.App) var mouseBtnEventSignal(default, null):heat.event.ISignal<EMouseBtn>;
    var keyEventSignalEmitter = new heat.event.SignalEmitter<EKey>();
    var mouseBtnEventSignalEmitter = new heat.event.SignalEmitter<EMouseBtn>();
    @:allow(core.App) var app:core.App;

    public function new() {
        keyEventSignal = keyEventSignalEmitter.signal;
        mouseBtnEventSignal = mouseBtnEventSignalEmitter.signal;
    }

    @:allow(core.App) dynamic function onInit() {}
    @:allow(core.App) dynamic function onUpdate(dt:Float) {}

    function init() {
        onInit();
    }

    function update(dt:Float) {
        onUpdate(dt);
    }

    @:allow(core.App) function makeNode():Node {
        return new Node();
    }

    public function exit() {
        #if sys
        Sys.exit(0);
        #end
    }
}