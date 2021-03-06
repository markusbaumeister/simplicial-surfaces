#############################################################################
##
##  SimplicialSurface package
##
##  Copyright 2012-2016
##    Markus Baumeister, RWTH Aachen University
##    Alice Niemeyer, RWTH Aachen University 
##
## Licensed under the GPL 3 or later.
##
#############################################################################

#! @Chapter Modification of polygonal complexes
#! @ChapterLabel Modification
#!
#! This chapter is concerned with the modification of polygonal complexes
#! (introduced in chapter <Ref Chap="PolygonalStructures"/> as a 
#! generalization of simplicial surfaces). This allows the construction
#! of new complexes from old ones.
#!
#! This chapter covers the operations of splitting 
#! (<Ref Sect="Section_Modification_Splitting"/>) and joining 
#! (<Ref Sect="Section_Modification_Joining"/>)
#! a polygonal complex along vertices or edges (more generally along 
#! a vertex-edge-path, which was introduced in section 
#! <Ref Sect="Section_Paths_VertexEdge"/>).
#!
#! The aim of these operations is to provide a set of tools that allows a
#! user to develop their own modifications without worrying too much about
#! the underlying incidence structure. To make this easier, section
#! <Ref Sect="Section_Modification_Applications"/>
#! contains several useful modifications, along with an explanation how
#! they can be constructed with the elementary tools.


#! @BeginChunk VertexEdgePath_Construction
#! Vertex-edge-paths can be created easily:
#! * From a list of vertices: <K>VertexEdgePathByVertices</K> 
#!   (<Ref Subsect="VertexEdgePathByVertices"/>)
#! * From a list of edges: <K>VertexEdgePathByEdges</K>
#!   (<Ref Subsect="VertexEdgePathByEdges"/>)
#! * From a list in which vertices and edges are alternating:
#!   <K>VertexEdgePath</K> (<Ref Subsect="VertexEdgePath"/>)
#! @EndChunk

#! @Section Splitting along a path
#! @SectionLabel Modification_Splitting
#!
#! This section contains the basic functionality for splitting polygonal
#! complexes along edges (<Ref Subsect="SplitEdge"/>) and vertices 
#! (<Ref Subsect="SplitVertex"/>). More generally, it also
#! provides methods to split along
#! vertex-edge-paths (<Ref Subsect="SplitVertexEdgePath"/> and 
#! <Ref Subsect="SplitEdgePath"/>).
#!
#! After splitting one element into several elements the label of the
#! old element is replaced by new labels. The splitting methods always
#! return the new labels to make further modification easier.
#!
#! This will be illustrated on a hexagon.
#! <Alt Only="TikZ">
#!   \input{Image_SplitExample.tex}
#! </Alt>
#! @BeginExampleSession
#! gap> hex := SimplicialSurfaceByDownwardIncidence(
#! >      [ [1,7],[2,7],[3,7],[4,7],[5,7],[6,7],[1,2],[2,3],[3,4],[4,5],[5,6],[1,6] ],
#! >      [ [1,2,7],[2,3,8],[3,4,9],[4,5,10],[5,6,11],[1,6,12] ]);;
#! @EndExampleSession
#!
#! For example it is possible to split the inner edge 1 into two 
#! boundary edges 13 and 14 by <K>SplitEdge</K> (<Ref Subsect="SplitEdge"/>).
#! @BeginExampleSession
#! gap> edgeSplit := SplitEdge(hex, 1);;
#! gap> edgeSplit[2];
#! [ 13, 14 ]
#! @EndExampleSession
#! <Alt Only="TikZ">
#!   {
#!     \def\splitEdge{1}
#!     \input{Image_SplitExample.tex}
#!   }
#! </Alt>
#! Conversely, trying to split a boundary edge, like 7, would have made
#! no difference:
#! @BeginExampleSession
#! gap> boundSplit := SplitEdge(hex, 7);;
#! gap> boundSplit[1] = hex;
#! true
#! @EndExampleSession
#!
#! After the edge split the vertex 1 has two umbrellas (compare
#! <Ref Subsect="UmbrellaPathPartitionsOfVertices"/> for details). These
#! can be split up by <K>SplitVertex</K> (<Ref Subsect="SplitVertex"/>).
#! @BeginExampleSession
#! gap> vertSplit := SplitVertex( edgeSplit[1], 1 );;
#! gap> vertSplit[2];
#! [ 8, 9 ]
#! @EndExampleSession
#! <Alt Only="TikZ">
#!   {
#!     \def\splitBoundaryRight{1}
#!     \input{Image_SplitExample.tex}
#!   }
#! </Alt>
#!
#! These two splitting operations can also be combined by using a 
#! vertex-edge-path (introduced in section 
#! <Ref Sect="Section_Paths_VertexEdge"/>). For example, to cut
#! through the edges 1 and 4 of the hexagon (along with the incident
#! vertices), we can use <K>SplitVertexEdgePath</K> 
#! (<Ref Subsect="SplitVertexEdgePath"/>).
#!
#! The splitting path can be given in multiple ways: via vertices,
#! via edges or by giving an alternating list of both.
#! @BeginExampleSession
#! gap> cutPath := VertexEdgePath(hex, [4,4,7,1,1]);
#! | v4, E4, v7, E1, v1 |
#! gap> VertexEdgePathByVertices(hex, [4,7,1]);
#! | v4, E4, v7, E1, v1 |
#! gap> VertexEdgePathByEdges(hex, [4,1]);
#! | v4, E4, v7, E1, v1 |
#! @EndExampleSession
#! <Alt Only="TikZ">
#!   \input{Image_SplitExample.tex}
#! </Alt>
#! @BeginExampleSession
#! gap> hexCut := SplitVertexEdgePath( hex, cutPath );;
#! gap> NumberOfConnectedComponents(hexCut[1]);
#! 2
#! @EndExampleSession
#TODO check second output
#! <Alt Only="TikZ">
#!   {
#!     \def\splitCenter{1}
#!     \def\splitBoundaryLeft{1}
#!     \def\splitBoundaryRight{1}
#!     \input{Image_SplitExample.tex}
#!   }
#! </Alt>
#!
#! If instead only the central vertex should be splitted (such that the
#! edge split "opens" the surface), the method <K>SplitEdgePath</K>
#! (<Ref Subsect="SplitEdgePath"/>) can be used instead.
#! @BeginExampleSession
#! gap> hexOpen := SplitEdgePath( hex, cutPath );;
#! gap> NumberOfConnectedComponents(hexOpen[1]);
#! 1
#! @EndExampleSession
#TODO check second output
#! <Alt Only="TikZ">
#!   {
#!     \def\splitCenter{1}
#!     \input{Image_SplitExample.tex}
#!   }
#! </Alt>
#!
#! 


