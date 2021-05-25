import std.stdio;
import lox.chunk;
import lox.value;

void main()
{
	auto chunk = new Chunk();
	auto constant = chunk.addConstant(1.2);
	chunk.write(Opcode.constant, 123);
	chunk.write(cast(ubyte)constant, 123);
	chunk.write(Opcode.return_, 123);
	chunk.disassemble("test chunk");
}
