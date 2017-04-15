// Benjamin Bartels
//
// CS 370
// Project2

#include <pthread.h>
#include <semaphore.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

// Struct definitions ///////////////////////////////////////////////////////////


// Struct that defines a queue
typedef struct {
        int* q;
        int queueSize;
        int first;
        int last;
        int count;
} queue;

// Struct that defines a channel
typedef struct
{
    int chanId;
    queue q;            
    sem_t raceSemephore;    // used to prevent race condition on this channel
    sem_t syncSemephore;    // used to sync on this channel    
} channel;

// Struct that defines a node in the ring
typedef struct
{
    int status;   // 1 = active, 0 = relay 
    int uid;
    int tempUid;
    int tempOneHopUid;
    int tempTwoHopUid;
    int isLeader;

} node;

// Queue methods ////////////////////////////////////////////////////////////////

// Initalizaes the queue to the passed in queueSize
void initQueue(queue *q, int queueSize) {
    q->queueSize = queueSize;
    q->q = (int*)malloc(sizeof(int) * q->queueSize);
    q->first = 0;
    q->last = q->queueSize-1;
    q->count = 0;
}

void enqueue(queue *q, int value)
{

    if (q->count < q->queueSize) {
        q->last = (q->last+1) % q->queueSize;
        q->q[ q->last ] = value;      
        q->count = q->count + 1;
    }
}

int dequeue(queue *q)
{
    int result;

    if (q->count > 0) {
        result = q->q[ q->first ];
        q->first = (q->first+1) % q->queueSize;
        q->count = q->count - 1;
    }

    return(result);
}

// Global vars

node* nodes;        // pointer to node array mem space
channel* channels;  // pointer to channel array mem space
int size;           // size of the network
int maxPhase;       // Max phase achieved by the leader.

// Read/Write methods ///////////////////////////////////////////////////////////

// function used to read from a channel
int read(channel* chan) {

    //wait(synchronization_semaphore);
    sem_wait(&chan->syncSemephore);
    //wait(race_condition_semaphore);
    sem_wait(&chan->raceSemephore);
    //int value = remove value from the queue
    int value = dequeue(&chan->q);
    //post(race_condition_semaphore);
    sem_post(&chan->raceSemephore);

    return value;
}

// function used to write to a channel
void write(channel* chan, int value) {

    // wait(race_condition_semaphore);
    sem_wait(&chan->raceSemephore);
    // put value on the queue
    enqueue(&chan->q, value);
    // post(race_condition_semaphore);
    sem_post(&chan->raceSemephore);
    // post(synchronization_semaphore) ;
    sem_post(&chan->syncSemephore);
}

// doThreadedWork method ////////////////////////////////////////////////////////

// Function that is called by each thread
void doThreadedWork(void *args) {

    int phase = 1;

    int index = (intptr_t) args;


    while(phase <= maxPhase){      

        int neighborIndex = index == size - 1 ? 0 : index + 1;

        channel * neighborChannel = &channels[neighborIndex];       // get neighboring channel
        channel * myChannel = &channels[index];                     // get this node's channel

        // if active
        if (nodes[index].status == 1){
            if (nodes[index].isLeader){
                printf("Leader: %i\n", nodes[index].uid); 
            }
            else {
                printf("[%i][%i][%i]\n", phase, nodes[index].uid, nodes[index].tempUid);
            }
            //printf("%i - [%i]->[%i][%i][%i]\n", phase, nodes[index].uid, nodes[index].tempTwoHopUid, nodes[index].tempOneHopUid, nodes[index].tempUid); 
          
            // write temp uid
            write(neighborChannel, nodes[index].tempUid);
           
            // read one hop temp uid
            nodes[index].tempOneHopUid = read(myChannel);

            // write one hop temp uid
            write(neighborChannel, nodes[index].tempOneHopUid);   

            // read two hop temp uid
            nodes[index].tempTwoHopUid = read(myChannel);

            // if one hop temp uid == tempu id
            if (nodes[index].tempOneHopUid == nodes[index].tempUid) {
                // => this node is the leader
                if (!nodes[index].isLeader)  {              
                    nodes[index].isLeader = 1;
                    maxPhase = phase + 1;       // set maxPhase here on leaders thread to stop on the next iteration of each node's thread
                }
            }
            // else if one hop temp uid > two hop temp uid && one hop temp uid > temp uid
            else if (nodes[index].tempOneHopUid > nodes[index].tempTwoHopUid 
                && nodes[index].tempOneHopUid > nodes[index].tempUid) {
                // => this node continues to be an active node
                // => temp uid = one hop temp uid
                nodes[index].tempUid = nodes[index].tempOneHopUid;
            }
            // else
            else {
                // => this node becomes a relay node
                nodes[index].status = 0;
            }
        }
        // else
        else {

            // read temp uid
            nodes[index].tempUid = read(myChannel);                   
            // write temp uid
            write(neighborChannel, nodes[index].tempUid);
            // read temp uid
            nodes[index].tempUid = read(myChannel);
            // write temp uid
            write(neighborChannel, nodes[index].tempUid);

        }

        phase++;
            
    }

    pthread_exit(NULL);
}

// main method //////////////////////////////////////////////////////////////////

void main ( int argc, char *argv[] ) {

    // grab args
    if ( argc != 2 )
    {
        printf( "usage: %s filename\n", argv[0] );
        exit(-1);
    }

    FILE* file = fopen(argv[1], "r"); 

    // open files
    if (! file )
    {  
        printf("Can't open file\n"); 
        exit(-1); 
    } 

    fscanf(file, "%d", & size );

    maxPhase = size;  // maxPhase will never be more than the size of the ring

    // allocate arrays from channels and nodes
    nodes = malloc(sizeof(node) * size);            
    channels = malloc(sizeof(channel) * size);

    pthread_t threadIds[size];

    // read in uids and init queue and semephores
    int newUid; 
    int i = 0;
    while ( fscanf(file, "%d", & newUid ) == 1 )  
    { 
        nodes[i].uid = nodes[i].tempUid = newUid;
        nodes[i].status = 1;

        initQueue(&channels[i].q,size);
        channels[i].chanId = i;
        sem_init(&channels[i].raceSemephore, 0, 1);
        sem_init(&channels[i].syncSemephore, 0, 0);
        i++;
    }

    // spawn threads
    for (i = 0; i < size ; i++) {
        pthread_create(&threadIds[i], NULL, (void *)doThreadedWork, (void *)(intptr_t)i);
    }

    // join the threads when finished
    for (i = 0; i < size ; i++) {
        pthread_join(threadIds[i], NULL);
    } 
}