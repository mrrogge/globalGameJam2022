package core;

import input.*;

class App {
    var frameAcc = 0.;
    var frameRate = 60.;
    public var backend(default, null):ABackend;
    @:allow(core.Scene) var keyEventSignal(default, null):heat.event.ISignal<EKey>;
    @:allow(core.Scene) var mouseBtnEventSignal(default, null):heat.event.ISignal<EMouseBtn>;

    @:allow(core.ABackend) var sceneStack(default, null) = new haxe.ds.GenericStack<Scene>();
    var nextScene:Scene;
    var scenesToDispose(default, null) = new haxe.ds.GenericStack<Scene>();

    public function new(backend:ABackend) 
    {
        this.backend = backend;
        attach();
    }

    /**
        Attaches this App to the backend. A backend instance can only be attached to one app at a time.
    **/
    function attach():App {
        backend.app = this;
        backend.onUpdate = update;
        backend.onInit = onInit;
        keyEventSignal = backend.keyEventSignal;
        mouseBtnEventSignal = backend.mouseBtnEventSignal;
        return this;
    }

    //Override this with your game-specific initialization logic. Runs once on startup.
    function onInit() {}

    //Update logic for the App. This should not be overridden.
    function update(dt:Float) {
        //using a constant update framerate of 60fps. May eventually make this configurable
        frameAcc += dt;
        if (frameAcc > 5/frameRate) frameAcc = 5/frameRate;
        while (frameAcc >= 1/frameRate) {
            onUpdate(1/frameRate);
            if (!sceneStack.isEmpty()) {
                sceneStack.first().update(1/frameRate);
            }
            frameAcc -= 1/frameRate;
        }
        while (!scenesToDispose.isEmpty()) {
            scenesToDispose.pop().dispose();
        }
    }

    //Override this with your game-specific logic that runs every frame.
    function onUpdate(dt:Float) {

    }

    function onBeforeScenePushed() {

    }

    function onAfterScenePushed() {

    }

    function onBeforeScenePopped() {

    }

    function onAfterScenePopped() {

    }

    @:allow(core.Scene) function pushNextScene() {
        onBeforeScenePushed();
        if (nextScene == null) return;
        sceneStack.add(nextScene);
        nextScene = null;
        onAfterScenePushed();
    }

    @:allow(core.Scene) function popScene() {
        onBeforeScenePopped();
        sceneStack.pop();
        onAfterScenePopped();
    }

    @:allow(core.Scene) function swapInNextScene() {
        popScene();
        pushNextScene();
    }

    @:allow(core.Scene) function makeNode():Node {
        return backend.makeNode();
    }

    @:allow(core.Scene) function queueSceneToDispose(scene:core.Scene) {
        scenesToDispose.add(scene);
    }

}