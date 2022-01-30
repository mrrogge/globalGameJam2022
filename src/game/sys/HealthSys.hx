package game.sys;

class HealthSys {
    var healthComs:heat.ecs.ComMap<Health>;
    public var onDamageSlot:heat.event.ISlot<game.EDamage>;
    public var killedSignal:heat.event.ISignal<EKilled>;
    var killedSignalEmitter = new heat.event.SignalEmitter<EKilled>();

    public function new(healthComs:heat.ecs.ComMap<Health>) {
        this.healthComs = healthComs;
        onDamageSlot = new heat.event.Slot(onDamage);
        killedSignal = killedSignalEmitter.signal;
    }

    function onDamage(event:EDamage) {
        var health = healthComs[event.targetId];
        if (health == null) return;
        health.current -= event.damage;
        if (health.current <= 0) {
            killedSignalEmitter.emit({
                targetId: event.targetId
            });
        }
    }
}