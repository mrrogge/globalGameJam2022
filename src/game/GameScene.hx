package game;

import com.*;
import game.sys.*;

class GameScene extends game.Scene {
    var collisionSys:col.CollisionSys;
    var separationSys:SeparationSys;
    var timerSys:TimerSys;
    var tweenerSys:TweenerSys;
    var gravitySys:GravitySys;
    var inputSys:InputSys;
    var moveSys:MoveSys;
    var scrollingBitmapSys:ScrollingBitmapSys;
    var heroMoveSys:HeroMoveSys;
    var frictionSys:FrictionSys;
    var enemyMoveSys:EnemyMoveSys;
    var bulletSys:BulletSys;
    var healthSys:HealthSys;
    var cameraSys:CameraSys;

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
        heroMoveSys = new HeroMoveSys(coms, app.assetService);
        frictionSys = new FrictionSys(coms);
        enemyMoveSys = new EnemyMoveSys(coms);
        bulletSys = new BulletSys(coms, heapsScene);
        healthSys = new HealthSys(coms.healthComs);
        cameraSys = new CameraSys(coms);

        //set the collision system filter
        collisionSys.filter = colFilter;

        //events
        separationSys.onCollisionSlot.connect(collisionSys.collisionSignal);
        heroMoveSys.onCollisionSlot.connect(collisionSys.collisionSignal);
        enemyMoveSys.onCollisionSlot.connect(collisionSys.collisionSignal);
        bulletSys.onCollisionSlot.connect(collisionSys.collisionSignal);
        heroMoveSys.onActionSlot.connect(inputSys.actionSignal);
        inputSys.keyEventSlot.connect(app.keyEventSignal);
        inputSys.mouseBtnEventSlot.connect(app.mouseBtnEventSignal);
        bulletSys.onSpawnBulletSlot.connect(heroMoveSys.bulletSignal);
        healthSys.onDamageSlot.connect(bulletSys.damageSignal);
        enemyMoveSys.onKilledSlot.connect(healthSys.killedSignal);
        enemyMoveSys.onEnergizedSlot.connect(bulletSys.energizeSignal);
        bulletSys.onSpawnBulletSlot.connect(enemyMoveSys.spawnBulletSignal);
        heroMoveSys.onKilledSlot.connect(healthSys.killedSignal);

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

        //build map layers
        var mapLayerBuilder = new tiled.MapLayerBuilder(coms, app.assetService);
        mapLayerBuilder.setTileImage(hxd.Res.img.tileset_png.toTile())
            .loadText(hxd.Res.tiledMaps.level1_json.entry.getText());
        mapLayerBuilder.selectLayerByName("background")
            .setParent(heapsScene, LayerKind.BACK_OBJECTS)
            .build();
        mapLayerBuilder.selectLayerByName("main")
            .setParent(heapsScene, LayerKind.MID_OBJECTS)
            .build();
        mapLayerBuilder.selectLayerByName("objects")
            .setParent(heapsScene, LayerKind.MID_OBJECTS)
            .build();
        mapLayerBuilder.selectLayerByName("foreground")
            .setParent(heapsScene, LayerKind.FRONT_OBJECTS)
            .build();

        //move camera
        heapsScene.camera.setPosition(0, 0);

        var gameInputConfig = new UserInputConfig()
        .setKeysToBools([
            W => MOVE_HERO(UP),
            SPACE => MOVE_HERO(UP),
            S => MOVE_HERO(DOWN),
            A => MOVE_HERO(LEFT),
            D => MOVE_HERO(RIGHT),
            J => HERO_SHOOT(LIGHT),
            K => HERO_SHOOT(DARK)
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

        //music
        hxd.Res.music.theme_mp3.play();
    }

    override function update(dt:Float) {
        super.update(dt);
        timerSys.update(dt);
        tweenerSys.update(dt);
        gravitySys.update(dt);
        frictionSys.update(dt);
        heroMoveSys.update(dt);
        enemyMoveSys.update(dt);
        bulletSys.update(dt);
        moveSys.move(dt);
        collisionSys.update(dt);
        moveSys.updateVels(dt);
        scrollingBitmapSys.update(dt);
        cameraSys.followHero();
        cameraSys.update(dt);
        bulletSys.disposeBullets();
        enemyMoveSys.disposeEnemies();
    }

    function colFilter(id1:heat.ecs.EntityId, id2:heat.ecs.EntityId):Bool {
        var kind = coms.kindComs[id1];
        if (kind == null) return false;
        var otherKind = coms.kindComs[id2];
        if (otherKind == null) return false;
        return switch kind {
            case HERO: {
                switch otherKind {
                    case ENEMY, BULLET(ENEMY), PICKUP(_), BARRIER: true;
                    case HERO, BULLET(HERO), ENEMY_BARRIER: false;
                }
            }
            case ENEMY: {
                switch otherKind {
                    case HERO, ENEMY, BULLET(HERO), BARRIER, ENEMY_BARRIER: true;
                    case BULLET(ENEMY), PICKUP(_): false;
                }
            }
            case BULLET(HERO): {
                switch otherKind {
                    case ENEMY, BULLET(ENEMY), BARRIER: true;
                    case HERO, BULLET(HERO), PICKUP(_), ENEMY_BARRIER: false;
                }
            }
            case BULLET(ENEMY): {
                switch otherKind {
                    case HERO, BULLET(HERO), BARRIER: true;
                    case ENEMY, BULLET(ENEMY), PICKUP(_), ENEMY_BARRIER: false;
                }
            }
            case PICKUP(_): {
                switch otherKind {
                    case HERO: true;
                    case ENEMY, BULLET(_), PICKUP(_), BARRIER, ENEMY_BARRIER: false;
                }
            }
            case BARRIER: {
                switch otherKind {
                    case HERO, ENEMY, BULLET(_): true;
                    case PICKUP(_), BARRIER, ENEMY_BARRIER: false;
                }
            }
            case ENEMY_BARRIER: {
                switch otherKind {
                    case ENEMY: true;
                    case HERO, BULLET(_), PICKUP(_), BARRIER, ENEMY_BARRIER: false;
                }
            }
        }
    }
}