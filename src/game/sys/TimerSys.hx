package game.sys;

class TimerSys {
    var timers:heat.ecs.ComMap<Timer>;
    var query = new heat.ecs.ComQuery();

    public function new(timers:heat.ecs.ComMap<Timer>) {
        this.timers = timers;
        query.with(timers);
    }

    public function update(dt:Float) {
        query.run();
        for (id in query.result) {
            timers[id].update(dt);
        }
    }
}