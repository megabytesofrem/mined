module game;

import bindbc.opengl;
import bindbc.glfw;
import gl3n.linalg;

import engine.core.camera;
import engine.core.shader;
import engine.core.window;
import engine.renderer.block.blockrenderer;

class GameWindow : Window
{
    Camera cam;

    ShaderProgram program;
    BlockRenderer renderer;

    override void onWindowCreate()
    {
        import std.file : getcwd;

        // Load the shader
        auto vertShader = VertexShader();
        auto fragShader = FragmentShader();

        vertShader.compile(getcwd ~ "/source/shaders/shader.vs");
        fragShader.compile(getcwd ~ "/source/shaders/shader.fs");

        program.link(vertShader, fragShader);
        program.use;

        glViewport(0, 0, this.width, this.height);

        glEnable(GL_TEXTURE_2D);
        glEnable(GL_DEPTH_TEST);
        glEnable(GL_CULL_FACE);

        // renderer stuff
        cam = Camera(80.0f, 640, 480);

        mat4 mvp = cam.projection * cam.view * mat4.identity();
        program.setUniform("mvp", mvp);

        renderer = new BlockRenderer();
        renderer.initRenderer();
    }

    void onKeyboard()
    {
        import core.stdc.stdlib : exit;

        if (glfwGetKey(this.window, GLFW_KEY_ESCAPE))
        {
            onWindowClose();
            glfwTerminate();
            exit(0);
        }
    }

    override void onWindowDraw()
    {
        onKeyboard();

        glClearColor(0.0, 0.0, 0.0, 1.0);
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

        // renderer stuff
        renderer.render(program);

        glfwSwapBuffers(this.window);
        glfwWaitEvents();
    }

    override void onWindowClose()
    {
        import std.stdio : writeln;

        writeln("Exiting mined..");
    }
}
