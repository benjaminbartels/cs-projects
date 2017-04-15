#include <list>
#include <iostream>
#include "processQueue.h"

using namespace std;

// See header file for general comments

ProcessQueue::ProcessQueue(SortType sortType){

	_sortType = sortType;

};	

void ProcessQueue::enqueue(Process process){		

	int sortableValue = process.getSortableValue(_sortType);

	if (_queue.empty() || sortableValue < _queue.front().getSortableValue(_sortType)) {
		_queue.push_front(process);
	}
	else if (sortableValue >= _queue.back().getSortableValue(_sortType)) {
		_queue.push_back(process);
	}
	else {			

		list<Process>::iterator i;

		for(i = _queue.begin(); i != _queue.end(); ++i) {

			if (sortableValue <= i->getSortableValue(_sortType)) {
				_queue.insert (i, process);
				break;
			}

		}
	}
}

// dequeues a list of processes whos sortable value equals sortableValue parameter
list<Process> ProcessQueue::dequeue(int sortableValue){

	list<Process> result;

	list<Process>::iterator i =_queue.begin();
	while(i != _queue.end()){
		if (sortableValue == i->getSortableValue(_sortType)) {
			result.push_front(*i);
			i = _queue.erase(i);			
		} 
		else 
			i++;
	}

 	return result;
}

Process ProcessQueue::dequeue(){

	Process result = _queue.front();
	_queue.pop_front();
 	return result;
}

Process ProcessQueue::peek(){
	return _queue.front();
}

// decrmenets io burst for all processing queue (I/O queue only)
void ProcessQueue::doWork(){

	if(_sortType == IO_BURSTS_REMAINING) {

		list<Process>::iterator i;
		for (i = _queue.begin(); i != _queue.end(); ++i) {
	    	i->doIoWork();
	    }
	}
}

bool ProcessQueue::isEmpty(){

	return (_queue.empty());
}

list<Process> ProcessQueue::toList(){
	return _queue;
}

void ProcessQueue::print(){
	
	list<Process>::iterator i;
	for (i = _queue.begin(); i != _queue.end(); ++i) {
    	i->print();
    }    
}
