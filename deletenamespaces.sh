push(){
    curl -k -H "Content-Type: application/json" -X PUT --data-binary @$i.json http://127.0.0.1:8001/api/v1/namespaces/$i/finalize
}
reemplaceTerminating(){
    findline
    if [ $number == '' ]
    then
      echo "\n $i is empty"
    else
      echo "\n $i is NOT empty $number"
      le=2
      fin=$(( $number + $le ))
      echo "$number,$fin" 
      sed -i "${number},${fin}d" $i.json
      push
    fi
}

findline(){
    number=`grep -m 1 -n "finalizers" $i.json  | awk -F ":" {'print $1'}`
    return $number
}

#!/bin/bash
echo "find namespaces"
ns=`kubectl get namespaces --all-namespaces | grep Terminating | awk {'print $1'}` 
for  i in $ns
do
	echo -en "$i \n"
	kubectl get namespace $i -o json > $i.json
  reemplaceTerminating 

done
 
echo "--------------End----------"
