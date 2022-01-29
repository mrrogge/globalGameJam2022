package input;

using tink.core.Option.OptionTools;

/**
    Responsible for handling UserInputConfigs, taking input events like keys and mouse presses and raising corresponding action events.
**/
class InputSys<TBool, TOnce> {
    public var keyEventSlot:heat.event.ISlot<EKey>;
    public var mouseBtnEventSlot:heat.event.ISlot<EMouseBtn>;
    public var actionSignal:heat.event.ISignal<EAction<TBool, TOnce>>;

    var actionEmitter = new heat.event.SignalEmitter<EAction<TBool, TOnce>>();

    var configs:heat.ecs.ComMap<UserInputConfig<TBool, TOnce>>;
    var query = new heat.ecs.ComQuery();

    //vars available only for onKeyEvent
    var actionBuffer = new Map<EAction<TBool, TOnce>, Bool>();

    public function new(configs:heat.ecs.ComMap<UserInputConfig<TBool, TOnce>>) {
        this.configs = configs;
        query.with(configs);
        keyEventSlot = new heat.event.Slot(onKeyEvent);
        mouseBtnEventSlot = new heat.event.Slot(onMouseBtnEvent);
        actionSignal = actionEmitter.signal;
    }

    function onKeyEvent(event:EKey) {
        actionBuffer.clear();
        query.run();
        for (id in query.result) {
            var config:UserInputConfig<TBool, TOnce> = configs[id];
            if (!config.enabled) continue;
            var boolActionKind = config.keysToBoolActions[event.code];
            if (boolActionKind != null) {
                switch event.kind {
                    case PRESSED: actionBuffer[EAction.BOOL(boolActionKind, true)] = true;
                    case RELEASED: actionBuffer[EAction.BOOL(boolActionKind, false)] = true;
                }
            }
            var onceActionkind = config.keysToOnceActions[event.code];
            if (onceActionkind != null) {
                switch event.kind {
                    case PRESSED: {}
                    case RELEASED: actionBuffer[EAction.ONCE(onceActionkind)] = true;
                }   
            }
        }
        for (action => v in actionBuffer) {
            actionEmitter.emit(action);
        }
    }

    function onMouseBtnEvent(event:EMouseBtn) {

    }

    public function dispose() {

    }

}