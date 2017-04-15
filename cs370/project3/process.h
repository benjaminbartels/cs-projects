#ifndef __PROCESS_H_INCLUDED__
#define __PROCESS_H_INCLUDED__ 

#include <list>

using namespace std;

// enum that defines queue type as well as how a processes is queued and dequeued in their respected queues
enum SortType { START_TIME, PRIORITY, IO_BURSTS_REMAINING, FINISH_TIME };

// represents a process
class Process {

private:

	// private fields
    int _pid;
    int _nice;
    int _startTime;
    int _endTime;
    int _originalPriority;
    int _priority;
    int _timeslice;
    list<int> _cpuBursts;
    list<int> _ioBursts;
    int _totalCpuTimeUsed;
    int _totalIoTimeUsed;

public:


	// ctors
	Process();
	Process(int pid, int nice, int startTime, list<int> cpuBursts, list<int> ioBursts);

	// accessors
	int getPid() const;
	int getSortableValue(SortType type) const;
	int getCpuBurstTime() const;
	int getCpuBurstCount() const;
	int getIoBurstTime() const;
	int getIoBurstCount() const;
	int getTimeslice() const;


	void switchBurstMode();			// switches process from/to cpu and io burst modes
	void setEndTime(int endTime);	// sets the end time called during completion
	void initalizePriority();		// init priority (first time)
	void calculatePriority();		// calculates all subsequent priorities
	void calculateTimeslice();		// calculates timeslice

	void doCpuWork(); 				// decrements cpu burst and timeslice
	void doIoWork();				// decrements io burst

	// used for final calulations
	int getTurnAroundTime() const;	
	int getTotalCpuTime() const;
	int getWaitingTime() const;
	double getPercentOfCpuUtilization() const;

	// for debugging
	void print();

};

#endif