#! @BeginGroup SplitEdge
#! @Description
#! Split the given <A>edge</A> in the polygonal complex <A>complex</A> into
#! as many edges as there are faces incident to <A>edge</A>. If there was only
#! one incident face (i.e. the edge is a boundary edge 
#! (<Ref Subsect="BoundaryEdges"/>)) then no labels are
#! changed. Otherwise the old edge label is no longer used and will be
#! replaced by the appropriate number of new labels. The new labels can be
#! defined by the optional argument <A>newEdgeLabels</A>.
#!
#! TODO examples
#!
#! The NC-version does not check whether <A>edge</A> is an actual edge of
#! <A>complex</A> and whether the new edge labels are actually available.
#!
#! @Returns a pair, where the first entry is a polygonal complex and the
#!   second entry is a set of the new edge labels.
#! @Arguments complex, edge[, newEdgeLabels]
DeclareOperation( "SplitEdge", [IsPolygonalComplex, IsPosInt, IsList] );
#! @Arguments complex, edge[, newEdgeLabels]
DeclareOperation( "SplitEdgeNC", [IsPolygonalComplex, IsPosInt, IsList] );
#! @EndGroup


#! @BeginGroup SplitVertex
#! @Description
#! Split the given <A>vertex</A> in the polygonal complex <A>complex</A> into
#! as many vertices as necessary such that the incident faces of the new
#! vertices are connected via the incident edges of these vertices.
#!
#! For a polygonal surface this corresponds to adding one vertex for each
#! element of the umbrella partition 
#! (<Ref Subsect="UmbrellaPathPartitionsOfVertices"/>) of <A>vertex</A>.
#!
#! If the vertex does not have to be split according to this rule (i.e. it is
#! an inner (<Ref Subsect="InnerVertices"/>) or a boundary 
#! (<Ref Subsect="BoundaryVertices"/>) vertex), its
#! label will stay the same. Otherwise the old label will be removed and
#! replaced by new labels. The new labels can be defined by the optional
#! argument <A>newVertexLabels</A>.
#!
#! TODO examples
#!
#! The NC-version does not check whether <A>vertex</A> is an actual vertex of
#! <A>complex</A> and whether the new vertex labels are actually available.
#!
#! @Returns a pair, where the first entry is a polygonal complex and the
#!   second entry is a set of the new vertex labels.
#! @Arguments complex, vertex[, newVertexLabels]
DeclareOperation( "SplitVertex", [IsVEFComplex, IsPosInt, IsList] );
#! @Arguments complex, vertex[, newVertexLabels]
DeclareOperation( "SplitVertexNC", [IsVEFComplex, IsPosInt, IsList] );
#! @EndGroup


#! @BeginGroup SplitVertexEdgePath
#! @Description
#! Split the given <A>complex</A> along the given <A>vePath</A>. First,
#! all edges of the path are splitted by <K>SplitEdge</K> 
#! (<Ref Subsect="SplitEdge"/>), then all vertices of the path are splitted
#! by <K>SplitVertex</K> (<Ref Subsect="SplitVertex"/>). If the first and
#! final vertex of <A>vePath</A> should not be splitted, the method
#! <K>SplitEdgePath</K> (<Ref Subsect="SplitEdgePath"/>) should be used
#! instead. 
#!
#! This method will change the labels of all affected vertices and edges.
#! All other labels remain unchanged.
#!
#! The given <A>vePath</A> has to be a duplicate-free 
#! (<Ref Subsect="VertexEdge_IsDuplicateFree"/>) vertex-edge-path
#! (for the definition see <Ref Subsect="VertexEdgePath"/>) of <A>complex</A>.
#! @InsertChunk VertexEdgePath_Construction
#!
#! This method returns a pair where the first component is the splitted
#! <A>complex</A> and the second one contains the changed labels.
#! The second component is a list of pairs [<A>newPath</A>, <A>oldPath</A>].
#! These are computed as follows: If the original <A>vePath</A> would be 
#! marked in the splitted complex, it would show up as multiple 
#! vertex-edge-paths. Each of those is a <A>newPath</A> and the corresponding
#! <A>oldPath</A> is the unique subpath of the original <A>vePath</A>, such
#! that each element of <A>newPath</A> was obtained from the element at the
#! same position in <A>oldPath</A>.
#!
#! TODO explain better
#!
#! TODO many, many examples
#!
#! The NC-versions do not check whether the given vertex-edge-paths match
#! the given <A>complex</A>.
#!
#! @Returns a pair, where the first entry is a polygonal complex and the
#!   second entry encodes the label changes
#! @Arguments complex, vePath
DeclareOperation( "SplitVertexEdgePath", [IsVEFComplex, IsVertexEdgePath] );
#! @Arguments complex, vePath
DeclareOperation( "SplitVertexEdgePathNC", [IsVEFComplex, IsVertexEdgePath] );
#! @EndGroup


#! @BeginGroup SplitEdgePath
#! @Description
#! Split the given <A>complex</A> along the given <A>vePath</A>. First,
#! all edges of the path are splitted by <K>SplitEdge</K> 
#! (<Ref Subsect="SplitEdge"/>), then all vertices of the path (except first
#! and last) are splitted
#! by <K>SplitVertex</K> (<Ref Subsect="SplitVertex"/>). If the first and
#! final vertex of <A>vePath</A> should also be splitted, the method
#! <K>SplitVertexEdgePath</K> (<Ref Subsect="SplitVertexEdgePath"/>) should
#! be used instead.
#!
#! This method will change the labels of all affected vertices and edges.
#! All other labels remain unchanged.
#!
#! The given <A>vePath</A> has to be a duplicate-free 
#! (<Ref Subsect="VertexEdge_IsDuplicateFree"/>) vertex-edge-path
#! (for the definition see <Ref Subsect="VertexEdgePath"/>) of <A>complex</A>.
#! @InsertChunk VertexEdgePath_Construction
#!
#! This method returns a pair where the first component is the splitted
#! <A>complex</A> and the second one contains the changed labels.
#! The second component is a list of pairs [<A>newPath</A>, <A>oldPath</A>].
#! These are computed as follows: If the original <A>vePath</A> would be 
#! marked in the splitted complex, it would show up as multiple 
#! vertex-edge-paths. Each of those is a <A>newPath</A> and the corresponding
#! <A>oldPath</A> is the unique subpath of the original <A>vePath</A>, such
#! that each element of <A>newPath</A> was obtained from the element at the
#! same position in <A>oldPath</A>.
#!
#! TODO explain better
#!
#! TODO many, many examples
#!
#! The NC-versions do not check whether the given vertex-edge-paths match
#! the given <A>complex</A>.
#!
#! @Returns a pair, where the first entry is a polygonal complex and the
#!   second entry encodes the label changes
#! @Arguments complex, vePath
DeclareOperation( "SplitEdgePath", [IsVEFComplex, IsVertexEdgePath and IsDuplicateFree] );
#! @Arguments complex, vePath
DeclareOperation( "SplitEdgePathNC", [IsVEFComplex, IsVertexEdgePath and IsDuplicateFree] );
#! @EndGroup


