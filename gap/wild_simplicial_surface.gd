#! @DoNotReadRestOfFile

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
