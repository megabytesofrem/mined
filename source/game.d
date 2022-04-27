module game;

import bindbc.opengl;
import bindbc.glfw;
import gl3n.linalg;

import engine.core.camera;
import engine.core.shader;
import engine.core.window;
import engine.renderer.block.blockrenderer;

class GameWindow : Window {
    Camera cam;

    ShaderProgram program;
    BlockRenderer block;

    float deltaTime = 0.0f;
    float lastFrame = 0.0f; 

    override void onWindowCreate() {
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
        //glEnable(GL_CULL_FACE);

        // renderer stuff
        cam = Camera(80.0f, this.width, this.height);
        cam.lookAt(cam.position, vec3(0, 1, 0), cam.up);

        block = new BlockRenderer();
        block.translate(vec3(0, 0, 0));

        // mat4 mvp = cam.projection * cam.view * block.modelMatrix.scale(0.1f, 0.1f, 0.1f);
        // program.setUniform("mvp", mvp.transposed);
    }

    void onKeyboard() {
        import std.stdio;
        const cameraSpeed = 2.0f * deltaTime;

        import core.stdc.stdlib : exit;

        if (glfwGetKey(this.window, GLFW_KEY_ESCAPE)) {
            onWindowClose();
            glfwTerminate();
            exit(0);
        }

        // Camera movement
        if (glfwGetKey(this.window, GLFW_KEY_W)) {
            writeln("w");
            cam.position += cam.front * cameraSpeed;
        }

        if (glfwGetKey(this.window, GLFW_KEY_S)) {
            cam.position -= cam.front * cameraSpeed;
        }

        if (glfwGetKey(this.window, GLFW_KEY_A)) {
            cam.position -= cross(cam.front, cam.up).normalized * cameraSpeed;
        }

        if (glfwGetKey(this.window, GLFW_KEY_D) == GLFW_PRESS) {
            cam.position += cross(cam.front, cam.up).normalized * cameraSpeed;
        }
    }

    override void onWindowDraw() {
        // Calculate delta time
        float current = glfwGetTime();
        deltaTime = current - lastFrame;
        lastFrame = current;

        onKeyboard();

        glClearColor(0.0, 0.0, 0.0, 1.0);
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

        // Camera
        cam.lookAtCamera();
        mat4 mvp = cam.projection * cam.view * block.modelMatrix;
        program.setUniform("mvp", mvp.transposed);

        // renderer stuff
        block.render(program);

        glfwSwapBuffers(this.window);
        glfwWaitEvents();
    }

    override void onWindowClose() {
        import std.stdio : writeln;

        writeln("Exiting mined..");
    }
}