#! @Section Removing faces
#! @SectionLabel Modification_FaceRemoval
#!
#! This section contains the functionality to:
#! * remove faces of a polygonal complex
#! * restrict a polygonal complex to a subset of faces
#!
#! TODO nice intro example

#! @BeginGroup SubcomplexByFaces
#! @Description
#! Return the polygonal complex that is generated by restricting 
#! <A>complex</A> to the given set of faces. This will remove all edges
#! and vertices that are not incident to one of the remaining faces.
#!
#! All labels of remaining vertices, edges and faces will remain the same.
#! The method <K>SubsurfaceByFaces</K> is only applicable to surfaces
#! and guarantees that the returned subcomplex is a surface. If this
#! is not possible <K>fail</K> is returned.
#! 
#! TODO example
#!
#! The NC-version does not check whether the given set of <A>faces</A>
#! actually consists only of faces in <A>complex</A>. It also does not
#! check whether the result of <K>SubsurfaceByFaces</K> is a surface.
#! 
#! @Returns a VEF-complex
#! @Arguments complex, faces
DeclareOperation( "SubcomplexByFaces", [IsVEFComplex, IsSet] );
#! @Arguments complex, faces
DeclareOperation( "SubcomplexByFacesNC", [IsVEFComplex, IsSet] );
#! @Returns a VEF-surface
#! @Arguments surface, faces
DeclareOperation( "SubsurfaceByFaces", [IsVEFSurface, IsSet] );
#! @Arguments surface, faces
DeclareOperation( "SubsurfaceByFacesNC", [IsVEFSurface, IsSet] );
#! @EndGroup


#! @BeginGroup RemoveFaces
#! @Description
#! Remove the given faces from <A>complex</A> and return the result. If this
#! removal results in vertices or edges that are not incident to any remaining
#! faces, they will be removed as well.
#! The labels of all remaining vertices, edges and faces
#! will remain unaffected.
#!
#! TODO example
#!
#! The NC-version does not check whether the given set of <A>faces</A> 
#! actually consists only of faces in <A>complex</A>.
#!
#! @Returns a polygonal complex
#! @Arguments complex, faces
DeclareOperation( "RemoveFaces", [IsVEFComplex, IsSet] );
#! @Arguments complex, faces
DeclareOperation( "RemoveFacesNC", [IsVEFComplex, IsSet] );
#! @Arguments complex, face
DeclareOperation( "RemoveFace", [IsVEFComplex, IsPosInt] );
#! @Arguments complex, face
DeclareOperation( "RemoveFaceNC", [IsVEFComplex, IsPosInt] );
#! @EndGroup



#! @Section Disjoint union
#! @SectionLabel Modification_DisjointUnion
#! 
#! This section explains the conventions of disjoint unions 
#! (<Ref Subsect="DisjointUnion"/>) of polygonal
#! complexes. While this might seem trivial at first, its behaviour has
#! to be stated clearly and unambiguously, since all of the joining
#! modifications of section <Ref Sect="Section_Modification_Joining"/> are
#! based on it.
#!
#! To illustrate this, consider the tetrahedron.
#! @BeginExampleSession
#! gap> tetra := Tetrahedron();;
#! @EndExampleSession
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle,edgeStyle,faceStyle]
#!     \input{Image_Tetrahedron_Net.tex}
#!   \end{tikzpicture}
#! </Alt>
#! Both of these tetrahedra have the same labels for vertices, edges and faces.
#! @BeginExampleSession
#! gap> Vertices(tetra);
#! [ 1, 2, 3, 4 ]
#! gap> Edges(tetra);
#! [ 1, 2, 3, 4, 5, 6 ]
#! gap> Faces(tetra);
#! [ 1, 2, 3, 4 ]
#! @EndExampleSession
#! A disjoint union can't just combine these labels because it would not be
#! clear to which component the vertex 2 is belonging. This conflict of labels
#! is a common occurence and has to be handled delicately.
#!
#! The <K>SimplicialSurface</K>-package deals with this problem by uniformly
#! shifting the labels of the second argument.
#! @BeginExampleSession
#! gap> disjoint := DisjointUnion(tetra, tetra);;
#! gap> Vertices( disjoint[1] );
#! [ 1, 2, 3, 4, 7, 8, 9, 10 ]
#! gap> Edges( disjoint[1] );
#! [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ]
#! gap> Faces( disjoint[1] );
#! [ 1, 2, 3, 4, 7, 8, 9, 10 ]
#! @EndExampleSession
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle,edgeStyle,faceStyle]
#!     \begin{scope}
#!        \input{Image_Tetrahedron_Net.tex}
#!     \end{scope}
#!     \begin{scope}[xshift=8cm];
#!        \def\disjoint{1}
#!        \input{Image_Tetrahedron_Net.tex}
#!     \end{scope}
#!   \end{tikzpicture}
#! </Alt>
#! Notably all labels of the second tetrahedron were shifted by the same
#! amount. More precisely they are shifted by the highest label of the
#! first tetrahedron - which is the edge label 6.
#!
#! To be able to use this information in further calculations, the used
#! shift is returned as well.
#! @BeginExampleSession
#! gap> disjoint[2];
#! 6
#! @EndExampleSession
#!


#! @BeginGroup DisjointUnion
#! @Description
#! Return the disjoint union of the given two polygonal complexes.
#! In this process the labels of the second complex usually are shifted.
#! The default shift is determined by this procedure:
#! <Enum>
#!   <Item>If the labels of vertices, edges and faces do not overlap,
#!      the second labels do not need to be shifted. The default shift
#!      is 0.</Item>
#!   <Item>Otherwise the labels of the second complex are shifted by
#!      the highest label of the first complex - which may be the label
#!      of a vertex, an edge or a face.</Item>
#! </Enum>
#! If the optional <A>shift</A> is higher than the default shift, it will
#! be used instead. Otherwise it will be ignored.
#! 
#! All labels of the second complex are shifted upwards by the same amount,
#! even if it would not be necessary to shift all of them that much to make
#! the labels disjoint.
#!       
#! TODO example different from the one before?
#!
#! @Returns a pair, where the first entry is a polygonal complex and the
#!   second entry is the used shift
#! @Arguments complex1, complex2[, shift]
DeclareOperation( "DisjointUnion", [IsVEFComplex, IsVEFComplex, IsInt] );
#! @EndGroup



#! @Section Joining along a path
#! @SectionLabel Modification_Joining
#!
#! This section contains the basic functionality for joining polygonal 
#! complexes along vertices and edges and more generally along
#! vertex-edge-paths (for their definition, compare
#! <Ref Subsect="VertexEdgePath"/>). More specifically the following
#! operations are supported:
#! * Identifying two vertices (<Ref Subsect="JoinVertices"/>)
#! * Identifying two edges (<Ref Subsect="JoinEdges"/>)
#! * Identifying two vertex-edge-paths (<Ref Subsect="JoinVertexEdgePaths"/>)
#! * Identifying the perimeters of two boundaries/holes 
#!   (<Ref Subsect="JoinBoundaries"/>)
#!
#! 
#! TODO examples + Tests

