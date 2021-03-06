#############################################################################
##
##  SimplicialSurface package
##
##  Copyright 2012-2018
##    Markus Baumeister, RWTH Aachen University
##    Alice Niemeyer, RWTH Aachen University 
##
## Licensed under the GPL 3 or later.
##
#############################################################################


#! @Chapter Paths and orientations
#! @ChapterLabel Paths
#!
#! In sections 
#! <Ref Sect="Section_Access_OrderedFaceAccess"/> and 
#! <Ref Sect="Section_Access_OrderedVertexAccess"/> the concepts of 
#! vertex-edge-paths and 
#! edge-face-paths were introduced. This chapter documents which methods
#! are available for these paths (in sections 
#! <Ref Sect="Section_Paths_VertexEdge"/> and 
#! <Ref Sect="Section_Paths_EdgeFace"/>). Then it
#! discusses applications of these paths, namely connectivity 
#! (<Ref Sect="Section_Paths_Connectivity"/>) and
#! orientability (<Ref Sect="Section_Orientability"/>).


#! @Section Vertex-Edge-Paths
#! @SectionLabel Paths_VertexEdge
#!
#! This section describes all methods for vertex-edge-paths. Intuitively,
#! vertex-edge-paths describe all paths that are realized by walking only on
#! the vertices and edges of a (bend) polygonal complex.
#!
#! We will illustrate several properties with vertex-edge-paths that are
#! defined on this simplicial surface:
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle,edgePlain,faceStyle]
#!     \input{Image_SixTrianglesInCycle.tex}
#!   \end{tikzpicture}
#! </Alt>
#! @ExampleSession
#! gap> hex := SimplicialSurfaceByDownwardIncidence( 
#! >      [ [1,7],[2,7],[3,7],[4,7],[5,7],[6,7],[1,2],[2,3],[3,4],[4,5],[5,6],[1,6] ],
#! >      [ [1,2,7],[2,3,8],[3,4,9],[4,5,10],[5,6,11],[1,6,12] ]);;
#! @EndExampleSession

#! @BeginChunk Definition_VertexEdgePath
#! A <E>vertex-edge-path</E> in a VEF-complex is a tuple
#! <M>(v_1, e_1, v_2, e_2, \ldots ,v_n, e_n, v_{{n+1}})</M> such that
#! * The <M>v_i</M> are vertices of the polygonal complex
#! * The <M>e_j</M> are edges of the polygonal complex
#! * For the edge <M>e_j</M> the set of incident vertices is <M>\{v_j,v_{{j+1}}\}</M>
#! @EndChunk

#! <ManSection Label="VertexEdgePath">
#!   <Oper Name="VertexEdgePath" Arg="complex, path" 
#!      Label="for IsVEFComplex and IsDenseList"
#!      Comm="Construct a vertex-edge-path from a VEF-complex and a list"/>
#!   <Oper Name="VertexEdgePathNC" Arg="complex, path" 
#!      Label="for IsVEFComplex and IsDenseList"
#!      Comm="Construct a vertex-edge-path from a VEF-complex and a list"/>
#!   <Returns>A VertexEdgePath-&GAP;-object</Returns>
#!   <Filt Name="IsVertexEdgePath" Arg="object" Label="for IsObject" Type="category"
#!      Comm="Check whether a given object is a VertexEdgePath"/>
#!   <Returns><K>true</K> or <K>false</K></Returns>
#!   <Description>
#!     The method <K>VertexEdgePath</K> constructs a new vertex-edge-path from
#!     a VEF-complex and a dense list of positive integers (alternating
#!     vertices and edges). The
#!     method <K>IsVertexEdgePath</K> checks if a given &GAP;-object
#!     represents such a path.
#!
#!     We illustrate this with two paths on the simplicial surface that was
#!     introduced at the start of section 
#!     <Ref Sect="Section_Paths_VertexEdge"/>.
#!     <Alt Only="TikZ">
#!       \input{Image_SixTriangles_AlphaAndOmega.tex}
#!     </Alt>
#!     @ExampleSession
#! gap> alphaPath := VertexEdgePath(hex, [2,2,7,5,5,10,4,9,3,3,7,6,6]);
#! | v2, E2, v7, E5, v5, E10, v4, E9, v3, E3, v7, E6, v6 |
#! gap> omegaPath := VertexEdgePath(hex, [3,9,4,10,5,5,7,6,6,12,1,7,2]);
#! | v3, E9, v4, E10, v5, E5, v7, E6, v6, E12, v1, E7, v2 |
#!     @EndExampleSession
#!
#!     @InsertChunk Definition_VertexEdgePath
#!
#!     <Alt Only="TikZ">
#!       \input{Image_SixTriangles_CircleAndClover.tex}
#!     </Alt>
#!     @ExampleSession
#! gap> circlePath := VertexEdgePath( hex, [1,7,2,8,3,9,4,10,5,11,6,12,1] );
#! ( v1, E7, v2, E8, v3, E9, v4, E10, v5, E11, v6, E12, v1 )
#! gap> cloverPath := VertexEdgePath( hex, [1,7,2,2,7,5,5,11,6,6,7,3,3,9,4,4,7,1,1] );
#! ( v1, E7, v2, E2, v7, E5, v5, E11, v6, E6, v7, E3, v3, E9, v4, E4, v7, E1, v1 )
#!     @EndExampleSession
#!
#!     The elements of a vertex-edge-path can be accessed by using the methods
#!     <K>PathAsList</K> (<Ref Subsect="VertexEdge_PathAsList"/>), 
#!     <K>VerticesAsList</K> (<Ref Subsect="VertexEdge_VerticesAsList"/>) and 
#!     <K>EdgesAsList</K> (<Ref Subsect="VertexEdge_EdgesAsList"/>).
#!
#!     Some shorter (but more ambigous) constructors are 
#!     <K>VertexEdgePathByVertices</K> 
#!     (<Ref Subsect="VertexEdgePathByVertices"/>) and
#!     <K>VertexEdgePathByEdges</K> (<Ref Subsect="VertexEdgePathByEdges"/>).
#!
#!     The NC-version does not check if the
#!     given <A>path</A> is a list 
#!     <M>[v_1,e_1,v_2,e_2,\ldots,v_n,e_n,v_{{n+1}}]</M> that fulfills these
#!     conditions.
#!   </Description>
#! </ManSection>
# No AutoDoc-documentation since the order of the next two entries should
# be switched
DeclareOperation( "VertexEdgePath", [IsVEFComplex, IsDenseList] );
DeclareOperation( "VertexEdgePathNC", [IsVEFComplex, IsDenseList] );


#! @BeginGroup VertexEdgePathByVertices
#! @Description
#! Construct a new vertex-edge-path (<Ref Subsect="VertexEdgePath"/>) from a
#! VEF-complex and a dense list of vertices. Every two adjacent vertices
#! have to be connected by an edge. If there are multiple such edges, the one
#! with the smallest label is used. If the given <A>vertexList</A> is empty,
#! <K>fail</K> is returned.
#!
#! With this the paths from <Ref Subsect="VertexEdgePath"/> can be defined
#! more compactly:
#! @BeginExampleSession
#! gap> newAlpha := VertexEdgePathByVertices( hex, [2,7,5,4,3,7,6] );
#! | v2, E2, v7, E5, v5, E10, v4, E9, v3, E3, v7, E6, v6 |
#! gap> alphaPath = newAlpha;
#! true
#! gap> newOmega := VertexEdgePathByVertices( hex, [3,4,5,7,6,1,2] );
#! | v3, E9, v4, E10, v5, E5, v7, E6, v6, E12, v1, E7, v2 |
#! gap> omegaPath = newOmega;
#! true
#! @EndExampleSession
#!     <Alt Only="TikZ">
#!       \input{Image_SixTriangles_AlphaAndOmega.tex}
#!     </Alt>
#! 
#! An example of the ambiguous nature is this triangular complex:
#! <Alt Only="TikZ">
#!   {
#!     \def\open{1}
#!     \input{Image_Eye_OpenClosed.tex}
#!   }
#! </Alt>
#! @BeginExampleSession
#! gap> eye := TriangularComplexByDownwardIncidence(
#! >            [[1,2],[2,3],[1,3],[2,4],[3,4],[2,3]], [[1,2,3],[4,5,6]]);;
#! gap> VertexEdgePathByVertices( eye, [1,2,3,4] );
#! | v1, E1, v2, E2, v3, E5, v4 |
#! gap> VertexEdgePathByVertices( eye, [2,3,2] );
#! ( v2, E2, v3, E2, v2 )
#! @EndExampleSession
#!
#! The NC-version does not check whether the given <A>vertexList</A> consists
#! of vertices in <A>complex</A> and whether every two adjacent vertices are
#! connected by an edge.
#!
#! @Returns a vertex-edge-path or <K>fail</K>
#! @Arguments complex, vertexList
DeclareOperation( "VertexEdgePathByVertices", [IsVEFComplex, IsDenseList] );
#! @Arguments complex, vertexList
DeclareOperation( "VertexEdgePathByVerticesNC", [IsVEFComplex, IsDenseList] );
#! @EndGroup


