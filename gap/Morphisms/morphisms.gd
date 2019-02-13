#############################################################################
##
##  SimplicialSurface package
##
##  Copyright 2012-2019
##    Markus Baumeister, RWTH Aachen University
##    Alice Niemeyer, RWTH Aachen University 
##
## Licensed under the GPL 3 or later.
##
#############################################################################

#! @Chapter Homomorphisms
#! @ChapterLabel Morphisms
#!
#! This chapter is concerned with morphisms between different polygonal
#! complexes (morphisms between bend polygonal complexes are not implemented
#! so far).
#!
#! A morphism between two polygonal complexes <M>(V_1,E_1,F_1)</M> and
#! <M>(V_2,E_2,F_2)</M> consists of maps <M>V_1 \to V_2</M>, <M>E_1 \to E_2</M>,
#! and <M>F_1 \to F_2</M>, such that incident elements remain incident.
#!
#! TODO: these maps can be represented as lists, or as mappings (in GAP)
#! TODO: example with constructors for the two
#!
#! TODO a lot of introduction

#idea: polygonal morphisms are maps between sets: vertices+edges+faces, where edges
# are shifted by MaxVertex and faces are shifted by MaxVertex+MaxEdge
DeclareCategory("IsGeneralPolygonalMorphism", IsNonSPGeneralMapping);
# TODO maybe add more specific properties, like IsPolygonalMorphism
# TODO are the names good? Or should we be more specific, e.g. IsPolygonalComplexMorphism, IsPolygonalSurfaceMorphism?


BindGlobal( "GeneralPolygonalMorphismFamily", 
    NewFamily( "GeneralPolygonalMorphismFamily", IsGeneralMapping, IsGeneralPolygonalMorphism ) );

#! @Section Consistent labels for vertices, edges, and faces
#! @SectionLabel VEFLabels
#!
#! We have defined VEF-complexes in a way such that the labels for vertices,
#! edges, and faces do not have to be distinct. While this is more convenient
#! for the casual user, it is sometimes practical to enforce distinct labels.
#! Notably, these cases include morphisms and automorphism groups.
#!
#! The distinct label set is called <K>VEFLabels</K>. Consider the following
#! polygonal surface:
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle,edgeStyle,faceStyle]
#!     \input{Image_VEFLabelsExample.tex}
#!   \end{tikzpicture}
#! </Alt>
#! @BeginExampleSession
#! gap> cat := PolygonalSurfaceByUpwardIncidence(
#! >        [[1,2,4,5],, [1,7], [2,7,8], [8,9], [4,9,10], [5,10]],
#! >        [[1], [1,2],, [2,4], [4],, [1], [2], [2], [4]]);;
#! gap> Vertices(cat);
#! [ 1, 3, 4, 5, 6, 7 ]
#! gap> Edges(cat);
#! [ 1, 2, 4, 5, 7, 8, 9, 10 ]
#! gap> Faces(cat);
#! [ 1, 2, 4 ]
#! gap> Intersection( Vertices(cat), Edges(cat) );
#! [ 1, 4, 5, 7 ]
#! @EndExampleSession
#! Using the VEF-labels shifts the labels of edges and faces upwards to
#! avoid intersections.
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle,edgeStyle,faceStyle]
#!     \def\veflabels{1}
#!     \input{Image_VEFLabelsExample.tex}
#!   \end{tikzpicture}
#! </Alt>
#! @BeginExampleSession
#! gap> VEFLabels(cat);
#! [ 1, 3, 4, 5, 6, 7, 8, 9, 11, 12, 14, 15, 16, 17, 18, 19, 21 ]
#! gap> VEFLabelsOfVertices(cat);
#! [ 1,, 3, 4, 5, 6, 7 ]
#! gap> VEFLabelsOfEdges(cat);
#! [ 8, 9,, 11, 12,, 14, 15, 16, 17 ]
#! gap> VEFLabelsOfFaces(cat);
#! [ 18, 19,, 21 ]
#! @EndExampleSession



