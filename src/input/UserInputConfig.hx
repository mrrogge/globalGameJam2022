package input;

/**
    An object defining a mapping between user inputs (keys, mouse, etc.) and actions.
**/
class UserInputConfig<TBool, TOnce> {
    public var enabled = true;
    public final keysToBoolActions = new Map<KeyCode, TBool>();
    public final keysToOnceActions = new Map<KeyCode, TOnce>();
    public final mouseToBoolActions = new Map<KeyCode, TBool>();
    public final mouseToOnceActions = new Map<KeyCode, TOnce>();

    public function new() {}

    public function setKeyToBool(code:KeyCode, kind:TBool):UserInputConfig<TBool, TOnce> {
        keysToBoolActions[code] = kind;
        return this;
    }

    public function setKeyToOnceAction(code:KeyCode, kind:TOnce):UserInputConfig<TBool, TOnce> {
        keysToOnceActions[code] = kind;
        return this;
    }

    public function setKeysToBool(codes:Iterator<KeyCode>, kind:TBool):UserInputConfig<TBool, TOnce> {
        for (code in codes) {
            keysToBoolActions[code] = kind;
        }
        return this;
    }

    public function setKeysToOnceAction(codes:Iterator<KeyCode>, kind:TOnce):UserInputConfig<TBool, TOnce> {
        for (code in codes) {
            keysToOnceActions[code] = kind;
        }
        return this;
    }

    public function setKeysToBools(map:Map<KeyCode, TBool>):UserInputConfig<TBool, TOnce> {
        for (code => kind in map) {
            keysToBoolActions[code] = kind;
        }
        return this;
    }

    public function setKeysToOnceActions(map:Map<KeyCode, TOnce>):UserInputConfig<TBool, TOnce> {
        for (code => kind in map) {
            keysToOnceActions[code] = kind;
        }
        return this;
    }

    public function clearKeyFromBool(code:KeyCode):UserInputConfig<TBool, TOnce> {
        keysToBoolActions.remove(code);
        return this;
    }

    public function clearKeyFromOnceAction(code:KeyCode):UserInputConfig<TBool, TOnce> {
        keysToOnceActions.remove(code);
        return this;
    }

    public function clearKeysFromBools(codes:Iterator<KeyCode>):UserInputConfig<TBool, TOnce> {
        for (code in codes) {
            keysToBoolActions.remove(code);
        }
        return this;
    }

    public function clearKeysFromOnceActions(codes:Iterator<KeyCode>):UserInputConfig<TBool, TOnce> {
        for (code in codes) {
            keysToOnceActions.remove(code);
        }
        return this;
    }
}