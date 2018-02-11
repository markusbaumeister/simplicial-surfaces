# @DoNotReadRestOfFile

##############################################################################
##
#W  wild_simplicial_surface.gd     SimplicialSurfaces     Alice Niemeyer
#W														Markus Baumeister
##
##
#Y  Copyright (C) 2016-2017, Alice Niemeyer, Markus Baumeister, 
#Y  Lehrstuhl B für Mathematik, RWTH Aachen
##
##  This file is free software, see license information at the end.
##
##  This file contains the declaration part for the wild simplicial surfaces
##	of the SimplicialSurfaces package.
##
##	TODO description of wild coloured simplicial surfaces
##
##  There are several ways of inputting a wild coloured simplicial surface.
##
##  A wild coloured simplicial surface is created by the function 
##  WildSimplicialSurface and is a GAP object. Simplicial surfaces can be 
##  obtained as follows:
##
##  1) Given a triple gens of involutions, the function
##     AllWildSimplicialSurfaces(gens)  computes  all wild coloured simplicial 
##     surfaces whose faces are the moved points of the generators and whose
##     edges are determined by the 2-cycles of the generators.
##  2) Input a surface by first listing the faces, 
##     then pairs of faces making up the edges, 
##     then the face-paths for  each vertex.  A face-path is simply
##     a list of the faces in the order in which they occur around a vertex.
##     The function WildSimplicialSurfacesFromFacePath takes this input
##     and returns all wild coloured simplicial surfaces matching the
##     description
##  3) Input a wild coloured surface by the following data structure, 
##     called the *generic-surface* data structure. The generic-surface
##     data structure is the most general data structure to describe
##     surfaces and is not restricted to wild coloured surfaces only.
##     The generic-surface data structure is a list of
##      the number of vertices, edges and faces
##      then pairs of vertices making up the edges, 
##      then triples of edges making up the faces, e.g.
##      ( |V|, |E|, |F|, [ [v1,v2],...],  [[e1,e2,e3],... ] )
##       here ei is a number, which is a position in the list of edges,
##       so that the list of vertex pairs can be indexed by ei to find
##       the two vertex numbers of edges ei.
##     
##
##
##    As GAP objects, certain general methods are installed for 
##    simplicial surface objects, such as Print and Display and "=".
##
##    The mr-type of a wild coloured simplicial surface simpsurf
##    can be determined with the function MrTypeOfWildSimplicialSurface.
##
##    As Simplicial surfaces are GAP objects, they cannot be 
##    accessed like records.
##
##    An action of a permutation on a simplicial surface is installed, 
##    allowing us to compute the orbits of a group acting on a set of
##    simplicial surfaces.
##    
##



#! @Description
#!  A coloured face edge path of an inner vertex v of a wild
#!  simplicial surface is   
#!  a list  $[c_1,f_1,c_2,f_2,...,c_n,f_n]$, where f1,...,fn are the faces incident
#!  to v and c1,..,cn are colours such that the edges of  face fi with 
#!  ci and c(i+1) are those incident to v and c(n+1)=c1. 
#!  A coloured face edge path of a boundary vertex v of a wild
#!  simplicial surface is   
#!  a list  [c1,f1,c2,f2,...,cn,fn, c(n+1)], where f1,...,fn are the
#!  faces incident 
#!  to v and c1,..,c(n+1) are colours such that the edges of  face fi with 
#!  ci and c(i+1) are those incident to v and the edges of f1 and fn
#!  with colours   c1 and  c(n+1), respectively, are boundary edges.
#! @Arguments a wild simplicial surface
#! @Returns a list
DeclareAttribute( "ColouredFaceEdgePathsOfVertices", IsWildSimplicialSurface );
DeclareOperation( "ColouredFaceEdgePathOfVertex", 
		[IsWildSimplicialSurface,IsPosInt] );
DeclareOperation( "ColouredFaceEdgePathOfVertexNC", 
		[IsWildSimplicialSurface,IsPosInt] );

#############################################################################
##
##
#!  @Section Functions for wild coloured simplicial surfaces
#!
#!
#!


#!	@Description
#!	Given a set of faces and a colour, return the edge such that the set of
#!	faces is the set of faces incident to the edge and that the edge has the
#!	given colour.
#!
#!	The NC-version doesn't check if the given colour is valid.
#!
#!	@Arguments wildSimplicialSurface, setOfFaces, colour
#!	@Returns an edge
DeclareOperation( "EdgeByFacesAndColour", 
	[ IsWildSimplicialSurface, IsSet, IsPosInt ] );
