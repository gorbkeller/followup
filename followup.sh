#!/bin/bash

echo "now running ~ followup ~"
echo "written by Gordon Keller"
echo "created: 1/29/23"
echo "modified: 1/29/23"
sleep 1

# parse out the test flag (expect '-t')
client_csv=$1
attch_dir=$2

i=1
while IFS=, read -r cfn cln sfn sln email phone inst
do
    # skip CSV header
    test $i -eq 1 && ((i=i+1)) && continue
    echo "$cfn,$cln,$sfn,$sln,$email,$phone,$inst"

    # skip empty lines
    if [ -z "$email" ]; then continue; fi

    echo ""
    echo "-----------------------------------"
    echo "Starting a new job..."

    # print out the current job
    echo "Client: $cfn $cln"
    echo "Student: $sfn $sln"
    echo "Email address: $email"
    echo "Phone number: $phone"
    echo "Instrument: $inst"


    # check to see if student has a new note
    # returns a note path if it exists
    # returns no note path if not

    student=""
    date=""
    note_path=""
    for FILE in $attch_dir/*; do 
        # parse out last part of file
        note_file_name=$(basename "$FILE")
        nfn_front="${note_file_name%.*}"
        IFS='_' read -ra nfn_array <<< "$nfn_front"
        student="${nfn_array[0]}"
        date="${nfn_array[3]} ${nfn_array[4]}"

        # if the student name matches the current line student name,
        # copy the path name to the output path and proceed
        if [ ${student,,} == ${sfn,,} ]; then
            note_path=$FILE
            echo "Found note for $sfn -- attach to email -> $note_path"
        fi
    done


    # parse out the date from the note title
    if [ -z "$note_path" ]
    then
        echo "No note path -- skipping send to $email ($cln,$cfn)"
    else
        # check for client-is-the-student case
        if [ ${cfn,,} == ${sfn,,} ]
            then
                echo "Hi $sfn, here are the notes from your $inst lesson this week. Thanks! - Gordon" | \
                    mutt -s "$sfn's Lesson Notes - $date" \
                    $email \
                    -a $note_path --
            else
                echo "Hi $cfn, here are the notes from $sfn's $inst lesson this week. Thanks! - Gordon" | \
                    mutt -s "$sfn's Lesson Notes - $date" \
                    $email \
                    -a $note_path --
        fi
    fi

    echo "Done with active job for $cln,$cfn."
    echo "-----------------------------------"
    echo ""

    sleep 1

done < $client_csv
echo "Lesson Follow-up Email Script finished!"
