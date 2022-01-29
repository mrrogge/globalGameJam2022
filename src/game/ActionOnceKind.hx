package game;

/**
    Different types of actions that can happen in the game.
**/
enum ActionOnceKind {
    OK;
    PAUSE_TOGGLE;
    MOVE_UI(dir:dir.Dir4);
}