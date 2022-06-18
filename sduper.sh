#/bin/bash

PATH_IN=$1
PATH_OUT=$2
HASHES=find-duplicates.db

if [ "$#" -ne 2 ] ; then
    echo "sintassi: sduper <directory input> <directory output>"
    exit 3
fi

/usr/bin/touch ${HASHES}
> ${HASHES}

# legge tutti i file della directory
for file in ${PATH_IN}/*
do
    filename=`/usr/bin/basename ${file}`
    
    # calcola l'hash del file
    SHASUM=`/usr/bin/shasum ${file}`

    # estrae l'hash   
    HASH=`echo ${SHASUM}| /usr/bin/cut -d " " -f 1`

    # cerca l'hash nel DB
    /usr/bin/grep ${HASH} ${HASHES}
        
    # se non lo trova, lo aggiunge
    if [ $? -eq 0 ] 
    then 
        echo ${filename} is a duplicate file 
        /bin/mv ${file} ${PATH_OUT}/${filename}
    else 
        echo ${HASH} >> ${HASHES}
    fi
    
done
