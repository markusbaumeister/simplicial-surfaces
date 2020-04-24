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

#! @Chapter Edge isosceles-colourings
#! @ChapterLabel EdgeIsoscelesColouring
#! 
#! In chapter <Ref Chap="Chapter_EdgeColouring"/> the concept of edge 
#! colourings was introduced in general. This chapter is concerned with
#! a specific type of edge colourings, namely isosceles colourings.
#! For an isosceles colouring we colour the edges of a surface in
#! two colours, one which we call the <i>leg</i> colour and one we
#! call the <i>base</i> colour. The edges of every face are coloured 
#! such that two edges are coloured in the leg colour and one
#! in the base colour.
#!
#! In section <Ref Sect="Section_EdgeIsoscelesColouring_Definition"/> 
#! the concept of the edge isosceles-colouring is defined. In addition,
#! some access
#! functions made possible by the colouring are described.
#!
#! Section <Ref Sect="Section_EdgeIsoscelesColouring_Permutations"/> represents
#! the edge isosceles-colouring of simplicial surfaces
#! as permutations, the
#! <K>ColourInvolutions</K> (<Ref Subsect="ColourInvolutions"/>).
#!
#! After these general properties, section 
#! <Ref Sect="Section_EdgeIsoscelesColouring_Wild"/> deals with a special
#! subclass of a vari-colouring: <E>edge two-colourings</E>, in
#! which the number of colours is minimal (for example, in a simplicial 
#! surface there can only be three colours). It describes a method to
#! uniquely reconstruct an exact-coloured surface from its permutation (by 
#! introducing the <E>local symmetries</E> 
#! (<Ref Subsect="LocalSymmetryOfEdges"/>)).
#!
#! Section <Ref Sect="Section_EdgeIsoscelesColouring_Wild"/> also
#! describes some methods to construct vari-coloured
#! and exact-coloured
#! surfaces.
#!

#TODO maybe add example of a simplicial surface without a vari-colouring

#! @Section Definition and elementary properties
#! @SectionLabel EdgeIsoscelesColouring_Definition
#! This section defines the concept of edge two-colourings
#! (<Ref Subsect="IsEdgeTwoColouring"/>) and introduces
#! the coloured version of this method:
#! * <K>ColouredEdgesOfFaces</K> (<Ref Subsect="ColouredEdgesOfFaces"/>) 
#!   extends <K>EdgesOfFaces</K> (<Ref Subsect="EdgesOfFaces"/>).
#! 
#! @InsertChunk Example_ColouredPrism


#! @BeginGroup IsEdgeTwoColouring
#! @Description
#! The property <K>IsEdgeTwoColouring</K> checks if the edges of each
#! face are two-coloured by the given edge colouring.
#! This is the case if and only if there are two colours such that
#! all edges of each face have one of these two colours and both colours
#! occur among the edges of each face.
#!
#! We illustrate this on the prism that was introduced at the start of
#! section <Ref Sect="Section_EdgeIsoscelesColouring_Definition"/>.
#! <Alt Only="TikZ">
#!   \input{_TIKZ_Prism_coloured.tex}
#! </Alt>
#! The given edge colouring is a vari-colouring but not an exact-colouring.
#! @BeginExampleSession
#! gap> EdgesOfColours( colPrism );
#! [ [ 1, 4 ], [ 3, 6 ], [ 9 ], [ 2, 7 ], [ 5, 8 ] ]
#! gap> IsEdgeTwoColouring( colPrism );
#! true
#! @EndExampleSession
#! 
#! TODO refer to comparison with simplicial surface (prove this result there);
#!
#! @Arguments colComplex
DeclareProperty("IsEdgeTwoColouring", IsEdgeColouredPolygonalComplex);
#! @Arguments colComplex
#NNDeclareProperty("IsEdgeExactColouring", IsEdgeColouredPolygonalComplex);
#! @EndGroup


