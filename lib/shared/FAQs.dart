import 'package:mech_track/models/FAQ.dart';

List<FAQ> faqs = [
  FAQ('What is the application for?', [
    'The equipment inventory application enables users to easily keep track of their inventory.'
  ]),
  FAQ('What file type can I upload?', [
    'Only CSV UTF-8 (comma delimited) files are accepted by the application.'
  ]),
  FAQ('What are the 3 access levels of the application?',
      ['There are 3 access levels namely: guest, employee, and admin.']),
  FAQ('What are the differences between the access levels?', [
    '%Guest access level:','Lowest access level. Only has the local database and does not need to create an account to access (Note: will still need to connect to the internet before entering as guest)',
    '%Employee access level:','Must have an account to access. This access level is now connected to the global database where changes on the database are updated in real time.',
    '%Admin access level:','Must have an account to access. Same as the employee level but has the ability to make changes in the global database.'
  ]),
  FAQ('What are the functions of the application?', [
    'Search options, search by category, search using QR, export or save as CSV file to device.'
  ]),
  FAQ('What is the purpose of the multi search option?', [
    'To compare/show the equipment\'s similarities based on their classifications.'
  ]),
  FAQ('What will happen if the internet is lost during usage?', [
    'No direct harm will be done, the only downside is that the global database base won\'t be updated in real time.'
  ]),
  FAQ('Why do we need to be connected to the internet?', [
    'There are two reasons: first is for authentication during log-in. All accounts (guest, employee and admin) are required to connect before the use of the application. Second is the real time global database of the application which updates in real time if changes were made by the admin.'
  ]),
  FAQ('What are the system requirements of the application?', [' ']),
  FAQ('What are the data limits of the application?', [
    '%Stored data: 1G',
    '%Document writes: 20k input',
    '%Document deletes: 20k'
  ]),
  FAQ('What to do if I encounter a bug?', [
    'Visit our facebook page to report some bugs. You can also message us if there are bugs to be encountered.'
  ]),
  FAQ('Why does the application need additional permissions?', [
    'To be able to use the QR scanner and to import csv files from the local storage.'
  ]),
  FAQ('What to do if I accidentally deny permissions?', [
    '%For camera:',
    'Proceed to settings > privacy > permission manager > camera > find the app > allow',
    '%For storage:',
    'Proceed to settings > privacy > permission manager > storage > find the app > allow'
  ]),
];
