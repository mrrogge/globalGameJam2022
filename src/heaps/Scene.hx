package heaps;

class Scene extends core.Scene {
    public var heapsScene(default, null):h2d.Scene;

    override public function new(app:core.App) {
        super(app);
        heapsScene = new h2d.Scene();
    }

    override function onDispose() {
        super.onDispose();
        heapsScene.dispose();
    }
}