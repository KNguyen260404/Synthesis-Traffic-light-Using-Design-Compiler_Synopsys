/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : W-2024.09-SP3
// Date      : Thu Jul  3 16:02:58 2025
/////////////////////////////////////////////////////////////


module Second_counter_pMAX_VAL99 ( clk, en, rst_n, last, pre_last, count );
  output [6:0] count;
  input clk, en, rst_n;
  output last, pre_last;
  wire   N10, N11, N12, N13, N14, N15, N23, N25, N26, n3, n4, n5, n1, n2, n6,
         n7, n8, n9, n10, n11, n12, n13;

  SAEDRVT14_OR3_1 U12 ( .A1(count[6]), .A2(count[5]), .A3(count[4]), .X(n5) );
  SAEDRVT14_ND2B_U_0P5 U15 ( .A(last), .B(en), .X(n4) );
  SAEDRVT14_OR4_1 U16 ( .A1(count[3]), .A2(count[2]), .A3(count[1]), .A4(n5), 
        .X(n3) );
  SAEDRVT14_FDPSBQ_1 \int_count_reg[0]  ( .D(N23), .CK(clk), .SD(rst_n), .Q(
        count[0]) );
  SAEDRVT14_FDPRBQ_V2LP_1 \int_count_reg[3]  ( .D(N26), .CK(clk), .RD(rst_n), 
        .Q(count[3]) );
  SAEDRVT14_FDPRBQ_V2LP_1 \int_count_reg[2]  ( .D(N25), .CK(clk), .RD(rst_n), 
        .Q(count[2]) );
  SAEDRVT14_FSDPRBQ_V2LP_0P5 \int_count_reg[4]  ( .D(n1), .SI(n13), .SE(N13), 
        .CK(clk), .RD(rst_n), .Q(count[4]) );
  SAEDRVT14_FSDPSBQ_V2LP_0P5 \int_count_reg[1]  ( .D(n4), .SI(n6), .SE(N10), 
        .CK(clk), .SD(rst_n), .Q(count[1]) );
  SAEDRVT14_FSDPSBQ_V2LP_0P5 \int_count_reg[5]  ( .D(n7), .SI(n6), .SE(N14), 
        .CK(clk), .SD(rst_n), .Q(count[5]) );
  SAEDRVT14_FSDPSBQ_V2LP_0P5 \int_count_reg[6]  ( .D(n7), .SI(n6), .SE(N15), 
        .CK(clk), .SD(rst_n), .Q(count[6]) );
  SAEDRVT14_TIE0_V1_2 U3 ( .X(n1) );
  SAEDRVT14_TIE1_4 U4 ( .X(n6) );
  SAEDRVT14_OR2_MM_0P5 U5 ( .A1(n10), .A2(count[4]), .X(n2) );
  SAEDRVT14_INV_1P5 U6 ( .A(n7), .X(n13) );
  SAEDRVT14_INV_1P5 U7 ( .A(count[0]), .X(n12) );
  SAEDRVT14_BUF_ECO_1 U8 ( .A(n4), .X(n7) );
  SAEDRVT14_AN2_1 U9 ( .A1(N11), .A2(n13), .X(N25) );
  SAEDRVT14_AN2_1 U10 ( .A1(N12), .A2(n13), .X(N26) );
  SAEDRVT14_OR2_MM_0P5 U11 ( .A1(n12), .A2(n7), .X(N23) );
  SAEDRVT14_NR2_MM_0P5 U13 ( .A1(n3), .A2(n12), .X(pre_last) );
  SAEDRVT14_NR2_MM_0P5 U14 ( .A1(n3), .A2(count[0]), .X(last) );
  SAEDRVT14_OR2_MM_0P5 U17 ( .A1(count[0]), .A2(count[1]), .X(n8) );
  SAEDRVT14_AO21B_0P5 U18 ( .A1(count[0]), .A2(count[1]), .B(n8), .X(N10) );
  SAEDRVT14_OR2_MM_0P5 U19 ( .A1(n8), .A2(count[2]), .X(n9) );
  SAEDRVT14_AO21B_0P5 U20 ( .A1(n8), .A2(count[2]), .B(n9), .X(N11) );
  SAEDRVT14_OR2_MM_0P5 U21 ( .A1(n9), .A2(count[3]), .X(n10) );
  SAEDRVT14_AO21B_0P5 U22 ( .A1(n9), .A2(count[3]), .B(n10), .X(N12) );
  SAEDRVT14_AO21B_0P5 U23 ( .A1(n10), .A2(count[4]), .B(n2), .X(N13) );
  SAEDRVT14_EN2_0P5 U24 ( .A1(count[5]), .A2(n2), .X(N14) );
  SAEDRVT14_NR2_MM_0P5 U25 ( .A1(count[5]), .A2(n2), .X(n11) );
  SAEDRVT14_EO2_V1_0P75 U26 ( .A1(count[6]), .A2(n11), .X(N15) );