#! @BeginGroup ColouredEdgesOfFaces
#! @Description
#! For an edge two-coloured polygonal complex
#! the method <K>ColouredEdgesOfFace</K>(<A>rbComp</A>, <A>face</A>) returns a
#! list of the incident edges of <A>face</A> such that the <E>i</E>-th entry has the
#! colour <E>i</E>. The NC-version does not check whether the given <A>face</A>
#! is an actual face of the coloured complex.
#!
#! The attribute <K>ColouredEdgesOfFaces</K> collects all of these lists in 
#! a list indexed by the face labels, i.e.
#! <K>ColouredEdgesOfFaces</K>(<A>rbComp</A>)[<A>face</A>] =
#! <K>ColouredEdgesOfFace</K>(<A>rbComp</A>, <A>face</A>). All other positions
#! are unbound.
#!
#! Consider the prism example from the start of section 
#! <Ref Sect="Section_EdgeIsoscelesColouring_Definition"/>.
#! <Alt Only="TikZ">
#!   \input{_TIKZ_Prism_coloured.tex}
#! </Alt>
#! @BeginExampleSession
#! gap> ColoursOfEdges(colPrism);
#! [ 1, 4, 2, 1, 5, 2, 4, 5, 3 ]
#! gap> ColouredEdgesOfFace(colPrism, 1);
#! [ 1, 3,, 2 ]
#! gap> ColouredEdgesOfFace(colPrism, 4);
#! [ 1, 6,, 7, 5 ]
#! gap> ColouredEdgesOfFaces(colPrism);
#! [ [ 1, 3,, 2 ],, [ 4, 3, 9,, 5 ], [ 1, 6,, 7, 5 ], [ 4, 6,, 2, 8 ],, [ ,, 9, 7, 8 ] ]
#! @EndExampleSession
#!
#! @Returns a list of (lists of) positive integers
#! @Arguments rbComp
DeclareAttribute( "ColouredEdgesOfFaces", 
    IsEdgeColouredPolygonalComplex and  IsEdgeTwoColouring );
#! @Arguments rbComp, face
DeclareOperation( "ColouredEdgesOfFace",
    [IsEdgeColouredPolygonalComplex and IsEdgeTwoColouring, IsPosInt]);
#! @Arguments rbComp, face
DeclareOperation( "ColouredEdgesOfFaceNC",
    [IsEdgeColouredPolygonalComplex and IsEdgeTwoColouring, IsPosInt]);
#! @EndGroup


#! @Section Permutation description
#! @SectionLabel EdgeIsoscelesColouring_Permutations
#!
#! While section <Ref Sect="Section_EdgeIsoscelesColouring_Definition"/> dealt
#! with general edge two-colourings, this section is restricted to
#! edge two-colourings of polygonal complexes without edge ramifications. 
#! For those there are
#! at most two faces incident to an edge.
#!
#! Therefore every colour can be interpreted as an involution on the set of 
#! faces
#! (which swaps two faces that are connected by an edge of that colour).
#!
#! @InsertChunk Example_ColouredDisk

#! @BeginGroup ColourInvolutions
#! @Description
#! For an edge isosceles-coloured simplicial surface
#! (<Ref Subsect="IsIsoscelesColouredSurface"/>) 
#! return the colour involutions of the edge-isosceles-coloured surface
#! obtained by subdividing each triangle by an edge through the apex
#! and the midpoint of the base.
#!
#! The attribute <K>ColourInvolutions</K>(<A>rcRamSurf</A>) returns a list
#! of three involutions. These involutions are the colour involutions of
#! a wild-coloured simplicial surface obtained as follows.
#! Let <i>m</i> denote the maximum value of a face of <A>rcRamSurf</A>.
#! A new edge passes from the apex of <i>F</i> to the mid point of the
#! base edge of <i>F</i> and thus each face <i>F</i> of <A>rcRamSurf</A>
#! is subdivided into two faces, namely <i> F</i> and <i> m + F</i>.
#! We use the convention that <i>F</i> is incident to the smaller vertex
#! of the base edge and <i>m+F</i> is incident to the larger vertex
#! of the base edge. With this subdivision, the isosceles coloured surface
#! becomes a wild-coloured surface with twice as many faces. The three
#! colours arise by colouring the subdivided base edges in one colour, the
#! leg edges in the second colour and the new edges introduced by the
#! subdivision in the third colour. The
#! colour involutions of this latter wild coloured surface are the
#! colour involutions associated to <A>rcRamSurf</A>. The involutions are
#! arranged in such a way that the first involution corresponds to the
#! involution of the subdivided base edges, the secold corresponds to
#! the involution of the leg edges, and the third corresponds to the
#! new edges introduced by the subdivision. Thereby, as in the case of
#! wild coloured surfaces, 
#! For a given colour <A>col</A> the colour involution encodes the 
#! neighbouring relation
#! of the faces that is induced by the edges of the colour <A>col</A>. A 
#! boundary edge induces a fixed point.
#! 
#! @InsertChunk Example_ColouredDisk_ColourInvolutions
#! @Returns a list of involutions
#! @Arguments rcRamSurf
DeclareAttribute("ColourInvolutions", IsEdgeColouredPolygonalComplex);
#! @EndGroup

