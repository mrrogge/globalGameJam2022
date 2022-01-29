package heaps;

import input.*;

class HeapsBackend extends core.ABackend
implements h3d.IDrawable
{
    final KEYMAP:Map<Int, KeyCode> = [
        hxd.Key.UP => UP,
        hxd.Key.DOWN => DOWN,
        hxd.Key.LEFT => LEFT,
        hxd.Key.RIGHT => RIGHT,
        hxd.Key.A => A,
        hxd.Key.B => B,
        hxd.Key.C => C,
        hxd.Key.D => D,
        hxd.Key.E => E,
        hxd.Key.F => F,
        hxd.Key.G => G,
        hxd.Key.H => H,
        hxd.Key.I => I,
        hxd.Key.J => J,
        hxd.Key.K => K,
        hxd.Key.L => L,
        hxd.Key.M => M,
        hxd.Key.N => N,
        hxd.Key.O => O,
        hxd.Key.P => P,
        hxd.Key.Q => Q,
        hxd.Key.R => R,
        hxd.Key.S => S,
        hxd.Key.T => T,
        hxd.Key.U => U,
        hxd.Key.V => V,
        hxd.Key.W => W,
        hxd.Key.X => X,
        hxd.Key.Y => Y,
        hxd.Key.Z => Z,
        hxd.Key.ESCAPE => ESC,
        hxd.Key.F1 => F1,
        hxd.Key.F2 => F2,
        hxd.Key.F3 => F3,
        hxd.Key.F4 => F4,
        hxd.Key.F5 => F5,
        hxd.Key.F6 => F6,
        hxd.Key.F7 => F7,
        hxd.Key.F8 => F8,
        hxd.Key.F9 => F9,
        hxd.Key.F10 => F10,
        hxd.Key.F11 => F11,
        hxd.Key.F12 => F12,
        hxd.Key.ENTER => ENTER,
        hxd.Key.NUMPAD_ENTER => NUMPAD_ENTER
    ];

    var engine(default,null):h3d.Engine;
    var sevents(default,null):hxd.SceneEvents;
    var isDisposed:Bool;
    var scene:h2d.Scene;

    override public function new() {
        super();
        var engine = h3d.Engine.getCurrent();
		if( engine != null ) {
			this.engine = engine;
			engine.onReady = setup;
			haxe.Timer.delay(setup, 0);
		} else {
			hxd.System.start(function() {
				this.engine = engine = @:privateAccess new h3d.Engine();
				engine.onReady = setup;
				engine.init();
			});
		}
        hxd.Window.getInstance().addEventTarget(onEvent);
    }

    function onResize() {}

    function setup() {
		var initDone = false;
		engine.onReady = nop;
		engine.onResized = function() {
			if( scene == null ) return; // if disposed
			scene.checkResize();
			if( initDone ) onResize();
		};
		sevents = new hxd.SceneEvents();
		loadAssets(function() {
			initDone = true;
			init();
			hxd.Timer.skip();
			mainLoop();
			hxd.System.setLoop(mainLoop);
			hxd.Key.initialize();
		});
	}

    function dispose() {
		engine.onResized = nop;
		engine.onContextLost = nop;
		isDisposed = true;
		if( scene != null ) scene.dispose();
		if( sevents != null ) sevents.dispose();
	}

    public function render(e:h3d.Engine) {
        if (scene != null) scene.render(e);
	}

    function mainLoop() {
		hxd.Timer.update();
		sevents.checkEvents();
		if( isDisposed ) return;
		update(hxd.Timer.dt);
		if( isDisposed ) return;
		var dt = hxd.Timer.dt; // fetch again in case it's been modified in update()
		if( scene != null ) scene.setElapsedTime(dt);
		engine.render(this);
	}
    
    function onEvent(et:hxd.Event):Void {
        switch et.kind {
            case EKeyDown: {
                if (KEYMAP.exists(et.keyCode)) {
                    keyEventSignalEmitter.emit({code:KEYMAP[et.keyCode], kind: PRESSED});
                }
                else {
                    keyEventSignalEmitter.emit({code:OTHER(et.keyCode), kind: PRESSED});
                }
            }
            case EKeyUp: {
                if (KEYMAP.exists(et.keyCode)) {
                    keyEventSignalEmitter.emit({code:KEYMAP[et.keyCode], kind: RELEASED});
                }
                else {
                    keyEventSignalEmitter.emit({code:OTHER(et.keyCode), kind: RELEASED});
                }
            }
            default: {}
        }
    }

    function loadAssets(onLoaded:() -> Void) {
        #if js
        hxd.Res.initEmbed();
        #else
        hxd.res.Resource.LIVE_UPDATE = true;
        hxd.Res.initLocal();
        #end
        onLoaded();
    }

    override function makeNode():core.Node {
        return new NodeObject(new h2d.Object());
    }

    static function nop() {}

    override function update(dt:Float) {
        if (app != null) {
            if (!app.sceneStack.isEmpty()) {
                var scene = Std.downcast(app.sceneStack.first(), heaps.Scene);
                if (scene != null) {
                    this.scene = scene.heapsScene;
                }
            }
        }
        super.update(dt);
    }
}