BindGlobal("__SIMPLICIAL_EqualFloats",
    function(x,y, eps)
        return (x-y)^2 < eps;
    end
);
BindGlobal( "__SIMPLICIAL_EqualPoints",
    function( p, q, eps )
        return (p[1]-q[1])^2 + (p[2]-q[2])^2 < eps;
    end
);


BindGlobal( "__SIMPLICIAL_PrintRecordInit",
    function(rec, surface)
        local givenStarts;

        # Starting faces
        if IsBound(rec!.startingFaces) then
            if IsPosInt(rec!.startingFaces) then
                givenStarts := [ rec!.startingFaces ];
            elif IsList( rec!.startingFaces ) and ForAll( rec!.startingFaces, IsPosInt ) then
                givenStarts := rec!.startingFaces;
            else
                Print("Given starting faces are neither a list of faces nor a single face.");
            fi;
        else
            rec!.givenStartingFaces := [];
        fi;
        rec!.givenStartingFaces := givenStarts;
        rec!.startingFaces := [];


        # edge lengths and angles
        if not IsBound( rec!.edgeLengths ) then
            rec!.edgeLengths := [];
        fi;
        rec!.givenEdgeLengths := rec!.edgeLengths;

        if not IsBound( rec!.angles ) then
            rec!.angles := [];
        fi;
        rec!.givenAngles := rec!.angles;

        # float accuracy
        if not IsBound( rec!.floatAccuracy ) then
            rec!.floatAccuracy := 0.001;
        fi;

        # coordinates (always recomputed)
        rec!.vertexCoordinates := [];
        for v in Vertices(surface) do
            rec!.vertexCoordinates[v] := [];
        od;
        rec!.edgeEndpints := [];
        for e in Edges(surface) do
            rec!.edgeEndpoints[e] := [];
        od;
        rec!.faceVertices := [];

        # openEdges
        rec!.openEdges := [];


        # drawing options
        if not IsBound( rec!.vertexLabels ) or not IsBool(rec!.vertexLabels) then
            rec!.vertexLabels := true;
        fi;
        if not IsBound( rec!.edgeLabels ) or not IsBool(rec!.edgeLabels) then
            rec!.edgeLabels := true;
        fi;
        if not IsBound( rec!.faceLabels ) or not IsBool(rec!.faceLabels) then
            rec!.faceLabels := true;
        fi;
        if not IsBound( rec!.scale ) then
            rec!.scale := 2;
        fi;


        # automatic compilation
        if not IsBound( rec!.compileLaTeX ) or not IsBool( rec!.compileLaTeX ) then
            rec!.compileLaTeX := false;
        fi;
    end
);

BindGlobal( "__SIMPLICIAL_PrintRecordCleanup",
    function(rec)
        Unbind( rec!.openEdges );
    end
);

