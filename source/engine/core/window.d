module engine.core.window;
import engine.core.shader;

import std.stdio;
import bindbc.opengl;
import bindbc.glfw;

class Window
{
    // The underlying native GLFW window
    private GLFWwindow* _window;
    private int _width, _height;

    public @property int width()
    {
        return this._width;
    }

    public @property int height()
    {
        return this._height;
    }

    public @property GLFWwindow* window()
    {
        return this._window;
    }

    public void create(int width, int height, string title)
    {
        import std.string : toStringz;

        this._width = width;
        this._height = height;

        const hasGlfw = loadGLFW();
        if (hasGlfw != glfwSupport)
        {
            writefln("GLFW failed to load!");
        }

        if (!glfwInit())
            return;

        // No idea what this does
        glfwWindowHint(GLFW_VERSION_MAJOR, 3);
        glfwWindowHint(GLFW_VERSION_MINOR, 3);

        _window = glfwCreateWindow(width, height, title.toStringz, null, null);
        if (!_window)
        {
            writefln("Failed to create window");
            glfwTerminate();
            return;
        }

        // Make the window the new OpenGL context
        glfwMakeContextCurrent(_window);
        const hasGl = loadOpenGL();

        onWindowCreate();
    }

    /**
     Run the main event loop and call the event handler
     */
    public void runEventLoop()
    {
        bool closed = cast(bool) glfwWindowShouldClose(this.window);
        while (!closed)
        {
            onWindowDraw();
        }

        // Call onWindowClose when the window is closed
        onWindowClose();
        glfwTerminate();
        return;
    }

    /// Event stubs for onWindowCreate, onWindowDraw etc
    public abstract void onWindowCreate();
    /// ditto
    public abstract void onWindowDraw();
    /// ditto
    public abstract void onWindowClose();
}
