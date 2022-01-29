package input;

/**
    An event representing a key press or release.
**/
typedef EKey = {
    final code:KeyCode;
    final kind:InputKeyEventKind;
}