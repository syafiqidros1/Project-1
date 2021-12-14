{

  Project:  MotorControl
  Platform: Parallax Project USB Board
  Revision: 1.3
  Author:   Syafiq Idros
  Date:     5th Nov 2021
  Log:
    Date: Desc
    02/11/2021: Added Forward/Back/Right/Left functions.
    04/11/2021: Changed zero to 1980,2000,1970,1980
    05/11/2021: Adjusted duration of turning.


}


CON

  '' [ Declare Pins for Motor ]
  motor1 = 10
  motor2 = 11
  motor3 = 12
  motor4 = 13

  motor1Zero = 1850 '1900 '1800
  motor2Zero = 1930 '1920 '1820
  motor3Zero = 1840 '1890 '1790
  motor4Zero = 1850 '1900 '1800

  speed  = 100    'Value when Robot moves forward.
  revspeed = 100  'Value when Robot moves backwards.


VAR ' Global Variable

  long cog2ID, cog2Stack[128]  ' Stack space for cog
  long _Ms_001

OBJ ' Object

  'Term  : "FullDuplexSerial.spin" 'UART communication for
  Servo : "Servo8Fast_vZ2.spin"

PUB Start(mainMsVal)     'mainMSVal                                                     'Runs on Cog 2
                                                                              ' Add Pause after each movement
  _Ms_001 := mainMSVal

  Stop

  cog2ID := cognew(motorSet, @cog2Stack)


  motorCore

  return

PRI motorSet  ' Set Servo Value

  Servo.Set(motor1, motor1Zero)
  Servo.Set(motor2, motor2Zero)
  Servo.Set(motor3, motor3Zero)
  Servo.Set(motor4, motor4Zero)

PUB motorCore

  Servo.Init               ' Initialise Pins
  Servo.AddSlowPin(motor1) ' Assignment of motor to pin
  Servo.AddSlowPin(motor2) ' Assignment of motor to pin
  Servo.AddSlowPin(motor3) ' Assignment of motor to pin
  Servo.AddSlowPin(motor4) ' Assignment of motor to pin
  Servo.Start              ' Calculates # of clocks per ZonePeriod & GlitchFree Servos.
  'Pause(500)               ' Pause for half a second.

PUB Stop  ' Stops the old cog.

  if cog2ID
    cogstop(cog2ID~)

PUB StopAllMotors               ' Stops all the motors.

  Servo.Set(motor1, motor1Zero)
  Servo.Set(motor2, motor2Zero)
  Servo.Set(motor3, motor3Zero)
  Servo.Set(motor4, motor4Zero)

PUB Forward                          ' Moves Forward

    Servo.Set(motor1, motor1Zero+speed)
    Servo.Set(motor2, motor2Zero+speed)
    Servo.Set(motor3, motor3Zero+speed)
    Servo.Set(motor4, motor4Zero+speed)


PUB Reverse                        ' Moves in reverse


    Servo.Set(motor1, motor1Zero-revspeed)
    Servo.Set(motor2, motor2Zero-revspeed)
    Servo.Set(motor3, motor3Zero-revspeed)
    Servo.Set(motor4, motor4Zero-revspeed)


PUB TurnRight                    ' Moves Right


    Servo.Set(motor1, motor1Zero-speed)
    Servo.Set(motor3, motor3Zero-speed)
    Servo.Set(motor2, motor2Zero+speed)
    Servo.Set(motor4, motor4Zero+speed)

PUB TurnLeft                          ' Moves Left

    Servo.Set(motor1, motor1Zero+speed)
    Servo.Set(motor3, motor3Zero+speed)
    Servo.Set(motor2, motor2Zero-speed)
    Servo.Set(motor4, motor4Zero-speed)


PRI Pause(ms) | t
  t := cnt - 1088   ' sync with system counter
  repeat (ms #> 0)  ' delay must be >0
    waitcnt(t += _Ms_001)
  return