#! @BeginGroup JoinVertices
#! @Description
#! Combine two vertices into one. This method comes in two flavors:
#! <Enum>
#!   <Item>Combine two vertices <A>v1</A> and <A>v2</A> of a single
#!      polygonal complex <A>complex</A> into one. This will return
#!      <K>fail</K> if the vertices are incident to a common face.
#!
#!      The optional argument <A>newVertexLabel</A> allows to set the
#!      label of the new vertex. By default, an unused label will be
#!      chosen.</Item>
#!   <Item>Combine two vertices <A>v1</A> and <A>v2</A> of two distinct
#!      polygonal complexes <A>complex1</A> and <A>complex2</A>. This will
#!      perform <K>DisjointUnion</K> (<Ref Subsect="DisjointUnion"/>) on
#!      the two complexes to reduce this problem to the first case.</Item>
#! </Enum>
#!
#! Both methods return a list, where the first entry is the new polygonal
#! complex, the second entry is the label of the new vertex and (only in the
#! second case) the third entry is the used shift of the disjoint union (refer
#! to section <Ref Sect="Section_Modification_DisjointUnion"/> for details).
#!
#! To illustrate the first case, consider the octahedron.
#! @BeginExampleSession
#! gap> octa := Octahedron();;
#! @EndExampleSession
#! <Alt Only="TikZ">
#!   \input{_TIKZ_Octahedron_constructor.tex}
#! </Alt>
#! It is possible to join vertices on opposite sides, for example 1 and 6.
#! @BeginExampleSession
#! gap> octJoin := JoinVertices(octa, 1, 6);;
#! gap> octJoin = fail;
#! false
#! @EndExampleSession
#! This combines the vertices 1 and 6 into a new one, which becomes a 
#! ramified vertex (<Ref Subsect="RamifiedVertices"/>).
#! @BeginExampleSession
#! gap> octJoin[2];
#! 7
#! gap> Vertices(octJoin[1]);
#! [ 2, 3, 4, 5, 7 ]
#! gap> RamifiedVertices(octJoin[1]);
#! [ 7 ]
#! @EndExampleSession
#! On the other hand, it is not possible to join two vertices if they are 
#! connected by an edge.
#! @BeginExampleSession
#! gap> JoinVertices(octa, [2,3]);
#! fail
#! @EndExampleSession
#!
#! To illustrate the second case, consider the following two simplicial
#! surfaces:
#! @BeginExampleSession
#! gap> leftWing := SimplicialSurfaceByVerticesInFaces( [[1,2,3],[2,3,4],,[3,4,5]] );;
#! @EndExampleSession
#! <Alt Only="TikZ">
#!   {
#!     \def\leftWing{1}
#!     \input{Image_Butterfly_unbalanced.tex}
#!   }
#! </Alt>
#! @BeginExampleSession
#! gap> rightWing := SimplicialSurfaceByVerticesInFaces( [[1,2,3],[2,3,4]] );;
#! @EndExampleSession
#! <Alt Only="TikZ">
#!   {
#!     \def\rightWing{1}
#!     \input{Image_Butterfly_unbalanced.tex}
#!   }
#! </Alt>
#! If these two surfaces are joined along the vertices 3 (of the left wing) and
#! 2 (of the right wing), the labels of the second one have to be shifted.
#! @BeginExampleSession
#! gap> butterfly := JoinVertices(leftWing, 3, rightWing, 2);;
#! gap> butterfly[3];
#! 7
#! @EndExampleSession
#! <Alt Only="TikZ">
#!   {
#!     \def\leftWing{1}
#!     \def\rightWing{1}
#!     \input{Image_Butterfly_unbalanced.tex}
#!   }
#! </Alt>
#! @BeginExampleSession
#! gap> butterfly[2];
#! 12
#! @EndExampleSession
#!
#! The NC-versions don't check whether the given vertices are distinct vertices of
#! the corresponding complexes and whether the <A>newVertexLabel</A> is available.
#!
#! @Returns a list, where the first entry is a polygonal complex, the second
#!   one is the new vertex label and the third is the shift for the labels of
#!   the second input <A>complex2</A> (only if applicable).
#! @Arguments complex, v1, v2[, newVertexLabel]
DeclareOperation( "JoinVertices", [IsVEFComplex, IsPosInt, IsPosInt, IsPosInt] );
#! @Arguments complex, v1, v2[, newVertexLabel]
DeclareOperation( "JoinVerticesNC", [IsVEFComplex, IsPosInt, IsPosInt, IsPosInt] );
#! @Arguments complex, vertexList[, newVertexLabel]
DeclareOperation( "JoinVertices", [IsVEFComplex, IsList, IsPosInt] );
#! @Arguments complex, vertexList[, newVertexLabel]
DeclareOperation( "JoinVerticesNC", [IsVEFComplex, IsList, IsPosInt] );
#! @Arguments complex1, v1, complex2, v2
DeclareOperation( "JoinVertices", [IsVEFComplex, IsPosInt, IsVEFComplex, IsPosInt] );
#! @Arguments complex1, v1, complex2, v2
DeclareOperation( "JoinVerticesNC", [IsVEFComplex, IsPosInt, IsVEFComplex, IsPosInt] );
#! @EndGroup


#! @BeginGroup JoinEdges
#! @Description
#! Combine two edges <A>e1</A> and <A>e2</A> of a polygonal complex into one
#! edge, whose new label can be given by the optional argument 
#! <A>newEdgeLabel</A> (otherwise a default label is chosen). The edges have 
#! to have had the same incident vertices.
#! 
#! This method returns a pair, where the first entry is the modified polygonal
#! complex and the second entry is the label of the new edge.
#!
#! For example consider the following triangular complex without edge
#! ramifications:
#! @BeginExampleSession
#! gap> eye := TriangularComplexByDownwardIncidence(
#! >     [[1,2],[2,3],[1,3],[2,4],[3,4],[2,3]], [[1,2,3],[4,5,6]]);;
#! @EndExampleSession
#! <Alt Only="TikZ">
#!   {
#!     \def\open{1}
#!     \input{Image_Eye_OpenClosed.tex}
#!   }
#! </Alt>
#! The only edges that can be joined are those with equal incident vertices.
#! These can be found by <K>EdgeAnomalyClasses</K> 
#! (<Ref Subsect="EdgeAnomalies"/>).
#! @BeginExampleSession
#! gap> EdgeAnomalyClasses(eye);
#! [ [ 1 ], [ 2, 6 ], [ 3 ], [ 4 ], [ 5 ] ]
#! @EndExampleSession
#! The only pair of edges with the same incident vertices are 2 and 6.
#! @BeginExampleSession
#! gap> closeEye := JoinEdges( eye, 2, 6 );;
#! gap> closeEye[2];
#! 7
#! @EndExampleSession
#! <Alt Only="TikZ">
#!     \input{Image_Eye_OpenClosed.tex}
#! </Alt>
#! @BeginExampleSession
#! gap> EdgeAnomalyClasses(closeEye[1]);
#! [ [ 1 ], [ 3 ], [ 4 ], [ 5 ], [ 7 ] ]
#! @EndExampleSession
#!
#! The NC-versions do not check whether the given edges are distinct edges
#! with the same incident vertices of <A>complex</A> and whether the new edge label is
#! actually valid.
#!
#! @Returns a pair, where the first entry is a polygonal complex and the
#!    second one is the new edge label
#! @Arguments complex, e1, e2[, newEdgeLabel]
DeclareOperation("JoinEdges", [IsVEFComplex, IsPosInt, IsPosInt, IsPosInt]);
#! @Arguments complex, e1, e2[, newEdgeLabel]
DeclareOperation("JoinEdgesNC", [IsVEFComplex, IsPosInt, IsPosInt, IsPosInt]);
#! @Arguments complex, edgeList[, newEdgeLabel]
DeclareOperation("JoinEdges", [IsVEFComplex, IsList, IsPosInt]);
#! @Arguments complex, edgeList[, newEdgeLabel]
DeclareOperation("JoinEdgesNC", [IsVEFComplex, IsList, IsPosInt]);
#! @EndGroup


