Feature: Jobseeker Management and performs different functions

  As an jobseeker
  I want to login to PETS
  And perform various functions

Background: seed data added to database

  Given the default settings are present

  Given the following jobseeker exist:
    | first_name| last_name| email                     | phone       | password   |password_confirmation| year_of_birth |job_seeker_status  |
    | vijaya    | karumudi | vijaya.karumudi@gmail.com | 345-890-7890| password   |password             | 1990          |Unemployed Seeking |
    | thomas    | jones    | tommy1@gmail.com          | 345-890-7890| password   |password             | 1990          |Unemployed Seeking |
    | Jane      | Seeker   | jane.seeker@places.com    | 345-890-7890| password   |password             | 1990          |Unemployed Seeking |

  Given the following companies exist:
    | agency  | name         | website     | phone        | email            | job_email        | ein        | status |
    | MetPlus | Widgets Inc. | widgets.com | 555-222-3333 | corp@widgets.com | corp@widgets.com | 12-3456789 | active |

  Given the following company people exist:
    | company      | role  | first_name | last_name | email            | password  | phone        |
    | Widgets Inc. | CA    | John       | Smith     | ca@widgets.com   | qwerty123 | 555-222-3334 |
    | Widgets Inc. | CC    | Jane       | Smith     | jane@widgets.com | qwerty123 | 555-222-3334 |

  Given the following jobs exist:
    | title   | shift  | fulltime | description | company      | creator        |
    | SW dev  | Evening| true     | develop SW  | Widgets Inc. | ca@widgets.com |
    | Trucker | Day    | true     | drive truck | Widgets Inc. | ca@widgets.com |
    | Doctor  | Day    | true     | heal sick   | Widgets Inc. | ca@widgets.com |
    | Clerk   | Day    | true     | service     | Widgets Inc. | ca@widgets.com |
    | Mime    | Day    | true     | freeze      | Widgets Inc. | ca@widgets.com |

  Given the following job applications exist:
    | job title  | job seeker                |
    | SW dev     | vijaya.karumudi@gmail.com |
    | Trucker    | vijaya.karumudi@gmail.com |
    | Doctor     | vijaya.karumudi@gmail.com |
    | Clerk      | tommy1@gmail.com           |
    | Doctor     | tommy1@gmail.com           |
    | Mime       | tommy1@gmail.com           |

   
  Given the following resumes exist:
    | file_name          | job_seeker             |
    | Janitor-Resume.doc | vijaya.karumudi@gmail.com |

  Given the following agency people exist:
    | agency  | role  | first_name | last_name | phone        | email          | password  |
    | MetPlus | AA,JD | John       | Smith     | 555-111-2222 | aa@metplus.org | qwerty123 |

  Given the following agency relations exist:
  	| job_seeker      | agency_person    | role |
  	| tommy1@gmail.com | aa@metplus.org   | JD   |

Scenario: new Js Registration
  Given I am on the Jobseeker Registration page
  When I fill in "First Name" with "test"
  And I fill in "Last Name" with "js80"
  And I fill in "Email" with "testjobseeker80@gmail.com"
  And I fill in "Phone" with "345-890-7890"
  And I fill in "Password" with "password"
  And I fill in "Password Confirmation" with "password"
  And I select "1990" in select list "Year Of Birth"
  Then I select "Employed Not Looking" in select list "Status"
  And I choose resume file "Admin-Assistant-Resume.pdf"
  Then I click the "Create Job seeker" button
  Then I should see "A message with a confirmation and link has been sent to your email address. Please follow the link to activate your account."

Scenario: validate email address
  Given I am on the Jobseeker Registration page
  And I fill in "Email" with "test@gmal.com"
  Then I click the "Create Job seeker" button
  And I should see "Email is not valid (did you mean ... test@gmail.com?"
  And I fill in "Email" with "test@gmail.com"
  Then I click the "Create Job seeker" button
  Then I should see "Email is not a valid address"
  And I fill in "Email" with "tester@gmail.com"
  Then I click the "Create Job seeker" button
  And I should not see "Email is not a valid address"
  And I fill in "Email" with "test_addr@gmail.com"
  Then I click the "Create Job seeker" button
  And I should see "Email is not a valid address"
  And I fill in "Email" with "test.addr@gmail.com"
  Then I click the "Create Job seeker" button
  And I should not see "Email is not a valid address"
  And I fill in "Email" with "test@yaho.com"
  Then I click the "Create Job seeker" button
  And I should see "Email is not valid (did you mean ... test@yahoo.com?"
  And I fill in "Email" with "test.addr@yahoo.com"
  Then I click the "Create Job seeker" button
  And I should not see "Email is not a valid address"
  And I fill in "Email" with "test_addr@yahoo.com"
  Then I click the "Create Job seeker" button
  And I should not see "Email is not a valid address"

Scenario: Invalid résumé file type
  Given I am on the Jobseeker Registration page
  When I fill in "First Name" with "test"
  And I fill in "Last Name" with "js80"
  And I fill in "Email" with "testjobseeker80@gmail.com"
  And I fill in "Phone" with "345-890-7890"
  And I fill in "Password" with "password"
  And I fill in "Password Confirmation" with "password"
  And I select "1990" in select list "Year Of Birth"
  Then I select "Employed Not Looking" in select list "Status"
  And I choose resume file "Test File.zzz"
  Then I click the "Create Job seeker" button
  Then I should see "File name unsupported file type"