#! @BeginGroup VertexEdgePathByEdges
#! @Description
#! Construct a new vertex-edge-path (<Ref Subsect="VertexEdgePath"/>) from a
#! VEF-complex and a dense list of edges. Every two adjacent edges
#! have to be connected by a vertex. If any vertex position is ambigous (for
#! example if only one edge is given), the smallest possible vertex is chosen
#! to be traversed first.
#!
#! With this the paths from <Ref Subsect="VertexEdgePath"/> can be defined
#! more compactly:
#! @BeginExampleSession
#! gap> newAlpha := VertexEdgePathByEdges( hex, [2,5,10,9,3,6] );
#! | v2, E2, v7, E5, v5, E10, v4, E9, v3, E3, v7, E6, v6 |
#! gap> alphaPath = newAlpha;
#! true
#! gap> newOmega := VertexEdgePathByEdges( hex, [9,10,5,6,12,7] );
#! | v3, E9, v4, E10, v5, E5, v7, E6, v6, E12, v1, E7, v2 |
#! gap> omegaPath = newOmega;
#! true
#! @EndExampleSession
#!     <Alt Only="TikZ">
#!       \input{Image_SixTriangles_AlphaAndOmega.tex}
#!     </Alt>
#! 
#! An example of the ambiguous nature is this triangular complex:
#! <Alt Only="TikZ">
#!   {
#!     \def\open{1}
#!     \input{Image_Eye_OpenClosed.tex}
#!   }
#! </Alt>
#! @BeginExampleSession
#! gap> eye := TriangularComplexByDownwardIncidence(
#! >            [[1,2],[2,3],[1,3],[2,4],[3,4],[2,3]], [[1,2,3],[4,5,6]]);;
#! gap> VertexEdgePathByEdges( eye, [2] );
#! | v2, E2, v3 |
#! gap> VertexEdgePathByEdges( eye, [2,6] );
#! ( v2, E2, v3, E6, v2 )
#! @EndExampleSession
#!
#! The NC-version does not check whether the given <A>edgeList</A> consists
#! of edges in <A>complex</A>.
#!
#! @Returns a vertex-edge-path
#! @Arguments complex, edgeList
DeclareOperation( "VertexEdgePathByEdges", [IsVEFComplex, IsDenseList] );
#! @Arguments complex, edgeList
DeclareOperation( "VertexEdgePathByEdgesNC", [IsVEFComplex, IsDenseList] );
#! @EndGroup


#! @BeginGroup VertexEdge_PathAsList
#! @Description
#!   Return the complete vertex-edge-path as a list (with vertices and
#!   edges alternating), starting with a vertex.
#!   
#!   For the examples from <K>VertexEdgePath</K> 
#!   (<Ref Subsect="VertexEdgePath"/>) in the simplicial surface from the 
#!   start of section <Ref Sect="Section_Paths_VertexEdge"/>:
#!   @ExampleSession
#! gap> PathAsList( alphaPath );
#! [ 2, 2, 7, 5, 5, 10, 4, 9, 3, 3, 7, 6, 6 ]
#! gap> PathAsList( omegaPath );
#! [ 3, 9, 4, 10, 5, 5, 7, 6, 6, 12, 1, 7, 2 ]
#! gap> PathAsList( circlePath );
#! [ 1, 7, 2, 8, 3, 9, 4, 10, 5, 11, 6, 12, 1 ]
#! gap> PathAsList( cloverPath );
#! [ 1, 7, 2, 2, 7, 5, 5, 11, 6, 6, 7, 3, 3, 9, 4, 4, 7, 1, 1 ]
#!   @EndExampleSession
#TODO should we execute the original paths again?
#! @Arguments vertexEdgePath
#! @Returns a list of positive integers
DeclareAttribute( "PathAsList", IsVertexEdgePath );
#! @EndGroup

#! @BeginGroup VertexEdge_VerticesAsList
#! @Description
#!   Return the vertices of the vertex-edge-path as a list.
#!
#!   For the examples from <K>VertexEdgePath</K> 
#!   (<Ref Subsect="VertexEdgePath"/>) in the simplicial surface from the 
#!   start of section <Ref Sect="Section_Paths_VertexEdge"/>:
#!   @ExampleSession
#! gap> VerticesAsList( alphaPath );
#! [ 2, 7, 5, 4, 3, 7, 6 ]
#! gap> VerticesAsList( omegaPath );
#! [ 3, 4, 5, 7, 6, 1, 2 ]
#! gap> VerticesAsList( circlePath );
#! [ 1, 2, 3, 4, 5, 6, 1 ]
#! gap> VerticesAsList( cloverPath );
#! [ 1, 2, 7, 5, 6, 7, 3, 4, 7, 1 ]
#!   @EndExampleSession
#! @Arguments vertexEdgePath
#! @Returns a list of positive integers
DeclareAttribute( "VerticesAsList", IsVertexEdgePath );
#! @EndGroup

#! @BeginGroup VertexEdge_EdgesAsList
#! @Description
#!     Return the edges of the vertex-edge-path as a list.
#!
#!   For the examples from <K>VertexEdgePath</K> 
#!   (<Ref Subsect="VertexEdgePath"/>) in the simplicial surface from the 
#!   start of section <Ref Sect="Section_Paths_VertexEdge"/>:
#!   @ExampleSession
#! gap> EdgesAsList( alphaPath );
#! [ 2, 5, 10, 9, 3, 6 ]
#! gap> EdgesAsList( omegaPath );
#! [ 9, 10, 5, 6, 12, 7 ]
#! gap> EdgesAsList( circlePath );
#! [ 7, 8, 9, 10, 11, 12 ]
#! gap> EdgesAsList( cloverPath );
#! [ 7, 2, 5, 11, 6, 3, 9, 4, 1 ]
#!   @EndExampleSession
#! @Arguments vertexEdgePath
#! @Returns a list of positive integers
DeclareAttribute( "EdgesAsList", IsVertexEdgePath );
#! @EndGroup


#! <ManSection Label="VertexEdge_IsClosedPath">
#!   <Prop Name="IsClosedPath" Arg="vertexEdgePath"
#!     Label="for IsVertexEdgePath"
#!     Comm="Return whether the given path is closed"/>
#!   <Returns><K>true</K> or <K>false</K></Returns>
#!   <Description>
#!     Check whether the given vertex-edge-path is closed, i.e. whether
#!     the first and last vertex in this path are equal.
#!
#!     From the example paths (introduced in 
#!     <Ref Subsect="VertexEdgePath"/> (<K>VertexEdgePath</K>)) only two
#!     are closed:
#!     @ExampleSession
#! gap> IsClosedPath( alphaPath );
#! false
#! gap> IsClosedPath( omegaPath );
#! false
#! gap> IsClosedPath( circlePath );
#! true
#! gap> IsClosedPath( cloverPath );
#! true
#!     @EndExampleSession
#!     <Alt Only="TikZ">
#!       \input{Image_SixTriangles_CircleAndClover.tex}
#!     </Alt>
#!   </Description>
#! </ManSection>
# This is documentation for a declaration in dual_path.gd

#! @Description
#! Return the inverse vertex-edge-path to the given path.
#!
#! TODO example
#!
#! @Arguments vertexEdgePath
#! @Returns a vertex-edge-path
DeclareAttribute( "Inverse", IsVertexEdgePath );


#! <ManSection Label="VertexEdge_IsDuplicateFree">
#!   <Prop Name="IsDuplicateFree" Arg="vertexEdgePath"
#!     Label="for IsVertexEdgePath"
#!     Comm="Return whether the given path is duplicate-free"/>
#!   <Returns><K>true</K> or <K>false</K></Returns>
#!   <Description>
#!     Check whether the given vertex-edge-path is duplicate-free.
#!
#!     A vertex-edge-path is duplicate-free if no vertices or edges
#!     appear twice in it - with one exception: if the path is closed
#!     (see <Ref Subsect="VertexEdge_IsClosedPath"/>) it does not matter that the
#!     first and last vertex are the same.
#!
#!     From the example paths (introduced in 
#!     <Ref Subsect="VertexEdgePath"/> (<K>VertexEdgePath</K>)) only two
#!     are duplicate-free:
#!     @ExampleSession
#! gap> IsDuplicateFree( alphaPath );
#! false
#! gap> IsDuplicateFree( omegaPath );
#! true
#! gap> IsDuplicateFree( circlePath );
#! true
#! gap> IsDuplicateFree( cloverPath );
#! false
#!     @EndExampleSession
#!     <Alt Only="TikZ">
#!       \input{Image_SixTriangles_CircleAndOmega.tex}
#!     </Alt>
#!   </Description>
#! </ManSection>
# This is documentation for a declaration in dual_path.gd


#! @BeginGroup VertexEdge_VerticesAsPerm
#! @Description
#!     If a vertex-edge-path is closed and duplicate-free, it induces
#!     a cyclic permutation on its vertices. This method returns that
#!     permutation.
#! 
#!     We illustrate this with
#!     the circle path from <K>VertexEdgePath</K> 
#!     (<Ref Sect="VertexEdgePath"/>).
#!     <Alt Only="TikZ">
#!       \input{Image_SixTriangles_Circle.tex}
#!     </Alt>
#!     @ExampleSession
#! gap> circlePath;
#! ( v1, E7, v2, E8, v3, E9, v4, E10, v5, E11, v6, E12, v1 )
#! gap> VerticesAsPerm(circlePath);
#! (1,2,3,4,5,6)
#!     @EndExampleSession
#! @Arguments vertexEdgePath
#! @Returns a permutation
DeclareAttribute( "VerticesAsPerm", IsVertexEdgePath );
#! @EndGroup


