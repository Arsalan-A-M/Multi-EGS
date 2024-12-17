
RootAutAlt := function(n)

    local i , l , perm ;

    perm := PermListList([1..n],Concatenation([2..n],[1])) ;
    l    := [];

    for i in [1..n]
        do 
            l[i] := [] ; 
        od;

    l[n+1] := perm ;

    return l; 
end;


DirectedAutNoZero := function(vector)

    local i , l ;

    l := [] ; 

    for i in [1..Length(vector)]
        do 
            l[i] := List([1..vector[i]],x->1) ;
        od;

    return Concatenation(l,[()]) ;

end;

DirectedAutNoZeroShort := function(vector)

    return Concatenation(List([1..Length(vector)], x->List([1..vector[x]],y->1)),[()]) ;
end;

RootAut := function(n)

  return  Concatenation(List([1..n], x-> []), [PermListList([1..n],Concatenation([2..n],[1]))]) ;

end;

DirectedAutB := function(vector,j)

    local i , l ;

    l := [] ; 

    for i in [1..Length(vector)]
        do 
            if vector[i] = 0 then 

                l[i] := [] ;

            else

                l[i] := List([1..vector[i]],x->1) ;
                l[Length(vector)+1] := [j] ;
            fi;
        od;

    return Concatenation(l,[()]);

end;

DirectedAutC := function(vector,j)

    local i , l ;

    l := [] ; 

    for i in [1..Length(vector)]
        do 
            if vector[i] = 0 then 

                l[i+1] := [] ;

            else

                l[i+1] := List([1..vector[i]],x->1) ;
                l[1] := [j] ;
            fi;
        od;

    return Concatenation(l,[()]) ;

end;

# This function generates a GGS group with defining vector <vector> given as a list. 

GGSGenerator := function(vector)

    return SelfSimilarGroup([RootAut(Length(vector)+1), DirectedAutB(vector,2)],["a","b"]) ;
end;

# This function generates a EGS group with defining vector <vector> given as a list.

EGSGenerator := function(vector)

    return SelfSimilarGroup([RootAut(Length(vector)+1), DirectedAutB(vector,2), DirectedAutC(vector,3)],["a","b","c"]) ;
end;

GeneratorString := function(matrix)
    
    local i , string ;

    string := ["a"] ;

    for i in [1..Length(matrix)]

        do 
            string[i+1] := StringFormatted("b{}", i ) ;
        od;

    return string;
end;

# This function generates a multi-edge group with defining matrix <matrix>.

MultiEdgeGenerator := function(matrix)

    

    local l , i ;
    
    l := [];

    for i in [1..Length(matrix)]
        do 
            l[1]   := RootAut(Length(matrix[1])+1) ;
            l[i+1] := DirectedAutB(matrix[i],i+1) ;
        od;

    Print(matrix,"\n") ;

    return SelfSimilarGroup(l,GeneratorString(matrix)) ;
end;

VectorGenerator := function(rows, prime)

return List([1..rows], x -> Random([0..prime-1])) ;

end;

MatrixGenerator := function(columns, rows, prime)

return List([1..columns], x -> VectorGenerator(rows, prime)) ;

end;

# This function generates a non-symmetric vector with "row" number of entries. Each entry takes a value from [0..prime]. 

NonSymmetricVector := function(rows, prime)

    local i , l , j ;

    j := Random([1..rows]) ;

    l := [1..rows] ; 

    l[(rows+1)-j] := 0 ;
    l[j] := Random([1..prime-1]) ;

    Print(j,"\n");
    Print(l[j],"\n") ;
    Print((rows+1)-j,"\n") ;
    Print(l[(rows+1)-j], "\n") ;
    
    for i in [1..rows]
        do 
            if i <> j and i <> (rows+1)-j then 
                l[i] := Random([0..prime-1]);
            fi;
        od;

    return l ;

end;

NonSymmetricMatrix := function(columns, rows, prime)

return List([1..columns], x -> NonSymmetricVector(rows, prime)) ;

end;

#Returns list. First entry is a random non-symmetric vector and second entry is postion of its zero entry. 

NonSymmetricVector2 := function(rows, prime)

    local i , l , j ;

    j := Random([1..rows]) ;

    l := [1..rows] ; 

    l[(rows+1)-j] := 0 ;
    l[j] := Random([1..prime-1]) ;

    for i in [1..rows]
        do 
            if i <> j and i <> (rows+1)-j then 
                l[i] := Random([0..prime-1]);
            fi;
        od;

    return [l,(rows+1)-j] ;

end;

#Function returns a set of vectors with only one non-zero entry

PseudoBasis := function(columns, rows)

    local l , int , k , i ;
    
    l   := [1..columns] ;

    for i in [1..columns] 
        do 
            l[i] := List([1..rows], x->0);
            l[i][i] := 1 ;
        od;
    return l ;
end;

# Function returns a set of vectors that have zero entry in a common position determined by a non-symmetric vector. 


ReqVectors := function(columns, rows, prime)

    local l , int , k , i , j  ;

    l := [1..columns] ; 

    int := NonSymmetricVector2(rows, prime) ;

    l[1] := int[1];
    k    := int[2];

    for i in [2..columns]
        do 
            l[i] := [1..rows];
                for j in [1..rows]
                    do 
                        if j <> k then
                            l[i][j] := Random([0..prime-1]);
                        else 
                            l[i][j] := 0;
                        fi;
                    od;
        od;
    return l ;

end;

