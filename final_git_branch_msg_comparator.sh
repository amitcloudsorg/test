#!/bin/bash

echo -n  "Enter 2 to 4 branches name sprated by white separated : "
#read user input
read  branch1 branch2 branch3 branch4
#branch=0
crnt_branch=`git branch | cut -d ' ' -f2`
#this loop with call function with branch name as input
for b in  $branch1 $branch2 $branch3 $branch4; do
        #function "git " for getting log for each branch
        function collect_commit_msg {
                # verify inserted branch
                verify_branch=`git branch | cut -d ' ' -f2 | egrep ^\$b\$`
                #checking for "verify_branch" value to not be zero
                if [ -z "$verify_branch" ];then
                        #change branch if current branch in not same as first input
                        git checkout $b
                        echo  "-----------------------------"
                        echo "sorted messages in $b"
                fi
                br_msg=(`git log --oneline | egrep '^ [A-Z]{1,3}-[0-9]{1,6}$' |cut -d' ' -f2|sort -u`) #machine msg pattern and sorting msg in alphabetical order. "XXX-123456"

                        echo "${br_msg[@]}" #printing all stored msg in array.
                        
                if [[ "$b" == "$branch1" ]];then


                        msg_cont1=(`echo ${br_msg[@]} |wc -w`) #counting stored msg in array
                        br_msg1=( "${br_msg[@]}" )
                        echo "sorted message count: ""$msg_cont1"  #printing msg count in array
                        
                fi
                ###########################
                #same process as above#
                if [[ "$b" == "$branch2" ]]; then

                        br_msg2=( "${br_msg[@]}" )
                        msg_cont2=(`echo ${br_msg2[@]} |wc -w`) #counting stored msg in array
                        echo "sorted message count: ""$msg_cont2"
                        
                fi
                ###########################
                #same steps as on above two branches.
                # counting  msg from third branch.
                if [[ "$b" == "$branch3" ]]; then

                        br_msg3=( "${br_msg[@]}" )
                        msg_cont3=(`echo ${br_msg3[@]}|wc -w`)
                        echo "sorted message count: ""$msg_cont3"
                        
                fi
                ###########################
                #same steps as on above 3 branches.
                if [[ "$b" == "$branch4" ]]; then

                        br_msg4=( "${br_msg[@]}" )
                        msg_cont4=(`echo ${br_msg4[@]}|wc -w`)
                        echo "sorted message count: ""$msg_cont4"
                fi

                        echo  "-----------------------------"

        }
                        #end of function

   collect_commit_msg  $b       #calling function alone with branches name as input

done  #loop ended

################################################################
#if you want to see all combined output you can uncomment below  lines starts with echo.

#echo "combine output"
#echo ${combined[@]}

#echo "%------------end-------------%"
####################################################################


                        # marge all array in one array
                        combined=( "${br_msg1[@]}" "${br_msg2[@]}" "${br_msg3[@]}" "${br_msg4[@]}" )

if [  -n "$b"  ]; then #checking for string lenth zero
     
        sorted_unique_ids=(`echo "${combined[@]}" | tr ' ' '\n' | sort |uniq -u`) #storing unique msg in array
        # to see tollel number of filtered  unique msg
        #echo "tottal sorted unique msg"
        #echo ${sorted_unique_ids[@]} |wc -w
        
        #adding msg length branch wise in variable 
        p1=$msg_cont1    
        p2=$p1+$msg_cont2 
        p3=$p2+$msg_cont3

        #filttering only common msg in all branch
        it=0
        for com in ${combined[@]}; do
        k=0
                for uni in ${sorted_unique_ids[@]}; do

                        if [ "$com" = "$uni" ] ; then
                        let k=$k+1
                        fi
                 done
                if [[ "$k" -eq 0 ]]; then
                        result+=( "$com" )
                        if [[ $it -lt $p1 ]]; then
                                 msg1+=( "$com" )
                        elif [[ $it -lt $p2 ]]; then
                                 msg2+=( "$com" )
                        elif [[ $it -lt $p3 ]]; then
                                 msg3+=( "$com" )
                        else
                                 msg4+=( "$com" )
                        fi


                fi
        let it=$it+1
        done

fi
#combining filtered msg array to a single array.
trc=( "${msg1[@]}" "${msg2[@]}" "${msg3[@]}" "${msg4[@]}") #combining
tr=(`echo "${trc[@]}" | tr ' ' '\n' | sort -u`) #sorting unique values
#final result loop for printing common msg table
for f in ${tr[@]}; do #this array have only common msg out of all branches
k1=0
k2=0
k3=0
k4=0
               for i in ${msg1[@]}; do

                        if [ "$f" = "$i" ] ; then #matching common array values with first given branch's msg
                        let k1=$k1+1
                        fi
                done

                 for i in ${msg2[@]}; do

                        if [ "$f" = "$i" ] ; then
                        let k2=$k2+1
                        fi
                done

                 for i in ${msg3[@]}; do

                        if [ "$f" = "$i" ] ; then
                        let k3=$k3+1
                        fi
                 done
                 for i in ${msg4[@]}; do

                        if [ "$f" = "$i" ] ; then
                        let k4=$k4+1
                        fi
                 done
        if [[ "$k1" -eq 0 ]]; then  #if couldn't find match that will add "-" at missing location in array.
                 rt1+=( "   -    " )
        else
                 rt1+=( "$f" )
        fi
        if [[ "$k2" -eq 0 ]]; then
                rt2+=( "   -   " )
        else
                rt2+=( "$f" )
        fi
        if [[ "$k3" -eq 0 ]]; then
                rt3+=( "   -    " )
        else
                rt3+=( "$f" )
        fi
        if [[ "$k4" -eq 0 ]]; then
                rt4+=( "   -    " )
        else
                rt4+=( "$f" )
        fi

done
echo "-----------------------------------------------------"
printf "| %-10s | %-10s | %-10s | %-10s |\n" "$branch1" "$branch2" "$branch3" "$branch4"

echo "-----------------------------------------------------"
k=0
for i in ${tr[@]}; do   # loop to print the final result

        #echo "----------------------------------------"
        printf "| %-10s | %-10s | %-10s | %-10s |\n" "${rt1[$k]}" "${rt2[$k]}" "${rt3[$k]}" "${rt4[$k]}"
        let k=$k+1
done
echo "-----------------------------------------------------"
        #will switch to the same branch where from the script has been executed
`git checkout $crnt_branch`