#! @BeginGroup VertexEdge_EdgesAsPerm
#! @Description
#!     If a vertex-edge-path is closed and duplicate-free, it induces
#!     a cyclic permutation on its edges. This method returns that
#!     permutation.
#!
#!     We illustrate this with
#!     the circle path from <K>VertexEdgePath</K> 
#!     (<Ref Sect="VertexEdgePath"/>).
#!     <Alt Only="TikZ">
#!       \input{Image_SixTriangles_Circle.tex}
#!     </Alt>
#!     @ExampleSession
#! gap> circlePath;
#! ( v1, E7, v2, E8, v3, E9, v4, E10, v5, E11, v6, E12, v1 )
#! gap> EdgesAsPerm(circlePath);
#! (7,8,9,10,11,12)
#!     @EndExampleSession
#! @Arguments vertexEdgePath
#! @Returns a permutation
DeclareAttribute( "EdgesAsPerm", IsVertexEdgePath );
#! @EndGroup


#! @BeginGroup
#! @Description
#! Return the VEF-complex for which the given vertex-edge-path is
#! defined.
#!
#! @Returns a VEF-complex
#! @Arguments vertexEdgePath
DeclareAttribute( "AssociatedVEFComplex", IsVertexEdgePath );
#! @EndGroup


#! @Description
#! Return whether the given vertex-edge-path is defined on a
#! polygonal complex.
#!
#! @Arguments vertexEdgePath
DeclareProperty( "IsPolygonalComplexPath", IsVertexEdgePath );

#! @Description
#! Return whether the given vertex-edge-path is defined on a
#! bend polygonal complex.
#!
#! @Arguments vertexEdgePath
DeclareProperty( "IsBendPolygonalComplexPath", IsVertexEdgePath );



##
## Coloured output-attributes
DeclareAttribute( "ViewInformation", IsVertexEdgePath );

#! @Section Perimeter paths
#! @SectionLabel Paths_Perimeter
#!
#! This section describes <E>perimeter paths</E>, which are special
#! vertex-edge-paths that additionally store the face which they
#! encircle. They are returned by
#! methods like <K>PerimeterPathsOfFaces</K> 
#! (<Ref Subsect="PerimeterPathsOfFaces"/>) and <K>Orientation</K>
#! (<Ref Subsect="Orientation"/>).
#!
#! Mathematically, a perimerter path is a closed vertex-edge-path that
#! encircles a face. For example, consider the tetrahedron
#! (<Ref Subsect="Tetrahedron"/>):
#! <Alt Only="TikZ">
#!    \input{_TIKZ_Tetrahedron_constructor.tex}
#! </Alt>
#! @BeginExampleSession
#! gap> tet := Tetrahedron();;
#! gap> PerimeterPathOfFace(tet, 1);
#! ( v1, E1, v2, E4, v3, E2, v1 )
#! gap> EdgesOfFace(tet, 1);
#! [ 1, 2, 4 ]
#! gap> VerticesOfFace(tet, 1);
#! [ 1, 2, 3 ]
#! @EndExampleSession
#!
#! Additionally, given a perimeter path, we sometimes need to access
#! the face it encircles. For most surfaces this is unproblematic,
#! but there are some exceptions, like the Janus-head
#! (<Ref Subsect="JanusHead"/>). For this reason, the attribute
#! <K>Face</K> (<Ref Subsect="PerimeterPath_Face"/>) was introduced.
#! <Alt Only="TikZ">
#!    \input{_TIKZ_Janus_constructor.tex}
#! </Alt>
#! @BeginExampleSession
#! gap> janus := JanusHead();;
#! gap> EdgesOfFace(janus,1) = EdgesOfFace(janus,2);
#! true
#! gap> VerticesOfFace(janus,1) = VerticesOfFace(janus, 2);
#! true
#! gap> perims := PerimeterPathsOfFaces(janus);
#! [ ( v1, E1, v2, E3, v3, E2, v1 ), ( v1, E1, v2, E3, v3, E2, v1 ) ]
#! gap> perims[1] = perims[2];
#! false
#! gap> Face(perims[1]);
#! 1
#! @EndExampleSession
#!
#! 



#! <ManSection Label="IsPerimeterPath">
#!   <Prop Name="IsPerimeterPath" Arg="object"
#!     Label="for IsObject"
#!     Comm="Return whether the given object is a perimeter path"/>
#!   <Returns><K>true</K> or <K>false</K></Returns>
#!   <Description>
#!      TODO
#!   </Description>
#! </ManSection>


#! @BeginGroup PerimeterPath_Face
#! @Description
#! Return the face to which this perimeter path belongs.
#!
#! @Returns a face
#! @Arguments perimPath
DeclareAttribute( "Face", IsPerimeterPath );
#! @EndGroup


#! @BeginGroup PerimeterPath
#! @Description
#! Construct a perimeter path from a vertex-edge-path and a 
#! face. If the face is not given, but can be uniquely reconstructed
#! from the vertex-edge-path, this will be done.
#!
#! If some edges of the given face are identified (this might
#! happen for a bend polygonal complex), the construction 
#! will fail as well.
#!
#! The NC-version does not check whether <A>face</A> is a face of
#! the underlying complex and whether it matches to the given
#! <A>vePath</A>. It also does not check whether the vertex-edge-path
#! is closed.
#!
#! @Returns a perimeter path
#! @Arguments vePath, face
DeclareOperation( "PerimeterPath", [IsVertexEdgePath, IsPosInt] );
#! @Arguments vePath, face
DeclareOperation( "PerimeterPathNC", [IsVertexEdgePath, IsPosInt] );
#! @Arguments vePath
DeclareOperation( "PerimeterPath", [IsVertexEdgePath] );
#! @EndGroup


#! @Description
#! If the perimeter path is defined on a bend polygonal complex 
#! <K>bendComplex</K>
#! this method returns the corresponding perimeter path on
#! the polygonal complex <K>LocalFace(bendComplex)</K>.
#!
#! If the underlying VEF-complex is a polygonal complex already,
#! this method returns <K>fail</K>.
#!
#! @Returns a perimeter path or <K>fail</K>
#! @Arguments perimPath
DeclareAttribute( "LocalPath", IsPerimeterPath );


#! @BeginGroup PerimeterPathByLocalPath
#! @Description
#! Construct a perimeter path for a bend polygonal complex from
#! a perimeter path on <K>LocalFace</K>(<A>bendComplex</A>).
#!
#! 
#! @Returns a perimeter path
#! @Arguments bendComplex, localPath
DeclareOperation( "PerimeterPathByLocalPath", [IsBendPolygonalComplex, IsPerimeterPath] );
#! @Arguments bendComplex, localPath
DeclareOperation( "PerimeterPathByLocalPathNC", [IsBendPolygonalComplex, IsPerimeterPath] );
#! @EndGroup


#! @Description
#! A perimeter path of a face on a bend polygonal complex defines a cyclic
#! orientation of the local flags within the face. This method returns
#! that cyclic permutation.
#!
#! @Returns a permutation
#! @Arguments perimPath
DeclareAttribute( "LocalFlagCycle", IsPerimeterPath and IsBendPolygonalComplexPath);


#! @Section Edge-Face-Paths
#! @SectionLabel Paths_EdgeFace
#!
#! This section describes edge-face-paths. Intuitively, an
#! edge-face-path is a sequence of faces that are connected by edges.
#! More formally:
#!
#! @InsertChunk Definition_EdgeFacePath
#!

#TODO replace old definition by this
#! @BeginChunk Definition_EdgeFacePath
#! An <E>edge-face-path</E> in a VEF-complex is a tuple
#! <M>(e_1, f_1, e_2, f_2, \ldots ,e_n, f_n, e_{{n+1}})</M> such that
#! * The <M>e_i</M> are edges of the polygonal complex
#! * The <M>f_j</M> are faces of the polygonal complex
#! * The edges <M>e_j</M> and <M>e_{{j+1}}</M> occur in two different
#!   positions in the perimeter of the face <M>f_j</M>.
#! @EndChunk

#! Depending on the type of the underlying VEF-complex, the implementation
#! of edge-face-paths in the <K>SimplicialSurfaces</K>-package differs:
#! <Enum>
#!   <Item>For polygonal complexes, it is sufficient to store the alternating
#!      list of edges and faces, i.e <K>PathAsList</K> 
#!      (<Ref Subsect="VertexEdge_PathAsList"/>). </Item>
#!   <Item>For bend polygonal complexes, more information is needed (since 
#!      two edges in the same face may share the same label). In this case,
#!      the <K>EdgeFacePathElements</K> 
#!      (<Ref Subsect="EdgeFacePathElements"/>) are crucial. An 
#!      edge-face-path-element is a tuple 
#!      <M>[face, [localEdgeIn, localEdgeOut]]</M>, consisting of
#!      a face and two local edges. The two local edges describe through
#!      which edges of the perimeter the path enters and leaves the face.
#!      </Item>
#! </Enum>

