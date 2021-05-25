module lox.chunk;
import lox.value;
import std.stdio;

enum Opcode : ubyte
{
    constant,
    negate,
    add,
    subtract,
    multiply,
    divide,
    return_,
}

class Chunk
{
    private {
        ubyte[] m_code;
        Value[] m_constants;
        int[] m_lines;
    }

    void write(ubyte value, int line)
    {
        m_code ~= value;
        m_lines ~= line;
    }

    void write(Opcode opcode, int line)
    {
        m_code ~= cast(ubyte)opcode;
        m_lines ~= line;
    }

    ubyte getCode(ulong offset)
    {
        return m_code[offset];
    }

    ubyte addConstant(Value value)
    {
        assert(m_constants.length < 255);
        m_constants ~= value;
        return cast(ubyte)(m_constants.length - 1L);
    }

    Value getConstant(ulong constant)
    {
        return m_constants[constant];
    }

    void disassemble(string name)
    {
        writeln("== ", name, " ==");
        for (int offset = 0; offset < m_code.length;)
            offset = disassembleInstruction(offset);
    }

    int disassembleInstruction(int offset)
    {
        writef("%04d ", offset);
        if (offset > 0 && m_lines[offset] == m_lines[offset - 1])
            writef("   | ");
        else
            writef("%4d ", m_lines[offset]);
        auto instruction = cast(Opcode)m_code[offset];
        final switch (instruction)
        {
            case Opcode.constant:
                return constantInstruction("CONSTANT", offset);
            case Opcode.negate:
                return simpleInstruction("NEGATE", offset);
            case Opcode.add:
                return simpleInstruction("ADD", offset);
            case Opcode.subtract:
                return simpleInstruction("SUBTRACT", offset);
            case Opcode.multiply:
                return simpleInstruction("MULTIPLY", offset);
            case Opcode.divide:
                return simpleInstruction("DIVIDE", offset);
            case Opcode.return_:
                return simpleInstruction("RETURN", offset);
        }
    }

    private int simpleInstruction(string name, int offset)
    {
        writeln(name);
        return offset + 1;
    }

    private int constantInstruction(string name, int offset)
    {
        auto constant = m_code[offset+1];
        writef("%-16s %4d '", name, constant);
        writef("%s", m_constants[constant]);
        writeln("'");
        return offset + 2;
    }
}