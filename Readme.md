# Assumptions
## General
1. Using a database adds work up front but is far easier than simple JSON or other structured data in the long run
2. Additions to the questions database would probably come from structured data import as well as some kind of user interface but for now there is JSON input only.
3. A question or an answer is unique even if its text is the same as another answer in another question (e.g. “I don’t know”) so that a change can be made to any text independently. 
4. Questions have one or more correct answers (there will always be a “none of the above” choice in case of zero).
5. Answers marked as correct (by myself) are not necessarily correct but I had a good shot at it.
6. Question sets are imported here through a JSON file, but they could also be imported through other parsing modules or entered question by question in an input module.
7. Unit tests here are included only to show how they work not to be a complete set of tests.
8. There is nothing secret here so a public GutHub repo will be acceptable.
9. For swift code the Ray Wenderlich style guide is accepted.
## Environment
- Project has been built with Xcode 9 beta 6. By the time anyone else looks at this project Xcode 9 is expected to be released.
- JSON is common web JSON understood by Xcode and validated by https://jsonlint.com/
## Operation
1. There are two kinds of users, students and teachers
2. For now users and their student/teacher designation are added by a JSON file, reproduced here:  

	{"teachers": [{
	]()"Mr. Bob": {
	"students": [
	]()"Callum",
	"Toby",
	"Paige"
	]
	}
	},
	{
	"Ms. Nguyen": {
	"students": [
	]()"Ting",
	"Artan",
	"Toby"
	]
	}
	}
	]} 
Other login names will not work until some onboarding module is written
 
3.  Decision about whether an individual is a teacher or student is made according to login used, currently set only at account creation.
4. A student might be recorded as having two teachers, so a student might need to choose which teacher’s quiz they would like to see.
### Teacher
1. Teachers can manage the Quiz objects owned by students. A Teacher may create a new Quiz and assign it to Students. 
2. Once assigned a Student may complete a Quiz. 
3. At any time a Teacher may see the Quiz results for a student. 
4. Where a Question has no answers (question 10 in this quiz) a Teacher may set a value for the score awarded to text entered by the student. This is standardised at a 0-100 value.
5. Where a multiple choice answer can be graded the result will be displayed.
6. Where a multiple choice has no answer given it is rated “Incomplete” and scores 0.
7. Where a textual answer has no text it is rated “Incomplete”.
8. Where a textual answer is given a Teacher may award a mark from 0-100 to that question.
### Student
1. A Student has a relationship with a Teacher. The Teacher has a range of Quizzes available

1. A student may complete a Quiz once it is assigned.
2. Students should be able to see when an assigned quiz is available to complete
2. A student may exit a Quiz at any time even if all Questions are not answered.
3. Students cannot see results currently
- A Quiz consistent of a number of questions each of which has some number of answers.
- A Quiz may not currently be changed once created. For now that means once imported as JSON.
- Questions belong to an individual Quiz. Even where questions are identical in two different Quiz collections it may be desirable to change the Question text of one of the objects only.
- Quiz answers belong to questions. Even where an answer “I don’t know” is reused a unique object is created because this text could change to “Cannot be determined” or similar without affecting other questions.
- At least one Answer for each Question will have the isCorrect attribute set true.
- Questions and Answers are extensible; in future image attributes may be added so that diagrams or pictures could form part of either.

