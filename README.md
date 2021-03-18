# OODD 517 - Library Management System

Admin email: admin@lib.edu

Admin password: Admin@123

#### Please read the following notes about things which we feel are not very obvious regarding our UI:

#### Note 1:
Creating a new book does not associate the book with a library. There is a separate link provided for admins and librarians to add books to libraries, where the number of copies of those books can be specified along with the library the book is to be added to. We did this to enable n-to-m relationship between libraries and books. The reason to handle count of books and the association between libraries and books this way was so that the same book could be added to multiple libraries. This would not have been possible had we associated the books directly with a library since books have a constraint of the ISBN being unique.

#### Note 2:
Image uploads work as expected and are visible in the show book link. However, due to the read only nature of the Heroku File System, the images get cleaned up after every reboot of the dyno and so the uploaded files are lost. We have also brought this to the notice of our mentor. Kindly take this into consideration when reviewing. Thanks!

#### Note 3:
At any given time, a student is allowed to see books associated with only one library. Thus, there is no separate link to browse books on the student home page, a student has to always browse books only by library. The association between books and libraries can be found in the Add Books to Libraries link, which is visible to the admin and librarians. Thanks!

#### Note 4:
The view book hold request on the student home page shows all the holds requests that the logged in student currently has. For a librarian it shows all the hold requests for books in the library which the librarian is associated with and for the admin, it shows holds requests across all libraries for all books.  
 
#### Note 5:
Kindly refer to the end of the file for information about edge cases handling. Thanks! 
 
This is a simple application to simulate the various operations that can be performed in a library.
It consists of following user types - 

1. Admin
2. Librarian
3. Student

The following features have been implemented so far:

### Login Page
-   Students, librarians and the admin can login through the same page by either using their login credentials or with their google account.
-   This pages also provides two seperate links for signing up as either a student or librarian (the librarian will have to be approved by the admin before he/she can log in after signing up).

# Admin

### Admin Homepage
Below are the details of the various links available on the home page when the admin logs in:

1.	Edit Profile – Allows the admin to update his email, username and password

2. Create New librarians/Approve Librarians - Provides the list of librarians along with following features – 
    -	View Librarian details
    -	Option to approve a Librarian
    -	Modify Librarian details
    -	Remove a Librarian from the system
    -	Add new Librarians

3. View/Add Students - Provides the list of students along with following features – 
    -	View Student details
    -	Modify Student details
    -	Remove a Student from the system
    -	Add new Students

4. View/Add Libraries - Provides the list of libraries along with following features – 
    -	View Library details
    -	Modify Library details
    -	Remove a Library from the system
    -	Add new Libraries

5. View/Add Books - Provides the list of books along with following features – 
    -	Search Books using title / author / subject / published interval (can specify all or no search fields)
    -	View Book details
    -	Modify Book details
    -	Remove a Book from the system
    -	Add new Books

6. View Book requests - Provides the list of book requests along with following features – 
    -	View Book request details
    -	Modify book requests
    -	Remove book requests
    -	Add new book request

7. View Book Histories – Allows the admin to view the history of all books issued and returned

8. Add Books to libraries – Allows the admin to add copies of the books in the library - 
    -   Book count details
    -	Modify book counts
    -	Remove the book count from the system (i.e., remove a book from a library)
    -	Add new book count (i.e., add a book to a library)

7. View overdue fines – Allows the admin to view the list fo students who have books overdue along with the overdue fines

# Librarian

### Librarian Homepage

1. Edit profile - Allows the librarian to update his email, username and password

2. View Book requests - 
    - Provides the librarian an option to approve or reject special book requests
    - Librarian can modify or delete book requests

3. Change Library Policies (WIP) - 
    - Allows Librarians to update the overdue day limit and overdue fines for Library he/she is assigned to 

4. View books
    -   Allows Librarian to view all books available in the library he/she is assigned to
    -	Search books by using title / author / subject / published interval
    -	View Book details
    -	Modify Book details
    -	Remove the book from the system
    -	Add new Books

# Student

### Student Homepage

1. Edit profile - Allows the student to update his/her email, username and password

2. Libraries - This shows the list of libraries belonging to the university which the student is a part of. It also allows students to browse books in a particular library and issue/bookmarks those books - 
    -   View list of accessible libraries with option to browse books in the library
    -	Search Books by using title / author / subject / published interval
    -	View Book details
    -	Issue a Book
    -	Bookmark a book

3. View checked out books 
    -   Allows students to view checked out books
    -   Provides an option to return books

4. View bookmarked books
    -   Displays list of books bookmarked by a student

5. View book hold request
    -   Displays list of book hold requests in case book was not available

6. View pending special book requests 
    -   Shows the status of special book requests with an option to modify and delete the request

7. View overdue fines
    -   Shows books which are overdue and the associated fines

#### Edge cases handling:

#### Deleting a book:
When a book is deleted, it is assumed that all the copies have been returned manually. Deleting a book deletes pending special/hold requests and bookmarks if any for the book being deleted and also increments the book limit of the students who had the book issued at the time of deletion of the book. This also deletes the associations the book has with any and all libraries present. All the history corresponding to the book is also deleted as it would lead to foreign key violations otherwise.

#### Deleting a student:
When a student is deleted, it is assumed that the books held by the student at the time of deletion are returned manually. Deleting a student thus, increments the count of the books if any being held by the student at the time of deletion in the corresponding libraries. Any pending special/hold requests and bookmarks corresponding to the student are also deleted. All the history corresponding to the student is also deleted as it would lead to foreign key violations otherwise.

#### Deleting a library:
When a library is deleted, all the books associated with the library as deleted. It is assumed that all books issued by this library to students are returned manually. Thus, deleting a library increments the book limit of the students who had books issued at the time of deletion. Further, the librarians associated with the library are also deleted and the history corresponding to all books associated with the library is also deleted. Again, this is done as it would lead to foreign key violations otherwise.
Note: Deleting a library does not delete the books present in the library, it just the associations of those books with the library allowing the books to be present in other libraies. This is another reason for not associating a book directly with a library.
