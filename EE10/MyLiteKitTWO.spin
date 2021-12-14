{

  Project:  EE-10 Assignment
  Platform: Parallax Project USB Board
  Revision: 1.4
  Author:   Syafiq Idros
  Date:     14th Nov 2021
  Log:
    Date: Desc
    14/11/2021: Call Function to read sensor added
    15/11/2021: Forward/Reverse & Stop Movement.
    20/11/2021: Added MotorObject & call function
    21/11/2021: Removed MotorObject and added Comms Object.


}


CON
        _clkmode    = xtal1 + pll16x                                               'Standard clock mode * crystal frequency = 80 MHz
        _xinfreq    = 5_000_000
        _ConClkFreq = ((_clkmode - xtal1) >> 0) * _xinfreq
        _Ms_001     = _ConClkFreq / 1_000

VAR
  long  mainTOF1Add, mainTOF2Add, mainUltra1Add, mainUltra2Add
  long  signal

OBJ
  Term     :"FullDuplexSerial.spin"
  Sensor   :"SensorControlTWO.spin"
  Comms    :"CommControl.spin"
  Motor    :"MotorControlTWO.spin"

PUB Start                                                                               'Runs on Cog Zero

  Sensor.Start(_Ms_001, @mainTOF1Add, @mainTOF2Add, @mainUltra1Add, @mainUltra2Add)
  Comms.Start(_Ms_001, @signal)
  Motor.Start(_Ms_001)

  'Term.Start(24, 25, 0, 9600)  'XCTU TERM DEBUG
  'Term.Start(31, 30, 0, 115200)  'XCTU TERM DEBUG

   {
   repeat
    Term.Str(String(13,"Ultrasonic 1 Readings: "))
    Term.Dec(mainUltra1Add)
    Term.Str(String(13, "Ultrasonic 2 Readings: "))
    Term.Dec(mainUltra2Add)
    Term.Str(String(13, "ToF 1 Reading: "))
    Term.Dec(mainTOF1Add)
    Term.Str(String(13, "ToF 2 Reading: "))
    Term.Dec(mainTOF2Add)      }

  repeat
    'Term.Str(String(13, "Hello"))
    'Term.Dec(signal)
    case (signal)
      1:
        Motor.Forward
        if ((mainTOF1Add  > 220) OR (mainUltra1Add < 200 AND mainUltra1Add > 0))
           signal := 5

      2:
        Motor.Reverse
        if ((mainTOF2Add  > 220) OR (mainUltra2Add < 200 AND mainUltra2Add > 0))
          signal := 5

      3:
        Motor.TurnLeft

      4:
        Motor.TurnRight

      5:
        Motor.StopAllMotors

PRI Pause(ms) | t
  t := cnt - 1088
  repeat (ms #> 0)
    waitcnt(t += _Ms_001)
  return