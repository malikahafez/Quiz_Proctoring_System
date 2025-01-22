# Quiz_Proctoring_System
A Prolog program that assigns Teaching Assistants to Quiz Proctoring Slots based on their teaching schedules.
## Predicates:
  **assign_proctors(AllTAs, Quizzes, TeachingSchedule, ProctoringSchedule):**
  
  - _AllTAs_ is a list of Teaching Assistants as structures: _ta(Name, Day_Off)_
  - _Quizzes_ is a list of structures: _quiz(Course, Day, Slot, Count)_ where _Course_ and _Day_ are constants
  - _TeachingSchedule_ is a list of six structures: _day(DayName, DaySchedule)_ where _DaySchedule_ is a list of length 5 representing the 5 slots of the day, and each slot is a list of TA names teaching during that slot
  - _Proctoring_Schedule_ is a list of structures assigning each quiz to the TA names to proctor it: _proctors(quiz(quiz(Course, Day, Slot, Count), TANames))_
    
**free_schedule((AllTAs, TeachingSchedule, FreeSchedule):**

 - _AllTAs_ is a list of Teaching Assistants as structures: _ta(Name, Day_Off)_
 - _TeachingSchedule_ is a list of six structures: _day(DayName, DaySchedule)_
 - _FreeSchedule_ has the same format as _TeachingSchedule_ and gives the slots in which the TAs are free

**assign_quizzes(Quizzes, FreeSchedule, ProctoringSchedule)**
- _Quizzes_ is a list of structures: _quiz(Course, Day, Slot, Count)_ where _Course_ and _Day_ are constants
 - _FreeSchedule_ has the same format as _TeachingSchedule_ and gives the slots in which the TAs are free
 -  _Proctoring_Schedule_ is a list of structures assigning each quiz to the TA names to proctor it: _proctors(quiz(quiz(Course, Day, Slot, Count), TANames))_
   
 **assign_quiz(Quiz, FreeSchedule, AssignedTAs)** 

  
 
