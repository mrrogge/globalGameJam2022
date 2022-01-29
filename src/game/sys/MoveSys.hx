package game.sys;

class MoveSys {
    var coms:ComStore;
    var query = new heat.ecs.ComQuery();

    public function new(coms:ComStore) {
        this.coms = coms;
        query.with(coms.velocities).with(coms.objects);
    }

    inline function sign(v:Float):Float {
        return v/Math.abs(v);
    }

    //Moves everything based on velocities
    public function move(dt:Float) {
        for (id in query.iter()) {
            var object = coms.objects[id];
            var vel = coms.velocities[id];
            object.x += Math.min(Math.max(vel.x, -vel.xMax), vel.xMax) * dt;
            object.y += Math.min(Math.max(vel.y, -vel.yMax), vel.yMax) * dt;
        }
    }

    //Call this after all movements have occurred for the frame to re-sync the velocity values.
    public function updateVels(dt:Float) {
        for (id in query.iter()) {
            var object = coms.objects[id];
            var vel = coms.velocities[id];
            vel.x = (object.x - vel.prevPos.x) / dt;
            vel.y = (object.y - vel.prevPos.y) / dt;
            vel.prevPos.x = object.x;
            vel.prevPos.y = object.y;
        }
    }
}