//This file was generated from (Academic) UPPAAL 4.1.25-5 (rev. 643E9477AA51E17F), April 2021

/*
1. The system is deadlock free.
No Deadlock
*/
A[] (not deadlock)

/*
2. A ventricular sense (VS) cannot be generated within VRP.
There does not eventually exist a path where a Ventricule Sense happens during VRP
*/
E<> not (MonitorVS.VSinVRP)

/*
3. An atrial sense (AS) cannot be generated within PVARP.
There does not eventually exist a path where a Atrial Sense happens during PVARP
*/
E<> not (MonitorAS.ASinPVARP)

/*
4. The pacemaker never delivers a pacing pulse (AP) within AEI.
There does not eventually exist a path where there is a Atrial Pace during the AEI period
*/
E<> not (MonitorAEI.InvalidAP)

/*
5. The pacemaker never delivers a pacing pulse (VP) within AVI.
There does not exist a path eventually where there is a Ventricle Pace during the URI period
*/
E<> not (MonitorAVI.InvalidVP)

/*
6. The pacemaker never delivers a pacing pulse (VP) within URI.
THere does not eventually exist a path where there is a Ventricle Pace during the URI period
*/
E<> not (MonitorURI.InvalidVP)

/*
7. The time interval between two consecutive ventricular events is always less or equal to LRI.

There does not eventually exists a path where when two consecutive ventricle events occur, the time is more than LRI
*/
E<> not (MonitorLRI.Detect imply MonitorLRI.timer > LRI)

/*
7. The time interval between two consecutive ventricular events is always less or equal to LRI.

There always exists for all paths where two consecutive ventricular events are always less than or equal to LRI
*/
A[](MonitorLRI.Detect imply MonitorLRI.timer <= LRI)

/*
8. The pacemaker can deliver a pacing pulse (VP), where the time interval between this VP and its
preceding atrial event is greater than AVI.

There eventually exists a path Where the MonitorAVIInterval detects a Ventricular Pace and the time from the previous atrial event is more than AVI
*/
E<> (MonitorAVIInterval.VPaceAfterAVI imply MonitorAVIInterval.timer > AVI && MonitorAVIInterval.timer == URI)

/*
Eventually a valid ventricle pace is done
*/
E<>(MonitorAVI.ValidVP)

/*
For all paths globally, an AVI Ventricle pace means that URI is inactive
*/
A[] (PM_AVI_M.AVI_Pace imply URIActive == false)

/*
There exists for all paths always where when AVI paces the Ventricle 
*/
E[] (PM_AVI_M.AVI_Pace imply PM_URI_Timer_M.URITimer >= URI)

/*
For all paths always, A ventricle pace implies that the AVItimer is more than or equal to AVI
*/
A[] (PM_AVI_M.AVI_Pace imply PM_AVI_Timer_M.AVITimer >= AVI)

/*
in all paths eventually AEI paces the Atrium, it implies that the AEI timer has expired
*/
A<> (PM_AEI_M.AEI_Pace imply PM_AEI_Timer_M.AEITimer == AEI)

/*
For all paths, always, whenever LRI expires, implies AVI is expiring
*/
A[](PM_LRI_M.LRIEXPIRY imply PM_AVI_Timer_M.AVITimer == AVI)

/*
Always, in all paths, A pacing action by AVI is while URI is inactive
*/
A[] (PM_AVI_M.AVI_Pace imply PM_URI_M.IDLE)

/*
Making Sure AVI will Pace the Ventricle
*/
E<> (PM_AVI_M.AVI_Pace)
