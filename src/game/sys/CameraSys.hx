package game.sys;

/**
    NOTE: this is pretty basic for now. Eventually, each camera should have a target that it tracks, and when the target moves the camera's movement will smoothly track it based on some config params. See old lua code for ideas.
**/
class CameraSys {

    static inline final EPSILON = 1e-7;
    var coms:ComStore;
    var heroQuery = new heat.ecs.ComQuery();

    public function new(coms:ComStore) 
    {
        this.coms = coms;
        heroQuery.with(coms.heroStates).with(coms.objects);
    }

    function sign(x:Float):Float {
        if (x < 0) return -1;
        else if (x == 0) return 0;
        else if (x > 0) return 1;
        else return 0;
    }

    public function update(dt:Float) {
        var cam = coms.cameras["worldCamera"];
        if (cam == null) return;
        var config = coms.camConfigs["worldCamera"];
        if (config == null) return;
        if (config.enableLock) {
            var dx = config.lockX-cam.x;
            var dy = config.lockY-cam.y;
            if (config.deadzone.containsPoint(dx, dy)) return;
            switch config.moveType {
                case NULL: {
                    cam.x = config.lockX;
                    cam.y = config.lockY;
                }
                case LINEAR(speed): {
                    cam.x += sign(dx) * Math.min(Math.abs(dx), 32 * speed * dt);
                    cam.y += sign(dy) * Math.min(Math.abs(dy), 32 * speed * dt);
                }
                case DAMPENED(stiffness): {
                    cam.x += sign(dx) * Math.min(Math.abs(dx), 
                        Math.abs(dx) * dt * stiffness);
                    cam.y += sign(dy) * Math.min(Math.abs(dy), 
                        Math.abs(dy) * dt * stiffness);
                }
            }
        }

        // temp hardcoded limits within scene area
        cam.x = Math.max(App.VIEW_WIDTH/2, Math.min(App.LEVEL_WIDTH-App.VIEW_WIDTH/2, cam.x));
        cam.y = Math.max(App.VIEW_HEIGHT/2, Math.min(App.LEVEL_HEIGHT-App.VIEW_HEIGHT/2, cam.y));
    }

    public function followHero() {
        for (id in heroQuery.iter()) {
            var config = coms.camConfigs["worldCamera"];
            if (config == null) return;
            var targetPos = coms.objects[id];
            if (targetPos == null) return;
            var absPos = targetPos.getAbsPos();
            config.lockX = absPos.x;
            config.lockY = absPos.y;
            break;
        }
    }
}