# Written by Bengt Oxelman in 2023
# activate os methods to interact with the operating system
import os
# activate numerical python library (for arrays)
import numpy as np
# path to the local directory
directory = 'yourlocaldirectory'
# count files
fcount = 0
# Iterate directory to count files
for path in os.listdir(directory):
    # get filename including full path
    f = os.path.join(directory, path)
    #remove mac invisible file
    if (f[-9:]=='.DS_Store'):
        os.remove(f)
    # check if current path is a file
    else:
         if os.path.isfile(os.path.join(directory, path)):
            fcount += 1
nsamp=85
#create 2D array for results, 3 statistics per sample
arr =  np.empty(shape = [fcount+2,3*nsamp+1],dtype=object)
#keep track of indices
x = 0
y = 0
arr[x,y] = "gene name"
x +=1
y +=1
name1=""
name2=""
# iterate through alignments
for filename in sorted(os.listdir(directory)):
    arr[x,0] = filename[0:8]
    fil = open(directory +'/'+ filename, "rt")
    l=0
    Count_bases=0
    Count_diff=0
    for linje in fil:
        error = 0
        line=linje.strip()
        if not line:
            break
        l+=1
        if l%4 == 1:
            name1 = line[1:12]
            # if it is the first file
            if x==1:
                arr[0,y] = name1
            if (x > 1) and (name1 != arr[0,y]):
                print(x)
                print (name1)
                print (name2)
                exit()
                print("Naming error in " + filename + " line " + str(l))
                continue
        if l%4 == 2:
            seq1 = line
        if l%4 == 3:
            name2 = line[1:12]
            if (name1 != name2):
                print("Naming error in " + filename + " line " + str(l))
                continue
            else:
                arr[0,y] = name1
        if l%4 == 0:
            seq2 = line
            pos = 0
            for base in seq1:
                if (base == "A") or (base == "C") or (base == "G") or (base == "T"):
                    if ((seq2[pos])== "A") or ((seq2[pos]) == "C") or ((seq2[pos]) == "G") or ((seq2[pos]) == "T"):
                        Count_bases+=1
                        if seq2[pos] != base:
                            Count_diff +=1
                pos +=1
            arr[x,y] = (len(line))
            y +=1
            arr[x,y] = (Count_bases)
            y +=1
            arr[x,y] = (Count_diff)
            y +=1
            Count_bases=0
            Count_diff=0
    x += 1
    y = 1
    fil.close()
np.savetxt('test.ppp',arr,fmt="%s",delimiter=',')
 