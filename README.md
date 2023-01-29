Followup: personalized emails for private practice follow-ups
Gordon Keller
1/29/2023

This repository contains a lightweight script ('followup.sh') which:
- queries a CSV of clients
- looks for corresponding attachments (e.g., notes from appointments)
- if found, a follow-up email is sent with the attached stuff

REQUIREMENTS:
- a working mutt (http://www.mutt.org/) installation
- a file in the root of this repo called "clients.csv" with the following format:
    CLIENT_FN,CLIENT_LN,STUDENT_FN,STUDENT_LN,EMAIL,PHONE,INSTRUMENT
    (this can be modified to match your use case -- this is for private
    music lessons)
- a local directory (default expected directory name is "notes") at the root of this repo

GETTING STARTED:
1. check that your mutt installation works (namely, that you can send emails from mutt)
2. create the "clients.csv" which will be parsed by the script. the script skips the first
line (assumes a header), so start on line 2 or modify the script.
3. create the "notes" directory




