package core;

class Scene {
    var disposed = false;
    var app:App;
    var nodes = new heat.ecs.ComMap<Node>();

    public function new(app:App) {
        this.app = app;
    }

    @:allow(core.App) function update(dt:Float) {
        if (disposed) return;
        onUpdate(dt);
    }

    //Override with game-specific logic that runs every frame.
    function onUpdate(dt:Float) {

    }

    function queueDispose() {
        app.queueSceneToDispose(this);
    }

    @:allow(core.App) function dispose() {
        onDispose();
        disposed = true;
    }

    function onDispose() {

    }

    function addNode(?parent:Node) {

    }

    function removeNode() {}
}