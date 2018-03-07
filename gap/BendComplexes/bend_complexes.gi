DeclareRepresentation( "IsBendPolygonalComplexRep", IsBendPolygonalComplex and IsAttributeStoringRep and IsComponentObjectRep, ["localEdgeOrientation"] );

BendPolygonalComplexType := NewType( BendPolygonalComplexFamily, IsBendPolygonalComplexRep );

# The primary components are
# attribute VertexMaps
# attribute EdgeMaps
# component localEdgeOrientation
InstallMethod( BendPolygonalComplex, "for three lists",
    [IsList, IsList, IsList],
    function( vertexMaps, edgeMaps, localEdgeOrientation )
        local obj;
        # TODO checks

        obj := Objectify( BendPolygonalComplexType, rec( localEdgeOrientation:=localEdgeOrientation ) );
        SetVertexMaps(obj, vertexMaps);
        SetEdgeMaps(obj, edgeMaps);

        return obj;
    end
);
InstallMethod( BendPolygonalComplex, "for a polygonal complex",
    [IsPolygonalComplex],
    function( complex )
        local perims, vertexMaps, i, edgeMaps, localEdgeOr, f, e, incFaces,
            incVerts, nextFace;

        # The order in PerimeterOfFaces defines the default orientation for each face
        perims := PerimetersOfFaces( complex );
        vertexMaps := List( perims, p -> ShallowCopy( VerticesAsList( p ) ) );
        for i in Faces(complex) do
            Remove(vertexMaps[i]);
        od;

        edgeMaps := List( perims, EdgesAsList );
    
        # Define local edge orientations
        localEdgeOr := [];
        for f in Faces(complex) do
            localEdgeOr[f] := [];
        od;
        for e in Edges(complex) do
            incFaces := FacesOfEdges(complex)[e];
            incVerts := VerticesOfEdges(complex)[e];
            # +1 if VertAsPerm maps #1 to #2 
            for i in [1..Length(incFaces)] do
                nextFace := incFaces[i];
                if incVerts[1]^VerticesAsPerm(perims[nextFace]) = incVerts[2] then
                    localEdgeOr[nextFace][Position(edgeMaps[nextFace],e)] := 1;
                else
                    localEdgeOr[nextFace][Position(edgeMaps[nextFace],e)] := -1;
                fi;
            od;
        od;
         return BendPolygonalComplex(vertexMaps, edgeMaps, localEdgeOr);
    end
);



# TODO properly install with attribute scheduler

##
## FaceSizes
##
InstallMethod( FaceSizes, "for a bend polygonal complex with VertexMaps", 
    [IsBendPolygonalComplex and HasVertexMaps],
    function( complex )
        return List( VertexMaps(complex), Length );
    end
);
InstallMethod( FaceSizes, "for a bend polygonal complex with EdgeMaps", 
    [IsBendPolygonalComplex and HasEdgeMaps],
    function( complex )
        return List( EdgeMaps(complex), Length );
    end
);


##
## Vertices, Edges and Faces
InstallMethod( VerticesAttributeOfBendPolygonalComplex, 
    "for a bend polygonal complex with VertexMaps",
    [IsBendPolygonalComplex and HasVertexMaps],
    function( complex )
        return __SIMPLICIAL_UnionSets( VertexMaps(complex) );
    end
);
InstallMethod( Edges,
    "for a bend polygonal complex with EdgeMaps",
    [IsBendPolygonalComplex and HasEdgeMaps],
    function( complex )
        return __SIMPLICIAL_UnionSets( EdgeMaps(complex) );
    end
);
InstallMethod( Faces,
    "for a bend polygonal complex with VertexMaps",
    [IsBendPolygonalComplex and HasVertexMaps],
    function( complex )
        return __SIMPLICIAL_BoundPositions( VertexMaps(complex) );
    end
);
InstallMethod( Faces,
    "for a bend polygonal complex with EdgeMaps",
    [IsBendPolygonalComplex and HasEdgeMaps],
    function( complex )
        return __SIMPLICIAL_BoundPositions( EdgeMaps(complex) );
    end
);


InstallMethod( IsRigidFaced, "for a bend polygonal complex",
    [IsBendPolygonalComplex],
    function(complex)
        return ForAll( Faces(complex), f -> 
            Length(Set(VertexMaps(complex)[f])) = FaceSizes(complex)[f] and 
            Length(Set(EdgeMaps(complex)[f])) = FaceSizes(complex)[f] );
    end
);


##
## General stuff
##
InstallMethod( LocalEdgeRelation, 
    "for a bend polygonal complex and two face-edge flags",
    [IsBendPolygonalComplex, IsList, IsList],
    function(complex, feFlag1, feFlag2)
        if EdgeMaps(complex)[feFlag1[1]][feFlag1[2]] <> EdgeMaps(complex)[feFlag2[1]][feFlag2[2]] then
            return fail;
        fi;

        return complex!.localEdgeOrientation[feFlag1[1]][feFlag1[2]] * 
            complex!.localEdgeOrientation[feFlag2[2]][feFlag2[2]];
    end
);
InstallMethod( LocalEdgeRelation, 
    "for a bend polygonal complex with edge signs and two face-edge flags",
    [IsBendPolygonalComplex and HasEdgeSigns, IsList, IsList],
    function(complex, feFlag1, feFlag2)
        if EdgeMaps(complex)[feFlag1[1]][feFlag1[2]] <> EdgeMaps(complex)[feFlag2[1]][feFlag2[2]] then
            return fail;
        fi;

        return EdgeSigns(complex)[EdgeMaps(complex)[feFlag1[1]][feFlag1[2]]];
    end
);


InstallMethod( SourceOfLocalEdge, "for a local edge and a face size",
    [IsPosInt, IsPosInt],
    function(edgeNr, faceSize)
        return edgeNr;
    end
);
InstallMethod( TargetOfLocalEdge, "for a local edge and a face size",
    [IsPosInt, IsPosInt],
    function(edgeNr, faceSize)
        if edgeNr = faceSize then
            return 1;
        else
            return edgeNr + 1;
        fi;
    end
);


#######################################
##  Later obsolete stuff
##
InstallMethod( Vertices, "for a bend polygonal complex", 
    [IsBendPolygonalComplex],
    function( complex )
        return VerticesAttributeOfBendPolygonalComplex(complex);
    end
);

InstallMethod(PolygonalComplex, "for a face-rigid bend polygonal complex", 
    [IsBendPolygonalComplex and IsRigidFaced],
    function(complex)
        local vertsOfEdges, edgesOfFaces, f, localVerts, localEdges, i,
            edge, verts;

        edgesOfFaces := List( EdgeMaps(complex), Set );
        vertsOfEdges := [];
        for f in Faces(complex) do
            localVerts := VertexMaps(complex)[f];
            localEdges := EdgeMaps(complex)[f];
            for i in [1..Length(localEdges)] do
                edge := localEdges[i];
                if i = FaceSizes(complex)[f] then
                    verts := [ localVerts[1], localVerts[i] ];
                else
                    verts := [ localVerts[i], localVerts[i+1] ];
                fi;
                if not IsBound( vertsOfEdges[edge] ) then
                    vertsOfEdges[edge] := Set(verts);
                fi;
            od;
        od;
     
        return PolygonalComplexByDownwardIncidence( vertsOfEdges, edgesOfFaces );
    end
);
RedispatchOnCondition( PolygonalComplex, true, [IsBendPolygonalComplex], [IsRigidFaced], 0 );
