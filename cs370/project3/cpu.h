#ifndef __CPU_H_INCLUDED__
#define __CPU_H_INCLUDED__ 

#include "process.h"

using namespace std;

// represents a cpu
class Cpu {

private:

	// private fields
    bool _isEmpty;
    Process _process;

public:

	Cpu();

    bool isEmpty() const;			// check to see if empty
	Process getProcess() const;		// gets process in cpu
	void setProcess(Process);		// sets process in cpu
    void removeProcess();			// clears cpu
    void doWork();					// decrements cpu burst and timeslice for process in cpu
    void print();					// for debugging
};

#endif