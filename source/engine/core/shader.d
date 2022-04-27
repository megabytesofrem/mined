module engine.core.shader;

import bindbc.opengl;
import gl3n.linalg;

import std.stdio;
import std.string : toStringz, fromStringz;
import std.file : readText;

// Write out shader compilation to stdout for debugging
void writeInfoLog(uint shaderType, uint shaderId) {
    int len;
    glGetShaderiv(shaderId, GL_INFO_LOG_LENGTH, &len);

    if (len > 0) {
        auto buf = new char[len];
        glGetShaderInfoLog(shaderId, len, null, buf.ptr);

        final switch (shaderType) {
        case GL_VERTEX_SHADER:
            writefln("Compile failed for vertex shader: %s", buf);
            break;
        case GL_FRAGMENT_SHADER:
            writefln("Compile failed for fragment shader: %s", buf);
            break;
        }
    }
}

struct ShaderProgram {
private:
    GLint _program;

    // Vertex and fragment shaders
    GLuint _vertShader;
    GLuint _fragShader;
public:
    @property GLint program() {
        return this._program;
    }

    /**
        Link the vertex and fragment shader, producing a shader program
     */
    void link(VertexShader vertShader, FragmentShader fragShader) {
        this._vertShader = vertShader.compiledShader;
        this._fragShader = fragShader.compiledShader;

        // Create the shader program
        _program = glCreateProgram();
        glAttachShader(program, _vertShader);
        glAttachShader(program, _fragShader);
        glLinkProgram(program);

        // Free the shaders after linking
        glDeleteShader(_vertShader);
        glDeleteShader(_fragShader);
    }

    void use() {
        glUseProgram(program);
    }

    // Uniforms
    void setUniform(string uniform, int value) {
        const location = glGetUniformLocation(this.program, uniform.toStringz);
        glUniform1i(location, value);
    }

    void setUniform(string uniform, float value) {
        const location = glGetUniformLocation(this.program, uniform.toStringz);
        glUniform1f(location, value);
    }

    void setUniform(string uniform, mat4 matrix) {
        const location = glGetUniformLocation(this.program, uniform.toStringz);

        // https://gl3n.dpldocs.info/v1.4.1/gl3n.linalg.Matrix.value_ptr.html
        glUniformMatrix4fv(location, 1, GL_TRUE, matrix.transposed.value_ptr);
    }
}

struct VertexShader {
private:
    GLuint _compiledShader;
public:
    @property GLuint compiledShader() {
        return this._compiledShader;
    }

    VertexShader compile(string path) {
        const(char*) source = readText(path).toStringz;
        int success;

        // Compile the vertex shader
        _compiledShader = glCreateShader(GL_VERTEX_SHADER);
        glShaderSource(_compiledShader, 1, &source, null);
        glCompileShader(_compiledShader);

        glGetShaderiv(_compiledShader, GL_COMPILE_STATUS, &success);
        if (!success)
            writeInfoLog(GL_VERTEX_SHADER, _compiledShader);

        return this;
    }
}

struct FragmentShader {
private:
    GLuint _compiledShader;
public:
    @property GLuint compiledShader() {
        return this._compiledShader;
    }

    FragmentShader compile(string path) {
        const(char*) source = readText(path).toStringz;
        int success;

        // Compile the vertex shader
        _compiledShader = glCreateShader(GL_FRAGMENT_SHADER);
        glShaderSource(_compiledShader, 1, &source, null);
        glCompileShader(_compiledShader);

        glGetShaderiv(_compiledShader, GL_COMPILE_STATUS, &success);
        if (!success)
            writeInfoLog(GL_VERTEX_SHADER, _compiledShader);

        return this;
    }
}
