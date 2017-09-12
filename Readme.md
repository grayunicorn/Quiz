# General
This has been a little ambitious for “a few hours” so it is not as complete as I imaged it but this should be good for the purpose.

This project is an iOS project in Xcode written using Swift 4. The version of Xcode used is 9 beta 6 - I anticipate Xcode 9 being released by Wednesday the 13th. Even if not Xcode 9 should be available from developer.appl.com as a free download.

Best practise would be to use unit testing as included with a standard Xcode project. I have not written tests.

In developing I have used GitHub with the usual branch/modify/pull request/merge cycle. I started off making some tasks in Trello but decided the branches 
I have developed it using iPhone simulators like iPhone SE though it should work on most others and on iPad simulators. No though has been given to optimising layout after rotation or for different screen sizes though it should work fine, just not adapt to the correct screen position.

The UI is basic iOS elements. You won’t have to look at programmer art here because there is none.

Given something that needs to be imported into a program I like to turn it into structured data. The quiz supplied is expressed in JSON (verified by https://jsonlint.com/) as `question_data.json` and included in the Xcode project. Another file `users.json` provides some users whose names can then be entered into the text box on the first screen. Users “Mr. Bob” and “Ms. Nguyen” are teachers while others like “Toby”, “Paige”, “Ting” etc. are their students. A JSON importer module handles the creation of database objects given their description in these JSON files. Other modules could handle other structured data, or a UI could be provided so that students and teachers could sign up and slot themselves into the database. For QuizCollection objects (the supplied quiz is one) a Teacher could be provided with a UI to create a new quiz.
## Running
After cloning this GitHub repository the program is started from the Xcode IDE by opening it in a compatible IDE (Xcode 9), then building and running using the usual “Play” icon button at top left. Any of the iPhone simulators is a good choice.

At any time the program can be reset completely by removing the app’s icon from the simulator, or by completely resetting the simulator. A startup task checks for the presence of users in the system and re-imports everything from JSON if it is not detected.

The general idea is that all of the objects are imported into a Core Data model. Student and Teacher are the entities that can login. A Teacher has 0..many Students, a Student has one teacher. Both entities can have 0 or more QuizCollections. A QuizCollection has QuizQuestions which in turn has QuizAnswers. The QuizAnswers can either be multiple choice, many answers having a true or false flag, or they can be a text question.

At this stage it is assumed that if a Student has a Teacher that has a QuizCollection the Student can complete it. 

When a Teacher has a QuizCollection then they are able to see “their” quizzes and can change the recorded answers for that QuizCollection object. When a Student logs in, if they have a Teacher who has a QuizCollection object they can then go and complete the quiz. Before their answers are recorded the QuizCollection object is duplicated and all answers are removed. When they complete the quiz they record a complete copy with their own answers as “their” quiz. That object is then independent of any others completed by Students (including self) or Teachers. If a Teacher were able to edit questions this strategy might not work but this could be overcome by adding a unique (UUID) attribute to all objects.

The second section in a Teacher’s login screen is quizzes that have been completed by a Student and require grading. The process of grading for multiple choice questions is that the Student’s version of the QuizCollection is compared against the Teacher’s. For text input questions the Teacher needs to read the answer and enter a grade manually.

When a completed quiz has been graded by the Teacher in this manner it not longer appears in the second section because it no longer requires grading - the QuizCollection object reports itself as “gradeable”. Quizzes in this condition can be viewed by the Teacher selecting a student from the third section and then viewing their completed quizzes and the grade they obtained.
## Future
The right way to do this kind of presentation is probably to use an existing forms library. It is not hard to bend a table view to the purpose but it is not really what it is for. In the absence of a real designer or familiarity with such libraries the table view was an easy choice. There is a lot more that could be done that requires time. 
### Uniqueness
- when objects are created they should be assigned a unique key such as a newly generated UUID at insertion. Login still needs to be unique for users, but this would allow quizzes to have the same title, or to be different versions of the same quiz with different questions - which would avoid the problem of automatic grading computing the wrong grade when answers remain and questions have been changed.
### Authentication:
- integration with school systems for user import/single sign-on
### Data Import:
- More format importers
- Management interface for creation of quizzes and other objects like users in-app
### More real-world handling
- Introduce Subjects as a more appropriate Student-owning object, where a Subject may have one teacher or many in that role. 
- Test many available quizzes from each Teacher. This should work but is not tested to probably does not.
- Introduce the capability of Students to have many Subjects or Teachers, as they usually do.
- Increase the richness of questions. Add the ability to present various kinds of media as components of questions and answers, such as diagrams or videos about which questions are asked.
### Grading:
- calendaring function, students assigned quizzes with due dates
- notification of assigned quizzes, quizzes requiring grading, grading completion etc.
- statistics for all of a student’s quiz attempts; average mark, trend toward improvement (or otherwise)
- an indication of the student’s performance relative to the peer results 
- red flags if a student’s text questions appear to be substantially the same as another’s
- more red flags if a student repeatedly gets the same answers wrong as another 
- Because of reuse of the QuizViewController, Teachers don’t have the best UI to complete grading having to go through all the questions. This could be improved.
(The really nice thing about having done all of this database work in the background is that all of these features are a matter of writing the right queries and displaying the results in a table.)
### UI
- This really needs work!
# Assumptions
## General
- Using a database adds work up front but is far easier than simple JSON or other structured data in the long run.
- Additions to the questions database would probably come from structured data import as well as some kind of user interface but for now there is JSON input only.
- It is a good thing to duplicate objects whenever they change or have their ownership changed. Space is cheap. There may be multiple copies of answers with text “I don’t know” wasting a small amount of space but it is good that any of these can be changed, for example “Cannot be determined”, without affecting any other objects.
- Questions have one or more correct answers (there will always be a “none of the above” choice in case of zero).
- Answers marked as correct in the quiz imported for teachers (by myself) are not necessarily correct but I had a good shot at it.
- Teachers may at times change answers in quizzes so it is a good thing that if an answer is corrected then all the multiple choice questions in submitted quizzes will be automatically corrected too.
## Operations
### Login
- Decision about whether an individual is a teacher or student is made according to login used, currently set only at account creation.
### Teacher
- Teachers can manage the QuizCollection object that they own. 
- As a result two different teachers may have a quiz that starts out the same but has the answers changed to be different - this is an intended consequence of the database structure.
- When a Student completes a quiz it may require grading (has answers requiring Teacher attention) and so such quizzes will appear in the Teacher’s view for grading. 
- Multiple choice questions are graded automatically by comparison with the Teacher’s quiz
-  Where a Question has no answers (question 10 in this quiz) a Teacher may set a value for the score awarded to text entered by the student. This is standardised at a 0-100 value.
- When such a quiz is graded it is removed from the view and is then available in the Student results section.
- The separation of a quiz for grading from the identity of the Student that completed it is also intentional, it is not good to grade with the identity of the Student influencing the decision. 
- Where a Student has completed and graded quizzes the Student appears in the Teacher’s view as having available results. The Teacher may view the results. 
### Student
- A Student has one teacher. Allowing each Student to have multiple teachers and therefore multiple available quizzes was a feature I planned to add but time ran out.
- A student may complete a quiz when a Teacher has one available. 
- When a quiz is complete it appears in the second section of the Student’s screen as a completed quiz. If immediately gradable the grade is displayed  otherwise it is marked as pending grading until a Teacher completes grading. Once graded the score is displayed.
- If a student exits a quiz before completion (pressing the final “Submit”) it is not recorded.