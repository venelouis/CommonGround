(* CommonGround - CODE FOR VIDEO DEMO *)
(* This code runs locally on your computer. Use it to record your screen. *)
(* Visit the link to see it in action: https://www.wolframcloud.com/obj/venelouis/Published/CommonGround.nb *)
(*The Cloud deploy relies on paid tier computation for GeoGraphics, please refer to the video demo for the full experience.*)

Module[{c1, c2, name1, name2, flag1, flag2, blendedFlag, dist, map, chart, finalImage},
 
 (* --- CONFIGURATION: CHOOSE COUNTRIES HERE --- *)
 c1 = Entity[, ];
 c2 = Entity[, ];
 
 Print[ <> CommonName[c1] <>  <> CommonName[c2] <> ];

 (* 1. PREPARE DATA *)
 name1 = CommonName[c1];
 name2 = CommonName[c2];

 (* 2. FLAGS (Fusion) *)
 flag1 = EntityValue[c1, ];
 flag2 = EntityValue[c2, ];
 
 blendedFlag = Module[{f1, f2, mask},
    f1 = RemoveAlphaChannel[ImageResize[flag1, {500, 300}]];
    f2 = RemoveAlphaChannel[ImageResize[flag2, {500, 300}]];
    mask = LinearGradientImage[{Left, Right}, {500, 300}];
    ImagePad[ImageAdd[ImageMultiply[f1, mask], ImageMultiply[f2, ColorNegate[mask]]], 5, White]
 ];

 (* 3. MAP (High Resolution) *)
 dist = GeoDistance[c1, c2];
 map = GeoGraphics[{
      Red, Thick, GeoPath[{c1, c2}, ],
      Black, PointSize[Large], GeoMarker[c1], GeoMarker[c2]
   }, GeoBackground -> , ImageSize -> 500, PlotLabel -> None];

 (* 4. CHART *)
 chart = BarChart[
    {QuantityMagnitude[EntityValue[c1, ]], 
     QuantityMagnitude[EntityValue[c2, ]]}, 
    ChartLabels -> {name1, name2}, 
    PlotLabel -> Style[, 18, FontFamily -> ],
    ColorFunction -> , ImageSize -> 500
 ];

 (* 5. FINAL POSTER ASSEMBLY *)
 finalImage = Column[{
   Style[, 50, Bold, FontFamily -> , Darker[Blue]],
   Style[ <> name1 <>  <> name2, 24, Gray],
   Spacer[20],
   
   Style[, 14, Bold, Gray],
   blendedFlag,
   Spacer[20],
   
   Style[, 14, Bold, Gray],
   Style[ <> ToString[Round[QuantityMagnitude[dist]]] <> , 18],
   map,
   Spacer[20],
   
   Style[, 14, Bold, Gray],
   chart,
   Spacer[30],
   
   Style[, 12, LightGray]
 }, Alignment -> Center, Background -> White, Frame -> True, FrameStyle -> LightGray, FrameMargins -> 40];
 
 (* 6. DISPLAY RESULT *)
 Rasterize[finalImage, , ImageResolution -> 120]
] 