#! We will illustrate the polygonal case on this simplicial surface:
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle,edgeStyle,faceStyle]
#!     \input{Image_ThinTorus.tex}
#!   \end{tikzpicture}
#! </Alt>
#! @ExampleSession
#! gap> thinTorus := SimplicialSurfaceByDownwardIncidence(
#! >      [[1,2],[2,3],[1,3],[1,4],[1,5],[2,5],[2,6],[3,6],[3,4],
#! >        [4,5],[5,6],[4,6],[1,4],[1,5],[2,5],[2,6],[3,6],[3,4]],
#! >      [[4,5,10],[1,5,6],[6,7,11],[2,7,8],[8,9,12],[3,4,9],
#! >        [10,13,14],[1,14,15],[11,15,16],[2,16,17],[12,17,18],[3,13,18]]);;
#! @EndExampleSession

#! <ManSection Label="EdgeFacePath">
#!   <Oper Name="EdgeFacePath" Arg="complex, path" 
#!      Label="for IsVEFComplex and IsDenseList"
#!      Comm="Construct an edge-face-path from a VEF-complex and a list"/>
#!   <Oper Name="EdgeFacePathNC" Arg="complex, path" 
#!      Label="for IsVEFComplex and IsDenseList"
#!      Comm="Construct an edge-face-path from a VEF-complex and a list"/>
#!   <Oper Name="EdgeFacePath" Arg="bendComplex, path, elements" 
#!      Label="for IsBendPolygonalComplex and IsDenseList and IsDenseList"
#!      Comm="Construct an edge-face-path from a bend polygonal complex and two lists"/>
#!   <Oper Name="EdgeFacePathNC" Arg="bendComplex, path, elements" 
#!      Label="for IsBendPolygonalComplex and IsDenseList and IsDenseList"
#!      Comm="Construct an edge-face-path from a bend polygonal complex and two lists"/>
#!   <Returns>An EdgeFacePath-&GAP;-object</Returns>
#!   <Filt Name="IsEdgeFacePath" Arg="object" Label="for IsObject" Type="category"
#!      Comm="Check whether a given object is an EdgeFacePath"/>
#!   <Returns><K>true</K> or <K>false</K></Returns>
#!   <Description>
#!     The method <K>EdgeFacePath</K> constructs a new edge-face-path from
#!     a VEF-complex and one (or two) dense list of positive integers. The
#!     method <K>IsEdgeFacePath</K> checks if a given &GAP;-object
#!     represents such a path.
#!
#!     The list <A>path</A> is an alternating list of edges and faces of
#!     the given VEF-complex <A>complex</A> (starting and ending with an 
#!     edge).
#!
#!     The list <A>elements</A> is only relevant if <A>complex</A> is a bend
#!     polygonal complex. It only has to be given if some edges within the
#!     same face of <A>complex</A> are identified. It is a list of
#!     <M>[face, [localEdgeIn, localEdgeOut]]</M>, where <A>face</A> is a
#!     face of <A>complex</A> and <A>localEdgeIn</A> and <A>localEdgeOut</A>
#!     are local edges within <A>face</A>. The local edges designate where
#!     the edge-face-path enters and leaves the face <A>face</A>.
#!
#!     We illustrate this with a path on the simplicial surface from the start
#!     of section
#!     <Ref Sect="Section_Paths_EdgeFace"/>.
#!     <Alt Only="TikZ">
#!       \begin{tikzpicture}[vertexStyle=nolabels,edgePlain,faceStyle]
#!         \def\edgeFacePath{1}
#!         \input{Image_ThinTorus.tex}
#!       \end{tikzpicture}
#!     </Alt>
#!
#!     @InsertChunk Definition_EdgeFacePath
#!
#!     @ExampleSession
#! gap> edgeFacePath := EdgeFacePath( thinTorus, [13,7,14,8,15,9,11,3,7,4,8,5,9] );
#! | e13, F7, e14, F8, e15, F9, e11, F3, e7, F4, e8, F5, e9 |
#! gap> IsEdgeFacePath(edgeFacePath);
#! true
#! gap> IsList(edgeFacePath);
#! false
#! gap> IsEdgeFacePath( [13,7,14,8,15,9,11,3,7,4,8,5,9] );
#! false
#!     @EndExampleSession
#!  
#!     The elements of a vertex-edge-path can be accessed by using the methods
#!     <K>PathAsList</K> (<Ref Subsect="EdgeFace_PathAsList"/>),
#!     <K>EdgesAsList</K> (<Ref Subsect="EdgeFace_EdgesAsList"/>) and 
#!     <K>FacesAsList</K> (<Ref Subsect="EdgeFace_FacesAsList"/>).
#!
#!     If the associated VEF-complex is a bend polygonal complex, the 
#!     edge-face-path-elements can be accessed by <K>EdgeFacePathElements</K>
#!     (<Ref Subsect="EdgeFacePathElements"/>).
#!
#!     The NC-version does not check if the
#!     given <A>path</A> is a list 
#!     <M>[e_1,f_1,e_2,f_2,\ldots,e_n,f_n,e_{{n+1}}]</M> that fulfills these
#!     conditions.
#!   </Description>
#! </ManSection>
# No AutoDoc-documentation since the order of the next two entries should
# be switched
DeclareOperation( "EdgeFacePath", [IsVEFComplex, IsDenseList] );
DeclareOperation( "EdgeFacePathNC", [IsVEFComplex, IsDenseList] );
DeclareOperation( "EdgeFacePath", [IsBendPolygonalComplex, IsDenseList, IsDenseList] );
DeclareOperation( "EdgeFacePathNC", [IsBendPolygonalComplex, IsDenseList, IsDenseList] );


#! @BeginGroup EdgeFace_PathAsList
#! @Description
#!   Return the complete edge-face-path as a list (with edges and
#!   faces alternating), starting with an edge.
#!   
#!   For the examples from <K>EdgeFacePath</K> 
#!   (<Ref Subsect="EdgeFacePath"/>) in the simplicial surface from the 
#!   start of section <Ref Sect="Section_Paths_EdgeFace"/>:
#!   @ExampleSession
#! gap> edgeFacePath;
#! | e13, F7, e14, F8, e15, F9, e11, F3, e7, F4, e8, F5, e9 |
#! gap> PathAsList( edgeFacePath );
#! [ 13, 7, 14, 8, 15, 9, 11, 3, 7, 4, 8, 5, 9 ]
#!   @EndExampleSession
#! @Arguments edgeFacePath
#! @Returns a list of positive integers
DeclareAttribute( "PathAsList", IsEdgeFacePath );
#! @EndGroup

#! @BeginGroup EdgeFace_EdgesAsList
#! @Description
#!   Return the edges of the edge-face-path as a list.
#!
#!   For the examples from <K>EdgeFacePath</K> 
#!   (<Ref Subsect="EdgeFacePath"/>) in the simplicial surface from the 
#!   start of section <Ref Sect="Section_Paths_EdgeFace"/>:
#!   @ExampleSession
#! gap> edgeFacePath;
#! | e13, F7, e14, F8, e15, F9, e11, F3, e7, F4, e8, F5, e9 |
#! gap> EdgesAsList( edgeFacePath );
#! [ 13, 14, 15, 11, 7, 8, 9 ]
#!   @EndExampleSession
#! @Arguments edgeFacePath
#! @Returns a list of positive integers
DeclareAttribute( "EdgesAsList", IsEdgeFacePath );
#! @EndGroup

#! @BeginGroup EdgeFace_FacesAsList
#! @Description
#!     Return the faces of the edge-face-path as a list.
#!
#!   For the examples from <K>EdgeFacePath</K> 
#!   (<Ref Subsect="EdgeFacePath"/>) in the simplicial surface from the 
#!   start of section <Ref Sect="Section_Paths_EdgeFace"/>:
#!   @ExampleSession
#! gap> edgeFacePath;
#! | e13, F7, e14, F8, e15, F9, e11, F3, e7, F4, e8, F5, e9 |
#! gap> FacesAsList( edgeFacePath );
#! [ 7, 8, 9, 3, 4, 5 ]
#!   @EndExampleSession
#! @Arguments edgeFacePath
#! @Returns a list of positive integers
DeclareAttribute( "FacesAsList", IsEdgeFacePath );
#! @EndGroup


#! @BeginGroup EdgeFacePathElements
#! @Description
#! For each face, this gives an element [face,[local edge in, local edge out]]
#! 
#! TODO
#!
#! Only valid for bend polygonal complexes, otherwise will return <K>fail</K>
#!
#! @Returns a list or fail
#! @Arguments edgeFacePath
DeclareAttribute( "EdgeFacePathElements", IsEdgeFacePath );
#! @EndGroup


