#!/bin/bash

notesdir="notes"

i=1
while IFS=, read -r cfn cln sfn sln email phone inst
do
    # skip CSV header
    test $i -eq 1 && ((i=i+1)) && continue
    echo "$cfn,$cln,$sfn,$sln,$email,$phone,$inst"

    # skip empty lines
    if [ -z "$email" ]; then continue; fi

    # check to see if student has a new note
    # returns a note path if it exists
    # returns no note path if not

    student=""
    date=""
    note_path=""
    for FILE in $notesdir/*; do 
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
            echo "attach -> $note_path"
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
                echo "Hi $sfn, here are the notes from your lesson this week. Thanks! - Gordon" | \
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

done < clients.csv
