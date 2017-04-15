// Benjamin Bartels

#include <iostream>
#include <list>
#include <fstream>
#include <sstream>
#include <iomanip>
#include "cpu.h"
#include "process.h"
#include "processQueue.h"

using namespace std;

// Pupulates the startup queue by reading in a file
bool initStartQueue(ProcessQueue &startUpQueue, char* path) {

	ifstream file(path,ios::in);

	// check to see if files exists and can be read
	if ( !file.is_open() ) {
    	cout<<"Could not open file\n";
    	return false;
	}

	int pid = 0;
	int nice = 0;
	int arrivalTime = 0;
	int cpuBursts = 0;
	int ioBursts = 0;
	list<int> cpuBurstLengths;
	list<int> ioBurstLengths;

	string line;
	// read lines
	while (getline(file, line))
	{

	    istringstream inputStream(line);

	    if(line == "***")
	    	break; // end file parsing

	    pid++;
	    inputStream >> nice;
	    inputStream >> arrivalTime;
	    inputStream >> cpuBursts;
	    ioBursts = cpuBursts - 1;
	    cpuBurstLengths.clear();
	    ioBurstLengths.clear();

	    bool isCpuBurst = true;
	    int burst;

	    // populate burst lists
	    while(true) {

	    	if(inputStream >> burst) {

		    	if (isCpuBurst){		    		
					cpuBurstLengths.push_front(burst);
		    		isCpuBurst = false;
		    	}
		    	else {
		    		ioBurstLengths.push_front(burst);
		    		isCpuBurst = true;
		    	}
	    	}
	    	else
	    	{
	    		break;
	    	} 
	    }

	    // create new process and add to queue
	    Process newProcess(pid, nice, arrivalTime, cpuBurstLengths, ioBurstLengths);
	    startUpQueue.enqueue(newProcess);
	}

	return true;

}

// Calculates and prints end od processing summary values
void doSummary(ProcessQueue finishedQueue){

	list<Process> finishedProcesses = finishedQueue.toList();

	list<Process>::iterator i;

	int tat = 0;
	int tct = 0;
	int wt = 0;
	double cut = 0;

	int totalTat = 0;
	int totalWt = 0;
	double totalCut = 0;	

	cout << "\nSummary:\n";

	// Calculate and print per process values
	for(i = finishedProcesses.begin(); i != finishedProcesses.end(); ++i) {

		tat = i->getTurnAroundTime();
		tct = i->getTotalCpuTime();
		wt = i->getWaitingTime();
		cut = i->getPercentOfCpuUtilization();

		cout << "Process " << setw(5) << i->getPid();
		cout << " TAT = " << setw(5) <<  tat;
		cout << " TCT = "<< setw(5) <<  tct;
		cout << " WT = " << setw(5) <<  wt;
		cout << " CUT = " << setw(5) <<  fixed << setprecision(1) << showpoint << cut;
		cout << '\n';

		totalTat = totalTat + tat;
		totalWt = totalWt + wt;
		totalCut = totalCut + cut;
	}	

	// caluclate and print averages
	double avgTat = (double)totalTat / (double)finishedProcesses.size();
	double avgWt = (double)totalWt / (double)finishedProcesses.size();
	double avgCut = (double)totalCut / (double)finishedProcesses.size();

	cout << '\n';
	cout << "Averages:\n";
	cout << setw(21) << "Avg TAT =" << setw(8) << fixed << setprecision(3) << showpoint << avgTat << '\n';
	cout << setw(21) << "Avg WT =" << setw(8) << avgWt << '\n';
	cout << setw(21) << "Avg CPU Utilization =" << setw(8) << avgCut << '\n';
	cout << '\n';
}

