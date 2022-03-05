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
    'Global Database currently use Firebase Free Plan only. This imposes limitations to read, write, update and delete operations in Global Database.',
    '%Stored data: 1G',
    '%Document reads: 50k per day',
    '%Document writes: 20k per day',
    '%Document deletes: 20k per day'
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
  FAQ('What to do if importing, adding, editing or deleting a document on Global database suddenly stops?', [
    'The first thing to do is to record or take note the event and inform the admin about encounter. '
        'It is most likely that the Global database quota has been reached leading to stoppage. You can resume your global operations the following day as quota resets everyday.',
    '\nUnfortunately, Google Firestore does not provide API method to inform the app users that the quota has been reached and only through the Firebase console the quota can be checked by the admin.\n',
    'If the admin determines that the quota is not the cause of stoppage, file a bug report to help fix the app.'
  ]),
  FAQ('What are the support CSV encoding types for Import?', [
    'Supported CSV encodings for import are:\n',
    '%CSV UTF-8',
    '%CSV MS-DOS',
    '%CSV Comma-Delimited'
  ]),
];
