(* Project: CommonGround 
   Description: A Wolfram Cloud App to foster unity by finding connections between nations.
   Author: Venelouis
*)

(* Helper Function: Create a fused flag representing unity *)
GenerateUnityFlag[c1_, c2_] := Module[{img1, img2, mask, blended},
  img1 = RemoveAlphaChannel[ImageResize[EntityValue[c1, "Flag"], {300, 200}]];
  img2 = RemoveAlphaChannel[ImageResize[EntityValue[c2, "Flag"], {300, 200}]];
  
  (* Create a gradient mask for smooth transition *)
  mask = LinearGradientImage[{Left, Right}, {300, 200}];
  
  (* Blend the images based on the gradient *)
  blended = ImageAdd[ImageMultiply[img1, mask], ImageMultiply[img2, ColorNegate[mask]]];
  
  (* Add a "Unity" watermark or frame *)
  ImagePad[blended, 5, White]
];

(* Helper Function: Find shared attributes *)
FindCommonalities[c1_, c2_] := Module[{langs1, langs2, sharedLangs, dist, popDiff},
  langs1 = EntityValue[c1, "Languages"];
  langs2 = EntityValue[c2, "Languages"];
  
  (* Find intersection of languages *)
  sharedLangs = Intersection[langs1, langs2];
  
  (* Calculate Geodesic distance *)
  dist = GeoDistance[c1, c2];
  
  {sharedLangs, dist}
];

(* The Main Cloud Deployment *)
CloudDeploy[
  FormPage[
    {
      "CountryA" -> "Country", 
      "CountryB" -> "Country"
    },
    Function[inputs,
      Module[{c1, c2, unitedFlag, commonData, sharedLangs, distance, map, lifeExp1, lifeExp2},
        c1 = inputs["CountryA"];
        c2 = inputs["CountryB"];
        
        (* 1. Generate Visual Unity *)
        unitedFlag = GenerateUnityFlag[c1, c2];
        
        (* 2. Calculate Data *)
        commonData = FindCommonalities[c1, c2];
        sharedLangs = commonData[[1]];
        distance = commonData[[2]];
        
        lifeExp1 = QuantityMagnitude[EntityValue[c1, "LifeExpectancy"]];
        lifeExp2 = QuantityMagnitude[EntityValue[c2, "LifeExpectancy"]];
        
        (* 3. Visualizing the Connection *)
        map = GeoGraphics[{
          Red, Thick, GeoPath[{c1, c2}, "Geodesic"],
          Black, PointSize[Medium], GeoMarker[c1], GeoMarker[c2]
        }, GeoBackground -> "VectorClassic", ImageSize -> Medium];

        (* 4. Construct the Report *)
        Grid[{
          {Style["The Common Ground Report", Title, FontFamily -> "Helvetica"]},
          {Style["Visualizing Unity between " <> CommonName[c1] <> " and " <> CommonName[c2], "Section"]},
          
          (* The Fused Flag *)
          {Column[{
             Style["A Symbol of Unity", "Subsection"],
             "We algorithmically blended your national identities:",
             unitedFlag
           }, Alignment -> Center]},
           
          (* The Map *)
          {Column[{
             Style["The Physical Connection", "Subsection"],
             "You are " <> ToString[Round[distance]] <> " apart, but connected by this path:",
             map
           }, Alignment -> Center]},
           
          (* Human Stats *)
          {Column[{
             Style["Shared Humanity", "Subsection"],
             BarChart[{lifeExp1, lifeExp2}, 
               ChartLabels -> {CommonName[c1], CommonName[c2]},
               PlotLabel -> "Life Expectancy (Years)",
               ColorFunction -> "Rainbow",
               ImageSize -> 300
             ],
             Style["Regardless of borders, we all strive for a long, healthy life.", Italic]
           }, Alignment -> Center]},
           
          (* Cultural Bridge *)
          {If[Length[sharedLangs] > 0,
             Column[{
               Style["The Language Bridge", "Subsection"],
               "You share these languages:",
               Row[CommonName /@ sharedLangs, ", "]
             }],
             Style["While you may speak different languages, diversity strengthens the global conversation.", "Text"]
           ]}
        }, Alignment -> Center, Spacings -> {2, 2}, Frame -> All]
      ]
    ],
    "Permissions" -> "Public",
    AppearanceRules -> <|
      "Title" -> "CommonGround",
      "Description" -> "Select two nations to find the unity between them."
    |>
  ]
]