#! @BeginGroup VEFLabels
#! @Description
#! Return the set of VEF-labels for the given VEF-complex. The
#! VEF-labels are a set of labels that distinguish vertices,
#! edges, and faces. It is constructed as follows:
#! * The vertex labels stay the same
#! * The edge labels are shifted upwards by the maximal vertex label
#! * The face labels are shifted upwards by the sum of maximal vertex
#!   label and maximal edge label
#!
#! For example, consider the polygonal surface from the start of
#! section <Ref Sect="Section_VEFLabels"/>:
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle, edgeStyle, faceStyle]
#!     \input{Image_VEFLabels_SideBySide.tex}
#!   \end{tikzpicture}
#! </Alt>
#! @BeginExampleSession
#! gap> Vertices(cat);
#! [ 1, 3, 4, 5, 6, 7 ]
#! gap> Edges(cat);
#! [ 1, 2, 4, 5, 7, 8, 9, 10 ]
#! gap> Faces(cat);
#! [ 1, 2, 4 ]
#! gap> VEFLabels(cat);
#! [ 1, 3, 4, 5, 6, 7, 8, 9, 11, 12, 14, 15, 16, 17, 18, 19, 21 ]
#! @EndExampleSession
#! @Arguments complex
#! @Returns a set of positive integers
DeclareAttribute( "VEFLabels", IsVEFComplex );
#! @EndGroup


#! @BeginGroup VEFLabelsOfVertices
#! @Description
#! The method <K>VEFLabelOfVertex</K>(<A>complex</A>, <A>vertex</A>) returns the
#! VEF-label of <A>vertex</A>. The NC-version does
#! not check whether the given <A>vertex</A> is a vertex of <A>complex</A>.
#! 
#! The attribute <K>VEFLabelsOfVertices</K>(<A>complex</A>) collects all of those
#! labels in a list that is indexed by the vertex labels, i.e.
#! <K>VEFLabelsOfOfVertices</K>(<A>complex</A>)[<A>vertex</A>] = 
#! <K>VEFLabelOfVertex</K>(<A>complex</A>, <A>vertex</A>).
#! All other positions of this list are not bound.
#! 
#! For example, consider the polygonal surface from the start of
#! section <Ref Sect="Section_VEFLabels"/>:
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle, edgeStyle, faceStyle]
#!     \input{Image_VEFLabels_SideBySide.tex}
#!   \end{tikzpicture}
#! </Alt>
#! @BeginExampleSession
#! gap> VEFLabelOfVertex(cat, 3);
#! 3
#! gap> VEFLabelOfVertex(cat, 6);
#! 6
#! gap> VEFLabelsOfVertices(cat);
#! [ 1,, 3, 4, 5, 6, 7 ]
#! @EndExampleSession
#! 
#! @Returns a list of positive integers / a positive integer
#! @Arguments complex
DeclareAttribute( "VEFLabelsOfVertices", IsVEFComplex );
#! @Arguments complex, vertex
DeclareOperation( "VEFLabelOfVertex", [IsVEFComplex, IsPosInt]);
#! @Arguments complex, vertex
DeclareOperation( "VEFLabelOfVertexNC", [IsVEFComplex, IsPosInt]);
#! @EndGroup


#! @BeginGroup VEFLabelsOfEdges
#! @Description
#! The method <K>VEFLabelOfEdge</K>(<A>complex</A>, <A>edge</A>) returns the
#! VEF-label of <A>edge</A>. The NC-version does
#! not check whether the given <A>edge</A> is an edge of <A>complex</A>.
#! 
#! The attribute <K>VEFLabelsOfEdges</K>(<A>complex</A>) collects all of those
#! labels in a list that is indexed by the edge labels, i.e.
#! <K>VEFLabelsOfOfEdges</K>(<A>complex</A>)[<A>edge</A>] = 
#! <K>VEFLabelOfEdge</K>(<A>complex</A>, <A>edge</A>).
#! All other positions of this list are not bound.
#! 
#! For example, consider the polygonal surface from the start of
#! section <Ref Sect="Section_VEFLabels"/>:
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle, edgeStyle, faceStyle]
#!     \input{Image_VEFLabels_SideBySide.tex}
#!   \end{tikzpicture}
#! </Alt>
#! @BeginExampleSession
#! gap> VEFLabelOfEdge(cat, 2);
#! 9
#! gap> VEFLabelOfEdge(cat, 10);
#! 17
#! gap> VEFLabelsOfEdges(cat);
#! [ 8, 9,, 11, 12,, 14, 15, 16, 17 ]
#! @EndExampleSession
#! 
#! @Returns a list of positive integers / a positive integer
#! @Arguments complex
DeclareAttribute( "VEFLabelsOfEdges", IsVEFComplex );
#! @Arguments complex, vertex
DeclareOperation( "VEFLabelOfEdge", [IsVEFComplex, IsPosInt]);
#! @Arguments complex, vertex
DeclareOperation( "VEFLabelOfEdgeNC", [IsVEFComplex, IsPosInt]);
#! @EndGroup


