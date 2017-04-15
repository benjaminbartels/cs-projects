#ifndef __PROCESSQUEUE_H_INCLUDED__
#define __PROCESSQUEUE_H_INCLUDED__ 

#include <list>
#include "process.h"

using namespace std;

// Represents a Process Queue
class ProcessQueue {

private:

	// private fields
    list<Process> _queue; 						// queue is a list of processes
    SortType _sortType; 						// defines how the queue us sorted

public:

	ProcessQueue(SortType sortType); 			// constructor, sortType equates to type of the queue
	void enqueue(Process process);				// enqueues a process
	list<Process> dequeue(int sortableValue);	// dequeues multiple processes
	Process dequeue();							// dequeues top processes
	Process peek();								// looks at top process
	bool isEmpty();								// checks to see if queue is empty
	void doWork();								// called to decrement I/O burst (I/O queue only)
	list<Process> toList();						// returns _queue list
	void print();								// for debugging
};

#endif