endmodule



    module Light_Counter_pGREEN_INIT_VAL14_pYELLOW_INIT_VAL2_pRED_INIT_VAL17_pCNT_WIDTH5_pINIT_WIDTH3 ( 
        clk, en, rst_n, init, last, cnt_out );
  input [2:0] init;
  output [4:0] cnt_out;
  input clk, en, rst_n;
  output last;
  wire   N8, N9, N10, N11, N12, n6, n7, n8, n9, n10, n11, n12, n13, n14, n15,
         n16, n17, n18, n19, n1, n2, n3, n4, n5, n20, n21, n22, n23, n24;

  SAEDRVT14_AOI22_1P5 U11 ( .A1(N9), .A2(n1), .B1(n24), .B2(cnt_out[1]), .X(
        n11) );
  SAEDRVT14_FDPSBQ_1 \count_reg[1]  ( .D(n18), .CK(clk), .SD(rst_n), .Q(
        cnt_out[1]) );
  SAEDRVT14_FDPSBQ_1 \count_reg[2]  ( .D(n17), .CK(clk), .SD(rst_n), .Q(
        cnt_out[2]) );
  SAEDRVT14_FDPSBQ_1 \count_reg[3]  ( .D(n16), .CK(clk), .SD(rst_n), .Q(
        cnt_out[3]) );
  SAEDRVT14_FDPRBQ_V2_0P5 \count_reg[4]  ( .D(n15), .CK(clk), .RD(rst_n), .Q(
        cnt_out[4]) );
  SAEDRVT14_FDPRBQ_V2_1 \count_reg[0]  ( .D(n19), .CK(clk), .RD(rst_n), .Q(
        cnt_out[0]) );
  SAEDRVT14_INV_1P5 U3 ( .A(n9), .X(n21) );
  SAEDRVT14_OR2_MM_0P5 U4 ( .A1(init[1]), .A2(init[0]), .X(n8) );
  SAEDRVT14_INV_1P5 U5 ( .A(n1), .X(n24) );
  SAEDRVT14_AO221_0P5 U6 ( .A1(N10), .A2(n20), .B1(cnt_out[2]), .B2(n21), .C(
        init[0]), .X(n17) );
  SAEDRVT14_NR4_0P75 U7 ( .A1(cnt_out[0]), .A2(cnt_out[1]), .A3(n14), .A4(
        cnt_out[2]), .X(last) );
  SAEDRVT14_OAI21_0P75 U8 ( .A1(init[2]), .A2(n11), .B(n23), .X(n18) );
  SAEDRVT14_INV_1P5 U9 ( .A(n8), .X(n23) );
  SAEDRVT14_AOI21_0P5 U10 ( .A1(n12), .A2(n13), .B(n8), .X(n19) );
  SAEDRVT14_ND2_CDC_0P5 U12 ( .A1(cnt_out[0]), .A2(n24), .X(n13) );
  SAEDRVT14_AOI21_0P5 U13 ( .A1(N8), .A2(n1), .B(init[2]), .X(n12) );
  SAEDRVT14_INV_1P5 U14 ( .A(cnt_out[0]), .X(N8) );
  SAEDRVT14_AOI21_0P5 U15 ( .A1(n6), .A2(n7), .B(n8), .X(n15) );
  SAEDRVT14_ND2_CDC_0P5 U16 ( .A1(cnt_out[4]), .A2(n24), .X(n7) );
  SAEDRVT14_AOI21_0P5 U17 ( .A1(n1), .A2(N12), .B(init[2]), .X(n6) );
  SAEDRVT14_BUF_ECO_1 U18 ( .A(n2), .X(n1) );
  SAEDRVT14_BUF_ECO_1 U19 ( .A(en), .X(n2) );
  SAEDRVT14_OR2_MM_0P5 U20 ( .A1(cnt_out[4]), .A2(cnt_out[3]), .X(n14) );
  SAEDRVT14_AO221_0P5 U21 ( .A1(N11), .A2(n20), .B1(cnt_out[3]), .B2(n21), .C(
        init[0]), .X(n16) );
  SAEDRVT14_INV_S_0P5 U22 ( .A(n10), .X(n20) );
  SAEDRVT14_INV_S_0P5 U23 ( .A(init[1]), .X(n22) );
  SAEDRVT14_ND3B_0P75 U24 ( .A(init[2]), .B1(n22), .B2(n1), .X(n10) );
  SAEDRVT14_ND3B_0P75 U25 ( .A(init[2]), .B1(n22), .B2(n10), .X(n9) );
  SAEDRVT14_OR2_MM_0P5 U26 ( .A1(cnt_out[0]), .A2(cnt_out[1]), .X(n3) );
  SAEDRVT14_AO21B_0P5 U27 ( .A1(cnt_out[0]), .A2(cnt_out[1]), .B(n3), .X(N9)
         );
  SAEDRVT14_OR2_MM_0P5 U28 ( .A1(n3), .A2(cnt_out[2]), .X(n4) );
  SAEDRVT14_AO21B_0P5 U29 ( .A1(n3), .A2(cnt_out[2]), .B(n4), .X(N10) );
  SAEDRVT14_EN2_0P5 U30 ( .A1(cnt_out[3]), .A2(n4), .X(N11) );
  SAEDRVT14_NR2_MM_0P5 U31 ( .A1(cnt_out[3]), .A2(n4), .X(n5) );
  SAEDRVT14_EO2_V1_0P75 U32 ( .A1(cnt_out[4]), .A2(n5), .X(N12) );
