package game;

/**
    Different types of boolean actions available in the game. These can be triggered with a true or false state.
**/
enum ActionBoolKind {
    MOVE_HERO(dir:dir.Dir4);
    HERO_SHOOT(dir:dir.Dir4);
}