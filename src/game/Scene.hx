package game;

class Scene extends heaps.Scene {
    public var coms(default, null) = new ComStore();

    override public function new(app:App) 
    {
        super(app);
        //sets the scene to a fixed size with space around it to fill the window. Hardcoding this for now, should eventually configurable via game UI
        heapsScene.scaleMode = LetterBox(App.VIEW_WIDTH, App.VIEW_HEIGHT, true, Center, Center);

        //set up cameras
        var bgCamera = heapsScene.camera;
        bgCamera.setAnchor(0, 0);
        bgCamera.setPosition(0, 0);
        bgCamera.clipViewport = true;
        bgCamera.layerVisible = layer -> {
            return layer == com.LayerKind.BG;
        }
        var worldCamera = new h2d.Camera(heapsScene);
        heapsScene.addCamera(worldCamera);
        worldCamera.setAnchor(0.5, 0.5);
        worldCamera.setPosition(App.VIEW_WIDTH/2, App.VIEW_HEIGHT/2);
        worldCamera.clipViewport = true;
        worldCamera.layerVisible = layer -> {
            return layer == com.LayerKind.BACK_OBJECTS
                || layer == com.LayerKind.MID_OBJECTS
                || layer == com.LayerKind.FRONT_OBJECTS;
        }
        var uiCamera = new h2d.Camera(heapsScene);
        heapsScene.addCamera(uiCamera);
        uiCamera.setAnchor(0, 0);
        uiCamera.clipViewport = true;
        uiCamera.layerVisible = layer -> {
            return layer == com.LayerKind.UI;
        }
        heapsScene.interactiveCamera = worldCamera;

        coms.cameras["bgCamera"] = bgCamera;
        coms.cameras["worldCamera"] = worldCamera;
        var worldCamConfig = new com.CameraConfig();
        worldCamConfig.lockX = 480;
        worldCamConfig.lockY = 250;
        worldCamConfig.deadzone.init(-32, -32, 64, 64);
        coms.camConfigs["worldCamera"] = worldCamConfig;
        coms.cameras["uiCamera"] = uiCamera;
    }

    override public function update(dt:Float) {

    }

    override function onDispose() {
        coms.disposeAll();
        super.onDispose();
    }
}