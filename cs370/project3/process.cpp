#include <list>
#include <iostream>
#include <iomanip>
#include "process.h"

using namespace std;

// See header file for general comments

Process::Process(int pid, int nice, int startTime, list<int> cpuBursts, list<int> ioBursts){

	_pid = pid;
	_nice = nice;
	_startTime = startTime;
	_endTime = 0;
	_originalPriority = 0;
    _priority = 0;
    _timeslice = 0;
	_cpuBursts = cpuBursts;
	_ioBursts = ioBursts;
	_totalCpuTimeUsed = 0;
	_totalIoTimeUsed = 0;

}

// to create a uninialized process
Process::Process() {
	_pid = -1;
}

int Process::getPid() const {
	return _pid; 
}

// accessor that returns a processes field based on the type of queue this instance is in
int Process::getSortableValue(SortType type) const { 

	switch(type) {

		case START_TIME:
			return _startTime;
		case PRIORITY:
			return _priority;
		case IO_BURSTS_REMAINING:
			return getIoBurstTime();
		case FINISH_TIME:
			return _endTime;
	}	
}

int Process::getCpuBurstTime() const {
	if(!_cpuBursts.empty())
		return _cpuBursts.front();	
	else
		return 0; 
}

int Process::getCpuBurstCount() const {

	return _cpuBursts.size();

}

int Process::getIoBurstTime() const {
	if(!_ioBursts.empty())
		return _ioBursts.front();	
	else
		return 0;
}

int Process::getTimeslice() const {
	return _timeslice;
}

// switches burst mode from io to/from cpu
void Process::switchBurstMode(){

	if(_cpuBursts.size() != 0){

		if(_cpuBursts.size() == _ioBursts.size()) {
			// in ioMode
			_ioBursts.pop_front();
		}
		else {
			// in cpu mode
			_cpuBursts.pop_front();
		}
	}
}

void Process::setEndTime(int endTime){

	_endTime = endTime;

}

int Process::getIoBurstCount() const {

	return _ioBursts.size();

}

void Process::initalizePriority() {

	_originalPriority = _priority = (int)(((_nice + 20) / 39.0 * 30) + 0.5) + 105;

}

void Process::calculatePriority() {

	int bonus = 0;


	if (_totalCpuTimeUsed < _totalIoTimeUsed) {
		bonus = (int)((( 1 - (_totalCpuTimeUsed/(double)_totalIoTimeUsed) ) * -5 ) - 0.5);
	}
	else {
		bonus = (int)((( 1 - (_totalIoTimeUsed/(double)_totalCpuTimeUsed) ) * -5 ) + 0.5);
	}

	_priority = _originalPriority + bonus;

}

void Process::calculateTimeslice(){

	_timeslice = (int)((1-_priority/150.0)*365+.5)+5;

}

void Process::doCpuWork(){
	_timeslice--;
	if(!_cpuBursts.empty() && _cpuBursts.front() > 0){

		_cpuBursts.front()--;
		_totalCpuTimeUsed++;
	}
}

void Process::doIoWork(){

	if(!_ioBursts.empty() && _ioBursts.front() > 0){		
		_ioBursts.front()--;
		_totalIoTimeUsed++;
	}
}

int Process::getTurnAroundTime() const {

	return _endTime - _startTime;
}

int Process::getTotalCpuTime() const{

	return _totalCpuTimeUsed;
}

int Process::getWaitingTime() const{

	return getTurnAroundTime() - _totalCpuTimeUsed - _totalIoTimeUsed;

}

double Process::getPercentOfCpuUtilization() const{

	return (double)_totalCpuTimeUsed / (double)getTurnAroundTime();

}

void Process::print() {

	cout << "Pid: " << setw(5) << _pid << " Nice: " << setw(3) << _nice;
	cout << " StartTime: " << setw(5) << _startTime << " Priority: " << setw(3) << _priority;
	cout << " Timeslice: " << setw(5) << _timeslice << " CPU: " << setw(5) << getCpuBurstTime();
	cout << " I/O: " << setw(5) << getIoBurstTime();
	cout << "\n";

}