#! @BeginGroup JoinVertexEdgePaths
#! @Description
#! Combine two duplicate-free (<Ref Subsect="VertexEdge_IsDuplicateFree"/>) 
#! vertex-edge-paths (<Ref Subsect="VertexEdgePath"/>) of equal length 
#! into
#! one. This is done by first joining the corresponding vertices by
#! <K>JoinVertices</K> (<Ref Subsect="JoinVertices"/>) and then identifying
#! the corresponding edges with <K>JoinEdges</K> (<Ref Subsect="JoinEdges"/>).
#! If two polygonal complexes are given, they are combined with 
#! <K>DisjointUnion</K> (<Ref Subsect="DisjointUnion"/>) before these
#! identifications take place.
#!
#! If some of the vertices can't be identified because they are incident
#! to the same edge, <K>fail</K> is returned. Otherwise this method returns a
#! pair, where the first entry is a polygonal complex and the second one
#! is the vertex-edge-path in the new polygonal complex that was generated
#! by the identified vertex-edge-paths.
#!
#! One thing that can be done is the construction of a ramified edge. 
#! Consider just one triangle:
#! @BeginExampleSession
#! gap> triangle := SimplicialSurfaceByDownwardIncidence( [[1,2],[1,3],[2,3]],[[1,2,3]] );;
#! @EndExampleSession
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle,edgeStyle,faceStyle]
#!     \def\len{3}
#!     \coordinate (L) at (0,0);
#!     \coordinate (R) at (\len,0);
#!     \coordinate (U) at (60:\len);
#!
#!     \draw[edge,face] (L) -- node[edgeLabel]{1} (R) -- node[edgeLabel]{3} (U) -- node[edgeLabel]{2} cycle;
#!     \node[faceLabel] at (barycentric cs:L=1,R=1,U=1){I};
#!     \foreach \p/\r/\n in {L/left/1,R/right/2,U/above/3}{
#!       \vertexLabelR{\p}{\r}{\n}
#!     }
#!   \end{tikzpicture}
#! </Alt>
#! First we combine two of them:
#! @BeginExampleSession
#! gap> joinPath := VertexEdgePathByVertices(triangle, [1,2]);
#! | v1, E1, v2 |
#! gap> join := JoinVertexEdgePaths(triangle, joinPath, triangle, joinPath);;
#! gap> join[2];
#! | v7, E7, v8 |
#! @EndExampleSession
#! Along this vertex-edge-path another of the triangles can be added:
#! @BeginExampleSession
#! gap> tripleJoin := JoinVertexEdgePaths(join[1],join[2],triangle,joinPath);;
#! gap> tripleJoin[2];
#! | v12, E12, v13 |
#! gap> RamifiedEdges(tripleJoin[1]);
#! [ 12 ]
#! @EndExampleSession
#! 
#! The NC-versions do not check whether the given vertex-edge-paths are
#! actually vertex-edge-paths of the polygonal complexes.
#! 
#! @Returns a pair, where the first entry is a polygonal complex and the
#!   second entry is a vertex-edge-path. The optional third entry describes
#!   the label shift of <A>complex2</A> (if applicable).
#! @Arguments complex, vePath1, vePath2
DeclareOperation("JoinVertexEdgePaths", [IsVEFComplex, 
    IsVertexEdgePath and IsDuplicateFree, 
    IsVertexEdgePath and IsDuplicateFree]);
#! @Arguments complex, vePath1, vePath2
DeclareOperation("JoinVertexEdgePathsNC", [IsVEFComplex, 
    IsVertexEdgePath and IsDuplicateFree, 
    IsVertexEdgePath and IsDuplicateFree]);
#! @Arguments complex1, vePath1, complex2, vePath2
DeclareOperation("JoinVertexEdgePaths", 
    [IsVEFComplex, IsVertexEdgePath and IsDuplicateFree, 
    IsVEFComplex, IsVertexEdgePath and IsDuplicateFree]);
#! @Arguments complex1, vePath1, complex2, vePath2
DeclareOperation("JoinVertexEdgePathsNC", 
    [IsVEFComplex, IsVertexEdgePath and IsDuplicateFree, 
    IsVEFComplex, IsVertexEdgePath and IsDuplicateFree]);
#! @EndGroup