#! <ManSection Label="EdgeFace_IsClosedPath">
#!   <Prop Name="IsClosedPath" Arg="edgeFacePath"
#!     Label="for IsEdgeFacePath"
#!     Comm="Return whether the given path is closed"/>
#!   <Returns><K>true</K> or <K>false</K></Returns>
#!   <Description>
#!     Check whether the given edge-face-path is closed, i.e. whether
#!     the first and last vertex in this path are equal.
#!
#! The example from <K>EdgeFacePath</K>
#! (<Ref Subsect="EdgeFacePath"/>) is not closed but an extended version
#! of the path is.
#! <Alt Only="TikZ">
#!   \input{Image_ThinTorus_longPath.tex}
#! </Alt>
#! @ExampleSession
#! gap> edgeFacePath;
#! | e13, F7, e14, F8, e15, F9, e11, F3, e7, F4, e8, F5, e9 |
#! gap> IsClosedPath(edgeFacePath);
#! false
#! gap> longPath := EdgeFacePath( thinTorus,
#! >                 [13,7,14,8,15,9,11,3,7,4,8,5,12,11,18,12,13]);
#! ( e13, F7, e14, F8, e15, F9, e11, F3, e7, F4, e8, F5, e12, F11, e18, F12, e13 )
#! gap> IsClosedPath(longPath);
#! true
#! @EndExampleSession
#!   </Description>
#! </ManSection>
# This is documentation for a declaration in dual_path.gd


#! @Description
#! Return the inverse edge-face-path to the given path.
#!
#! TODO example
#!
#! @Arguments edgeFacePath
#! @Returns a edge-face-path
DeclareAttribute( "Inverse", IsEdgeFacePath );



#! <ManSection Label="EdgeFace_IsDuplicateFree">
#!   <Prop Name="IsDuplicateFree" Arg="edgeFacePath"
#!     Label="for IsEdgeFacePath"
#!     Comm="Return whether the given path is duplicate-free"/>
#!   <Returns><K>true</K> or <K>false</K></Returns>
#!   <Description>
#!     Check whether the given edge-face-path is duplicate-free.
#!
#!     An edge-face-path is duplicate-free if no edges or faces
#!     appear twice in it - with one exception: if the path is closed
#!     (see <Ref Subsect="EdgeFace_IsClosedPath"/>) it does not matter that the
#!     first and last edge are the same.
#!
#!     Both the path from <K>EdgeFacePath</K>
#!     (<Ref Subsect="EdgeFacePath"/>) and the longer one from
#!     <K>IsClosedPath</K> (<Ref Subsect="EdgeFace_IsClosedPath"/>)
#!     are duplicate-free.
#!     @ExampleSession
#! gap> IsDuplicateFree( edgeFacePath );
#! true
#! gap> IsDuplicateFree( longPath );
#! true
#!     @EndExampleSession
#! 
#! TODO example where non-central edges are double. Execute other paths again?
#!   </Description>
#! </ManSection>
# This is documentation for a declaration in dual_path.gd


#! @BeginGroup EdgeFace_EdgesAsPerm
#! @Description
#!     If an edge-face-path is closed and duplicate-free, it induces
#!     a cyclic permutation on its edges. This method returns that
#!     permutation.
#! 
#! We illustrate this on the long path from <K>IsClosed</K>
#! (<Ref Subsect="EdgeFace_IsClosedPath"/>).
#! <Alt Only="TikZ">
#!  \input{Image_ThinTorus_longPath.tex}
#! </Alt>
#! @ExampleSession
#! gap> longPath;
#! ( e13, F7, e14, F8, e15, F9, e11, F3, e7, F4, e8, F5, e12, F11, e18, F12, e13 )
#! gap> EdgesAsPerm(longPath);
#! (7,8,12,18,13,14,15,11)
#! @EndExampleSession
#! 
#! @Arguments edgeFacePath
#! @Returns a permutation
DeclareAttribute( "EdgesAsPerm", IsEdgeFacePath );
#! @EndGroup


#! @BeginGroup EdgeFace_FacesAsPerm
#! @Description
#!     If an edge-face-path is closed and duplicate-free, it induces
#!     a cyclic permutation on its faces. This method returns that
#!     permutation.
#!
#! We illustrate this on the long path from <K>IsClosed</K>
#! (<Ref Subsect="EdgeFace_IsClosedPath"/>).
#! <Alt Only="TikZ">
#!  \input{Image_ThinTorus_longPath.tex}
#! </Alt>
#! @ExampleSession
#! gap> longPath;
#! ( e13, F7, e14, F8, e15, F9, e11, F3, e7, F4, e8, F5, e12, F11, e18, F12, e13 )
#! gap> FacesAsPerm(longPath);
#! (3,4,5,11,12,7,8,9)
#! @EndExampleSession
#!
#! @Arguments edgeFacePath
#! @Returns A permutation
DeclareAttribute( "FacesAsPerm", IsEdgeFacePath );
#! @EndGroup


#! @Description
#! Return the VEF-complex for which the given edge-face-path is
#! defined.
#! @Arguments edgeFacePath
#! @Returns a VEF-complex
DeclareAttribute( "AssociatedVEFComplex", IsEdgeFacePath );


#! @Description
#! Return whether the given edge-face-path is defined on a
#! (bend) polygonal complex.
#!
#! @Arguments vertexEdgePath
DeclareProperty( "IsPolygonalComplexPath", IsEdgeFacePath );

#! @Description
#! Return whether the given edge-face-path is defined on a
#! (bend) polygonal complex.
#!
#! @Arguments vertexEdgePath
DeclareProperty( "IsBendPolygonalComplexPath", IsEdgeFacePath );



##
## Coloured output-attributes
DeclareAttribute( "ViewInformation", IsEdgeFacePath );

#! @Section Geodesic and umbrella paths
#! @SectionLabel Paths_Geodesics
#!
#! Section <Ref Sect="Section_Paths_EdgeFace"/> introduced the concept of
#! edge-face-paths. This section deals with two specific types of 
#! edge-face-paths, namely umbrella and geodesic paths.
#!
#! This will be illustrated on the following torus:
#! <Alt Only="TikZ">
#!   \input{Image_Geodesics.tex}
#! </Alt>
#! @BeginExampleSession
#! gap> torus := SimplicialSurfaceByDownwardIncidence(
#! >     [ [1,2],[1,2],[1,3],[2,3],[2,4],[1,4],[3,4],[3,4],[1,3],[1,4],[2,4],[2,3] ],
#! >     [ [1,3,4],[4,5,7],[2,5,6],[3,6,8],[7,9,10],[1,10,11],[8,11,12],[2,9,12] ]);;
#! @EndExampleSession
#! 

#! @Description
#! Check whether the given edge-face-path is an umbrella-path, i.e. whether
#! there is one vertex such that all edges and faces of the edge-face-path
#! are incident to it.
#!
#! As an illustration consider the torus from the start of section
#! <Ref Sect="Section_Paths_Geodesics"/>:
#! <Alt Only="TikZ">
#!   {
#!      \def\pathFive{1}
#!      \def\pathSix{1}
#!      \def\pathSeven{1}
#!      \def\pathFour{1}
#!      \input{Image_Geodesics.tex}
#!   }
#! </Alt>
#! @BeginExampleSession
#! gap> umb := EdgeFacePath( torus, [7,5,10,6,11,7,8,4,6] );
#! | e7, F5, e10, F6, e11, F7, e8, F4, e6 |
#! gap> IsUmbrellaPath(umb);
#! true
#! @EndExampleSession
#!
#! @Arguments edgeFacePath
DeclareProperty( "IsUmbrellaPath", IsEdgeFacePath );


#! @BeginGroup IsGeodesicPath
#! @Description
#! Check whether the given edge-face-path is a geodesic path.
#!
#! If the edge-face-path is defined on a polygonal complex, this is
#! equivalent to asking, whether 
#! each
#! vertex (except those of the first and last edge) is incident to exactly
#! three faces of the path.
#!
#! If the edge-face-path is defined on a bend polygonal complex, a geodesic
#! path
#! is defined by its <K>DefiningLocalFlags</K> (compare 
#! <Ref Subsect="DefiningFlags"/>).
#!
#! TODO give more information
#! 
#! As an illustration consider the torus from the start of section
#! <Ref Sect="Section_Paths_Geodesics"/>:
#! <Alt Only="TikZ">
#!  {
#!      \def\pathOne{1}
#!      \def\pathTwo{1}
#!      \def\pathThree{1}
#!      \def\pathFour{1}
#!      \input{Image_Geodesics.tex}
#!  }
#! </Alt>
#! @BeginExampleSession
#! gap> closedGeo := EdgeFacePath( torus, [3,1,4,2,5,3,6,4,3] );
#! ( e3, F1, e4, F2, e5, F3, e6, F4, e3 )
#! gap> IsGeodesicPath(closedGeo);
#! true
#! @EndExampleSession
#! Geodesic paths do not have to be closed (<Ref Subsect="IsClosedGeodesicPath"/>):
#! <Alt Only="TikZ">
#!  {
#!      \def\pathFive{1}
#!      \def\pathTwo{1}
#!      \def\pathThree{1}
#!      \input{Image_Geodesics.tex}
#!  }
#! </Alt>
#! @BeginExampleSession
#! gap> openGeo := EdgeFacePath( torus, [9,5,7,2,5,3,2] );
#! | e9, F5, e7, F2, e5, F3, e2 |
#! gap> IsGeodesicPath(openGeo);
#! true
#! @EndExampleSession
#! 
#! @Arguments edgeFacePath
DeclareProperty( "IsGeodesicPath", IsEdgeFacePath );
#! @EndGroup

