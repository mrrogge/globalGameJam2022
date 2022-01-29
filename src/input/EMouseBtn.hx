package input;

/**
    An event representing mouse button interaction.
**/
typedef EMouseBtn = {
    final code:Int;
    final kind:InputKeyEventKind;
    final x:Int;
    final y:Int;
}