DeclareOperation( "EdgeByFacesAndColourNC", 
	[ IsWildSimplicialSurface, IsSet, IsPosInt ] );



#! @Description
#! Return the double cover of the wild simplicial surface, keeping the 
#! MR-type fixed.
#! 
#! @Arguments wildSimplicialSurface
#! @Returns the double cover
DeclareOperation( "DoubleCover", [IsWildSimplicialSurface] );

#############################################################################
##
#!   @Description
#!   The function SixFoldCover takes as input a generic description of
#!   a simplicial surface.  The six fold cover of a simplicial surface is
#!   the following surface.
#!   If f is a face of the original face with edge numbers e_a, e_b and
#!   e_c, then the face is covered by the six faces of the form
#!   (f, e1, e2, e3), for which {e1, e2, e3}  = {e_a, e_b, e_c}.
#!   See Proposition 3.XX in the paper.
#!   @Arguments
#!
#!   If the optional argument mrtype is given, it has to be a list of length 
#!   3 and each entry has to be  $1$, or $2$. In this case the six fold cover 
#!   will treat the position $i$ for $i\in\{1,2,3\}$ of the three
#!   edges around a faces either as a   reflection (mirror), if the entry 
#!   in position $i$ of mrtype is 1, or as a rotation, if the entry in 
#!   position $i$ is 2. That is, the cover surface is generated by three
#!   transpositions $\sigma_i$ for $i=1,2,3$. For $i=1$, suppose $f$ and 
#!   $f'$ are faces of the surface surf such that the edges of $f$ are 
#!   $e_1, e_2$  and $e_3$ and the edges of $f'$ are  $e_1, e_a, e_b$ are 
#!   the edges $e_1, e_2$ and $e_a$ intersect in a common vertex and 
#!   the edges $e_1, e_3$ and $e_b$ intersect in a common vertex.
#!   For $i=1$ and  mrtype of position $1$ being  mirror (i.e. $1$), then 
#!   $$\sigma_1(f,e_1,e_2,e_3) = (f', e_1, e_a, e_b),$$ whereas if the 
#!   mrtype of position $1$ is a reflection (i.e. $2$), then 
#!   $$\sigma_1(f,e_1,e_2,e_3) = (f', e_1, e_b, e_a).$$ The definition
#!   of $\sigma_2$ and $\sigma_3$ are analogous, with $e_2$, respectively
#!   $e_3$ taking the role of the common edge $e_1.$
#!
#!   
#!   If the optional argument mredges is given, and mredges is a list of 
#!   length equal to the number of edges of the surface **surf** and an
#!   entry for an edge e is either 1 or 2. If the entry is 1 then 
#!   the six fold cover will treat the edge as a reflection (mirror) and 
#!   if the entry is 2  then the edge is treated as a rotation. 
#!
#!   The six fold cover is always a wild colourable simplicial surface.
#!   @Returns a wild coloured simplicial surface
#!   @Arguments surface, mrtype, bool
#!   if bool is true or not given, the mrtype specifies the behaviour of 
#!   the $\sigma_i$, if bool is false, the mrtype specifies the behaviour
#!   of the edges.
#!
DeclareOperation( "SixFoldCover", [IsSimplicialSurface, IsList] );


#!
#!  @Description
#!  Compute the action of a permutation on the faces of a wild simplicial
#!  surface. The permutation acts on the faces, while the names of vertices
#!  and edges may change.
#!  @Arguments surface, perm
#!  @Returns The new wild simplicial surface
DeclareOperation( "ImageWildSimplicialSurface", 
        [IsWildSimplicialSurface, IsPerm] );

#! @DoNotReadRestOfFile
#TODO modify the following declarations so that they work in AutoDoc