#! @Description
#! For every geodesic path (<Ref Subsect="IsGeodesicPath"/>) there is an 
#! interwoven
#! vertex-edge-path with the same edges. All vertices of the geodesic path 
#! appear
#! in this vertex-edge-path.
#!
#! TODO explain, draw picture of this zig-zagging vertex-edge-path
#!
#! As an illustration consider the two geodesic paths from 
#! <Ref Subsect="IsGeodesicPath"/>:
#! <Alt Only="TikZ">
#!  {
#!      \def\pathOne{1}
#!      \def\pathTwo{1}
#!      \def\pathThree{1}
#!      \def\pathFour{1}
#!      \input{Image_Geodesics.tex}
#!  }
#! </Alt>
#! @BeginExampleSession
#! gap> VertexEdgePath(closedGeo);
#! ( v1, E3, v3, E4, v2, E5, v4, E6, v1 )
#! @EndExampleSession
#! <Alt Only="TikZ">
#!  {
#!      \def\pathFive{1}
#!      \def\pathTwo{1}
#!      \def\pathThree{1}
#!      \input{Image_Geodesics.tex}
#!  }
#! </Alt>
#! @BeginExampleSession
#! gap> VertexEdgePath(openGeo);
#! ( v1, E9, v3, E7, v4, E5, v2, E2, v1 )
#! @EndExampleSession
#! 
#!
#! @Returns a vertex-edge-path
#! @Arguments geodesic
DeclareAttribute( "VertexEdgePath", IsEdgeFacePath and IsGeodesicPath );
#TODO is this a good name?


#! @BeginGroup MaximalGeodesicPaths
#! @Description
#! Compute the set of all maximal geodesic paths of <A>ramSurf</A>, i.e. the
#! set of all geodesic paths that can not be extended further.
#!
#! For a polygonal complex, the operation 
#! <K>MaximalGeodesicPathOfFlag</K>(<A>ramSurf</A>, <A>flag</A>)
#! returns the unique maximal geodesic path that is defined by the given
#! <A>flag</A>. The NC-version does not check whether the given <A>flag</A>
#! is actually a flag of <A>ramSurf</A>.
#!
#! For a bend polygonal complex, this works similarly, but instead of
#! a flag a local flag has to be given.
#!
#! As an illustration consider the torus from the start of section
#! <Ref Sect="Section_Paths_Geodesics"/>:
#! <Alt Only="TikZ">
#!      \input{Image_Geodesics.tex}
#! </Alt>
#! @BeginExampleSession
#! gap> MaximalGeodesicPaths(torus);
#! [ ( e1, F1, e4, F2, e7, F5, e10, F6, e1 ), 
#!  ( e1, F6, e11, F7, e8, F4, e3, F1, e1 ), 
#!  ( e2, F3, e5, F2, e7, F5, e9, F8, e2 ), 
#!  ( e2, F8, e12, F7, e8, F4, e6, F3, e2 ), 
#!  ( e3, F1, e4, F2, e5, F3, e6, F4, e3 ), 
#!  ( e9, F8, e12, F7, e11, F6, e10, F5, e9 ) ]
#! @EndExampleSession
#! TODO more explanation and example with boundaries?
#!
#! TODO If there are multiple ways to write a geodesic, which is picked?
#!
#! @Returns a set of edge-face-paths
#! @Arguments ramSurf
DeclareAttribute( "MaximalGeodesicPaths", IsVEFComplex and IsNotEdgeRamified );
#! @Returns an edge-face-path
#! @Arguments ramSurf, flag
DeclareOperation( "MaximalGeodesicPathOfFlag", [IsPolygonalComplex and IsNotEdgeRamified, IsList] );
#! @Arguments ramSurf, flag
DeclareOperation( "MaximalGeodesicPathOfFlagNC", [IsPolygonalComplex and IsNotEdgeRamified, IsList] );
#! @Arguments ramSurf, localFlag
DeclareOperation( "MaximalGeodesicPathOfLocalFlag", [IsBendPolygonalComplex and IsNotEdgeRamified, IsPosInt] );
#! @Arguments ramSurf, localFlag
DeclareOperation( "MaximalGeodesicPathOfLocalFlagNC", [IsBendPolygonalComplex and IsNotEdgeRamified, IsPosInt] );
#! @EndGroup

#! @BeginGroup IsClosedGeodesicPath
#! @Description
#! Check whether the given edge-face-path is a closed geodesic path, i.e. 
#! whether
#! is is a geodesic path (<Ref Subsect="IsGeodesicPath"/>) where first and 
#! last edge
#! coincide, such that all vertices are incident to exactly three faces of
#! the path.
#!
#! As an illustration consider the two geodesic paths from 
#! <Ref Subsect="IsGeodesicPath"/>:
#! <Alt Only="TikZ">
#!  {
#!      \def\pathOne{1}
#!      \def\pathTwo{1}
#!      \def\pathThree{1}
#!      \def\pathFour{1}
#!      \input{Image_Geodesics.tex}
#!  }
#! </Alt>
#! @BeginExampleSession
#! gap> IsClosedGeodesicPath(closedGeo);
#! true
#! @EndExampleSession
#! <Alt Only="TikZ">
#!  {
#!      \def\pathFive{1}
#!      \def\pathTwo{1}
#!      \def\pathThree{1}
#!      \input{Image_Geodesics.tex}
#!  }
#! </Alt>
#! @BeginExampleSession
#! gap> IsClosedGeodesicPath(openGeo);
#! false
#! @EndExampleSession
#!
#! @Arguments edgeFacePath
DeclareProperty( "IsClosedGeodesicPath", IsEdgeFacePath );
#! @EndGroup
InstallTrueMethod( IsGeodesicPath, IsClosedGeodesicPath );

#! @BeginGroup DefiningFlags
#! @Description
#! Return the defining flags of the given geodesic path
#! (<Ref Subsect="IsGeodesicPath"/>) as a list.
#!
#! If the geodesic path is defined on a polygonal complex, regular
#! flags are used. If it is defined on a bend polygonal complex,
#! local flags have to be used (and <K>DefiningLocalFlags</K>).
#!
#! Consider the geodesic path
#! <M>[e_1,f_1,e_2,f_2,e_3,f_3,e_4,f_4,e_1]</M>.
#! <Alt Only="TikZ">
#!      \input{Image_DefiningFlags.tex}
#! </Alt>
#! The defining flags can be illustrated as follows:
#! <Alt Only="TikZ">
#!  {
#!      \def\normal{1}
#!      \input{Image_DefiningFlags.tex}
#!  }
#! </Alt>
#! 
#! As an illustration consider the two geodesic paths from
#! <Ref Subsect="IsGeodesicPath"/>.
#! <Alt Only="TikZ">
#!  {
#!      \def\pathOne{1}
#!      \def\pathTwo{1}
#!      \def\pathThree{1}
#!      \def\pathFour{1}
#!      \input{Image_Geodesics.tex}
#!  }
#! </Alt>
#! @BeginExampleSession
#! gap> DefiningFlags(closedGeo);
#! [ [ 1, 3, 1 ], [ 3, 4, 2 ], [ 2, 5, 3 ], [ 4, 6, 4 ] ]
#! @EndExampleSession
#! <Alt Only="TikZ">
#!  {
#!      \def\pathFive{1}
#!      \def\pathTwo{1}
#!      \def\pathThree{1}
#!      \input{Image_Geodesics.tex}
#!  }
#! </Alt>
#! @BeginExampleSession
#! gap> DefiningFlags(openGeo);
#! [ [ 1, 9, 5 ], [ 3, 7, 2 ], [ 4, 5, 3 ] ]
#! @EndExampleSession
#!
#! @Returns a list of flags
#! @Arguments geodesic
DeclareAttribute( "DefiningFlags", IsEdgeFacePath and IsPolygonalComplexPath and IsGeodesicPath );
#! @Returns a list of local flags
#! @Arguments geodesic
DeclareAttribute( "DefiningLocalFlags", IsEdgeFacePath and IsBendPolygonalComplexPath and IsGeodesicPath );
#TODO good name?
#! @EndGroup


#! @BeginGroup MaximalDuplicateFreeGeodesicPaths
#! @Description
#! For a given <A>flag</A> return the maximal duplicate-free geodesic
#! path
#! defined by this flag, i.e. it is extended in positive direction until one
#! face-duplication arises. Then it is extended in negative direction.
#!
#! The method <K>MaximalDuplicateFreeGeodesicPaths</K>(<A>ramSurf</A>) returns
#! the set of all those geodesics.
#!
#! TODO examples
#!
#! @Returns a set of duplicate-free geodesic paths
#! @Arguments ramSurf
DeclareAttribute( "MaximalDuplicateFreeGeodesicPaths", IsPolygonalComplex and IsNotEdgeRamified );
#! @Returns a duplicate-free geodesic path
#! @Arguments ramSurf, flag
DeclareOperation( "MaximalDuplicateFreeGeodesicPathOfFlag", [IsPolygonalComplex and IsNotEdgeRamified, IsList] );
#! @Arguments ramSurf, flag
DeclareOperation( "MaximalDuplicateFreeGeodesicPathOfFlagNC", [IsPolygonalComplex and IsNotEdgeRamified, IsList] );
#! @EndGroup

