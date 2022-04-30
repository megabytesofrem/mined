module game;

import bindbc.opengl;
import bindbc.glfw;
import gl3n.linalg;

import mined.engine.camera;
import mined.engine.shader;
import mined.engine.texture;
import mined.engine.window;
import mined.renderer.chunkrenderer;

import std.stdio;

class GameWindow : Window
{
    /// Camera in the game world
    Camera cam;

    /// Compiled shader program
    ShaderProgram program;

    ChunkRenderer chunkRenderer;
    Texture tex;

    float deltaTime = 0.0f;
    float lastFrame = 0.0f;

    override void onWindowCreate()
    {
        import std.file : getcwd;

        // Load the shaders
        auto vertShader = VertexShader();
        auto fragShader = FragmentShader();

        vertShader.compile(getcwd ~ "/source/shaders/shader.vs");
        fragShader.compile(getcwd ~ "/source/shaders/shader.fs");

        program.link(vertShader, fragShader);
        program.use;

        glViewport(0, 0, this.width, this.height);

        // GL options
        glEnable(GL_TEXTURE_2D);
        glEnable(GL_DEPTH_TEST);
        glEnable(GL_CULL_FACE);

        // Camera stuff
        cam = Camera(100.0f, this.width, this.height);
        cam.position = vec3(0, 0, 50);
        cam.lookAt(cam.position, vec3(0, 1, 0), cameraUp);

        chunkRenderer = new ChunkRenderer();

        tex = Texture.loadBitmap("textures/brick.bmp");
        tex.use(GL_TEXTURE0);
        program.setUniform("tex", 0);

        // Register mouse callback
        glfwSetMouseButtonCallback(this.window, &GameWindow.onMouse);
    }

    /// Mouse handler code
    extern (C) static void onMouse(GLFWwindow* window, int button, int action, int mods) nothrow
    {
        // Doesn't work :(
        double xpos, ypos;
        glfwGetCursorPos(window, &xpos, &ypos);

        core.stdc.stdio.printf("cursor pos: %f, %f\n", xpos, ypos);
    }

    void onKeyboard()
    {
        import std.stdio;

        const cameraSpeed = 5.0f * deltaTime;

        import core.stdc.stdlib : exit;

        if (glfwGetKey(this.window, GLFW_KEY_ESCAPE))
        {
            onWindowClose();
            glfwTerminate();
            exit(0);
        }

        // Camera movement
        if (glfwGetKey(this.window, GLFW_KEY_W))
        {
            writeln("w");
            cam.position += cameraFront.normalized * cameraSpeed;
            writefln("pos: %s", cam.position);
        }

        if (glfwGetKey(this.window, GLFW_KEY_S))
        {
            cam.position -= cameraFront.normalized * cameraSpeed;
            writefln("pos: %s", cam.position);
        }

        if (glfwGetKey(this.window, GLFW_KEY_A))
        {
            cam.position -= cross(cameraFront, cameraUp).normalized * cameraSpeed;
        }

        if (glfwGetKey(this.window, GLFW_KEY_D))
        {
            cam.position += cross(cameraFront, cameraUp).normalized * cameraSpeed;
        }

        if (glfwGetKey(this.window, GLFW_KEY_R))
        {
            writeln("resetting camera position");
            cam.position = vec3(0, 0, 50);
        }
    }

    override void onWindowDraw()
    {
        // Calculate delta time
        float current = glfwGetTime();
        deltaTime = current - lastFrame;
        lastFrame = current;

        onKeyboard();

        glClearColor(0.0, 0.0, 0.0, 1.0);
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

        // Camera
        cam.lookAtCamera();
        mat4 mvp = cam.projection * cam.view * chunkRenderer.modelMatrix;
        program.setUniform("mvp", mvp.transposed);

        // Renderer stuff
        chunkRenderer.render(program);

        glfwSwapBuffers(this.window);
        glfwWaitEvents();
    }

    override void onWindowClose()
    {
        import std.stdio : writeln;

        writeln("Exiting mined..");
    }
}
