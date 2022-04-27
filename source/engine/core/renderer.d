module engine.core.renderer;

import engine.core.shader;
import bindbc.opengl;

class Renderer {
    abstract void initRenderer();
    abstract void render(ShaderProgram program);
}