#! @Description
#! For a closed geodesic path (<Ref Subsect="IsClosedGeodesicPath"/>) 
#! construct the
#! <E>geodesic flag cycle</E>.
#!
#! If <A>closedGeodesic</A> is defined on a polygonal complex, this is a 
#! permutation on the 3-flags
#! (<Ref Subsect="Flags"/>). It can also be obtained as one cycle of
#! the product of the Dress involutions (<Ref Subsect="DressInvolutions"/>),
#! by first applying the one for vertices, then edges and finally faces.
#!
#! If <A>closedGeodesic</A> is defined on a bend polygonal complex, this
#! is a permutation on the local flags.
#!
#! TODO explain properly with picture
#!
#! @Returns a permutation
#! @Arguments closedGeodesic
DeclareAttribute( "GeodesicFlagCycle", IsEdgeFacePath and IsClosedGeodesicPath );
#TODO is this a good name?


#! @Section Connectivity
#! @SectionLabel Paths_Connectivity
#!
#! This section contains methods that deal with the (strong) connectivity of 
#! polygonal
#! complexes (which were introduced in chapter 
#! <Ref Chap="PolygonalStructures"/> as a generalisation of simplicial 
#! surfaces). More specifically it contains these
#! capabilities:
#! * Determine if a polygonal complex is (strongly) connected 
#!   (<Ref Subsect="IsConnected"/> and <Ref Subsect="IsStronglyConnected"/>).
#! * Determine the (strongly) connected components of a polygonal complex 
#!   (<Ref Subsect="ConnectedComponents"/> and 
#!   <Ref Subsect="StronglyConnectedComponents"/>).
#!
#! The distinction between <E>connectivity</E> and <E>strong connectivity</E> 
#! is only
#! relevant for polygonal complexes that are not also polygonal surfaces.
#! This can be seen in this example:
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[scale=2, vertexStyle, edgeStyle=nolabels, faceStyle]
#!      \input{Image_ButterflyOfTriangles.tex}
#!   \end{tikzpicture}
#! </Alt>
#! @ExampleSession
#! gap> butterfly := TriangularComplexByVerticesInFaces( 7, 4,
#! > [ [1,2,3], [1,6,7], [1,3,4], [1,5,6] ]);;
#! @EndExampleSession
#! This example is connected since its incidence graph (see section
#! <Ref Sect="Section_Graphs_Incidence"/>) is 
#! connected.
#! @ExampleSession
#! gap> IsConnected( butterfly );
#! true
#! @EndExampleSession
#! But in several situations it is convenient to regard this
#! example as disconnected, with the following connected components:
#! <Alt Only="TikZ">
#!    \begin{tikzpicture}[scale=2, vertexStyle, edgeStyle=nolabels, faceStyle]
#!       \def\swapColors{1}
#!       \input{Image_ButterflyOfTriangles.tex}
#!    \end{tikzpicture}
#! </Alt>
#! This notion of connectivity is called <E>strong connectivity</E>. 
#! A polygonal complex is strongly connected if and only if the polygonal 
#! complex without
#! its vertices is connected.
#! @ExampleSession
#! gap> IsStronglyConnected( butterfly );
#! false
#! @EndExampleSession
#!

#! @BeginGroup IsConnected
#! @Description
#! Check whether the given polygonal complex is connected. A polygonal complex
#! is connected if and only if its incidence graph (compare section 
#! <Ref Sect="Section_Graphs_Incidence"/>) is 
#! connected.
#!
#! For example, consider the ramified simplicial surface from the start of 
#! section <Ref Sect="Section_Paths_Connectivity"/>:
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[scale=2, vertexStyle, edgeStyle=nolabels, faceStyle]
#!     \input{Image_ButterflyOfTriangles.tex}
#!   \end{tikzpicture}
#! </Alt>
#! @ExampleSession
#! gap> IsConnected( butterfly );
#! true
#! @EndExampleSession
#! 
#! @Arguments complex
DeclareProperty( "IsConnected", IsVEFComplex );
#! @EndGroup

#! @BeginGroup ConnectedComponents
#! @Description
#! Return a list of the connected components of the given polygonal complex 
#! (as polygonal complexes). They correspond to the connected components
#! of the incidence graph (compare section 
#! <Ref Sect="Section_Graphs_Incidence"/>).
#!
#! If a face of the polygonal complex is given as an additional argument,
#! only the connected component containing that face is returned. The 
#! NC-version does not check if <A>face</A> is a face of <A>complex</A>.
#!
#! For example, consider the ramified simplicial surface from the start of
#! section <Ref Sect="Section_Paths_Connectivity"/>:
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[scale=2, vertexStyle, edgeStyle=nolabels, faceStyle]
#!     \input{Image_ButterflyOfTriangles.tex}
#!   \end{tikzpicture}
#! </Alt>
#! @ExampleSession
#! gap> comp := ConnectedComponents( butterfly );;
#! gap> Size(comp);
#! 1
#! gap> comp[1] = butterfly;
#! true
#! @EndExampleSession
#TODO better example..
#!
#! @Returns a list of polygonal complexes
#! @Arguments complex
DeclareOperation( "ConnectedComponents", [IsVEFComplex] );
#! @Arguments complex
DeclareAttribute( "ConnectedComponentsAttributeOfVEFComplex", IsVEFComplex );
#! @Returns a polygonal complex
#! @Arguments complex, face
DeclareOperation( "ConnectedComponentOfFace", [IsVEFComplex, IsPosInt] );
#! @Arguments complex, face
DeclareOperation( "ConnectedComponentOfFaceNC", [IsVEFComplex, IsPosInt] );
#! @EndGroup


#! @BeginGroup IsStronglyConnected
#! @Description
#! Check whether the given polygonal complex is strongly connected. A polygonal 
#! complex
#! is strongly connected if and only if one of the following equivalent 
#! conditions hold:
#! * It is still connected after removal of all vertices. 
#! * For each pair of faces there is an edge-face-path (compare section 
#!   <Ref Sect="Section_Access_OrderedVertexAccess"/>) that connects them.
#!
#! For example, consider the ramified simplicial surface from the start of 
#! section <Ref Sect="Section_Paths_Connectivity"/>:
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[scale=2, vertexStyle, edgeStyle=nolabels, faceStyle]
#!     \input{Image_ButterflyOfTriangles.tex}
#!   \end{tikzpicture}
#! </Alt>
#! @ExampleSession
#! gap> IsStronglyConnected( butterfly );
#! false
#! @EndExampleSession
#! 
#! @Arguments complex
DeclareProperty( "IsStronglyConnected", IsVEFComplex );
#! @EndGroup

#! @BeginGroup StronglyConnectedComponents
#! @Description
#! Return a list of the strongly connected components of the given polygonal 
#! complex 
#! (as polygonal complexes).
#!
#! If a face of the polygonal complex is given as an additional argument,
#! only the strongly connected component containing that face is returned. The 
#! NC-version does not check if <A>face</A> is a face of <A>complex</A>.
#!
#! For example, consider the ramified simplicial surface from the start of 
#! section <Ref Sect="Section_Paths_Connectivity"/>:
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[scale=2, vertexStyle, edgeStyle=nolabels, faceStyle]
#!     \input{Image_ButterflyOfTriangles.tex}
#!   \end{tikzpicture}
#! </Alt>
#! @ExampleSession
#! gap> comp := StronglyConnectedComponents(butterfly);;
#! gap> Size(comp);
#! 2
#! gap> Faces( comp[1] );
#! [ 1, 3 ]
#! gap> Faces( comp[2] );
#! [ 2, 4 ]
#! gap> comp[1] = StronglyConnectedComponentOfFace(butterfly, 1);
#! true
#! gap> comp[2] = StronglyConnectedComponentOfFace(butterfly, 4);
#! true
#! @EndExampleSession
#!
#! @Returns a list of polygonal complexes
#! @Arguments complex
DeclareOperation( "StronglyConnectedComponents", [IsVEFComplex] );
#! @Arguments complex
DeclareAttribute( "StronglyConnectedComponentsAttributeOfVEFComplex", IsVEFComplex );
#! @Returns a polygonal complex
#! @Arguments complex, face
DeclareOperation( "StronglyConnectedComponentOfFace", [IsVEFComplex, IsPosInt] );
#! @Arguments complex, face
DeclareOperation( "StronglyConnectedComponentOfFaceNC", [IsVEFComplex, IsPosInt] );
#! @EndGroup