#TODO allow more options here, NC-versions
#! @BeginGroup JoinBoundaries
#! @Description
#! Combine two boundaries into one. This method takes the starts of two
#! vertex-edge-paths (<Ref Subsect="VertexEdgePath"/>) and extends those
#! into vertex-edge-paths along the boundary of the given polygonal surfaces.
#! Then the method <K>JoinVertexEdgePaths</K> 
#! (<Ref Subsect="JoinVertexEdgePaths"/>) will be called on these 
#! vertex-edge-paths.
#!
#! If two surfaces should be combined, <K>DisjointUnion</K> 
#! (<Ref Subsect="DisjointUnion"/>) will be
#! called beforehand.
#!
#! Currently the <A>veList</A> has to be given as a list
#! [<A>vertex</A>, <A>edge</A>].
#!
#! For example, consider the following simplicial surface:
#! <Alt Only="TikZ">
#!  \begin{tikzpicture}[vertexStyle,edgeStyle,faceStyle]
#!      \def\len{2.5}
#!      \coordinate (Z) at (0,0);
#!      \foreach \i in {0,1,2,3}{
#!          \coordinate (P\i) at (45+90*\i:\len);
#!      }
#!
#!      \draw[edge,face]
#!          (Z) -- (P0) -- node[edgeLabel]{5} (P1) -- cycle
#!          (Z) -- node[edgeLabel]{2} (P1) -- node[edgeLabel]{6} (P2) -- cycle
#!          (Z) -- node[edgeLabel]{3} (P2) -- node[edgeLabel]{7} (P3) -- cycle
#!          (Z) -- node[edgeLabel]{4} (P3) -- node[edgeLabel]{8} (P0) -- node[edgeLabel]{1} cycle;
#!
#!      \foreach \p/\q/\n in {0/1/I, 1/2/II, 2/3/III, 3/0/IV}{
#!          \node[faceLabel] at (barycentric cs:Z=1,P\p=1,P\q=1) {\n};
#!      }
#!  
#!      \foreach \p/\r/\n in {Z/right/1, P0/right/2, P1/above/3, P2/left/4, P3/below/5}{
#!          \vertexLabelR{\p}{\r}{\n}
#!      }
#!  \end{tikzpicture}
#! </Alt>
#! @BeginExampleSession
#! gap> fourGon := SimplicialSurfaceByDownwardIncidence(
#! >        [[1,2],[1,3],[1,4],[1,5],[2,3],[3,4],[4,5],[2,5]], 
#! >         [[1,2,5],[2,3,6],[3,4,7],[1,4,8]] );;
#! @EndExampleSession
#!
#! Combining two of these along their boundaries gives the octahedron.
#! @BeginExampleSession
#! gap> oct := JoinBoundaries(fourGon, [3,6], fourGon, [4,7]);;
#! gap> IsIsomorphic(oct[1], Octahedron());
#! true
#! @EndExampleSession
#!
#! @Returns a list, where the first entry is a polygonal surface, the
#!   second one is a vertex-edge-path and the third one is the label
#!   shift of <A>complex2</A> (if applicable).
#! @Arguments surface, veList1, veList2
DeclareOperation( "JoinBoundaries", [IsVEFSurface, IsList, IsList] );
#! @Arguments surface1, veList1, surface2, veList2
DeclareOperation( "JoinBoundaries", [IsVEFSurface, IsList, IsVEFSurface, IsList] );
#! @EndGroup


#! @Section Specific modifications
#! @SectionLabel Modification_Applications
#! 
#! This section contains some specific modifications that are generally 
#! useful. To illustrate the power of the modification toolbox that was
#! developed in the previous sections, the fundamental code for each
#! of them is presented as well. To make seeing the underlying structure
#! easier, this code will not consider border cases or check its inputs
#! for validity.
#!
#! 

#! @BeginGroup ConnectedFaceSum
#! @Description
#! Compute the <E>connected face-sum</E> of two polygonal surfaces.
#! The connected face-sum identifies the faces of two polygonal surfaces
#! and removes them afterwards. The edges of the identified faces can't
#! be boundary edges (<Ref Subsect="BoundaryEdges"/>), otherwise <K>fail</K>
#! is returned.
#!
#! Since there are six different ways how the two faces could be identified,
#! this methods needs a flag of each complex, i.e. a list of a vertex, an edge
#! and a face that are all incident.
#!
#! TODO example (important since otherwise it might seem that this method is not implemented);
#!
#! The central part of this can be implemented like this:
#! @BeginLogSession
#! gap> rem1 := RemoveFace( surface1, flag1[3] );
#! gap> rem2 := RemoveFace( surface2, flag2[3] );
#! gap> conSum := JoinBoundaries(rem1, flag1{[1,2]}, rem2, flag2{[1,2]})[1];
#! @EndLogSession
#!
#! @Returns a polygonal surface or <K>fail</K>
#! @Arguments surface1, flag1, surface2, flag2
DeclareOperation( "ConnectedFaceSum", [IsVEFSurface, IsList, IsVEFSurface, IsList] );
#! @EndGroup
#TODO can this be implemented more generally?


#! @Description
#! Remove all "ears" of the given simplicial surface, i.e. all pairs of faces
#! that share two edges. The resulting edge anomaly is also fixed by
#! identifying the edges.
#!
#! TODO example
#!
#! For a given face-anomaly [<A>face1</A>, <A>face2</A>] this could be
#! implemented like this:
#! @BeginLogSession
#! gap> commonEdges := Intersection( 
#! >          EdgesOfFace(surface,face1), EdgesOfFace(surface,face2) );
#! gap> edge1 := Difference( EdgesOfFace(surface,face1), commonEdges )[1];
#! gap> edge2 := Difference( EdgesOfFace(surface,face2), commonEdges )[1];
#! gap> rem := RemoveFaces(surface, [face1, face2]);
#! gap> snipp := JoinEdges(rem, edge1, edge2)[1];
#! @EndLogSession
#!
#! @Returns a simplicial surface
#! @Arguments surface
DeclareOperation( "SnippOffEars", [IsSimplicialSurface] );


#! @Description
#! Split all vertices of the given polygonal complex via <K>SplitVertex</K>
#! (<Ref Subsect="SplitVertex"/>). For polygonal complexes without edge 
#! ramifications
#! (<Ref Sect="IsNotEdgeRamified"/>) this is equivalent to
#! splitting all ramified vertices (<Ref Subsect="RamifiedVertices"/>). In
#! this case a polygonal surface will be returned.
#!
#! TODO example
#!
#! @Returns a polygonal complex
#! @Arguments complex
DeclareOperation("SplitAllVertices", [IsVEFComplex]);


#TODO maybe move into chapter ExampleApplications?
#! @Section Example: Cut and Mend
#! @SectionLabel Modification_CutMend
#!
#! While the previous sections talked about general modifications and some
#! often-used modifications, this section shows how these tools could be used
#! in practice. After introducing some modifications of theoretical value it
#! is shown how they could be implemented with the help from the package.
#! 
#! Specifically this concerns the following operations (for polygonal surfaces):
#! <Enum>
#!   <Item><K>CraterCut</K> (<Ref Subsect="CraterCut"/>): For an inner edge 
#!      (<Ref Subsect="InnerEdges"/>) 
#!      with two
#!      incident inner vertices (<Ref Subsect="InnerVertices"/>), split the
#!      edge in two (while leaving the vertices intact).
#!
#!      The inverse operation is the <K>CraterMend</K>
#!      (<Ref Subsect="CraterMend"/>).</Item>
#!   <Item><K>RipCut</K> (<Ref Subsect="RipCut"/>): For an inner edge 
#!      (<Ref Subsect="InnerEdges"/>), 
#!      where one of the incident vertices is an inner vertex 
#!      (<Ref Subsect="InnerVertices"/>) and one is a boundary vertex
#!      (<Ref Subsect="BoundaryVertices"/>), split the edge and the boundary
#!      vertex.
#!
#!      The inverse operation is the <K>RipMend</K>
#!      (<Ref Subsect="RipMend"/>).</Item>
#!   <Item><K>SplitCut</K> (<Ref Subsect="SplitCut"/>): For an inner edge 
#!      with two incident boundary
#!      vertices (<Ref Subsect="BoundaryVertices"/>), split the edge and
#!      both incident vertices in two.
#!
#!      The inverse operation is the <K>SplitMend</K>
#!      (<Ref Subsect="SplitMend"/>).</Item>
#! </Enum>
#!
#! Besides the actual modification it is also important to have some function
#! available that checks if the conditions are fulfilled.
#!
#! Each of these six operations has their own manual entry with a code 
#! snippet. These code snippets could be put into a file <E>CutMend.g</E>
#! and read into an active &GAP;-session by 
#! @BeginLogSession
#! gap> Read("CutMend.g");
#! @EndLogSession
#! While this is not necessary for the concrete methods in this section, this
#! would be the method of choice for used-defined modifications.

