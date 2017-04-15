#include "cpu.h"
#include "process.h"
#include <iostream>

using namespace std;

// See header file for general comments

Cpu::Cpu() {}

bool Cpu::isEmpty() const {
	return _process.getPid() == -1;
}

Process Cpu::getProcess() const {
	return _process;
}

void Cpu::setProcess(Process process) {
	_process = process;
}

void Cpu::removeProcess() {
	_process = Process();
}

void Cpu::doWork() {
	_process.doCpuWork();
}

void Cpu::print() {

	if (_process.getPid() == -1)
		cout << "NONE\n";		
	else
		_process.print();

}