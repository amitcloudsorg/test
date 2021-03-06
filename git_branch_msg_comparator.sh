#!/bin/bash

echo -n  "Enter 2 or 3 branches name sprated by white separated : "
#read user input
read  branch1 branch2 branch3
#branch=0
crnt_branch=`git branch | cut -d ' ' -f2`
#this loop with call function with branch name as input
for b in  $branch1 $branch2 $branch3; do
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
		# grep and sorting msg from first branch.
		if [[ "$b" == "$branch1" ]];then
   			br_msg1=(`git log --oneline | egrep -o ' [A-Z]{1,3}-[0-9]{1,6}$' |cut -d' ' -f2|sort -u`) #machine msg pattern and sorting msg in alphabetical order.

   			msg_cont1=(`echo ${br_msg1[@]} |wc -w`) #counting stored msg in array
   			echo "${br_msg1[@]}" #printing all stored msg in array.
   			echo "sorted message count: ""$msg_cont1"  #printing msg count in array
   			echo  "============================="
   			echo  "-----------------------------"
		fi
		###########################
		#on second branch we have same process as above# grep, sorting and counting  msg from second branch.
		if [[ "$b" == "$branch2" ]]; then
   			br_msg2=(`git log --oneline | egrep ' [A-Z]{1,3}-[0-9]{1,6}$' |cut -d' ' -f2|sort -u`)

   			msg_cont2=(`echo ${br_msg2[@]} |wc -w`) #counting stored msg in array
   			echo "${br_msg2[@]}"
   			echo "sorted message count: ""$msg_cont2"
   			echo  "============================="
   			echo  "-----------------------------"
  	 	fi
		###########################
		#same steps as on above two branches.
		# grep, sorting and counting  msg from third branch.
		if [[ "$b" == "$branch3" ]]; then

   			br_msg3=(`git log --oneline | egrep ' [A-Z]{1,3}-[0-9]{1,6}$' |cut -d' ' -f2|sort -u`)
   			msg_cont3=(`echo ${br_msg3[@]}|wc -w`)
   			echo "${br_msg3[@]}"
   			echo "sorted message count: ""$msg_cont3"
   			echo  "-----------------------------"
	   		echo  "============================="
			###########################
		fi
	}
			#end of function
		                        
   collect_commit_msg  $b	#calling function alone with branches name as input

done
#loop ended

################################################################
#if you want to see all combined output you can uncomment below 4 lines

#echo "combine output"
#echo ${combined[@]}

#echo "total msg : " ${combined[@]} |wc -w
#echo "%------------end-------------%"
####################################################################
#sorting common msg from combined array

			# marge all array in one array
			combined=( "${br_msg1[@]}" "${br_msg2[@]}" "${br_msg3[@]}" )

if [  -n "$b"  ]; then #checking for string lenth zero


	#echo "%---uniq mseg---%"
	#echo "${combined[@]}" | tr ' ' '\n' | sort | uniq -u #soring and printing unique msg that are not common.

	sorted_unique_ids=(`echo "${combined[@]}" | tr ' ' '\n' | sort |uniq -u`) #storing unique msg in array's first location as string
	# to see tollel number of filtered  unique msg
	#echo "tottal sorted unique msg"
	#echo ${sorted_unique_ids[@]} |wc -w

	m1=$msg_cont1
	m2=$msg_cont2
	m3=$msg_cont3
	p1=$msg_cont1
	p2=$p1+$msg_cont2
	p3=$p2+$p3
	#filttering only common msg in all branch
	it=0
	for item in ${combined[@]}; do
	let k=0
                for iti in ${sorted_unique_ids[@]}; do

                        if [ "$item" = "$iti" ] ; then    #
                        let k=$k+1
                        fi
                 done
        	if [[ "$k" -eq 0 ]]; then
                	result+=( "$item" )
                        if [[ $it -lt $p1  ]]; then
                                 msg1+=( "$item" )
                        elif [[ $it -lt $p2  ]]; then
                                 msg2+=( "$item" )
                        else
                                 msg3+=( "$item" )
                        fi

        	fi


        let it=$it+1
	done

fi
#combining filtered msg array to a single array.
trc=( "${msg1[@]}" "${msg2[@]}" "${msg3[@]}" )
tr=(`echo "${trc[@]}" | tr ' ' '\n' | sort -u`)
#final result loop for printing common msg table
for f in ${tr[@]}; do #this array have only common msg out of all branches
k1=0
k2=0
k3=0
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

done
echo "----------------------------------------"
printf "| %-10s | %-10s | %-10s |\n" "$branch1" "$branch2" "$branch3"

echo "----------------------------------------"
for i in ${tr[@]}; do   # loop to print the final result

        #echo "----------------------------------------"
        printf "| %-10s | %-10s | %-10s |\n" "${rt1[$k]}" "${rt2[$k]}" "${rt3[$k]}"
        let k=$k+1
        done
echo "----------------------------------------"
        #will switch to the same branch where from the script has been executed
`git checkout $crnt_branch`