#! @BeginGroup VEFLabelsOfFaces
#! @Description
#! The method <K>VEFLabelOfFace</K>(<A>complex</A>, <A>face</A>) returns the
#! VEF-label of <A>face</A>. The NC-version does
#! not check whether the given <A>face</A> is a face of <A>complex</A>.
#! 
#! The attribute <K>VEFLabelsOfFaces</K>(<A>complex</A>) collects all of those
#! labels in a list that is indexed by the face labels, i.e.
#! <K>VEFLabelsOfOfFaces</K>(<A>complex</A>)[<A>face</A>] = 
#! <K>VEFLabelOfFace</K>(<A>complex</A>, <A>face</A>).
#! All other positions of this list are not bound.
#! 
#! For example, consider the polygonal surface from the start of
#! section <Ref Sect="Section_VEFLabels"/>:
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle, edgeStyle, faceStyle]
#!     \input{Image_VEFLabels_SideBySide.tex}
#!   \end{tikzpicture}
#! </Alt>
#! @BeginExampleSession
#! gap> VEFLabelOfFace(cat, 2);
#! 19
#! gap> VEFLabelOfFace(cat, 4);
#! 21
#! gap> VEFLabelsOfFaces(cat);
#! [ 18, 19,, 21 ]
#! @EndExampleSession
#! 
#! @Returns a list of positive integers / a positive integer
#! @Arguments complex
DeclareAttribute( "VEFLabelsOfFaces", IsVEFComplex );
#! @Arguments complex, vertex
DeclareOperation( "VEFLabelOfFace", [IsVEFComplex, IsPosInt]);
#! @Arguments complex, vertex
DeclareOperation( "VEFLabelOfFaceNC", [IsVEFComplex, IsPosInt]);
#! @EndGroup


#! @BeginGroup VertexOfVEFLabel
#! @Description
#! Given a VEF-complex <A>complex</A> and a VEF-label <A>label</A>, the
#! method <K>VertexOfVEFLabel</K>(<A>complex</A>, <A>label</A>) returns
#! the vertex associated to <A>label</A>.
#!
#! For example, consider the polygonal surface from the start of
#! section <Ref Sect="Section_VEFLabels"/>:
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle, edgeStyle, faceStyle]
#!     \input{Image_VEFLabels_SideBySide.tex}
#!   \end{tikzpicture}
#! </Alt>
#! @BeginExampleSession
#! gap> VertexOfVEFLabel(cat, 1);
#! 1
#! gap> VertexOfVEFLabel(cat, 2);
#! fail
#! gap> VertexOfVEFLabel(cat, 7);
#! 7
#! gap> VertexOfVEFLabel(cat, 8);
#! fail
#! @EndExampleSession
#!
#! The NC-version does not check whether the given <A>label</A> is valid.
#! The normal version checks this and returns <K>fail</K> if <A>label</A>
#! is not valid.
#! @Returns a positive integer or <K>fail</K>
#! @Arguments complex, label
DeclareOperation( "VertexOfVEFLabel", [IsVEFComplex, IsPosInt] );
#! @Arguments complex, label
DeclareOperation( "VertexOfVEFLabelNC", [IsVEFComplex, IsPosInt] );
#! @EndGroup