#TODO Is this relabelling ok?

#! @Section Isosceles coloured surfaces
#! @SectionLabel EdgeIsoscelesColouring_Wild
#!
#! While the previous sections dealt with general edge vari-colourings,
#! this section focuses exclusively on edge exact-coloured
#! simplicial surfaces, i.,e. simplicial surfaces whose edges are coloured
#! with two colours.

#! Since these are quite important structures, we will denote them by
#! <E>isosceles-coloured surfaces</E> (<Ref Subsect="IsIsoscelesColouredSurface"/>).
#!
#! In this situation there is an additional local symmetry structure on the
#! edges. For every inner edge (<Ref Subsect="InnerEdges"/>) there are two
#! possible colourings of the adjacent faces, which can be described by a 
#! symmetry with respect to the edge between them. The colours can either be
#! mirrored or rotated into each other.
#! <Alt Only="TikZ">
#!   \input{Image_LocalSymmetry.tex}
#! </Alt>
#! The first type is called <E>mirror</E> and the second one <E>rotation</E>.
#! Together with the <E>boundary</E>-type for the boundary edges
#! (<Ref Subsect="BoundaryEdges"/>) this defines the <K>LocalSymmetryOfEdges</K>
#! (<Ref Subsect="LocalSymmetryOfEdges"/>).
#!
#! Together with the edge colouring, the local symmetry determines the underlying
#! simplicial surface.

#! @BeginGroup IsIsoscelesColouredSurface
#! @Description
#! Check if an edge-coloured polygonal complex is a 
#! <E>wild-coloured surface</E>, i.e.
#! * It is a simplicial surface (<Ref Subsect="IsSimplicialSurface"/>)
#! * It has an edge-exact colouring (<Ref Subsect="IsEdgeIsoscelesColouring"/>), 
#!   i.e. the edges are coloured by three colours and the edges of every
#!   face have different colours.
#!
#! TODO example
#!
#! @Arguments colSurf 
DeclareProperty( "IsIsoscelesColouredSurface", IsPolygonalComplex );
DeclareProperty( "IsIsoscelesColouredSurface", IsEdgeColouredPolygonalComplex );
#! @EndGroup
InstallTrueMethod( IsEdgeColouredSimplicialSurface, IsIsoscelesColouredSurface );


#! @Section Functions for isosceles coloured Simplicial Surfaces
#! @SectionLabel Isosceles_Useful
#!
#! This section describes some usful functions for isosceles coloured
#! Simplicial surfaces
#!
#! @BeginGroup ApexOfFace
#! @Description
#! For an isosceles coloured surface (<Ref Subsect="IsIsoscelesColouredSurface"/>) the method 
#! <K>ApexOfFace</K>(<A>isosSurf</A>, <A>face</A>) returns the 
#! vertex at the apex of the face. 
#!
DeclareOperation( "ApexOfFace", [IsIsoscelesColouredSurface, IsPosInt] );
#! @EndGroup

