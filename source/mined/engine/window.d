module mined.engine.window;
import mined.engine.shader;

import std.stdio;
import bindbc.opengl;
import bindbc.glfw;

class Window
{
private:
    // The underlying native GLFW window
    GLFWwindow* _window;
    int _width, _height;
public:
    @property int width()
    {
        return this._width;
    }

    @property int height()
    {
        return this._height;
    }

    @property GLFWwindow* window()
    {
        return this._window;
    }

    extern (C) static void messageCallback(GLenum source, GLenum type, GLuint id, GLenum severity, GLsizei length, const(
            GLchar*) message, const(void*) userParam) nothrow
    {
        import core.stdc.stdio;
        import std.string : toStringz;

        fprintf(stderr, "GL CALLBACK: %s type = 0x%x, severity = 0x%x, message = %s\n".toStringz,
            (type == GL_DEBUG_TYPE_ERROR ? "** GL ERROR **".toStringz : "".toStringz),
            type, severity, message);
    }

    void create(int width, int height, string title)
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
        glfwWindowHint(GLFW_VERSION_MAJOR, 4);
        glfwWindowHint(GLFW_VERSION_MINOR, 4);

        // Debug
        //glEnable(GL_DEBUG_OUTPUT);
        //glDebugMessageCallback(&messageCallback, cast(void*)0);

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
    void runEventLoop()
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
    abstract void onWindowCreate();
    /// ditto
    abstract void onWindowDraw();
    /// ditto
    abstract void onWindowClose();
}