#! @BeginGroup EdgeOfVEFLabel
#! @Description
#! Given a VEF-complex <A>complex</A> and a VEF-label <A>label</A>, the
#! method <K>EdgeOfVEFLabel</K>(<A>complex</A>, <A>label</A>) returns
#! the edge associated to <A>label</A>.
#!
#! For example, consider the polygonal surface from the start of
#! section <Ref Sect="Section_VEFLabels"/>:
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle, edgeStyle, faceStyle]
#!     \input{Image_VEFLabels_SideBySide.tex}
#!   \end{tikzpicture}
#! </Alt>
#! @BeginExampleSession
#! gap> EdgeOfVEFLabel(cat, 7);
#! fail
#! gap> EdgeOfVEFLabel(cat, 9);
#! 2
#! gap> EdgeOfVEFLabel(cat, 10);
#! fail
#! gap> EdgeOfVEFLabel(cat, 16);
#! 9
#! gap> EdgeOfVEFLabel(cat, 18);
#! fail
#! @EndExampleSession
#!
#! The NC-version does not check whether the given <A>label</A> is valid.
#! The normal version checks this and returns <K>fail</K> if <A>label</A>
#! is not valid.
#! @Returns a positive integer or <K>fail</K>
#! @Arguments complex, label
DeclareOperation( "EdgeOfVEFLabel", [IsVEFComplex, IsPosInt] );
#! @Arguments complex, label
DeclareOperation( "EdgeOfVEFLabelNC", [IsVEFComplex, IsPosInt] );
#! @EndGroup


#! @BeginGroup FaceOfVEFLabel
#! @Description
#! Given a VEF-complex <A>complex</A> and a VEF-label <A>label</A>, the
#! method <K>FaceOfVEFLabel</K>(<A>complex</A>, <A>label</A>) returns
#! the face associated to <A>label</A>. 
#!
#! For example, consider the polygonal surface from the start of
#! section <Ref Sect="Section_VEFLabels"/>:
#! <Alt Only="TikZ">
#!   \begin{tikzpicture}[vertexStyle, edgeStyle, faceStyle]
#!     \input{Image_VEFLabels_SideBySide.tex}
#!   \end{tikzpicture}
#! </Alt>
#! @BeginExampleSession
#! gap> FaceOfVEFLabel(cat, 17);
#! fail
#! gap> FaceOfVEFLabel(cat, 18);
#! 1
#! gap> FaceOfVEFLabel(cat, 20);
#! fail
#! gap> FaceOfVEFLabel(cat, 21);
#! 4
#! gap> FaceOfVEFLabel(cat, 22);
#! fail
#! @EndExampleSession
#!
#! The NC-version does not check whether the given <A>label</A> is valid.
#! The normal version checks this and returns <K>fail</K> if <A>label</A>
#! is not valid.
#! @Returns a positive integer of <K>fail</K>
#! @Arguments complex, label
DeclareOperation( "FaceOfVEFLabel", [IsVEFComplex, IsPosInt] );
#! @Arguments complex, label
DeclareOperation( "FaceOfVEFLabelNC", [IsVEFComplex, IsPosInt] );
#! @EndGroup



#! @Section Construction of Morphisms
#! @SectionLabel Morphisms_Construction
#!
#! In this section, we give several different ways to construct morphisms
#! from scratch.

# TODO implement constructor by three lists (images of vertices, edges and faces)

# TODO implement IdentityMapping

# TODO implement InverseMapping/InverseMorphism (for appropriate...)

# TODO overload CompositionMapping2

#! @Section Elementary properties
#! @SectionLabel Morphisms_Properties

# TODO document some of the generic properties like IsInjective, IsSurjective, ...


#! @Section Images and pre-images

#TODO
# implement PreImagesOfVertex
# implement PreImagesOfEdge
# implement PreImagesOfFace


# implement ImageOfVertex (for a total and single-valued ..);
# implement ImageOfEdge (for a total and single-valued ..);
# implement ImageOfFace (for a total and single-valued ..);


#! @Section Components of a morphism

#List of TODO:
# implement VertexMapAsImageList (for single-valued);
# implement EdgeMapAsImageList (for single-valued);
# implement FaceMapAsImageList (for single-valued);

# attribute SourceComplex
# attribute SourceSurface
# attribute RangeComplex
# attribute RangeSurface


# attribute VertexMapping
# attribute EdgeMapping
# attribute FaceMapping


##########################################