#! @BeginGroup BaseEdgeOfFace
#! @Description
#! For an isosceles coloured surface (<Ref Subsect="IsIsoscelesColouredSurface"/>) the method 
#! <K>BaseEdgeOfFace</K>(<A>isosSurf</A>, <A>face</A>) returns the 
#! base edge of the face.
#!
DeclareOperation( "BaseEdgeOfFace", [IsIsoscelesColouredSurface, IsPosInt] );
#! @EndGroup




#! @BeginGroup ColouredUmbrellasOfVertices
#! @Description
#! For a wild coloured surface (<Ref Subsect="IsWildColouredSurface"/>) the method 
#! <K>ColouredUmbrellaOfVertex</K>(<A>wildSurf</A>, <A>vertex</A>) returns an edge-coloured 
#! edge-face path for the umbrella-path around <A>vertex</A>. All of these 
#! umbrella-paths
#! are collected in the attribute
#! <K>ColouredUmbrellasOfVertices</K>(<A>wildSurf</A>), i.e.
#! <K>ColouredUmbrellasOfVertices</K>(<A>wildSurf</A>)[<A>vertex</A>]
#! = <K>ColouredUmbrellaOfVertex</K>(<A>wildSurf</A>, <A>vertex</A>).
#!
#! This method extends <K>UmbrellaPathsOfVertices</K> 
#! (<Ref Subsect="UmbrellaPathsOfVertices"/>). The edge-coloured edge-face-paths
#! behave exactly as regular edge-face-paths but are displayed differently.
#! 
#! The NC-version does not check whether the given <A>vertex</A> actually
#! is a vertex of <A>wildSurf</A>.
#!
#! @Returns a list of coloured edge-face-paths
#! @Arguments wildSurf
DeclareAttribute( "ColouredUmbrellasOfVertices", IsIsoscelesColouredSurface );
#! @Returns a coloured edge-face-path
#! @Arguments wildSurf, vertex
DeclareOperation( "ColouredUmbrellaOfVertex", [IsIsoscelesColouredSurface, IsPosInt] );
#! @Returns a coloured edge-face-path
#! @Arguments wildSurf, vertex
DeclareOperation( "ColouredUmbrellaOfVertexNC", [IsIsoscelesColouredSurface, IsPosInt] );
#! @EndGroup


#! @BeginGroup LocalSymmetryOfEdges
#! @Description
#! Return the local symmetry of the edges in <A>colSurf</A>, i.e. whether the 
#! colours in the adjacent faces of a given inner edge are mirrored or rotated.
#!
#! TODO explanation
#!
#! TODO tests
#!
#! @Returns a list of strings
#! @Arguments colSurf
DeclareAttribute( "LocalSymmetryOfEdges", IsIsoscelesColouredSurface );
#! @Returns a list of positive integers
#! @Arguments colSurf
DeclareAttribute( "LocalSymmetryOfEdgesAsNumbers", IsIsoscelesColouredSurface ); 
#! @EndGroup


#! Of particular interest are those colourings where the local symmetry is equal
#! for each edge of the same colour. In comparison to the wild-coloured 
#! surfaces these colourings are much better behaved. Therefore they are 
#! called <E>tame-coloured surfaces</E>.
#! @BeginGroup IsTameColouredSurface
#! @Description
#! Check whether the local symmetry (<Ref Subsect="LocalSymmetryOfEdges"/>) of
#! a wild-coloured surface is equal
#! for all edges of the same colour.
#!
#! The method <K>LocalSymmetryOfColours</K> returns a list of local symmetries that is
#! indexed by the colours.
#! 
#! TODO a lot of tests (how should this interact with other options?);
#! 
#! @Arguments colSurf
#NNDeclareProperty( "IsTameColouredSurface", IsEdgeColouredPolygonalComplex);
#! @Returns a list of strings
#! @Arguments colSurf
#NNDeclareAttribute( "LocalSymmetryOfColours", IsTameColouredSurface);
#! @Returns a list of positive integers
#! @Arguments colSurf
#NNDeclareAttribute( "LocalSymmetryOfColoursAsNumbers", IsTameColouredSurface);
#! @EndGroup
#NNInstallTrueMethod( IsIsoscelesColouredSurface, IsTameColouredSurface );