endmodule


module Counter_decoder_pNUMBER_WIDTH5_pLED_WIDTH8_pLED_NO2 ( clk, en, number, 
        display_led );
  input [4:0] number;
  output [15:0] display_led;
  input clk, en;
  wire   \*Logic0* , display_led_9, display_led_8, n17, n18, n19, n20, n21,
         n22, n23, n24, n25, n26, n27, n28, n29, n30, n31, n32, n33, n34, n35,
         n36, n37, n38, n39, n40, n41, n42, n43, n44, n45, n46, n47, n48, n49,
         n50, n51, n52, n53, n54, n55, n56, n57, n58, n59, n60, n61, n62, n63,
         n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14, n15, n16
;
  assign display_led[7] = \*Logic0* ;
  assign display_led[14] = \*Logic0* ;
  assign display_led[15] = \*Logic0* ;
  assign display_led[9] = display_led_9;
  assign display_led[10] = display_led_9;
  assign display_led[8] = display_led_8;
  assign display_led[11] = display_led_8;
  assign display_led[12] = display_led_8;
  assign display_led[13] = display_led_8;

  SAEDRVT14_AN3_0P75 U21 ( .A1(n14), .A2(n7), .A3(n53), .X(n50) );
  SAEDRVT14_OA21B_1 U68 ( .A1(n20), .A2(number[2]), .B(n21), .X(n19) );
  SAEDRVT14_OA31_1 U69 ( .A1(n26), .A2(n27), .A3(n28), .B(en), .X(
        display_led[6]) );
  SAEDRVT14_AO33_1 U70 ( .A1(n31), .A2(n24), .A3(en), .B1(n7), .B2(n25), .B3(
        n9), .X(display_led[5]) );
  SAEDRVT14_AO32_1 U71 ( .A1(n32), .A2(n15), .A3(n33), .B1(n12), .B2(n34), .X(
        n31) );
  SAEDRVT14_AO32_1 U72 ( .A1(n36), .A2(n24), .A3(n25), .B1(n37), .B2(en), .X(
        display_led[2]) );
  SAEDRVT14_OA21_1 U73 ( .A1(n40), .A2(n41), .B(en), .X(display_led[1]) );
  SAEDRVT14_OA31_1 U74 ( .A1(n21), .A2(n10), .A3(n35), .B(en), .X(
        display_led[0]) );
  SAEDRVT14_TIE0_V1_2 U3 ( .X(\*Logic0* ) );
  SAEDRVT14_INV_1P5 U4 ( .A(n24), .X(n9) );
  SAEDRVT14_AN2_1 U5 ( .A1(n60), .A2(n11), .X(n21) );
  SAEDRVT14_ND2_CDC_0P5 U6 ( .A1(n9), .A2(n60), .X(n29) );
  SAEDRVT14_INV_1P5 U7 ( .A(n30), .X(n6) );
  SAEDRVT14_INV_1P5 U8 ( .A(n63), .X(n10) );
  SAEDRVT14_ND3B_0P75 U9 ( .A(n6), .B1(n23), .B2(n29), .X(n28) );
  SAEDRVT14_ND3B_0P75 U10 ( .A(n21), .B1(n22), .B2(n57), .X(n40) );
  SAEDRVT14_AN2_1 U11 ( .A1(n35), .A2(en), .X(display_led[3]) );
  SAEDRVT14_OR2_MM_0P5 U12 ( .A1(n14), .A2(n13), .X(n24) );
  SAEDRVT14_ND2_CDC_0P5 U13 ( .A1(n49), .A2(n53), .X(n22) );
  SAEDRVT14_INV_1P5 U14 ( .A(n36), .X(n7) );
  SAEDRVT14_ND2_CDC_0P5 U15 ( .A1(n7), .A2(n53), .X(n57) );
  SAEDRVT14_NR2_MM_0P5 U16 ( .A1(n36), .A2(n4), .X(n60) );
  SAEDRVT14_NR2_MM_0P5 U17 ( .A1(n32), .A2(n16), .X(n25) );
  SAEDRVT14_NR2_MM_0P5 U18 ( .A1(n20), .A2(n24), .X(n54) );
  SAEDRVT14_INV_1P5 U19 ( .A(n32), .X(n12) );
  SAEDRVT14_OAI21_0P75 U20 ( .A1(n4), .A2(n42), .B(n1), .X(n41) );
  SAEDRVT14_INV_1P5 U22 ( .A(n27), .X(n1) );
  SAEDRVT14_OAI21_0P75 U23 ( .A1(n7), .A2(n14), .B(n13), .X(n42) );
  SAEDRVT14_ND3B_0P75 U24 ( .A(n36), .B1(n4), .B2(n11), .X(n23) );
  SAEDRVT14_INV_1P5 U25 ( .A(n39), .X(n11) );
  SAEDRVT14_OR2_MM_0P5 U26 ( .A1(n20), .A2(n39), .X(n30) );
  SAEDRVT14_ND3B_0P75 U27 ( .A(n15), .B1(n14), .B2(n13), .X(n63) );
  SAEDRVT14_INV_1P5 U28 ( .A(n45), .X(n2) );
  SAEDRVT14_ND3B_0P75 U29 ( .A(n46), .B1(n47), .B2(n48), .X(n45) );
  SAEDRVT14_ND3B_0P75 U30 ( .A(n50), .B1(n51), .B2(n52), .X(n46) );
  SAEDRVT14_ND3B_0P75 U31 ( .A(n39), .B1(n4), .B2(n49), .X(n48) );
  SAEDRVT14_INV_1P5 U32 ( .A(n61), .X(n3) );
  SAEDRVT14_ND3B_0P75 U33 ( .A(n62), .B1(n55), .B2(n57), .X(n61) );
  SAEDRVT14_ND3B_0P75 U34 ( .A(n26), .B1(n22), .B2(n23), .X(n62) );
  SAEDRVT14_ND3B_0P75 U35 ( .A(n24), .B1(n4), .B2(n49), .X(n55) );
  SAEDRVT14_ND3B_0P75 U36 ( .A(n14), .B1(n53), .B2(n49), .X(n52) );
  SAEDRVT14_ND3B_0P75 U37 ( .A(n58), .B1(n3), .B2(n59), .X(n35) );
  SAEDRVT14_AN4_1 U38 ( .A1(n29), .A2(n47), .A3(n51), .A4(n30), .X(n59) );
  SAEDRVT14_OAI21_0P75 U39 ( .A1(n63), .A2(n33), .B(n5), .X(n58) );
  SAEDRVT14_INV_1P5 U40 ( .A(n54), .X(n5) );
  SAEDRVT14_AO22_1 U41 ( .A1(n24), .A2(n25), .B1(n15), .B2(en), .X(
        display_led_9) );
  SAEDRVT14_NR2_MM_0P5 U42 ( .A1(n3), .A2(n16), .X(display_led[4]) );
  SAEDRVT14_AN2_1 U43 ( .A1(en), .A2(n17), .X(display_led_8) );
  SAEDRVT14_NR2_MM_0P5 U44 ( .A1(number[1]), .A2(number[4]), .X(n49) );
  SAEDRVT14_INV_1P5 U45 ( .A(number[3]), .X(n14) );
  SAEDRVT14_INV_1P5 U46 ( .A(number[2]), .X(n13) );
  SAEDRVT14_NR2_MM_0P5 U47 ( .A1(number[0]), .A2(number[2]), .X(n53) );
  SAEDRVT14_OAI21_0P75 U48 ( .A1(number[2]), .A2(n14), .B(n39), .X(n32) );
  SAEDRVT14_ND2_CDC_0P5 U49 ( .A1(number[1]), .A2(number[0]), .X(n33) );
  SAEDRVT14_INV_1P5 U50 ( .A(number[1]), .X(n8) );
  SAEDRVT14_INV_1P5 U51 ( .A(number[0]), .X(n4) );
  SAEDRVT14_INV_1P5 U52 ( .A(number[4]), .X(n15) );
  SAEDRVT14_ND2_CDC_0P5 U53 ( .A1(number[0]), .A2(n49), .X(n20) );
  SAEDRVT14_OR2_MM_0P5 U54 ( .A1(n13), .A2(number[3]), .X(n39) );
  SAEDRVT14_OR2_MM_0P5 U55 ( .A1(n8), .A2(number[4]), .X(n36) );
  SAEDRVT14_AOI21_0P5 U56 ( .A1(n38), .A2(n12), .B(number[4]), .X(n37) );
  SAEDRVT14_AOI21_0P5 U57 ( .A1(n9), .A2(number[1]), .B(number[0]), .X(n38) );
  SAEDRVT14_NR2_MM_0P5 U58 ( .A1(n63), .A2(number[0]), .X(n26) );
  SAEDRVT14_OAI22_0P75 U59 ( .A1(n8), .A2(n15), .B1(number[1]), .B2(number[0]), 
        .X(n34) );
  SAEDRVT14_INV_1P5 U60 ( .A(en), .X(n16) );
  SAEDRVT14_ND3B_0P75 U61 ( .A(number[3]), .B1(n13), .B2(n60), .X(n51) );
  SAEDRVT14_ND3B_0P75 U62 ( .A(n20), .B1(n13), .B2(number[3]), .X(n47) );
  SAEDRVT14_ND3B_0P75 U63 ( .A(n43), .B1(n44), .B2(n2), .X(n27) );
  SAEDRVT14_ND3B_0P75 U64 ( .A(n24), .B1(n4), .B2(n7), .X(n44) );
  SAEDRVT14_ND3B_0P75 U65 ( .A(n54), .B1(n55), .B2(n56), .X(n43) );
  SAEDRVT14_ND2_CDC_0P5 U66 ( .A1(n10), .A2(number[1]), .X(n56) );
  SAEDRVT14_ND3B_0P75 U67 ( .A(n18), .B1(n2), .B2(n19), .X(n17) );
  SAEDRVT14_ND3B_0P75 U75 ( .A(n6), .B1(n22), .B2(n23), .X(n18) );
