package core;

/**
 * Defines a 2D position for an entity. The position is based on a local transform relative to a parent in a scene hierarchy. The method for deriving an absolute position value is left up to the implementation.
 */
interface IPos {
    public var x(get, set):Float;
    public var y(get, set):Float;
    public var absX(get, never):Float;
    public var absY(get, never):Float;
}