#! @BeginGroup CraterCut
#! @Description
#! Every inner edge (<Ref Subsect="InnerEdges"/>) whose incident vertices are
#! both inner vertices (<Ref Subsect="InnerVertices"/>) can be split into
#! two boundary edges by a
#! <K>CraterCut</K>. The attribute 
#! <K>CraterCuttableEdges</K>(<A>complex</A>) returns the set of all 
#! edges that fulfill these conditions.
#!
#! TODO example
#!
#! This could be implemented like this:
#! @BeginExampleSession
#! gap> CraterCuttableEdges_custom := function(complex)
#! >      return Filtered( InnerEdges(complex),
#! >         e -> ForAll( VerticesOfEdges(complex)[e], 
#! >            v -> IsInnerVertexNC(complex,v) ) );
#! >    end;
#! function( complex ) ... end
#! gap> CraterCut_custom := function(complex, edge)
#! >       if not edge in CraterCuttableEdges_custom(complex) then
#! >         Error("Given edge has to be crater-cuttable");
#! >       fi;
#! >       
#! >       return SplitEdge(complex, edge)[1];
#! >    end;
#! function( complex, edge ) ... end
#! @EndExampleSession
#!
#! @Returns a polygonal complex
#! @Arguments complex, edge
DeclareOperation( "CraterCut", [IsPolygonalComplex, IsPosInt] );
#! @Returns a set of positive integers
#! @Arguments complex
DeclareAttribute( "CraterCuttableEdges", IsPolygonalComplex );
#! @EndGroup

#! @BeginGroup CraterMend
#! @Description
#! Every pair of boundary edges (<Ref Subsect="BoundaryEdges"/>) with the
#! same incident vertices, that also are boundary vertices 
#! (<Ref Subsect="BoundaryVertices"/>), can be joined into one inner edge
#! by a <K>CraterMend</K>. The attribute 
#! <K>CraterMendableEdgePairs</K>(<A>complex</A>) returns the set of all
#! edge pairs that fulfill these conditions.
#!
#! TODO example
#!
#! This could be implemented like this:
#! @BeginExampleSession
#! gap> CraterMendableEdgePairs_custom := function(complex)
#! >        local edgeAnom, edgePairs;
#! > 
#! >        edgeAnom := List( EdgeAnomalyClasses(complex), 
#! >            cl -> Filtered( cl, 
#! >                e -> IsBoundaryEdgeNC(complex, e) and 
#! >                    ForAll( VerticesOfEdges(complex)[e], 
#! >                        v -> IsBoundaryVertexNC(complex, v) ) ) );
#! >        edgePairs := Combinations(edgeAnom, 2);
#! >        return Union(edgePairs);
#! >    end;
#! function( complex ) ... end
#! gap> CraterMend_custom := function(complex, edgePair)
#! >        if not Set(edgePair) in CraterMendableEdgePairs_custom(complex) then
#! >            Error("Given edge-pair has to be crater-mendable.");
#! >        fi;
#! >        return JoinEdgesNC(complex, edgePair)[1];
#! >    end;
#! function( complex, edgePair ) ... end
#! @EndExampleSession
#!
#! @Returns a polygonal complex
#! @Arguments complex, edgePair
DeclareOperation( "CraterMend", [IsPolygonalComplex, IsList] );
#! @Returns a set of edge pairs
#! @Arguments complex
DeclareAttribute( "CraterMendableEdgePairs", IsPolygonalComplex );
#! @EndGroup


#! @BeginGroup RipCut
#! @Description
#! For every inner edge (<Ref Subsect="InnerEdges"/>) where one incident vertex
#! is an inner vertex (<Ref Subsect="InnerVertices"/>) and one is a boundary
#! vertex (<Ref Subsect="BoundaryVertices"/>) a <E>rip cut</E> can be 
#! performed. In doing so, the edge and the boundary vertex are split in two.
#! The attribute <K>RipCuttableEdges</K>(<A>complex</A>) returns a set of all
#! edges with these properties.
#!
#! TODO example
#!
#! This could be implemented like this:
#! @BeginExampleSession
#! gap> RipCuttableEdges_custom := function(complex)
#! >        local CheckInnerBound;
#! >    
#! >        CheckInnerBound := function(e)
#! >            local verts;
#! >    
#! >            verts := VerticesOfEdges(complex)[e];
#! >            return ( IsInnerVertexNC(complex, verts[1]) and 
#! >                        IsBoundaryVertexNC(complex, verts[2]) ) 
#! >                or ( IsInnerVertexNC(complex, verts[2]) and 
#! >                        IsBoundaryVertexNC(complex, verts[1]) );
#! >        end;
#! >        return Filtered(InnerEdges(complex), CheckInnerBound );
#! >    end;
#! function( complex ) ... end
#! gap> RipCut_custom := function(complex, edge)
#! >        if not edge in RipCuttableEdges_custom(complex) then
#! >            Error("Given edge has to be rip-cuttable.");
#! >        fi;
#! >        return SplitVertexEdgePathNC(complex, VertexEdgePathByEdgesNC(complex, [edge]))[1];
#! >    end;
#! function( complex, edge ) ... end
#! @EndExampleSession
#! 
#! @Returns a polygonal complex
#! @Arguments complex, edge
DeclareOperation( "RipCut", [IsPolygonalComplex, IsPosInt] );
#! @Returns a set of edges
#! @Arguments complex
DeclareAttribute( "RipCuttableEdges", IsPolygonalComplex );
#! @EndGroup


