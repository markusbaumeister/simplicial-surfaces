
# Bend polygonal complexes are their own category
#TODO derive IsPolygonalComplex from this
DeclareCategory( "IsBendPolygonalComplex", IsObject );
BindGlobal( "BendPolygonalComplexFamily", 
    NewFamily( "BendPolygonalComplexFamily", IsObject, IsBendPolygonalComplex ));

# For each face: number of internal vertices (which kind of polygon?)
DeclareAttribute( "FaceSizes", IsBendPolygonalComplex );

# For each face: For each internal vertex: image in vertex set
DeclareAttribute( "VertexMaps", IsBendPolygonalComplex );

# For each face: For each internal edge: image in edge set
DeclareAttribute( "EdgeMaps", IsBendPolygonalComplex );

# Proto-constructor (VertexMaps, EdgeMaps, localEdgeOrientation);
DeclareOperation( "BendPolygonalComplex", [IsList, IsList, IsList] );
# Default constructor from a polygonal complex
DeclareOperation( "BendPolygonalComplex", [IsPolygonalComplex] );

# Check whether the bend polygonal complex is a polygonal complex
DeclareProperty( "IsRigidFaced", IsBendPolygonalComplex );

# Return a set of all rigid faces
DeclareAttribute( "RigidFaces", IsBendPolygonalComplex );

# Return a set of all bend faces
DeclareAttribute( "BendFaces", IsBendPolygonalComplex );

###################
## These attributes are here for development purposes:
DeclareAttribute( "VerticesAttributeOfBendPolygonalComplex", IsBendPolygonalComplex );
DeclareOperation( "Vertices", [IsBendPolygonalComplex] );
DeclareAttribute( "Edges", IsBendPolygonalComplex );
DeclareAttribute( "Faces", IsBendPolygonalComplex );

DeclareProperty( "IsRamifiedSurface", IsBendPolygonalComplex );
DeclareProperty( "IsSurface", IsBendPolygonalComplex );
InstallTrueMethod( IsRamifiedSurface, IsSurface );

DeclareAttribute( "PolygonalComplex", IsBendPolygonalComplex );
###################

# For each edge: How are the two adjacent faces connected?
DeclareAttribute( "EdgeSigns", IsBendPolygonalComplex and IsRamifiedSurface );
# For two [face, localEdge]-s return +1 or -1 (how are those two relatively oriented)
DeclareOperation( "LocalEdgeRelation", [IsBendPolygonalComplex, IsList, IsList] );

# Return the source of local edge #1 in a polygon of size #2
DeclareOperation( "SourceOfLocalEdge", [IsPosInt, IsPosInt] );

# Return the target of local edge #1 in a polygon of size #2
DeclareOperation( "TargetOfLocalEdge", [IsPosInt, IsPosInt] );

