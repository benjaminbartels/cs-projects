// Benjmain Bartels
//
// CS 370
// Project2

#include <stdio.h>
#include <termios.h>
#include <unistd.h>
#include <limits.h>
#include <string.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <stdlib.h>

// Utility Method used to clear the current line and displays the prompt with PWD
void displayPrompt() {

	char buffer[PATH_MAX + 1];

	char * currentDir = getcwd(buffer, PATH_MAX + 1 );
	
	 if( currentDir != NULL ) {
		printf("%c[2K", 27);
	    printf( "\r%s>", currentDir );
	}

	fflush( stdout );
}

// Utility Method used to gets the length of an array of strings
int getStringArrayLength(char** array) {
	  int count = 0;
	  while(array[count]) count++;
	  return count;
}

// Utility Method used to gets the length of a string
int getStringLength(char* string) {
	  int count = 0;
	  while(string[count]) count++;
	  return count;
}

// used to run the specified command as teh source or destination of a pipe
void runPipedCommand(int descriptor[], char * command, char * args[], int isSource) {

	int pid = fork();
	int status;

	if (pid == 0) {
		
		if (isSource) {
			// is source so set 2nd descriptor standard output
			dup2(descriptor[1], 1);
			close(descriptor[0]);
		} else {
			// is destination so set 1st descriptor standard input
			dup2(descriptor[0], 0);
			close(descriptor[1]);
		}

		// execute command, -1 on error
		if(execvp(command, args) == -1){
			perror(NULL);
			exit(-1);
		}

	}
	else if (pid == -1) {
		perror(NULL);
		exit(1);
	}
}