#############################################################################
##
##  AllWildSimplicialSurfaces( gens[, mrtype] ) . . . . all simplicial surfaces
##  AllWildSimplicialSurfaces( grp[, mrtype] )
##  AllWildSimplicialSurfaces( sig1, sig2, sig3[, mrtype] )
##
##
#!  @Description
#!  This function computes all wild-coloured simplicial surfaces generated
#!  by a triple of involutions as specified in the input. If the optional
#!  argument mrtype is present, only those wit a predefined mrtype are
#!  constructed.
#!  The involution triple can be given to the function in various ways.
#!  Either they are input as a list gens of three involutions, or as
#!  a group grp whose generators are the tree involutions, or they can
#!  be input into the function as three arguments, one for each involution.
#! 
#!  In case the optional argument mrtype  is present, it can be used to
#!  restrict to wild-colourings for which some or all edges have a predefined
#!  colour. This is equivalent to marking the cycles of the three involutions
#!  as follows. If the edge $(j, j^\sigma_i)$ of the involution $\sigma_i$ is
#!  to be a reflection (mirror) let $k=1$, if it is to be a rotation, let 
#!  $k=2$ and if it can be either let $k=0.$ Then set $mrtype[i][j] = k$.
#!  @Returns a list of all wild-coloured simplicial surfaces with generating
#!  set given by three involutions.
#!  The function AllWildSimplicialSurfaces when called with the optional argument
#!  mrtype now returns all wild-coloured simplicial surfaces whose edges
#!  are coloured according to the restrictions imposed by mrtype.
#!  @Arguments gens,  a list of three involutions
#!
DeclareOperation( "AllWildSimplicialSurfaces", [IsList,IsList] ); 

##############################################################################
##
#!	@Description
#!	For a given list of wild simplicial surfaces this method returns all of
#!	them where edges with the same colour have the same MR-type.
#!
#!	@Arguments wildSimplicialSurfaceList
#!	@Returns a list of wild simplicial surfaces
DeclareOperation( "FilteredStructuresWildSimplicialSurface", [IsList] );


#############################################################################
##
#!	@Description
#!	Possible inputs are:
#!	- a group
#!	- a list with three involutions
#!	- three involutions
#!	This method returns all wild simplicial surfaces that can be defined
#!	on the basis of these three involutions.
#!
#!	@Arguments listOfInvolutions
#!	@Returns a list of wild simplicial surfaces
DeclareOperation( "AllStructuresWildSimplicialSurfaces", [IsList] );


#############################################################################
##
#!  @Description
#!  This function takes as input a list of pairs of integers. Suppose the
#!  integers occurring in this list of pairs is the set faces. Then this
#!  function computes all triples of involutions acting on the set faces.
#!  @Returns a list of lists, which are involution triples.
#!  @Arguments a list of lists, which is a list of pairs of integers
#!
DeclareOperation( "GeneratorsFromFacePairs",  [IsList] );



#############################################################################
##
#!  @Description
#!  This function takes as input a ``face"- description of a surface. 
#!  A ``face"-description of a surface is as  follows.
#!
#!  A list surf with three entries:
#!  * a list of integers, the faces, 
#!  * a list of  pairs of faces making up the edges, 
#!  * a list of  face-paths, one face-path for  each vertex. 
#!  A face-path is a list of on a vertex in the order in which they occur
#!  in the vertex. Note that in this representation it is critical that a 
#!  closed face-path is represented by a list of faces that repeats the 
#!  starting face at the end! That means  the first and last face in the
#!  list of faces for the given face-path **must** be equal, otherwise 
#!  the face-path is assumed to be a path from a face with boundary to 
#!  another face with boundary around a fixed vertex.
#!   Thus the ``face"-description has the form
#!  surf := [ [f1, f2, ..., fn, f1],  [ [f1,f2],...],  [[f1,f2,f3,...],... ];
#!  This is a very simple way of inputting a simplicial surface by just 
#!  reading off the face numbers of each  vertex.
#!
#!
#!  @BeginExample the tetrahedron is represented as
#!    tetra := [ [1..4], [[1,2],[1,3],[1,4],[2,3],[3,4],[2,4]],
#!             [[1,2,3,1], [1,3,4,1],[1,2,4,1],[2,3,4,2]]];
#!  AllWildSimplicialSurfacesFromFacePath(tetra[1],tetra[2],tetra[3]);
#!  
#!             where the triple [1,2,3,1] encodes a closed face path
#!              around one vertex.
#!  @EndExample
#!
#!  @Returns  the list of all wild coloured simplicial surfaces with these 
#!  specifications.
#!  @Arguments a list of lists, representing a ``face"-description of a surface
#! 
DeclareOperation( "AllWildSimplicialSurfacesFromFacePath", [IsList,IsList,IsList]);
