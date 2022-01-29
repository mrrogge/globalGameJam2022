package input;

/**
    Represents an action that can be mapped to an input event.
**/
enum EAction<TBool, TOnce> {
    BOOL(kind:TBool, state:Bool);
    ONCE(kind:TOnce);
}