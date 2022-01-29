/**
    The main entrypoint for the application. This simply creates an instance of the game's App class.
**/
class Main {
    public static function main() {
        new game.App(
            new heaps.HeapsBackend()
        );
    }
}