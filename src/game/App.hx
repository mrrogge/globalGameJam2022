package game;

class App extends core.App {
    public static inline final LEVEL_WIDTH = 32*35;
    public static inline final LEVEL_HEIGHT = 32*21;
    public static inline final WALL_DEPTH = 32;
    public static inline final VIEW_WIDTH = 960;
    public static inline final VIEW_HEIGHT = 450;

    var sceneState:SceneState = TITLE;
    public var assetService = new heaps.AssetService();

    override function onInit() {
        hxd.Window.getInstance().resize(VIEW_WIDTH, VIEW_HEIGHT);
        // hxd.Window.getInstance().displayMode = Fullscreen;

        //setup initial scene
        pushNextScene();
    }

    override function onUpdate(dt:Float) {
        
    }

    override function onBeforeScenePushed() {
        super.onBeforeScenePushed();
        switch sceneState {
            case NONE: {
                nextScene = new SplashScene(this);
                sceneState = SPLASH;
            }
            case SPLASH: {
                nextScene = new TitleMenuScene(this);
                sceneState = TITLE;
            }
            case TITLE: {
                nextScene = new GameScene(this);
                sceneState = GAME;
            }
            case GAME: {}
        }
    }
}

enum SceneState {
    NONE;
    SPLASH;
    TITLE;
    GAME;
}