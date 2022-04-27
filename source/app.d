import std.stdio;

import game;

void main() {
	GameWindow window = new GameWindow();

	window.create(800, 600, "Minecraft Clone");
	window.runEventLoop;
}
