import std.stdio;

import game;

void main()
{
	GameWindow window = new GameWindow();
	
	window.create(640, 480, "Minecraft Clone");
	window.runEventLoop;
}