@javascript
Scenario: login jobseeker, land on home page, see applied jobs
  Given I am on the home page
  And I login as "vijaya.karumudi@gmail.com" with password "password"
  Then I should see "Signed in successfully."
  And I should be on the Job Seeker 'vijaya.karumudi@gmail.com' Home page
  And I should see "vijaya"
  And I should see "SW dev" before "Job Opportunities - New"
  And I should see "Trucker" before "Job Opportunities - New"
  And I should see "Doctor" before "Job Opportunities - New"

@javascript
Scenario: job seeker finds new job opportunities
  When I am in Job Seeker's browser
  Given I am on the home page
  And I login as "vijaya.karumudi@gmail.com" with password "password"
  And I wait 1 second
  Then I should see "Signed in successfully"
  And I should be on the Job Seeker 'vijaya.karumudi@gmail.com' Home page
  And I should see "Mime" after "Job Opportunities - New"
  And I should see "Clerk" after "Job Opportunities - New"
  When I am in Company Contact's browser
  Given I am on the home page
  And I login as "jane@widgets.com" with password "qwerty123"
  And I create the following jobs
  | title          | shift   | fulltime | description       | company      | creator        |
  | RoR Developer  | Evening | true     | develop WA        | Widgets Inc. | ca@widgets.com |
  | UI Developer   | Day     | true     | design interfaces | Widgets Inc. | ca@widgets.com |
  When I am in Job Seeker's browser
  And I reload the page
  And I wait 1 second
  Then I should see "UI Developer" after "Job Opportunities - New"
  And I should see "RoR Developer" after "UI Developer"

Scenario: jobseeker homepage with no agency relations
  Given I am on the home page
  And I login as "vijaya.karumudi@gmail.com" with password "password"
  Then I should see "Signed in successfully."
  And I should be on the Job Seeker 'vijaya.karumudi@gmail.com' Home page
  And I should see "Name vijaya karumudi"
  And I should see "Case Manager None assigned"
  And I should see "Job Developer None assigned"

Scenario: edit Js Registration
  Given I am on the home page
  And I login as "vijaya.karumudi@gmail.com" with password "password"
  Then I should see "Signed in successfully"
  When I click the "vijaya" link
  And I fill in "First Name" with "vijaya1"
  And I fill in "Zipcode" with "54321"
  Then I select "Employed Not Looking" in select list "Status"
  And I fill in "Password" with "password"
  And I fill in "Password Confirmation" with "password"
  Then I click the "Update Job seeker" button
  Then I should see "Jobseeker was updated successfully."
  When I click the "vijaya" link
  Then The field 'First Name' should have the value 'vijaya1'
  And The field 'Zipcode' should have the value '54321'

Scenario: edit Js Registration without password change
  Given I am on the home page
  And I login as "vijaya.karumudi@gmail.com" with password "password"
  Then I should see "Signed in successfully"
  When I click the "vijaya" link
  And I fill in "First Name" with "vijaya1"
  Then I select "Employed Not Looking" in select list "Status"
  Then I click the "Update Job seeker" button
  Then I should see "Jobseeker was updated successfully."

@javascript
Scenario: delete jobseeker
  Given I am on the home page
  And I login as "aa@metplus.org" with password "qwerty123"
  Then I am on the JobSeeker Show page for "vijaya.karumudi@gmail.com"
  Then I click and accept the "Delete Job Seeker" button
  And I wait 1 second
  Then I should see "Jobseeker was deleted successfully."

Scenario: cancel redirects to JS home page
  Given I am on the home page
  And I login as "vijaya.karumudi@gmail.com" with password "password"
  And I should see "Your Information"
  Then I click the "vijaya" link
  Then I click the "Cancel" link
  And I should be on the Job Seeker 'vijaya.karumudi@gmail.com' Home page

@javascript
Scenario: Job Developer sees job seeker's job applications
  Given I am on the home page
  And I login as "aa@metplus.org" with password "qwerty123"
  Then I should see "Welcome back to PETS, John Smith"
  Then I am on the JobSeeker Show page for "tommy1@gmail.com"
  And I wait 1 second
  And I should see "Clerk"
  And I should see "Doctor"
  And I should see "Mime"
  And I should not see "Trucker"

@javascript
Scenario: Download resume file_name as a Company Admin
  Given I am on the home page
  And I am logged in as "ca@widgets.com" with password "qwerty123"
  And I should see "SW dev"
  When I click the "SW dev" link
  And I wait 1 second
  And I should see "Applications for this Job"
  Then I click the "karumudi, vijaya" link
  Then I should see button "Download Resume"
  And I click the "Download Resume" button
  Then I should get a download with the filename "Janitor-Resume.doc"
  
  
  @selenium 

  @javascript
  Scenario: non-admin and non-agency person trying to access to admin home page
    Given I am on the home page
    And I login as "vijaya.karumudi@gmail.com" with password "password"
    Then I should see "Signed in successfully."
    And I should not see "Admin"
    When I type agency_admin home in the URL address bar
    Then I should see "Current agency cannot be determined"
    And I should be on the home page
