package game;

class Scene extends heaps.Scene {
    public var coms(default, null) = new ComStore();

    override public function new(app:App) 
    {
        super(app);
        //sets the scene to a fixed size with space around it to fill the window. Hardcoding this for now, should eventually configurable via game UI
        heapsScene.scaleMode = LetterBox(App.VIEW_WIDTH, App.VIEW_HEIGHT, true, Center, Center);
    }

    override public function update(dt:Float) {

    }

    override function onDispose() {
        coms.disposeAll();
        super.onDispose();
    }
}