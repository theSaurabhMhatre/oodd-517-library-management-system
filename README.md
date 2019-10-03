# OODD 517 - Library Management System

This is a simple application to simulate the various operations that can be performed in a library.
It consists of following Users - 

1. Admin
2. Librarian
3. Student

#Admin 
### Admin Homepage –
Below are the details of the hyperlinks available on the home page are mentioned 
1	Edit Profile – Allows the admin to update his email, password and user name.

2 Librarian -  Provides the list of librarians along with following functionalities – 
-	Librarian details
-	Option to approve the librarian
-	Modify librarian information
-	Remove the librarian from the system
-	Add new librarian

3	Students - Provides the list of students along with following functionalities – 
-	 Student details
-	Modify student information
-	Remove the student from the system
-	Add new student

4	Libraries - Provides the list of libraries along with following functionalities – 
-	Library details
-	Modify library information
-	Remove the library from the system
-	Add new library

5	Books - Provides the list of books along with following functionalities – 
-	Search book by using title / author / subject / published interval
-	Book details
-	Modify book information
-	Remove the book from the system
-	Add new book

6	Book requests - Provides the list of book requests along with following functionalities – 
-	Book request details
-	Modify book request
-	Remove the book request from the system
-	Add new book request

7 Add Book counts to libraries – Allows the admin to add copies of the books in the library
-   Book count details
-	Modify book count
-	Remove the book count from the system
-	Add new book count

#Librarian
###Librarian Homepage

1 Edit profile - Allows the librarian to update his email, password and user name

2 View book requests - 
- Provides the librarian an option to approve or reject the student's special book request
- Librarian can modify or delete the request

3 Change library policies
- The librarian can change the maximum issue day limit and overdue fines of library to which he is assigned

4 View books
- Librarian can list all the books available in the library to which he is assigned
-	Search book by using title / author / subject / published interval
-	Book details
-	Modify book information
-	Remove the book from the system
-	Add new book

#Student
### Student Homepage

1 Edit profile - Allows the student to update his email, password and user name

2 Libraries - The student browses through list of libraries and he can add book requests using this link.
It also provides following functionalities -
-   List of accessible libraries with book browse option
-	Search book by using title / author / subject / published interval
-	Book details
-	Issue book
-	Bookmark a book

3 View checked out books 
- Displays history of the student's book issues and returns.
- Provides an option to return a book 
- Provides an option to issue a book

4 View bookmarked books
- Displays list of books marked as bookmark by the student

5 Book hold request
- Displays list of book hold requests

6 View pending special book requests 
- Shows the status of special book requests with an option to modify and delete the request

###Login Page
-   The student, librarian and the admin can login through the same page by using their valid credentials and affiliation
-   It provides two different sign up pages for librarian and student to sign up as a new user