endmodule


module Light_FSM_LIGHT_STATE_WIDTH3 ( clk, en, rst_n, light_cnt_last, 
        second_cnt_pre_last, light, light_cnt_init );
  output [2:0] light;
  output [2:0] light_cnt_init;
  input clk, en, rst_n, light_cnt_last, second_cnt_pre_last;
  wire   N8, N9, n7, n8, n9, n10, n11, n12, n13, n14, n15, n16, n17, n1, n2,
         n3, n4, n5, n18, n19, n20, n21;
  wire   [1:0] light_current_state;

  SAEDRVT14_AN3_0P75 U3 ( .A1(n7), .A2(n18), .A3(n4), .X(light_cnt_init[2]) );
  SAEDRVT14_AN3_0P75 U4 ( .A1(n4), .A2(n7), .A3(light_current_state[0]), .X(
        light_cnt_init[0]) );
  SAEDRVT14_EO2_V1_0P75 U25 ( .A1(n10), .A2(light_current_state[0]), .X(n9) );
  SAEDRVT14_AO32_1 U26 ( .A1(n18), .A2(n19), .A3(en), .B1(n14), .B2(
        light_current_state[1]), .X(n13) );
  SAEDRVT14_FDPRBQ_V2LP_1 \light_current_state_reg[0]  ( .D(N8), .CK(clk), 
        .RD(rst_n), .Q(light_current_state[0]) );
  SAEDRVT14_FDPRBQ_V2_1 \light_current_state_reg[1]  ( .D(N9), .CK(clk), .RD(
        rst_n), .Q(light_current_state[1]) );
  SAEDRVT14_INV_1P5 U5 ( .A(n8), .X(light_cnt_init[1]) );
  SAEDRVT14_OR2_MM_0P5 U6 ( .A1(n10), .A2(n12), .X(n8) );
  SAEDRVT14_ND2_CDC_0P5 U7 ( .A1(n2), .A2(light_cnt_last), .X(n10) );
  SAEDRVT14_INV_1P5 U8 ( .A(n3), .X(n4) );
  SAEDRVT14_NR2_MM_0P5 U9 ( .A1(n16), .A2(n21), .X(N8) );
  SAEDRVT14_OA221_U_0P5 U10 ( .A1(n19), .A2(n18), .B1(n20), .B2(n12), .C(n17), 
        .X(n16) );
  SAEDRVT14_OAI21_0P75 U11 ( .A1(n20), .A2(n19), .B(n18), .X(n17) );
  SAEDRVT14_AOI21_0P5 U12 ( .A1(n8), .A2(n15), .B(n21), .X(N9) );
  SAEDRVT14_OR2_MM_0P5 U13 ( .A1(n19), .A2(n14), .X(n15) );
  SAEDRVT14_INV_1P5 U14 ( .A(light_current_state[0]), .X(n18) );
  SAEDRVT14_OR2_MM_0P5 U15 ( .A1(n18), .A2(light_current_state[1]), .X(n12) );
  SAEDRVT14_INV_1P5 U16 ( .A(n1), .X(n2) );
  SAEDRVT14_INV_1P5 U17 ( .A(second_cnt_pre_last), .X(n1) );
  SAEDRVT14_INV_1P5 U18 ( .A(light_current_state[1]), .X(n19) );
  SAEDRVT14_OAI21_0P75 U19 ( .A1(n12), .A2(n20), .B(n5), .X(light[0]) );
  SAEDRVT14_INV_1P5 U20 ( .A(n13), .X(n5) );
  SAEDRVT14_INV_1P5 U21 ( .A(en), .X(n21) );
  SAEDRVT14_NR2_MM_0P5 U22 ( .A1(n9), .A2(n19), .X(light[2]) );
  SAEDRVT14_ND2_CDC_0P5 U23 ( .A1(n8), .A2(n11), .X(light[1]) );
  SAEDRVT14_ND3B_0P75 U24 ( .A(light_current_state[0]), .B1(n10), .B2(
        light_current_state[1]), .X(n11) );
  SAEDRVT14_AN2_1 U27 ( .A1(light_current_state[1]), .A2(light_cnt_last), .X(
        n7) );
  SAEDRVT14_INV_0P75 U28 ( .A(n2), .X(n3) );
  SAEDRVT14_INV_S_0P5 U29 ( .A(n10), .X(n20) );
  SAEDRVT14_NR2_MM_0P5 U30 ( .A1(n18), .A2(n10), .X(n14) );
