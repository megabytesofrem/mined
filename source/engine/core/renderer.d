module engine.core.renderer;

import engine.core.shader;
import bindbc.opengl;

class Renderer
{
    public abstract void initRenderer();
    public abstract void render(ShaderProgram program);
}
