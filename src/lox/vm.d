module lox.vm;
import lox.chunk;
import lox.value;
import std.stdio: write, writeln;

enum int StackMax = 256;

enum InterpretResult
{
    ok,
    compileError,
    runtimeError,
}

class VM
{
    private {
        Chunk m_chunk;
        int m_ip;
        Value[StackMax] m_stack;
        int m_stackTop;
        bool m_traceExecution;
    }

    this()
    {
        m_traceExecution = true;
    }

    InterpretResult interpret(Chunk chunk)
    {
        assert(chunk !is null);
        m_chunk = chunk;
        m_ip = 0;
        return run();
    }
    
    private void resetStack()
    {
        m_stackTop = 0;
    }

    private void push(Value value)
    {
        assert(m_stackTop < m_stack.length);
        m_stack[m_stackTop++] = value;
    }

    private Value pop()
    {
        assert(m_stackTop > 0);
        return m_stack[--m_stackTop];
    }

    private ubyte readUByte()
    {
        return m_chunk.getCode(m_ip++);
    }

    private Value readConstant()
    {
        return m_chunk.getConstant(readUByte());
    }

    private InterpretResult run()
    {
        while (true)
        {
            if (m_traceExecution)
            {
                write("          ");
                for (int slot = 0; slot < m_stackTop; slot++)
                {
                    write("[");
                    write(m_stack[slot]);
                    write("]");
                }
                writeln();
                m_chunk.disassembleInstruction(m_ip);
            }

            auto instruction = cast(Opcode)readUByte();
            final switch (instruction)
            {
                case Opcode.constant:
                    {
                        auto constant = readConstant();
                        push(constant);
                    }
                    break;
                case Opcode.negate:
                    push(-pop());
                    break;
                case Opcode.add:
                    {
                        auto b = pop();
                        auto a = pop();
                        push(a + b);
                    }
                    break;
                case Opcode.subtract:
                    {
                        auto b = pop();
                        auto a = pop();
                        push(a - b);
                    }
                    break;
                case Opcode.multiply:
                    {
                        auto b = pop();
                        auto a = pop();
                        push(a * b);
                    }
                    break;
                case Opcode.divide:
                    {
                        auto b = pop();
                        auto a = pop();
                        push(a / b);
                    }
                    break;
                case Opcode.return_:
                    writeln(pop());
                    return InterpretResult.ok;
            }
        }
    }
}