endmodule


module Traffic_light ( clk, en, rst_n, green_light, yellow_light, red_light, 
        count );
  output [6:0] count;
  input clk, en, rst_n;
  output green_light, yellow_light, red_light;
  wire   second_cnt_last, second_cnt_pre_last, light_cnt_en, light_cnt_last;
  wire   [2:0] light_cnt_init;
  wire   [4:0] light_cnt_out;

  Second_counter_pMAX_VAL99 second_cnt ( .clk(clk), .en(en), .rst_n(rst_n), 
        .last(second_cnt_last), .pre_last(second_cnt_pre_last), .count(count)
         );
  Light_Counter_pGREEN_INIT_VAL14_pYELLOW_INIT_VAL2_pRED_INIT_VAL17_pCNT_WIDTH5_pINIT_WIDTH3 dut1 ( 
        .clk(clk), .en(light_cnt_en), .rst_n(rst_n), .init(light_cnt_init), 
        .last(light_cnt_last), .cnt_out(light_cnt_out) );
  Counter_decoder_pNUMBER_WIDTH5_pLED_WIDTH8_pLED_NO2 dut2 ( .clk(clk), .en(en), .number(light_cnt_out) );
  Light_FSM_LIGHT_STATE_WIDTH3 dut3 ( .clk(clk), .en(en), .rst_n(rst_n), 
        .light_cnt_last(light_cnt_last), .second_cnt_pre_last(
        second_cnt_pre_last), .light({red_light, yellow_light, green_light}), 
        .light_cnt_init(light_cnt_init) );
  SAEDRVT14_AN2_1 U2 ( .A1(second_cnt_last), .A2(en), .X(light_cnt_en) );
endmodule

