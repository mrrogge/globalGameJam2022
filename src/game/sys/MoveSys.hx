package game.sys;

class MoveSys {
    var coms:ComStore;
    var query = new heat.ecs.ComQuery();

    public function new(coms:ComStore) {
        this.coms = coms;
        query.with(coms.velocities).with(coms.objects);
    }

    //Moves everything based on velocities
    public function move(dt:Float) {
        for (id in query.iter()) {
            var object = coms.objects[id];
            var vel = coms.velocities[id];
            object.x += vel.x;
            object.y += vel.y;
        }
    }

    //Call this after all movements have occurred for the frame to re-sync the velocity values.
    public function updateVels() {
        for (id in query.iter()) {
            var object = coms.objects[id];
            var vel = coms.velocities[id];
            vel.x = object.x - vel.prevPos.x;
            vel.y = object.y - vel.prevPos.y;
            vel.prevPos.x = object.x;
            vel.prevPos.y = object.y;
        }
    }
}