// main function
int main(int argc, char* argv[]) { 

	if (argc != 2){
		cout << " Usage: " << argv[0] << " <filename>\n";		
		return 0;
	}
	
	// create cpu and queues
	Cpu cpu;
	ProcessQueue startUpQueue(START_TIME);
	ProcessQueue readyQueue(PRIORITY);
	ProcessQueue expiredQueue(PRIORITY);
	ProcessQueue ioQueue(IO_BURSTS_REMAINING);
	ProcessQueue finishedQueue(FINISH_TIME);

	int clock = 0; // inti clock

	if(!initStartQueue(startUpQueue,argv[1]))
		return 0;

	while(true) {

		list<Process>::iterator i;

		// dequeue process for starting queue from thsi clock value
		list<Process> startingProcesses = startUpQueue.dequeue(clock);

		// calculate first priority and timeslice for all starting processes and enqueue to ready queue
		for(i = startingProcesses.begin(); i != startingProcesses.end(); ++i) {
			i->initalizePriority();
			i->calculateTimeslice();
			cout << "[" << clock << "] <" << i->getPid() << "> Enters Ready Queue (Priority: " << i->getSortableValue(PRIORITY) 
				<< ", Timeslice: " << i->getTimeslice() << ")\n";			
			readyQueue.enqueue(*i);
		}

		// if cpu is empty grab lowest priority process from ready if not empty
		if (cpu.isEmpty()){
			if (!readyQueue.isEmpty()) {
				Process nextProcess = readyQueue.dequeue();
				cout << "[" << clock << "] <" << nextProcess.getPid() << "> Enters the CPU\n";
				cpu.setProcess(nextProcess);
			}
		}

		// if lowest priority process in ready is lower than the one in cpu, preeempt.
		if (!cpu.isEmpty() && !readyQueue.isEmpty() && readyQueue.peek().getSortableValue(PRIORITY) < cpu.getProcess().getSortableValue(PRIORITY)) {
			Process preementedProcess = cpu.getProcess();
			Process preementingProcess = readyQueue.dequeue();
			cout << "[" << clock << "] <" << preementingProcess.getPid() << "> Preements Process " << preementedProcess.getPid() << '\n';
			cpu.setProcess(preementingProcess);
			readyQueue.enqueue(preementedProcess); // put preempted process back in ready queue 
		}

		// do io and cpu work
		cpu.doWork();
		ioQueue.doWork();


		if (!cpu.isEmpty()) {
			
			Process cpuProcess = cpu.getProcess();

			// if done with cpu burst switch to io burst
			if (cpuProcess.getCpuBurstTime() == 0) {
				cpuProcess.switchBurstMode();
				// after last cpu burst, send process to end queue
				if(cpuProcess.getCpuBurstCount() == 0 ){					
					cout << "[" << clock << "] <" << cpuProcess.getPid() << "> Finishes and moves to the Finished Queue\n";
					cpuProcess.setEndTime(clock+1); //  add one to clock to compensate for starting clock at 0
					finishedQueue.enqueue(cpuProcess);
				} else {
					// else move process to io queue
					cout << "[" << clock << "] <" << cpuProcess.getPid() << "> Moves to the I/O Queue\n";				
					ioQueue.enqueue(cpuProcess);
				}
				// clear cpu
				cpu.removeProcess();
			}

			// if timeslice is 0 then recalc priority and timeslice and send to expired queue
			if(cpuProcess.getTimeslice() == 0) {
				cpuProcess.calculatePriority();
				cpuProcess.calculateTimeslice();
				cout << "[" << clock << "] <" << cpuProcess.getPid() << "> Finishes its time slice and moves to the Expired Queue (Priority: " 
					<< cpuProcess.getSortableValue(PRIORITY) << ", Timeslice: " << cpuProcess.getTimeslice() << ")\n";	
				expiredQueue.enqueue(cpuProcess);
				// clear cpu
				cpu.removeProcess();
			}

		}

		// get all process done with i/o at this clock cycle
		list<Process> doneWithIoProcesses = ioQueue.dequeue(0);

		for(i = doneWithIoProcesses.begin(); i != doneWithIoProcesses.end(); ++i) {
			i->switchBurstMode(); // switch to cpu
			// if timeslice is 0 then recalc priority and timeslice and send to expired queue
			if (i->getTimeslice() == 0){
				i->calculatePriority();
				i->calculateTimeslice();
				cout << "[" << clock << "] <" << i->getPid() << "> Finished I/O and moves to the Expired Queue\n";	
				expiredQueue.enqueue(*i);
			}
			else {
				// else move process to ready queue
				cout << "[" << clock << "] <" << i->getPid() << "> Finished I/O and moves to the Ready Queue\n";	
				readyQueue.enqueue(*i);
			}

		}

		// break on all relevent queues being empty
		if (startUpQueue.isEmpty() && readyQueue.isEmpty() && expiredQueue.isEmpty() && ioQueue.isEmpty() && cpu.isEmpty()){			
			break;
		}

		// if ready queue and cpu is empty but expired is not, swap queues.
		if (readyQueue.isEmpty() && cpu.isEmpty() && !expiredQueue.isEmpty()) {
			cout << "[" << clock << "] *** Queue Swap\n";	
			ProcessQueue temp = readyQueue;
			readyQueue = expiredQueue;
			expiredQueue = temp;
		}
	
		// uncomment for debuging......
		// cout << "==========================================STATUS==========================================\n";
		// cout << "CURRENT CPU PROCESS ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n";
		// cpu.print();
		// cout << "STARTUP ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n";
		// startUpQueue.print();
		// cout << "READY ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n";
		// readyQueue.print();
		// cout << "EXPIRED ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n";
		// expiredQueue.print();
		// cout << "I/O ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n";
		// ioQueue.print();
		// cout << "FINISHED +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n";
		// finishedQueue.print();
		// cout << "\n\n";
		// cin.get();

		clock++;
		
	}

	doSummary(finishedQueue);
}