BindGlobal( "__SIMPLICIAL_PrintRecordInitializePolygons",
    function(rec, surface)
        local lengths, angles, edges, vertices;

        lengths := rec!.edgeLengths;
        angles := rec!.angles;

        #TODO allow different way to give angles

        # each angle is stored as a pair of floats [sin(alpha), cos(alpha)]
        for f in Faces(surface) do
            edges := EdgesOfFaces(surface)[f];
            vertices := VerticesOfFaces(surface)[f];
            if not IsBound(angles[f]) then
                angles[f] := [];
            fi;
            # Case all values are set
            if ForAll(edges, e -> IsBound(lengths[e])) and ForAll(vertices, v -> IsBound(angles[f][v])) then
                # Check inner angle sum
                radAngles := List( vertices, v -> Atan2(angles[f][v][1], angles[f][v][2]) );
                angleSum := Sum( radAngles );
                if not __SIMPLICIAL_EqualFloats( angleSum, ( Size(edges) - 2 )/Size(edges)*FLOAT.PI, printRecord!.floatAccuracy ) then
                    Error(Concatenation("Wrong angles for face ", String(f), " given.");
                else
                    continue; # We don't check whether the face closes since this is checked in __SIMPLICIAL_PrintRecordComputeFace
                fi;
            fi;

            # Case triangle
            if Size(edges) = 3 and ForAll(edges, e -> IsBound(lengths[e])) then
                for i in [1,2,3] do
                    # find opposing vertex
                    oppVert := Difference(vertices, VerticesOfEdges(surface)[edges[i]])[1];
                    j := i mod 3 + 1;
                    k := (i+1) mod 3 + 1;
                    cos := Float( (lengths[edges[i]]^2 - lengths[edges[j]]^2 - lengths[edges[k]]^2) / ( -2*lengths[j]*lengths[k] );
                    sin := Sqrt(1 - cos^2);
                    # TODO test validity of edge lengths
                    angles[f][oppVert] := [sin, cos];
                od;
                continue;
            fi;

            # Define everything to be a regular polygon with side length 1
            for e in edges do
                lengths[e] := 1;
            od;
            regAngle := SinCos( (Size(edges) - 2) / Size(edges) * FLOAT.PI );
            for v in vertices do
                angles[v] := regAngle;
            od;
        od;
    end
);

BindGlobal( "__SIMPLICIAL_PrintRecordStartingFace",
    function(rec, surface, unplacedFaces)
        local f;

        # Try to find a starting face in the givenStartingFaces
        for f in rec!.givenStartingFaces do
            if f in unplacedFaces then
                return f;
            fi;
        od;

        # Otherwise return the smallest remaining face
        return Minimum(unplacedFaces);
    end
);

BindGlobal( "__SIMPLICIAL_PrintRecordFindVertex",
    function(printRecord, prVertex)
        local i, pos, compareCoords;

            for i in [1..Length(printRecord!.vertexCoordinates[prVertex[1]])] do
                compareCoords := printRecord!.vertexCoordinates[prVertex[1]][i];
                if __SIMPLICIAL_EqualPoints( compareCoords, prVertex, printRecord!.floatAccuracy ) then
                    pos := i;
                    break;
                fi;
            od;

        return pos;
    end
);

BindGlobal( "__SIMPLICIAL_PrintRecordComputeFirstFace",
    function(printRecord, surface, face)
        local edges;

        edges := EdgesOfFaces(surface)[face];
        len := printRecord!.edgeLengths[edges[1]];
        verts := VerticesOfEdges(surface)[edges[1]];

        # Save those coordinates
        printRecord!.vertexCoordinates[verts[1]] := [ [0.,0.] ];
        printRecord!.vertexCoordinates[verts[2]] := [ [Float(len),0.] ];
        printRecord!.edgeEndpoints[edges[1]] := [ [ verts[1], 1 ], [ verts[2], 2 ] ];
        if not IsBoundaryEdge( surface, edges[1] ) then
            Add(printRecord!.openEdges, edges[1]);
        fi;

        return __SIMPLICIAL_PrintRecordComputeFace( printRecord, surface, face, edges[1] );
    end
);
# The return value of compute face is complicated since we want to perform 
# some checks after the computation but before we save the data.
# 
# It returns a list with two components:
# 1. A list of vertices around the face, stored either as [v, pos] or [v, coord]
# 2. A list of edges around the face (correctly oriented), stored as
#       [e, vertexPair], where vertexPair consists of two vertex-numbers
BindGlobal( "__SIMPLICIAL_PrintRecordComputeFace",
    function(printRecord, surface, face, edge)
        local givenEdge, givenPRVertexFirst, givenPRVertexSecond, 
            returnedVertices, returnedEdges, lastVertex, lastVertexCoord, 
            currentVertex, currentVertexCoord, lastEdge, vector, nextEdge,
            nextVertex, newVector, angle, nextVertexCoords, pos, i, 
            compareCoords;

        givenEdge := edge;
        givenPRVertexFirst := printRecord!.edgeEndpoints[edge[1]][1][1];
        givenPRVertexSecond := printRecord!.edgeEndpoints[edge[1]][1][2];

        returnedVertices := [ givenPRVertexSecond ];
        returnedEdges := [];

        lastVertex := givenPRVertexFirst[1];
        lastVertexCoord := printRecord!.vertexCoordinates[lastVertex][givenPRVertexFirst[2]];
        currentVertex := givenPRVertexSecond[1];
        currentVertexCoord := printRecord!.vertexCoordinates[currentVertex][givenPRVertexSecond[2]];
        lastEdge := givenEdge;

        while Size(returnedVertices) < Size(VerticesOfFaces(surface)[face]) do
            vector := lastVertexCoord - currentVertexCoord;

            nextEdge := OtherEdgeOfVertexInFace( surface, lastVertex, lastEdge, face );
            nextVertex := OtherVertexOfEdge( surface, lastVertex, nextEdge );

            # rescale the vector
            vector := vector * Float( printRecord!.edgeLengths[nextEdge] / printRecord!.edgeLengths[lastEdge] );

            # rotate the vector
            angle := printRecord!.angles[face][lastVertex;
            newVector := [ angle[2]*vector[1]+angle[1]*vector[2], -angle[1]*vector[1]+angle[2]*vector[2] ];

            nextVertexCoords := currentVertexCoord + newVector;

            # Check if this vertex coordinates already appear somewhere
            pos := __SIMPLICIAL_PrintRecordFindVertex( printRecord, [newVertex, nextVertexCoords] );
            if pos = 0 then
                Add( returnedVertices, [nextVertex, nextVertexCoords] );
            else
                Add( returnedVertices, [nextVertex, pos] );
            fi;
            Add( returnedEdges, [ [nextEdge, newVertex, currentVertex] ] );


            lastVertex := currentVertex;
            lastVertexCoord := currentVertexCoord;
            currentVertex := nextVertex;
            currentVertexCoord := nextVertexCoords;
            lastEdge := nextEdge;
        od;

        # Check if the face was closed
        lastVertex := returnedVertices[ Size(returnedVertices) ];
        if lastVertex <> givenPRVertexFirst then
            Error("Face does not close.");
        fi;

        return [returnedVertices, returnedEdges];
    end
);

BindGlobal( "__SIMPLICIAL_PrintRecordAddFace",
    function( printRecord, surface, returnedVertices, returnedEdges, face )
        local vertexPositions, prVertex, pos, prEdge, vertices; 

        # We store the position of the vertex coordinates
        vertexPositions := [];
        for prVertex in returnedVertices do
            if IsPosInt( prVertex[2] ) then
                vertexPositions[prVertex[1]] := prVertex[2];
            else
                # Try to find this vertex
                pos := __SIMPLICIAL_PrintRecordFindVertex( printRecord, prVertex );
                if pos = 0 then
                    # It is new
                    Add( printRecord!.vertexCoordinates[prVertex[1]], prVertex[2] );
                    pos := Size( printRecord!.vertexCoordinates[prVertex[1]] );
                fi;
                vertexPositions[prVertex[1]] := pos;
            fi;
        od;

        # Add the edges
        for prEdge in returnedEdges do
            vertices := List( prEdge[2], v -> [v, vertexPositions[v]] );
            # Check if the edge already exists
            pos := 0;
            for i in [1..Size(printRecord!.edgeEndpoints[prEdge[1]])] do
                if Set( printRecord!.edgeEndpoints[prEdge[1]][i] ) = Set(vertices) then
                    pos := i;
                    printRecord!.openEdges := Difference( printRecord!.openEdges, [prEdge[1]] );
                    break;
                fi;
            od;
            if pos = 0 then
                Add( printRecord!.edgeEndpoints[prEdge[1]], vertices );
                if not IsBoundaryEdge(surface, prEdge[1]) then
                    Add( printRecord!.openEdges, prEdge[1] );
                fi;
            fi;
        od;

        # Add the face
        printRecord!.faceVertices[face] := List( returnedVertices, v -> [ v[1], vertexPositions[v[1]] ] );
    end
);

BindGlobal( "__SIMPLICIAL_PrintRecordNextEdge",
    function( printRecord, rejected )
        #TODO implement more involved methods
        # Naive method that returns the minimum open edge
        return Difference( printRecord!.openEdges, rejected )[1];
    end
);


# We use the answer of
# https://stackoverflow.com/questions/563198/how-do-you-detect-where-two-line-segments-intersect
# to compute the intersection of two line segments
BindGlobal( "__SIMPLICIAL_IntersectingLineSegments",
    function( edgeCoords1, edgeCoords2 )
        local Cross, vtx1, vtx2, det, diff, factor1, factor2, min, max;

        Cross := function( v, w )
            return v[1]*w[2] - v[2]*w[1];
        end;

        # Rewrite the lines into p + t * v
        vtx1 := edgeCoords1[2] - edgeCoords1[1];
        vtx2 := edgeCoords2[2] - edgeCoords2[1];

        # Check first if the lines are parallel
        det := Cross( vtx1, vtx2 );
        diff := edgeCoords2[1] - edgeCoords1[1];
        if __SIMPLICIAL_EqualFloats(det, 0.) then
            # parallel case:
            # We have to check if the lines coincide
            # For that we check if the vector between the two base
            # points is parallel to the line directions
            if not __SIMPLICIAL_EqualFloats( Cross( vtx1, diff ), Float(0)) then
                return false;
            fi;
            
            # Now we know that the associated lines coincide
            # Determine factor1 such that
            # p_2 = p_1 + factor1 * vtx_1
            # and factor2 such that
            # p_2 + vtx_2 = p_1 + factor * vtx_1
            if not __SIMPLICIAL_EqualFloats( vtx1[1], Float(0) ) then
                factor1 := diff[1]/vtx1[1];
                factor2 := factor1 + vtx2[1]/vtx1[1];
            else
                factor1 := diff[2]/vtx1[2];
                factor2 := factor1 + vtx2[2]/vtx1[2];
            fi;
            
            # The segments intersect if the segment between the factors
            # intersects (0,1)
            min := Minimum( factor1, factor2 );
            max := Maximum( factor1, factor2 );
            if min <= Float(0) and max > Float(0) then
                return true;
            elif min > Float(1) and max < Float(1) then
                return true;
            else
                return false;
            fi;
        else
            # the associated lines intersect
            factor1 := Cross( diff, vtx2 ) / det;
            factor2 := Cross( diff, vtx1 ) / det;
            if factor1 < Float(0) or factor1 > Float(1) then
                return false;
            elif factor2 < Float(0) or factor2 > Float(1) then
                return false;
            elif ( __SIMPLICIAL_EqualFloats(factor1,0.) or __SIMPLICIAL_EqualFloats(factor1,1.) )
                and ( __SIMPLICIAL_EqualFloats(factor2,0.) or __SIMPLICIAL_EqualFloats(factor2,1.) ) then
                return false;
            else
                return true;
            fi;
        fi;
    end
);


BindGlobal("__SIMPLICIAL_PrintRecordNoIntersection",
    function( printRecord, surface, vertexData, edgeData, testResults )
        local;

        # If there were intersections before, there are so now
        if testResults[1] = false then
            return testResults;
        fi;

        # Convert the vertexData into a list v -> second entry
        vertexInfo := [];
        for pair in vertexData do
            vertexInfo[pair[1]] := pair[2];
        od;

        # We only have to check if there are new intersections
        # For that reason we store the checked edges in testResults
        cleanEdges := testResults[2];
        for edge in Edges(surface) do
            for edgePos in [1..Size(printRecord!.edgeEndpoints[edge])] do
                if [edge, edgePos] in cleanEdges then
                    continue;
                fi;

                # We have not checked this edge before
                edgeEndpoints := printRecord!.edgeEndpoints[edge][edgePos];
                vertex1 := edgeEndpoints[1];
                vertex2 := edgeEndpoints[2];
                vertex1Coord := printRecord!.vertexCoordinates[ vertex1[1] ][ vertex1[2] ];
                vertex2Coord := printRecord!.vertexCoordinates[ vertex2[1] ][ vertex2[2] ];

                for newEdge in edgeData do
                    newVertex1Name := newEdge[2][1];
                    newVertex2Name := newEdge[2][2];

                    # if vertex(i) = newVertex(j) then position [i][j] = 1
                    correspondenceMatrix := [ [0,0], [0,0] ];

                    #TODO get rid of code duplication
                    if IsPosInt(vertexInfo[newVertex1Name]) then
                        newVertex1Coord := printRecord!.vertexCoordinates[newVertex1Name][vertexInfo[newVertex1Name]];
                        # compare directly with original vertices
                        if vertex1 = [newVertex1Name, vertexInfo[newVertex1Name]] then #TODO can it happen that the new vertex v is identified with the old vertex w??
                            correspondenceMatrix[1][1] := 1;
                        elif vertex2 = [newVertex1Name, vertexInfo[newVertex1Name]] then
                            correspondenceMatrix[2][1] := 1;
                        fi;
                    else
                        # compare coordinates
                        newVertex1Coord := vertexInfo[newVertex1Name];
                        if __SIMPLICIAL_EqualPoints( vertex1Coord, vertexInfo[newVertex1Name], printRecord!.floatAccuracy ) then
                            if newVertex1Name <> vertex1[1] then
                                # Conflict with two different vertices at the same position
                                return [false, cleanEdges];
                            else
                                correspondenceMatrix[1][1] := 1;
                            fi;
                        elif __SIMPLICIAL_EqualPoints( vertex2Coord, vertexInfo[newVertex1Name], printRecord!.floatAccuracy) then
                            if newVertex1Name <> vertex2[1] then
                                return [false, cleanEdges];
                            else
                                correspondenceMatrix[2][1] := 1;
                            fi;
                        fi;
                    fi;

                    if IsPosInt(vertexInfo[newVertex2Name]) then
                        newVertex2Coord := printRecord!.vertexCoordinates[newVertex2Name][vertexInfo[newVertex2Name]];
                        # compare directly with original vertices
                        if vertex1 = [newVertex2Name, vertexInfo[newVertex2Name]] then 
                            correspondenceMatrix[1][2] := 1;
                        elif vertex2 = [newVertex2Name, vertexInfo[newVertex2Name]] then
                            correspondenceMatrix[2][2] := 1;
                        fi;
                    else
                        newVertex2Coord := vertexInfo[newVertex2Name];
                        # compare coordinates
                        if __SIMPLICIAL_EqualPoints( vertex1Coord, vertexInfo[newVertex2Name], printRecord!.floatAccuracy ) then
                            if newVertex2Name <> vertex1[1] then
                                # Conflict with two different vertices at the same position
                                return [false, cleanEdges];
                            else
                                correspondenceMatrix[1][2] := 1;
                            fi;
                        elif __SIMPLICIAL_EqualPoints( vertex2Coord, vertexInfo[newVertex2Name], printRecord!.floatAccuracy) then
                            if newVertex2Name <> vertex2[1] then
                                return [false, cleanEdges];
                            else
                                correspondenceMatrix[2][2] := 1;
                            fi;
                        fi;
                    fi;

                    # We now have constructed a correspondence matrix such that 
                    # in every row and every column there is at most one 1.
                    if Sum(Sum(correspondenceMatrix)) = 2 then
                        # We only have to compare the edge numbers
                        if edge <> newEdge[1] then
                            return [false, cleanEdges];
                        fi;
                    else
                        # Compute the intersection normally
                        if __SIMPLICIAL_IntersectingLineSegments( [vertex1Coord, vertex2Coord], [newVertex1Coord, newVertex2Coord] ) then
                            return [false, cleanEdges];
                        fi;
                    fi;
 
                od;
            od;
            Add( cleanEdges, [edge, edgePos] );
        od;

        return [true, Set(cleanEdges)];
    end
);


BindGlobal("__SIMPLICIAL_PrintRecordGeneralHeader",
    function(printRecord)
        return Concatenation(
            "\\documentclass{article}\n\n",
            "\\usepackage[inner=0.5cm,outer=0.5cm,top=1cm,bottom=0.5cm]{geometry}\n\n",
            "\\pagestyle{empty}\n");
    end
);

BindGlobal( "__SIMPLICIAL_PrintRecordTikzHeader",
    function(printRecord)
        local relPath, gapPath, path, input, content;

        relPath := "doc/TikZHeader.tex";
        gapPath := List( GAPInfo.RootPaths, p -> Concatenation(p, relPath) );
        gapPath := Filtered( gapPath, IsReadableFile );
        for path in gapPath do
            input := InputTextFile( path );
            content := ReadAll(input);
            CloseStream(input);
            return content;
        od;

        Error("Internal Error: doc/TikZHeader.tex not found.");
    end
);

BindGlobal( "__SIMPLICIAL_PrintRecordDrawVertex",
    function( printRecord, surface, vertex, vertexTikzCoord, vertexCoord )
        return "\\vertexLabelR{", vertexTikzCoord, "}{left}{$v_{", vertex, "}$}" 
    end
);

BindGlobal( "__SIMPLICIAL_PrintRecordDrawEdge",
    function( printRecord, surface, edge, vertexTikzCoord, vertexCoord )
        local res;

        res := "";
        Append(res, "\\draw[edge] (", vertexTikzCoord[1], ") -- node[edgeLabel] {$e_{", edge, "}$} (", vertexTikzCoord[2], ");");

        return res;
    end
);

BindGlobal( "__SIMPLICIAL_PrintRecordDrawFace",
    function( printRecord, surface, face, vertexTikzCoord, vertexCoord )
        local res, i;

        res := "";
        Append(res, "\\fill[");
        # Determine if the swap colour is used
        if IsOrientable(surface) and printRecord!.faceVertices[f][2][1]^OrientationByVerticesAsPerm(surface)[face] = printRecord!.faceVertices[f][1][1] then
            Append(res, "faceSwap");
        else
            Append(res, "face");
        fi;
        Append(res, "] ");

        for coord in vertexTikzCoord do
            Append(res, " (", coord, ") --");
        od;
        Append(res, " cycle;\n");
        Append(res, "\\node[faceLabel] at (barycentric cs:");
        for i in [1..Size(vertexTikzCoord)] do
            if i > 1 then
                Append(res, ", ");
            fi;
            Append(res, coord, "=1");
        od;
        Append(res, ") {$f_{", face, "}$};\n" );

        return res;
    end
);

BindGlobal( "__SIMPLICIAL_PrintRecordTikzOptions",
    function(printRecord, surface)
        local res;

        res := "";
        # Add the vertex style
        Append( res, "vertexBall" );
        if printRecord!.vertexLabels = false then
            Append( res, "=nolabels" );
        fi;
        Append( res, ", " );

        # Add the edge style
        Append( res, "edgeDouble" );
        if printRecord!.edgeLabels = false then
            Append( res, "=nolabels" );
        fi;
        Append( res, ", " );

        # Add the face style
        Append( res, "faceStyle" );
        if printRecord!.faceLabels = false then
            Append( res, "=nolabels" );
        fi;
        Append( res, ", " );

        # Scale the picture
        Append( res, "scale=" );
        Append( res, printRecord!.scale );

        return res;
    end
);


# general method
InstallMethod( DrawSurfaceToTikz, 
    "for a polygonal surface, a filename and a record",
    [IsPolygonalSurface, IsString, IsRecord],
    function(surf, fileName, printRecord)
        local file, output;

        # Try to open the given file
        file := Filename( DirectoryCurrent(), fileName ); #TODO allow absolute paths
        output := OutputTextFile( file, false ); # override other files
        if output = fail then
            Error(Concatenation("File ", String(file), " can't be opened.") );
        fi;
        SetPrintFormattingStatus( output, false );


        __SIMPLICIAL_PrintRecordInit(printRecord, surface);
        __SIMPLICIAL_PrintRecordInitializePolygons(printRecord, surface);

        # Start the actual method
        unplacedFaces := Faces(surface);
        strongComponents := [];
        while not IsEmpty(unplacedFaces) do
            # Find the starting face
            start := __SIMPLICIAL_PrintRecordStartingFace( printRecord, surface, unplacedFaces );
            Add( printRecord!.startingFaces, start );
            computedFace := __SIMPLICIAL_PrintRecordComputeFirstFace( printRecord, surface, start );
            __SIMPLICIAL_PrintRecordAddFace(printRecord, surface, computedFace[1], computedFace[2], start);
            unplacedFaces := Difference( unplacedFaces, [start] );

            comp := [start];

            nextFct := [ ["__SIMPLICIAL_PrintRecordNextEdge", infinity] ];
            checkFct := [ "__SIMPLICIAL_PrintRecordNoIntersection" ];
            # This is an infinite loop to extend all edges - bounded from above by the number of edges
            for k in [1..NumberOfEdges(surface)] do
                # Find the next edge
                nextEdge := fail;
                firstEdge := fail; # Fallback if all edges fail some test
                rejected := [];
                repeatData := [];
                for i in [1..Size(nextFct)] do
                    tries := 1;
                    if tries > nextFct[i][2] then
                        continue;
                    fi;
                    proposedEdge := ValueGlobal( nextFct[i][1] )(printRecord, rejected);
                    if firstEdge = fail then
                        firstEdge := proposedEdge;
                    fi;

                    # every edge is used at most once (if there could be ambiguity, the edge has more than 2 incident faces)
                    # for each edge we store
                    # 1) the adjacent face
                    # 2) the computed vertex data
                    # 3) the computed edge data
                    # 4) a list with the results of the checks
                    if IsBound( repeatData[proposedEdge] ) then
                        # Take data from storage
                        adFace := repeatData[proposedEdge][1];
                        vertexData := repeatData[proposedEdge][2];
                        edgeData := repeatData[proposedEdge][3];
                        testResults := repeatData[proposedEdge][4];
                    else
                        adFace := Intersection( FacesOfEdges(surface)[proposedEdge], unplacedFaces )[1];
                        vertexEdgeData := __SIMPLICIAL_PrintRecordComputeFace(printRecord, surface, adFace, proposedEdge);
                        vertexData := vertexEdgeData[1];
                        edgeData := vertexEdgeData[2];
                        testResults := [];
                    fi;

                    # do tests
                    success := true;
                    for j in [1..Size(checkFct)] do
                        if IsBound( testResults[j] ) then
                            # there was a test before
                            testResults[j] := ValueGlobal( checkFaceFct[j] )(printRecord, surface, vertexData, edgeData, testResults[j]);
                        else
                            testResults[j] := ValueGlobal( checkFaceFct[j] )(printRecord, surface, vertexData, edgeData, []);
                        fi;

                        if testResults[j][1] = false then
                            success := false;
                            break;
                        fi;
                    od;
                
                    # Store data since it is either needed to avoid recomputation or to continue
                    repeatData[proposedEdge] := [ adFace, vertexData, edgeData, testResults ];

                    if not success then
                        Add(rejected, proposedEdge);
                        proposedEdge := fail;
                        continue;
                    else
                        nextEdge := proposedEdge;
                        break;
                    fi;
                od;
                if proposedEdge = fail then
                    # take the first edge instead
                    proposedEdge = firstEdge;
                fi;

                # if there is no edge at all, we are done
                if firstEdge = fail then
                    Add( strongComponents, comp );
                    break;
                fi;

    
                # Add the new face
                __SIMPLICIAL_PrintRecordAddFace( printRecord, surface, repeatData[proposedEdge][2], repeatData[proposedEdge][3] );
                Add( comp, repeatData[proposedEdge][1] );
            od;
        od;

        # Set the strongly connected components (if not already done)
        if not HasStronglyConnectedComponents( surface ) then
            SetStronglyConnectedComponents( surface, List( strongComponents, c -> SubsurfaceByFacesNC(surface, c) ) );
        fi;

        # Write this data into the file
        AppendTo( output, __SIMPLICIAL_PrintRecordGeneralHeader(printRecord) );
        AppendTo( output, __SIMPLICIAL_PrintRecordTikzHeader(printRecord) );
        AppendTo( output, "\\begin{document}\n\n" );
        
        if IsBound(printRecord!.caption) then
          AppendTo( output,
          "\\subsection*{", printRecord!.caption, "}\n \\bigskip\n");
        fi;
        
        TikzCoordFromVertexPosition := function( vertPos )
            return Concatenation( "V", vertPos[1], "_", vertPos[2], "" );
        end;
        allVertexCoords := printRecord!.vertexCoordinates;
        for comp in StronglyConnectedComponents(surface) do
            # Start the picture
            AppendTo( output, "\n\\begin{tikzpicture}[", __SIMPLICIAL_PrintRecordTikzOptions(printRecord, comp), "]\n" );

            # Define coordinates of vertices
            for v in Vertices(comp) do
                for i in [1..Size(vertexCoords)] do
                    AppendTo( output, "\\coordinate (", TikzCoordFromVertexPosition([v,i]), ") at (", allVertexCoords[v][i][1], ", ", allVertexCoords[v][i][2], ");\n" );
                od;
            od;
            AppendTo(output, "\n\n");

            # Draw faces
            for f in Faces(comp) do
                facePath := EvaluateFunctionList( facePerimeterFct, [printRecord, surface, f] );
                vertexPositions := List( [1..Size(facePath)/2], i -> facePath[2*i-1] );
                AppendTo( output, __SIMPLICIAL_PrintRecordDrawFace(printRecord, surface, f, 
                    List(vertexPositions, TikzCoordFromVertexPosition), List(vertexPositions, p -> allVertexCoords[p[1]][p[2]])) );
            od;

            AppendTo( output, "\n\n" );
            # Draw edges
            for e in Edges(comp) do
                ends := EvaluateFunctionList( edgeEndpointsFct, [printRecord, surface, e] );
                for i in [1..Size(ends)] do
                    AppendTo( output, __SIMPLICIAL_PrintRecordDrawEdge( printRecord, surface, e,
                        List( ends[i], TikzCoordFromVertexPosition ),
                        List( ends[i], p -> allVertexCoords[p[1]][p[2]] ) ) );
                od;
            od;

            AppendTo( output, "\n\n" );
            # Draw vertices
            for v in Vertices(comp) do
                positions := allVertexCoords[v];
                for i in [1..Size(positions)] do
                    AppendTo( output, __SIMPLICIAL_PrintRecordDrawVertex( printRecord, surface, v, TikzCoordFromVertexPosition([v,i]), allVertexCoords[v][i] ));
                od;
            od;
            

            # End the picture
            AppendTo( output, "\n\\end{tikzpicture}" );
        od;
        AppendTo( output, "\n\\end{document}\n");
        CloseStream(output);
        Print( "Picture written in TikZ." );


        if record.compileLaTeX then
            Print( "Start LaTeX-compilation.\n" );

            # Run pdfLaTeX on the file (without visible output)
            Exec( "pdflatex ", name, " > /dev/null" );
            Print( "Picture rendered (with pdflatex).\n");
        fi;



        # Clean up the record
        for i in cleanFct do
            ValueGlobal(i)(printRecord);
        od;

        return printRecord;
    end
);


