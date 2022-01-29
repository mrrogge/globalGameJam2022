package game.sys;

class GravitySys {
    var coms:ComStore;
    var query = new heat.ecs.ComQuery();

    public function new(coms:ComStore) {
        this.coms = coms;
        query.with(coms.mass).with(coms.velocities);
    }

    public function update(dt:Float) {
        for (id in query.iter()) {
            var mass = coms.mass[id];
            var velocity = coms.velocities[id];
            velocity.y += mass * dt;    
        }
    }
}