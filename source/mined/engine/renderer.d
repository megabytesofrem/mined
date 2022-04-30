module mined.engine.renderer;

import mined.engine.shader;
import bindbc.opengl;

class Renderer {
    abstract void initRenderer();
    abstract void render(ShaderProgram program);
}
