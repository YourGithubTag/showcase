//Compsys 705 Assignment 2 - Q1
//Author: Nikhil Kumar

#define N 3 //num of processors
#define J N-1 //0 to J processors

byte mutex = 0;
byte i = 2;

byte pos[N];
byte step[J];

byte CriticalArray[N];

//LTL: Safety property-1
ltl safety {[](mutex <= 1)}

//LTL: Liveness property-2, checking if for any process, once it is waiting, it will enter the critical state
//Indicated by the position array has a 1, meaning waiting, and then once set to zero, meaning process finished
ltl Liveness01 {[] (((pos[0] == 1) -> <>(pos[0] == 0) -> <>(CriticalArray[0])) 
               ||   ((pos[1] == 1) -> <>(pos[1] == 0) -> <>(CriticalArray[1])) 
               ||   ((pos[2] == 1) -> <>(pos[2] == 0) -> <>(CriticalArray[2])) )}

//LTL: Liveness property-2, checking if for ALL process, once it is waiting, it will enter the critical state
//Indicated by the position array has a 1, meaning waiting, and then once set to zero, meaning process finished
ltl Liveness02 {[] (((pos[0]) -> <>(pos[0] == 0) -> <>(CriticalArray[0])) 
               &&   ((pos[1]) -> <>(pos[1] == 0) -> <>(CriticalArray[1])) 
               &&   ((pos[2]) -> <>(pos[2] == 0) -> <>(CriticalArray[2])) )}

//LTL: Liveness property-3, Any process not in the critical section will eventually enter the critical section
ltl Liveness03 {[]((pos[0] == 1) -> <>(CriticalArray[0] == 1) 
                || (pos[1] == 1) -> <>(CriticalArray[1] == 1) 
                || (pos[2] == 1) -> <>(CriticalArray[2] == 1) )}

//LTL: Liveness property-3, Any process not in the critical section will eventually enter the critical section
ltl Liveness04 {[]((CriticalArray[0] == 0) -> <>(CriticalArray[0] == 1) 
                && (CriticalArray[1] == 0) -> <>(CriticalArray[1] == 1) 
                && (CriticalArray[2] == 0) -> <>(CriticalArray[2] == 1) )}

//Process Model
proctype P(byte popID) {
  //Initalization 
  byte j;
  byte k;
  j = 1; 
  CriticalArray[popID] = 0; //Setting up the critical section array

  //Loop which loops from j = i to N-1
  do
    ::(j < N) ->
      //Setting the arrays with process values
      atomic{pos[popID] = j;}
      atomic{step[(j-1)] = popID;}
      k = 0;

      //Loop which checks the wait until K 
      do  
        ::(k == popID) ->
           k++;
        ::((k <= J) && (k != popID)) -> 
          ((step[(j-1)] != popID) || (pos[k] < j)) ; //Waiting for Conditions to be met
          k++; //Iterate K loop
        ::else -> break; //Break the loop if k > J, all elements have been checked
      od;
      //Iterate J loop
      j++;
      //If j has finished cycling through the stages
      ::(j == N) ->
        //Setting the position array
        atomic{pos[popID] = N;}
        break; //Breaking the loop to go to the Critical Section
  od;

  //Critical Section, incrementing and decrementing mutex to check for critical section accesses
  mutex++;
  CriticalArray[popID] = 1; // setting the critical array output to check against the LTL properties 
  mutex--;

  //Setting the pos array to zero, to show that the process has been completed
  pos[popID] = 0;
  j = 0;
}

init {
  atomic { run P(0); run P(1); run P(2); }
}
