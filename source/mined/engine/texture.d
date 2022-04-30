module mined.engine.texture;

import bindbc.opengl;
import dlib.image.io;
import dlib.image;

struct Texture
{
private:
    int _handle;
public:
    @property int handle()
    {
        return this._handle;
    }

    this(int handle)
    {
        this._handle = handle;
    }

    static Texture loadBitmap(string path)
    {
        import std.file : getcwd;

        auto image = loadBMP(getcwd ~ "/" ~ path);
        auto data = image.data;

        // Generate the textures
        uint texHandle;
        glGenTextures(1, &texHandle);
        glBindTexture(GL_TEXTURE_2D, texHandle);

        // Load the texture
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, 16, 16, 0, GL_RGB, GL_UNSIGNED_BYTE, data.ptr);

        // Texture wrap and filtering
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_R, GL_REPEAT);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);

        glGenerateMipmap(GL_TEXTURE_2D);
        return Texture(texHandle);
    }

    void use(GLuint unit)
    {
        glActiveTexture(unit);
        glBindTexture(GL_TEXTURE_2D, this._handle);
    }
}
