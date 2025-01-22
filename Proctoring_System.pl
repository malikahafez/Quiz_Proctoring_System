
%Implementation of assign_quiz/3:

%getDayIndex(Day,Index):
%Get Index of the given date from Quiz to access the DaySchedule

getDayIndex(sat,0).
getDayIndex(sun,1).
getDayIndex(mon,2).
getDayIndex(tue,3).
getDayIndex(wed,4).
getDayIndex(thu,5).

%Make sure that all TAs in AssignedTAs are different:
%all_diff(List): the elements of List are not repeated

all_diff([_]).
all_diff([H|T]):- \+member(H,T), all_diff(T).

%assign_quiz predicate

assign_quiz(quiz(_,Day,Slot,Count),FreeSchedule,AssignedTAs):-
		length(AssignedTAs,Count),
		getDayIndex(Day,I),
		nth0(I,FreeSchedule,day(_,DaySchedule)),
		J is Slot-1, nth0(J,DaySchedule,SlotTAs),
		freeTAs(SlotTAs,AssignedTAs,Count),
		all_diff(AssignedTAs).

		
%Finding the AssignedTAs list elements:
%freeTAs(SlotTAs,AssignedTAs,Count): assign TA if they do not teach during the slot, skip TA if they teach during the slot
%SlotTAs is a list of the TAs from a slot, Count is the number of required TAs for the quiz,
%AssignedTAs is the list of TA names that can proctor the quiz
		
freeTAs(_,[],0).	
freeTAs(SlotTAs,[HN|TN],Count):- 	member(HN,SlotTAs),
										C1 is Count-1,
										freeTAs(SlotTAs,TN,C1).											
freeTAs(SlotTAs,[HN|TN],Count):- 	\+member(HN,SlotTAs),
										freeTAs(SlotTAs,TN,Count).


%Implementation of assign_quizzes/3:
%assign_quizzes predicate
										
assign_quizzes([],_,[]).
assign_quizzes([HQ|TQ], FreeSchedule, [proctors(HQ,AssignedTAs)|TP]) :-
			assign_quiz(HQ,FreeSchedule,AssignedTAs),
			assign_quizzes(TQ,FreeSchedule,TP).	
			

%Implementation of free_schedule/3:	
%free_schedule predicate		
			
free_schedule(AllTAs,[day(sat,TSA),day(sun,TSU),day(mon,TMO),day(tue,TTU),day(wed,TWE),day(thu,TTH)], [day(sat,SA),day(sun,SU),day(mon,MO),day(tue,TU),day(wed,WE),day(thu,TH)]):-
							free_schedule_help(AllTAs,TSA,SA,sat),
							free_schedule_help(AllTAs,TSU,SU,sun),
							free_schedule_help(AllTAs,TMO,MO,mon),
							free_schedule_help(AllTAs,TTU,TU,tue),
							free_schedule_help(AllTAs,TWE,WE,wed),
							free_schedule_help(AllTAs,TTH,TH,thu).
		
%free_schedule_help(AllTAs,DayTeachingSchedule,DayFreeSchedule,Day):
%DayTeachingSchedule is the schedule of the TAs teaching in each slot,
%DayFreeSchedule is the schedule of TAs that are free in each slot

%if AllTAs is only one TA:

free_schedule_help([ta(_,Day_Off)],_,[[],[],[],[],[]],Day_Off).
free_schedule_help([ta(Name,Day_Off)],[T1,T2,T3,T4,T5],[F1,F2,F3,F4,F5],Day):-
			Day\=Day_Off,
			fill_slot([Name],T1,F1),
			fill_slot([Name],T2,F2),
			fill_slot([Name],T3,F3),
			fill_slot([Name],T4,F4),
			fill_slot([Name],T5,F5),!.

%if AllTAs is more than one TA:
			
free_schedule_help(AllTAs,[T1,T2,T3,T4,T5],[F1,F2,F3,F4,F5],Day):-
			length(AllTAs,X),
			X>1,
			eligible(AllTAs,Day,EligibleTAs),
			fill_slot(EligibleTAs,T1,F11),
			permutation(F1,F11),
			fill_slot(EligibleTAs,T2,F22),
			permutation(F2,F22),
			fill_slot(EligibleTAs,T3,F33),
			permutation(F3,F33),
			fill_slot(EligibleTAs,T4,F44),
			permutation(F4,F44),
			fill_slot(EligibleTAs,T5,F55),
			permutation(F5,F55).
		

%loop over Tas to fill slot of the day in free schedule
%fill_slot(EligibleTAs,SlotTeachingSchedule,SlotFreeSchedule):
%SlotFreeSchedule is the list of all TA names that are not teaching during the slot
%SlotTeachingSchedule is the list of all TA names that are teaching during the slot

fill_slot([Name],[],[Name]).
fill_slot(TAs,[],TAs).
fill_slot([],_,[]).	
fill_slot([Name|T],SlotTeachingSched,[Name|TF]):-
		\+member(Name,SlotTeachingSched),
		fill_slot(T,SlotTeachingSched,TF).
fill_slot([Name|T],SlotTeachingSched,F):-
		member(Name,SlotTeachingSched),
		fill_slot(T,SlotTeachingSched,F).
		
%Find out if the TAs are eligible to proctor on a day based on their day off: eligible if day is not their day off
%eligible(AllTAs,Day,EligibleTAs)
%
%EligibleTAs is list of TA names whose day off is not on the given day

eligible([],_,[]).
eligible([ta(_,Day_Off)|T],Day_Off,EligibleTAs):-
		eligible(T,Day_Off,EligibleTAs).
eligible([ta(Name,Day_Off)|T],Day,[Name|ET]):-
		Day\=Day_Off,
		eligible(T,Day,ET).
		
		
%Implementation of assign_proctors\4	

assign_proctors(AllTAs, Quizzes, TeachingSchedule, ProctoringSchedule):- 
	free_schedule(AllTAs, TeachingSchedule, FreeSchedule),!,
	assign_quizzes(Quizzes, FreeSchedule, ProctoringSchedule).
	
		
		
	