#! @BeginGroup AllIsoscelesColouredSurfaces
#! @Description
#! This method computes all isosceles-coloured surfaces up to isomorphism
#! based on the given information. The information can be given in one of
#! two forms:
#! <Enum>
#!   <Item>A simplicial surface (<Ref Subsect="IsSimplicialSurface"/>).
#!      The optional argument <A>localSymmetry</A> is a list that encodes
#!      the local symmetry (<Ref Subsect="LocalSymmetryOfEdges"/>) of some
#!      edges:
#!      <List>
#!        <Item>If <A>localSymmetry</A>[<A>edge</A>] = 1, then <A>edge</A> will
#!           become a mirror-edge.</Item>
#!        <Item>If <A>localSymmetry</A>[<A>edge</A>] = 2, then <A>edge</A> will
#!           become a rotation-edge.</Item>
#!        <Item>Unbound positions and the value 0 are ignored, all other entries
#!           will throw errors. </Item>
#!      </List>
#!   </Item>
#!   <Item>A list of three involutions that will become the colour involutions
#!       (<Ref Subsect="ColourInvolutions"/>) of all returned isosceles-coloured 
#!       surfaces. The involutions can also be given individually (with 
#!       colours 1, 2, 3) or as generators of a group.
#! 
#!       The optional argument <A>localSymmetry</A> is a list that
#!       encodes the local symmetry (<Ref Subsect="IsTameColouredSurface"/>)
#!       of the colours. The entry <A>localSymmetry</A>[<A>colour</A>] can be
#!       given in one of two forms (all others will throw errors):
#!       <Enum>
#!         <Item>If the entry <A>localSymmetry</A>[<A>colour</A>] is 1, then all edges 
#!            with colour <A>colour</A> will be
#!            mirror edges. If it is 2, they will be rotation edges. If the
#!            entry is 0 or unbound, no information is given.</Item>
#!         <Item>If the entry <A>localSymmetry</A>[<A>colour</A>] is again
#!            a list, it has to be indexed by the cycles of the
#!            involution <A>invList</A>[<A>colour</A>], i.e. the entry at 
#!            position <A>k</A> encodes the local symmetry of the k-th cycle
#!            (counted in 
#!            <K>Cycles</K>(<A>invList</A>[<A>colour</A>], <A>[1..n]</A>), 
#!            where <A>n</A> is the highest point moved by the involutions). 
#!            As usual, 1 means mirror and 2 means rotation.</Item>
#!       </Enum>
#!   </Item>
#! </Enum>
#!
#!
#! @BeginExampleSession
#! gap> tetIsosceles := AllIsoscelesColouredSurfaces(Tetrahedron());;
#! gap> Size(tetIsosceles);
#! 1
#! @EndExampleSession
#! TODO examples that use local symmetries -> what is interesting (but small)?
#!
#! @Returns a list of isosceles-coloured surfaces 
#! @Arguments simpSurf[, localSymmetry]
DeclareOperation( "AllIsoscelesColouredSurfaces", [IsSimplicialSurface, IsList] );
#! @Arguments simpSurf[, localSymmetry]
DeclareOperation( "AllIsoscelesColouredSurfaces", [IsList, IsList] );
#! @Arguments invList[, localSymmetry]
#! @EndGroup

#! @BeginGroup VertexCounterByAngle
#! @Description
#!  The function VertexCounterByAngle is a refinement of the function
#!  VertexCounter: For an edge coloured simplicial surface it determines
#!  for every vertex how many faces are incident to that vertex at a given
#!  angle.
#!  Note that each angle in a face of a wild or isosceles coloured simplicial
#!  surface is determined by the colour of the edge opposite to this angle.
#! @Returns a list 
#! @Arguments colSimSurf
#! @EndGroup
##
DeclareOperation( "VertexCounterByAngle",
    [IsEdgeColouredSimplicialSurface]);