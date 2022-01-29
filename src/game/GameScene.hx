package game;

import com.*;
import game.sys.*;

class GameScene extends Scene {
    var collisionSys:col.CollisionSys;
    var separationSys:SeparationSys;
    var timerSys:TimerSys;
    var tweenerSys:TweenerSys;
    var gravitySys:GravitySys;
    var inputSys:InputSys;
    var moveSys:MoveSys;
    var scrollingBitmapSys:ScrollingBitmapSys;

    override public function new(app:App)
    {
        super(app);

        //systems
        collisionSys = new col.CollisionSys(coms.collidables, coms.objects);
        separationSys = new SeparationSys(coms);
        timerSys = new TimerSys(coms.timers);
        tweenerSys = new TweenerSys(coms.tweeners);
        gravitySys = new GravitySys(coms);
        inputSys = new InputSys(coms.userInputConfigs);
        moveSys = new MoveSys(coms);
        scrollingBitmapSys = new ScrollingBitmapSys(coms);

        //events
        separationSys.onCollisionSlot.connect(collisionSys.collisionSignal);
        inputSys.actionSignal.connect(new heat.event.Slot(
            (arg:input.EAction<ActionBoolKind, ActionOnceKind>)->{
                switch arg {
                    case ONCE(RESET): {
                        var object = coms.objects["hero"];
                        if (object == null) return;
                        object.x = 0;
                        object.y = 0;
                        var vel = coms.velocities["hero"];
                        if (vel == null) return;
                        vel.x = 0;
                        vel.y = 0;
                        vel.prevPos.x = 0;
                        vel.prevPos.y = 0;
                    }
                    default: {}
                }
            }
        ));
        inputSys.keyEventSlot.connect(app.keyEventSignal);
        inputSys.mouseBtnEventSlot.connect(app.mouseBtnEventSignal);

        //build the background
        new BackgroundBuilder(coms)
            .setTile(hxd.Res.img.titleBackground_png.toTile())
            .setParent(heapsScene)
            .setSize(App.VIEW_WIDTH, App.VIEW_HEIGHT)
            .autoScrollY(true, 2)
            .autoFlipX(true, 0.4)
            .autoFlipY(true, 0.2)
            .randScrollX(true, 0.2)
            .build();

        var id = coms.getIntId();
        var collidable = new col.Collidable(0, 0, App.VIEW_WIDTH, 50);
        collidable.movable = false;
        coms.collidables[id] = collidable;
        var tile = app.assetService.getTileFromSpriteKind(RECT(0, 0, Std.int(App.VIEW_WIDTH), Std.int(50), 0xFFFFFF, 1));
        var bitmap = new h2d.Bitmap(tile);
        bitmap.setPosition(0, 400);
        coms.bitmaps[id] = bitmap;
        coms.objects[id] = bitmap;
        heapsScene.addChildAt(bitmap, LayerKind.MID_OBJECTS);
        coms.kindComs[id] = Kind.BARRIER;

        id = "hero";
        collidable = new col.Collidable(0, 0, 50, 50);
        collidable.movable = true;
        coms.collidables[id] = collidable;
        tile = app.assetService.getTileFromSpriteKind(RECT(0, 0, Std.int(50), Std.int(50), 0xFFFFFF, 1));
        bitmap = new h2d.Bitmap(tile);
        bitmap.setPosition(200, 0);
        coms.bitmaps[id] = bitmap;
        coms.objects[id] = bitmap;
        heapsScene.addChildAt(bitmap, LayerKind.MID_OBJECTS);
        coms.kindComs[id] = Kind.HERO;
        coms.mass[id] = 50;
        coms.velocities[id] = new Velocity(0,0,200,0);

        var gameInputConfig = new UserInputConfig()
        .setKeysToBools([
            W => MOVE_HERO(UP),
            S => MOVE_HERO(DOWN),
            A => MOVE_HERO(LEFT),
            D => MOVE_HERO(RIGHT),
            UP => HERO_SHOOT(UP),
            DOWN => HERO_SHOOT(DOWN),
            LEFT => HERO_SHOOT(LEFT),
            RIGHT => HERO_SHOOT(RIGHT)
        ])
        .setKeysToOnceActions([
            ESC => PAUSE_TOGGLE,
            ENTER => RESET
        ]);
        coms.userInputConfigs["gameInputs"] = gameInputConfig;
        var pauseInputConfig = new UserInputConfig()
        .setKeysToOnceActions([
            W => MOVE_UI(UP),
            S => MOVE_UI(DOWN),
            A => MOVE_UI(LEFT),
            D => MOVE_UI(RIGHT),
            ESC => PAUSE_TOGGLE
        ]);
        pauseInputConfig.enabled = false;
        coms.userInputConfigs["pauseInputs"] = pauseInputConfig;
    }

    override function update(dt:Float) {
        super.update(dt);
        timerSys.update(dt);
        tweenerSys.update(dt);
        gravitySys.update(dt);
        moveSys.move(dt);
        collisionSys.update(dt);
        moveSys.updateVels();
        scrollingBitmapSys.update(dt);
    }
}