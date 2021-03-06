BindGlobal( "__SIMPLICIAL_Test_VEF_SpecialisedIncidence",
    function()
        local torus, torus_ve, torus_vf, torus_ef, ball, ball_ve, ball_vf, 
            ball_ef, torus_umb, ball_umb;

        torus_ve := [[2],[2],,[2]];
        torus_vf := [[2],,[2]];
        torus_ef := [[1,2,4],,[1,2,4]];
        torus := BendPolygonalComplexBySignedFacePerimeters(
            [[2,1,2,4,2,2],,[2,-2,2,-1,2,-4]]);
        __SIMPLICIAL_BendPolygonalComplex_SufficientInformation(torus);
        SIMPLICIAL_TestAssert(VerticesOfEdges(torus)=torus_ve);
        SIMPLICIAL_TestAssert(EdgesOfFaces(torus)=torus_ef);
        SIMPLICIAL_TestAssert(VerticesOfFaces(torus)=torus_vf);

        ball_ve := [,[1,2],[2],[2,4]];
        ball_vf := [[1,2],,[2,4]];
        ball_ef := [[2,3],,[3,4]];
        ball := BendPolygonalComplexBySignedFacePerimeters(
            [[2,3,2,2,1,-2],,[2,3,2,4,4,-4]] );
        __SIMPLICIAL_BendPolygonalComplex_SufficientInformation(ball);
        SIMPLICIAL_TestAssert(VerticesOfEdges(ball)=ball_ve);
        SIMPLICIAL_TestAssert(EdgesOfFaces(ball)=ball_ef);
        SIMPLICIAL_TestAssert(VerticesOfFaces(ball)=ball_vf);

        # EdgeInFaceByVertices
        SIMPLICIAL_TestAssert(EdgeInFaceByVertices(torus,1,[2])=fail);
        SIMPLICIAL_TestAssert(EdgesInFaceByVertices(torus,1,[2])=[1,2,4]);
        SIMPLICIAL_TestAssert(EdgesInFaceByVertices(torus,1,[2,2])=[1,2,4]);

        SIMPLICIAL_TestAssert(EdgeInFaceByVertices(ball, 1, [1,2])=2);
        SIMPLICIAL_TestAssert(EdgeInFaceByVertices(ball, 1, [2,2])=3);
        SIMPLICIAL_TestAssert(EdgesInFaceByVertices(ball, 1, [2])=[3]);

        # OtherEdgeOfVertexInFace
        SIMPLICIAL_TestAssert(OtherEdgeOfVertexInFace(torus, 2, 1,1) = fail);
        SIMPLICIAL_TestAssert(OtherEdgesOfVertexInFace(torus, 2, 1,1) = [2,4]);

        SIMPLICIAL_TestAssert(OtherEdgeOfVertexInFace(ball, 1,2,1)=fail);
        SIMPLICIAL_TestAssert(OtherEdgeOfVertexInFace(ball, 2,2,1)=3);
        SIMPLICIAL_TestAssert(OtherEdgesOfVertexInFace(ball, 1,2,1)=[]);

        # OtherVertexOfEdge
        SIMPLICIAL_TestAssert(OtherVertexOfEdge(torus, 2,4) = 2);
        SIMPLICIAL_TestAssert(OtherVertexOfEdge(ball, 2,3) = 2);
        SIMPLICIAL_TestAssert(OtherVertexOfEdge(ball, 4,4) = 2);

        # NeighbourFaceByEdge
        SIMPLICIAL_TestAssert(NeighbourFaceByEdge(torus,1,2)=3);
        SIMPLICIAL_TestAssert(NeighbourFacesByEdge(torus,1,2)=[3]);
        SIMPLICIAL_TestAssert(NeighbourFaceByEdge(ball,1,2)=1);

        # PerimetersOfFaces (defined by local vertices/edges)
        SIMPLICIAL_TestAssert(PathAsList(PerimeterPathOfFace(torus,1))=[2,1,2,2,2,4,2]);
        SIMPLICIAL_TestAssert(PathAsList(PerimeterPathOfFace(torus,3))=[2,2,2,4,2,1,2]);
        SIMPLICIAL_TestAssert(PathAsList(PerimeterPathsOfFaces(ball)[1])=[1,2,2,3,2,2,1]);
        SIMPLICIAL_TestAssert(PathAsList(PerimeterPathsOfFaces(ball)[3])=[2,3,2,4,4,4,2]);

        # UmbrellaPathsOfVertices
        torus_umb := UmbrellaPathsOfVertices(torus);
        ball_umb := UmbrellaPathsOfVertices(ball);
        SIMPLICIAL_TestAssert(torus_umb[2] <> fail);
        SIMPLICIAL_TestAssert(IsUmbrellaPath(torus_umb[2]));
        SIMPLICIAL_TestAssert(Length(PathAsList(torus_umb[2]))=13);
        SIMPLICIAL_TestAssert(fail <> ball_umb[2]);
        SIMPLICIAL_TestAssert(ForAll(ball_umb, IsUmbrellaPath));
        SIMPLICIAL_TestAssert(Length(PathAsList(ball_umb[2]))=9);

        # MaximalGeodesicPaths
        SIMPLICIAL_TestAssert(Length(MaximalGeodesicPaths(torus))=3);
        SIMPLICIAL_TestAssert(Length(MaximalGeodesicPaths(ball))=1);

        # Orientation
        SIMPLICIAL_TestAssert(IsOrientable(torus));
        SIMPLICIAL_TestAssert(IsOrientable(ball));

        # Euler-characteristic
        SIMPLICIAL_TestAssert(EulerCharacteristic(torus)=0);
        SIMPLICIAL_TestAssert(EulerCharacteristic(ball)=2);

        # IsClosedSurface
        SIMPLICIAL_TestAssert(IsClosedSurface(torus));
        SIMPLICIAL_TestAssert(IsClosedSurface(ball));

        # EdgeDegrees
        SIMPLICIAL_TestAssert(EdgeDegreeOfVertex(torus,2)=3);
        SIMPLICIAL_TestAssert(EdgeDegreesOfVertices(ball)=[1,3,,1]);

        # FaceDegrees
        SIMPLICIAL_TestAssert(FaceDegreeOfVertex(torus,2) = 2);
        SIMPLICIAL_TestAssert(FaceDegreesOfVertices(ball)=[1,2,,1]);

        # VertexCounter
        SIMPLICIAL_TestAssert(VertexCounter(torus)=[ [2,1] ]);
        SIMPLICIAL_TestAssert(VertexCounter(ball)=[ [1,2], [2,1] ]);

        # IsFaceHomogeneous
        SIMPLICIAL_TestAssert(IsFaceHomogeneous(torus));
        SIMPLICIAL_TestAssert(IsTriangular(torus));
        SIMPLICIAL_TestAssert(not IsQuadrangular(torus));
        SIMPLICIAL_TestAssert(IsFaceHomogeneous(ball));
        SIMPLICIAL_TestAssert(IsTriangular(ball));
        SIMPLICIAL_TestAssert(not IsQuadrangular(ball));
    end
);