#! @BeginGroup NumberOfConnectedComponents
#! @Description
#! Return the number of (strongly) connected components of the given polygonal
#! complex.
#!
#! TODO explain definitions
#!
#! For example consider the ramified simplicial surface from the start of
#! section <Ref Sect="Section_Paths_Connectivity"/>:
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[scale=2, vertexStyle=nolabels, edgeStyle=nolabels, faceStyle=nolabels]
#!      \input{Image_ButterflyOfTriangles.tex}
#!   \end{tikzpicture}
#! </Alt>
#! @ExampleSession
#! gap> NumberOfConnectedComponents(butterfly);
#! 1
#! gap> NumberOfStronglyConnectedComponents(butterfly);
#! 2
#! @EndExampleSession
#!
#! @Returns a positive integer
#! @Arguments complex
DeclareAttribute( "NumberOfConnectedComponents", IsVEFComplex );
#! @Arguments complex
DeclareAttribute( "NumberOfStronglyConnectedComponents", IsVEFComplex );
#! @EndGroup


#! @Section Orientability
#! @SectionLabel Orientability
#! 
#! This section contains methods that deal with the orientability of (bend)
#! polygonal surfaces without edge ramifications (compare section
#! <Ref Sect="PolygonalStructures_surface"/>). For (bend) polygonal 
#! complexes with edge ramifications the concept of orientability is not 
#! well-defined since there is no
#! proper way to deal with edges that are incident to more than two faces.
#TODO more explanation needed?
#!
#! A polygonal orientation is defined by choosing a direction along the 
#! perimeter of each polygon such that for each edge with exactly two 
#! incident faces both directions are defined. This direction is modelled
#! by a perimeter path (compare <Ref Sect="Section_Paths_Perimeter"/> for
#! details).
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexPlain=nolabels, edgePlain=nolabels, faceStyle=nolabels]
#!     \def\orientation{1}
#!     \input{Image_ConstructorExample.tex}
#!   \end{tikzpicture}
#! </Alt>
#! A VEF-complex without edge ramifications is <E>orientable</E> if such a choice of
#! directions is possible.
#!
#! For a given VEF-complex this orientation can be computed.
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexPlain, edgePlain, faceStyle]
#!      \input{Image_ConstructorExample.tex}
#!   \end{tikzpicture}
#! </Alt>
#! @ExampleSession
#! gap> surface := PolygonalSurfaceByDownwardIncidence(
#! > [,[3,5],,,,[3,7],,[3,11],,[7,11],,[5,13],,[7,13],[11,13]],
#! > [ [2,6,12,14],,, [6,8,10],,,,, [10,14,15] ]);;
#! gap> IsOrientable(surface);
#! true
#! @EndExampleSession
#!
#! The orientation of a face is given as a vertex-edge-path (compare section
#! <Ref Sect="Section_Paths_VertexEdge"/>) in which vertices and edges are
#! alternating. For the quadrangular face we could represent one of these
#! paths as <M>[3,6,7,14,13,12,5,2,3]</M>. From the paths we can also
#! compute the corresponding permutations of vertices and edges alone.
#!
#! @ExampleSession
#! gap> orient := Orientation( surface );
#! [ (v3,E2,v5,E12,v13,E14,v7,E6,v3),,, (v3,E6,v7,E10,v11,E8,v3),,,,, (v7,E14,v13,E15,v11,E10,v7) ]
#! gap> List(orient, VerticesAsPerm);
#! [ (3,5,13,7),,, (3,7,11),,,,, (7,13,11) ]
#! gap> List(orient, VerticesAsList);
#! [ [3,5,13,7,3],,, [3,7,11,3],,,,, [7,13,11,7] ]
#! gap> List(orient, EdgesAsPerm);
#! [ (2,12,14,6),,, (6,10,8),,,,, (10,14,15) ]
#! gap> List(orient, EdgesAsList);
#! [ [2,12,14,6],,, [6,10,8],,,,, [14,15,10] ]
#! @EndExampleSession
#!
#! If the orientation for one face is given, this defined the orientations
#! for the strongly connected component (compare
#! <Ref Subsect="StronglyConnectedComponents"/>) of this face. The convention
#! for returning an orientation is as follows:
#! * For each strongly connected component there is a face with 
#!   minimal number.
#! * The orientation of this face is equal to <K>PermeterOfFace</K>
#!   (<Ref Subsect="PerimeterPathsOfFaces"/>) of this face.
#!

#! @BeginGroup IsOrientable
#! @Description
#! Return whether the given ramified polygonal surface is orientable.
#!
#! A ramified polygonal surface is orientable if it is possible to choose a 
#! direction along the perimeter of each face such that each pair of adjacent
#! faces defines opposite directions on the shared edge.
#!
#! As an example, consider the polygonal surface from the start of section
#! <Ref Sect="Section_Orientability"/>:
#! <Alt Only="TikZ">
#!    \begin{tikzpicture}[vertexStyle=nolabels, edgeStyle=nolabels, faceStyle]
#!       \input{Image_ConstructorExample.tex}
#!    \end{tikzpicture}
#! </Alt>
#! @ExampleSession
#! gap> IsOrientable( surface );
#! true
#! @EndExampleSession
#! TODO other example?
#! @Arguments ramSurf
DeclareProperty( "IsOrientable", IsVEFComplex and IsNotEdgeRamified );
#! @EndGroup

#! @BeginGroup Orientation
#! @Description
#! Return the orientation of the given ramified polygonal surface, if
#! it exists (otherwise return <K>fail</K>). The orientation is given as a list
#! with the faces of <A>ramSurf</A> as indices.
#!
#! For each face, this list contains a perimeter-path (see 
#! <Ref Subsect="PerimeterPath"/> for the precise definition) of this face.
#! To access perimeter-paths the methods of sections
#! <Ref Sect="Section_Paths_VertexEdge"/> and
#! <Ref Sect="Section_Paths_Perimeter"/> can be used.
#! 
#! TODO describe properly
#!
#! For example, consider the polygonal surface from the start of section
#! <Ref Sect="Section_Orientability"/>:
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle, edgeStyle, faceStyle]
#!      \input{Image_ConstructorExample.tex}
#!   \end{tikzpicture}
#! </Alt>
#! @ExampleSession
#! gap> orient := Orientation( surface );
#! [ (v3,E2,v5,E12,v13,E14,v7,E6,v3),,, (v3,E6,v7,E10,v11,E8,v3),,,,, (v7,E14,v13,E15,v11,E10,v7) ]
#! gap> List(orient, VerticesAsPerm);
#! [ (3,5,13,7),,, (3,7,11),,,,, (7,13,11) ]
#! gap> List(orient, VerticesAsList);
#! [ [3,5,13,7,3],,, [3,7,11,3],,,,, [7,13,11,7] ]
#! gap> List(orient, EdgesAsPerm);
#! [ (2,12,14,6),,, (6,10,8),,,,, (10,14,15) ]
#! gap> List(orient, EdgesAsList);
#! [ [2,12,14,6],,, [6,10,8],,,,, [14,15,10] ]
#! @EndExampleSession
#! 
#! @Returns a list of vertex-edge-paths
#! @Arguments ramSurf
DeclareAttribute( "Orientation", IsVEFComplex and IsNotEdgeRamified );
#! @EndGroup


#! @Description
#! Compute the <E>orientation cover</E> of a polygonal complex without edge
#! ramifications.
#! It is constructed in the following way:
#! * For each face in <A>ramSurf</A> the orientation cover has to faces,
#!   corresponding to the two possible orientations of this face. These
#!   orientations are represented as <E>perimeter paths</E> (compare
#!   section <Ref Sect="Section_Paths_Perimeter"/>).
#! * Two adjacent faces with orientation in <A>ramSurf</A> are adjacent
#!   in the cover if these orientations induce opposite orientations on
#!   the connecting edge.
#! * The vertices are defined by going around an umbrella and transforming
#!   the orientations correspondingly.
#!
#! This method returns a list with three entries:
#! * The first entry is the covering surface
#! * The second entry is a map from the covering surface to <A>ramSurf</A>.
#!   It is given in the form of three lists: The first list maps the vertices
#!   of the cover to the vertices of <A>ramSurf</A>, the second list maps the
#!   edges and the third one maps the faces.
#! * The third entry is a map from the faces of the covering surface to the
#!   orientation that was used in defining this face.
#!
#! The resulting polygonal surface is always closed 
#! (<Ref Subsect="IsClosedSurface"/>) and orientable 
#! (<Ref Subsect="IsOrientable"/>). If the original <A>ramSurf</A> was
#! orientable, it has two connected components, otherwise just one.
#!
#! @BeginExampleSession
#! gap> tetCov := OrientationCover(Tetrahedron())[1];;
#! gap> NumberOfVertices(tetCov);
#! 8
#! gap> NumberOfEdges(tetCov);
#! 12
#! gap> NumberOfFaces(tetCov);
#! 8
#! gap> NumberOfConnectedComponents(tetCov);
#! 2
#! gap> 
#! @EndExampleSession
#! TODO more varied examples
#! 
#! @Returns a list, where the first entry is a polygonal surface and the
#! subsequent entries are its vertices, edges and faces
#! @Arguments ramSurf
DeclareOperation("OrientationCover", [IsPolygonalComplex and IsNotEdgeRamified]);



##
## Undocumented stuff for edge-coloured edge-face-paths
DeclareAttribute("AssociatedEdgeColouredPolygonalComplex", IsEdgeColouredEdgeFacePath);
