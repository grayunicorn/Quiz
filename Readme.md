# Assumptions
## General
1. Everything may change. Flexible is better
2. Using a database adds work up front but is far easier than simple JSON or other structured data in the long run
3. Additions to the questions database would probably come from structured data import as well as some kind of user interface but for now there is JSON input only.
3. There are two kinds of users, students and teachers
4. Questions may not belong to only one quiz. For example a larger pool of questions may exist that could be added to any quiz, or be a random selection in a quiz of 10 questions at any given time.
5. Questions have one or more correct answers (there will always be a “none of the above” choice in case of zero).
6. Answers chosen as correct (by myself) are acceptable for this implementation.
7. Unit tests here are included only to show how they work not to be a complete set of tests.
8. There is nothing secret here so a public GutHub repo will be acceptable.
## Environment
- Project has been built with Xcode 9 beta 6. By the time anyone else looks at this project Xcode 9 is expected to be released.