#! @BeginGroup RipMend
#! @Description
#! Every pair of boundary edges (<Ref Subsect="BoundaryEdges"/>) that has
#! exactly one boundary vertex (<Ref Subsect="BoundaryVertices"/>) and no
#! other vertex in common, can be joined by a <K>RipMend</K>. The 
#! attribute <K>RipMendableEdgePairs</K>(<A>complex</A>) returns the set of
#! all edge pairs that fulfill these conditions.
#!
#! If the joined vertices are connected by an edge, the mend can not be
#! performed and <K>fail</K> will be returned.
#!
#! TODO examples
#!
#! This could be implemented like this:
#! @BeginExampleSession
#! gap> RipMendableEdgePairs_custom := function(complex)
#! >        local pairs, v, boundEdges, edgePairs;
#! >    
#! >        pairs := [];
#! >        for v in BoundaryVertices(complex) do
#! >            boundEdges := Filtered( EdgesOfVertices(complex)[v], 
#! >                e -> IsBoundaryEdgeNC(complex, e) );
#! >            edgePairs := Combinations(boundEdges, 2);
#! >            Append(pairs, Filtered(edgePairs, p -> 
#! >                OtherVertexOfEdgeNC(complex,v,p[1]) <> 
#! >                OtherVertexOfEdgeNC(complex,v,p[2])));
#! >        od;
#! >    
#! >        return Set(pairs);
#! >    end;
#! function( complex ) ... end
#! gap> RipMend_custom := function(complex, edgePair)
#! >        local commonVertex, path1, path2, join;
#! > 
#! >        if not edgePair in RipMendableEdgePairs(complex) then
#! >            Error("Given edge-pair has to be rip-mendable.");
#! >        fi;
#! >        commonVertex := Intersection( 
#! >            VerticesOfEdge(complex, edgePair[1]), 
#! >            VerticesOfEdge(complex, edgePair[2]) )[1];
#! >        path1 := VertexEdgePathNC(complex, [commonVertex, edgePair[1], 
#! >                OtherVertexOfEdgeNC(complex, commonVertex, edgePair[1])]);
#! >        path2 := VertexEdgePathNC(complex, [commonVertex, edgePair[2], 
#! >                OtherVertexOfEdgeNC(complex, commonVertex, edgePair[2])]);
#! >        join := JoinVertexEdgePathsNC(complex, path1, path2);
#! >        if join = fail then
#! >            return fail;
#! >        else
#! >            return join[1];
#! >        fi;
#! >    end;
#! function( complex, edgePair ) ... end
#! @EndExampleSession
#!
#! @Returns a polygonal complex or <K>fail</K>
#! @Arguments complex, edgePair
DeclareOperation( "RipMend", [IsPolygonalComplex, IsList] );
#! @Returns a set of edge pairs
#! @Arguments complex
DeclareAttribute( "RipMendableEdgePairs", IsPolygonalComplex );
#! @EndGroup


#! @BeginGroup SplitCut
#! @Description
#! Any inner edge (<Ref Subsect="InnerEdges"/>) with two incident
#! boundary vertices (<Ref Subsect="InnerVertices"/>) can be splitted
#! into two boundary edges by a <K>SplitCut</K>. The attribute
#! <K>SplitCuttableEdges</K>(<A>complex</A>) returns the set of all edges
#! satisfying this property.
#!
#! TODO example
#!
#! This could be implemented like this:
#! @BeginExampleSession
#! gap> SplitCuttableEdges_custom := function(complex)
#! >        return Filtered(InnerEdges(complex), 
#! >            e -> ForAll(VerticesOfEdges(complex)[e], 
#! >                v -> IsBoundaryVertexNC(complex, v)));
#! >    end;
#! function( complex ) ... end
#! gap> SplitCut_custom := function(complex, edge)
#! >        if not edge in SplitCuttableEdges_custom(complex) then
#! >            Error("Given edge has to be split-cuttable.");
#! >        fi;
#! >        return SplitVertexEdgePathNC(complex, VertexEdgePathByEdgesNC(complex, [edge]))[1];
#! >    end;
#! function( complex, edge ) ... end
#! @EndExampleSession
#! 
#! @Returns a polygonal complex
#! @Arguments complex, edge
DeclareOperation( "SplitCut", [IsPolygonalComplex, IsPosInt] );
#! @Returns a set of edges
#! @Arguments complex
DeclareAttribute( "SplitCuttableEdges", IsPolygonalComplex );
#! @EndGroup

#! @BeginGroup SplitMend
#! @Description
#! Two boundary edges (<Ref Subsect="BoundaryEdges"/>) with no shared
#! vertices can be joined by <K>SplitMend</K>. For this operation to
#! be well-defined two vertices of these edges that should be combined 
#! have to be
#! given as well. The attribute 
#! <K>SplitMendableFlagPairs</K>(<A>complex</A>) returns the set of
#! all pairs of vertex-edge-flags (<Ref Subsect="VertexEdgeFlags"/>)
#! that fulfill the above conditions.
#!
#! If two given flags can't be joined (because two vertices that should
#! be joined are connected by an edge), <K>fail</K> is returned.
#!
#! TODO examples
#!
#! This could be implemented like this:
#! @BeginExampleSession
#! gap> SplitMendableFlagPairs_custom := function( complex )
#! >        local boundPairs, flagPairs, verts1, verts2, pair;
#! >    
#! >        flagPairs := [];
#! >        boundPairs := Combinations( BoundaryEdges(complex), 2 );
#! >        for pair in boundPairs do
#! >            verts1 := VerticesOfEdges(complex)[pair[1]];
#! >            verts2 := VerticesOfEdges(complex)[pair[2]];
#! >            if IsEmpty(Intersection(verts1, verts2)) then
#! >                Append( flagPairs, [ 
#! >                    Set( [ [ verts1[1], pair[1] ], [ verts2[1], pair[2] ] ] ),
#! >                    Set( [ [ verts1[1], pair[1] ], [ verts2[2], pair[2] ] ] ),
#! >                    Set( [ [ verts1[2], pair[1] ], [ verts2[1], pair[2] ] ] ),
#! >                    Set( [ [ verts1[2], pair[1] ], [ verts2[2], pair[2] ] ] )] );
#! >            fi;
#! >        od;
#! >    
#! >        return Set(flagPairs);
#! >    end;
#! function( complex ) ... end
#! gap> SplitMend_custom := function( complex, flagPair )
#! >        local path1, path2, join;
#! >    
#! >        if not flagPair in SplitMendableFlagPairs(complex) then
#! >            Error("Given flag-pair has to be split-mendable");
#! >        fi;
#! >    
#! >        path1 := VertexEdgePathNC(complex, [ flagPair[1][1], flagPair[1][2],
#! >            OtherVertexOfEdgeNC(complex, flagPair[1][1], flagPair[1][2])]);
#! >        path2 := VertexEdgePathNC(complex, [ flagPair[2][1], flagPair[2][2],
#! >            OtherVertexOfEdgeNC(complex, flagPair[2][1], flagPair[2][2])]);
#! >        join := JoinVertexEdgePathsNC(complex, path1, path2);
#! >        if join = fail then
#! >            return fail;
#! >        else
#! >            return join[1];
#! >        fi;
#! >    end;
#! function( complex, flagPair ) ... end
#! @EndExampleSession
#!
#! @Returns a polygonal complex or <K>fail</K>
#! @Arguments complex, flagPair
DeclareOperation( "SplitMend", [IsPolygonalComplex, IsList] );
#! @Returns a set of vertex-edge-flag pairs
#! @Arguments complex
DeclareAttribute( "SplitMendableFlagPairs", IsPolygonalComplex );
#! @EndGroup


# These do not fit the above pattern:
# CommonCover       -> does not fit here at all -> chapter Coverings (or only as a section in chapter "Associated Complexes" that also includes DualSurface?)
# AddVertexIntoEdge (and the rest of Jesse's stuf) -> subdivision section?