void main() {
	
	// Constant declarations
	const char DELIMITERS[] = " \t\n";
	const char PIPE[] = "|";
	const int MAX_ARGS = 256;
	const int MAX_HISTORY = 10;

	const int UP = 65;
	const int DOWN = 66;
	const int ESCAPE = 27;
	const int LEFT_BRACKET = 91;
	const int BACK_SPACE = 127; // delete envokes 127 (DEL)
	const int DELETE = 126; // backspace envokes 126 (~)

	// Variable declarations
	int exited = 0;
	char * firstCommandArgs[MAX_ARGS]; 
	char ** firstCommandArgPtr;
	char * secondCommandArgs[MAX_ARGS]; 
	char ** secondCommandArgPtr;

	char history[MAX_HISTORY][LINE_MAX];
	int historyIndex = -1; // index of history, goes up to max
	int currentHistoryIndex = -1; // point to element in history array


	// configure the input (termios)
	struct termios originalConfig;
	tcgetattr(0, &originalConfig);
	struct termios newConfig = originalConfig;
	newConfig.c_lflag &= ~(ICANON|ECHO);
	newConfig.c_cc[VMIN] = 1;
	newConfig.c_cc[VTIME] = 1;
	tcsetattr(0, TCSANOW, &newConfig);	

	// while not exited
	while(!exited) {

		// clear the current input and print prompt
		displayPrompt();
		
		char keyPressBuffer[3];
		char commandLine[LINE_MAX];
		int commandLineIndex = 0;			

		while(1) {
			int bytesRead = read(0, keyPressBuffer, 3);

			// on up or down, break
			if (bytesRead == 3){
				if (keyPressBuffer[0] == ESCAPE && keyPressBuffer[1] == LEFT_BRACKET){

					if (keyPressBuffer[2] == UP){		
						
						// decrement history index
						if (currentHistoryIndex >= 0 && currentHistoryIndex) {
							currentHistoryIndex--;
						}

						// re-display promt and print saved command at index
						displayPrompt();
						strcpy(commandLine,history[currentHistoryIndex]);
						commandLineIndex = getStringLength(commandLine);
						printf("%s", commandLine);
					
					}		
					else if (keyPressBuffer[2] == DOWN){

						// increment history index
						if (currentHistoryIndex <= historyIndex) {
							currentHistoryIndex++;
						}

						
						if (currentHistoryIndex > historyIndex) {
							// if at end, just print empty prompt
								displayPrompt();
								commandLineIndex = 0;
								commandLine[commandLineIndex] = '\0';	
						} 
						else {
							// re-display prompt and print saved command at index
							displayPrompt();
							strcpy(commandLine,history[currentHistoryIndex]);
							commandLineIndex = getStringLength(commandLine);
							printf("%s", commandLine);							
						}

					 }
					
					fflush( stdout );		
									
				}
			}
			// handle normal keys
			else if (bytesRead == 1){			
				
				// handle delete and backspace
				if (keyPressBuffer[0] == DELETE || keyPressBuffer[0] == BACK_SPACE){
					if (commandLineIndex > 0) {
						commandLineIndex--;	
						commandLine[commandLineIndex] = '\0';
						displayPrompt();
						printf("%s", commandLine);										
					}
				} 

				// enter not pressed, buffer key
				else if (keyPressBuffer[0] != '\n'){

					putchar (keyPressBuffer[0]);

					commandLine[commandLineIndex] = keyPressBuffer[0];					
					commandLineIndex++;					
				}

				// enter pressed, submit command
				else if (keyPressBuffer[0] == '\n'){					

					putchar (keyPressBuffer[0]);

					commandLine[commandLineIndex] = '\0';					

					if(strcmp(commandLine, "\0") != 0) {
						
						// add to history
						if (historyIndex + 1 < MAX_HISTORY){
		
							// if history is not full add it to empty slot and increment
							historyIndex++;	
							strcpy(history[historyIndex], commandLine);
							currentHistoryIndex = historyIndex + 1;	
						}
						else {
							
							// history is full, shift slots up and insert new entry at end
							int i;
							for (i = 0; i < MAX_HISTORY - 1; i++ ) {			
								strcpy(history[i], history[i+1]);						
							}
						
							strcpy(history[MAX_HISTORY-1], commandLine);
							currentHistoryIndex = historyIndex + 1;	
						}
						
						fflush( stdout );

					}
					break;
				}
			}

      		fflush(stdout);
		}

		// detect pipe character
		int i = 0;
		int pipeCount = 0;
		for (i = 0; commandLine[i] != '\0'; i++) {
		    if (commandLine[i] == '|')
		    	pipeCount++;

			if (pipeCount > 1)
				break;
		}

		// if 2 piped charaters detected, then ignore
		if (pipeCount > 1) {

			printf("Cannot pipe more than 2 commands.\n");
	
		} else {

			char * firstCommand = strtok(commandLine, "|");
			char * secondCommand = strtok(NULL, "|");

			// parse input into a 1st command
			firstCommandArgPtr = firstCommandArgs;
			*firstCommandArgPtr++ = strtok(firstCommand, DELIMITERS);
			while ((*firstCommandArgPtr++ = strtok(NULL, DELIMITERS))); // loop through and save tokens

			// parse input into a 2st command if not NULL
			if (secondCommand != NULL) {
				secondCommandArgPtr = secondCommandArgs;
				*secondCommandArgPtr++ = strtok(secondCommand, DELIMITERS);
				while ((*secondCommandArgPtr++ = strtok(NULL, DELIMITERS))); // loop through and save tokens
			}

			if (getStringArrayLength(firstCommandArgs) > 0) {

				// if cd command
				if(strcmp(firstCommandArgs[0], "cd") == 0) {
					// change the current working directory
					if(chdir(firstCommandArgs[1]) == -1) {
						perror(NULL);
					}
				}
				// if exit, end program
				else if (strcmp(firstCommandArgs[0], "exit") == 0 && firstCommandArgs[1] == NULL) {
					break;
				}
				else {
					

					if (secondCommand == NULL) {
						// if no pipe then execute normally
						int status;

						unsigned int pid = fork();

						if (pid == 0)
						{
							//Child Process					
							if(execvp(firstCommandArgs[0],firstCommandArgs) == -1){
								perror(NULL);
								exit(-1);
							}
						}
						else if (pid > 0)
						{
							//Parent Process
							waitpid(pid,&status,WUNTRACED);
						}


					} else {
						// if pipeing then setup 2 commands and pipe them
						int status;
						int pid;
						int descriptors[2];

						pipe(descriptors);

						runPipedCommand(descriptors,firstCommandArgs[0], firstCommandArgs, 1);  // source
						runPipedCommand(descriptors,secondCommandArgs[0], secondCommandArgs, 0); // destination
						close(descriptors[0]); 
						close(descriptors[1]);	
						
						// loop until both children are done
						while (1)
						{
							pid = wait(&status);
							if (pid == -1)		
								break;	
						}
					}
				}
			}
		}
	}

	// restore the input configuration (termios)
	tcsetattr(0, TCSANOW, &originalConfig);
}