import std.stdio;
import lox.chunk;
import lox.value;
import lox.vm;

void main()
{
	auto chunk = new Chunk();
	auto constant = chunk.addConstant(1.2);
	chunk.write(Opcode.constant, 123);
	chunk.write(constant, 123);
	constant = chunk.addConstant(3.4);
	chunk.write(Opcode.constant, 123);
	chunk.write(constant, 123);
	chunk.write(Opcode.add, 123);
	constant = chunk.addConstant(5.6);
	chunk.write(Opcode.constant, 123);
	chunk.write(constant, 123);
	chunk.write(Opcode.divide, 123);
	chunk.write(Opcode.negate, 123);
	chunk.write(Opcode.return_, 123);
	chunk.disassemble("test chunk");

	auto vm = new VM();
	vm.interpret(chunk);
}
