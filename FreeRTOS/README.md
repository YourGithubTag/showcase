# COMPSYS 723 Assignment 01 

## Frequency Relay System

### Cecil Symes & Nikhil Kumar

This assignment contains a FreeRTOS system which implements a Frequency Relay control system on a Nios II softcore processor on an Altera FPGA. The project is made for a DE2-115 development board.


## Installation:

The Nios II Soft-core and related Avalon interface should be flashed onto the appropriate Altera FPGA. This can be found in the SOPC folder.

 Once the system is ready, build the system using the provided make file, which will produce an ELF file which can be flashed onto the Nios II. 

The included makefile will link the Assignment01_BSP, which has been modified from the original project BSP. This BSP is slightly modified to provide a 1us timer to the timestamp function which will allow the system to use the Avalon Timestamp timer for timing of latency values.

This can be done using the Command-line using the Nios II Software Build Tools or using the Nios II Eclipse IDE.

Make sure to have the board be currently connected to your device to allow for communication between your machine and the Nios II processor, as this allows for flashing and Nios II commandline outputs.



#### Nios II Eclipse IDE

Import the folder into the Nios II Eclipse IDE. Right click on the Assignment01 folder and select the build option. Once the project has been built, go the run tab in the ribbon, and select "run configurations" From this menu you can create a run mode which will run on the Nios II hardware. Make sure to have the right JTAG port and options selected. From here  you can run the built project on the Nios II. 


#### Command-line on Linux Systems:

Open up the Terminal and change directory into the Nios II SBT installation path. Run the Nios II command line bash script, found in the Nios II SBT installation path. Running this bash script will set up the environment values to use the Nios II SBT in the open terminal. From here, CD into the project folder and navigate to Software/Assignment01/ . You can then run the ``make` command to build the project. From here, open a new terminal and repeat the steps of running the Nios II command line bash script. Once that has been completed, run the `nios2-terminal` command. This will run the Nios II terminal inside the open terminal, allowing to see any printf statements and to ensure that the Nios II processor is running.

Once the project has been built, you can now send the generated ELF file to the Nios II by running `Nios2-download -g Assignment01.elf` to download the built project ELF file and run the system as soon as it's downloaded.


## Operation

The system will start up and begin the Frequency Relay program. 

The VGA output of the DE2-115 board will be sending real-time data of the current system, presenting plots which show frequency and the rate of change for the frequency, as well as information about the system state. 

###### Switch Control:

The switches on the DE2-115 board represent wall switches which connect/disconnect loads. The loads are represented by LEDs of the DE2-115 board. These LEDs can be turned on or off using the switches of the DE2-115 board. There are seven switches which represent seven loads of the system, from Switch 0 to switch 7. 

##### Normal Mode:

At the beginning of the program, any switches which are set high will have the corresponding loads connected. This will show as the Red LEDs turning on. The user can connect/disconnect any loads via the switches. 

As soon as the system detects an instability based on any given thresholds, the Frequency Relay will transition to Load management mode.

The given thresholds for frequency and rate of change for frequency can be changed in the maintenance mode of the system, which can be accessed from the Button 1 of the DE2-115 board.


##### Load Management mode:

This mode is entered as soon as the system detects that the frequency is unstable. From here it will begin to manage the loads automatically. A load will be disconnected, and the Red LED corresponding to the LED will turn off, and a green LED will turn on, signaling that the load has been turned off by the system. The system will continue to turn off loads if the frequency continues to be unstable, and will reconnect the loads one by one if the frequency is stable again. 

The loads are turned off in order of ascending priority of the loads, with load 7 being the highest priority load, whilst load 0 is the lowest priority. 

In this mode, the user cannot bring any new loads online, but can disconnect any loads that are currently turned on, or have already been shed and do not want to be reconnected. 

The system will leave the load management mode automatically once all the loads have been reconnected and the frequency remains stable. 



##### Maintenance mode:

Maintenance mode can be accessed via the button 1. Once this mode is entered, the system no longer will be managing the loads, and will connect any loads not currently connected. 

From this mode the thresholds which determine if the system is unstable or not can be changed via the keyboard. 

###### Keyboard Instructions: 

When in maintenance mode, the user can input values using the keyboard to update the lower frequency threshold and rate of change threshold.
Only numerical digits, periods, and spacebar presses are registered. Up to 4 characters can be entered before the value is taken and used to update the current threshold. If a period is pressed, a decimal point will be placed. If the period is pressed twice, a zero will instead be registered for the second press. The spacebar will update the value immediately without waiting for 4 characters to be entered.

For example, if the number 1,234 is desired, then the digits 1, 2, 3, and 4 can be pressed in order and the value will automatically be submitted.
If the number 1.23 is desired, then the keys 1, ., 2, and 3 can be pressed in order and the value will automatically be submitted.
If the number 1.4 is desired, then the keys 1, ., and 4 will be pressed, followed by a spacebar press in order to submit the value early.

The currently selected threshold to be edited is displayed on the LCD for 5 seconds after submission of the previous value. The first threshold that is edited by default is the lower frequency threshold. After a value is submitted, then the next threshold to be edited is the rate of change threshold. After this, the system returns to editing the lower frequency threshold, and so on and so forth until the user exits maintenance mode.
The values are updated immediately, not upon leaving maintenance mode.





