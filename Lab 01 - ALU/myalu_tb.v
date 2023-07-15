//=========================================================================
// Name & Email must be EXACTLY as in Gradescope roster!
// Name: Christopher Arellano
// Email: carel009@ucr.edu
// 
// Assignment name: Lab 01 - ALU
// Lab section: 021
// TA: Quan Fan
// 
// I hereby certify that I have not received assistance on this assignment,
// or used code, from ANY outside source other than the instruction team
// (apart from what was provided in the starter file).
//
//=========================================================================

`timescale 1ns / 1ps

module myalu_tb;
    parameter NUMBITS = 8;

    // Inputs
    reg clk;
    reg reset;
    reg [NUMBITS-1:0] A;
    reg [NUMBITS-1:0] B;
    reg [2:0] opcode;

    // Outputs
    wire [NUMBITS-1:0] result;
    reg [NUMBITS-1:0] R;
    wire carryout;
    wire overflow;
    wire zero;

    // -------------------------------------------------------
    // Instantiate the Unit Under Test (UUT)
    // -------------------------------------------------------
    myalu #(.NUMBITS(NUMBITS)) uut (
        .clk(clk),
        .reset(reset) ,  
        .A(A), 
        .B(B), 
        .opcode(opcode), 
        .result(result), 
        .carryout(carryout), 
        .overflow(overflow), 
        .zero(zero)
    );

      initial begin

     clk = 0; reset = 1; #50; 
     clk = 1; reset = 1; #50; 
     clk = 0; reset = 0; #50; 
     clk = 1; reset = 0; #50; 
         
     forever begin 
        clk = ~clk; #50; 
     end 
     
    end 
    
    integer totalTests = 0;
    integer failedTests = 0;
    initial begin // Test suite
        // Reset
        @(negedge reset); // Wait for reset to be released (from another initial block)
        @(posedge clk); // Wait for first clock out of reset 
        #10; // Wait 

        // Additional test cases
        // ---------------------------------------------
        // Testing unsigned additions 
        // --------------------------------------------- 
        $write("Test Group 1: Testing unsigned additions ... \n");
        opcode = 3'b000; 
        totalTests = totalTests + 1;
        $write("\tTest Case 1.1: Unsigned Add ... ");
        A = 8'hFF; //255
        B = 8'h01; //1
        R = 8'h00; //256 (overflow)
        #100; // Wait 
        if (R != result || zero != 1'b1 || carryout != 1'b1) begin
            $write("failed\n");
            failedTests = failedTests + 1;
        end else begin
            $write("passed\n");
        end
        #10; // Wait 
        
		// Add more tests here

        totalTests = totalTests + 1;
		$write("\tTest Case 1.2 Unsigned Add ...");
		A = 8'h0F; //15
   		B = 8'h0F; //15
		R = 8'h1E; //30
		#100; // Wait
		if (R != result || zero != 1'b0 || carryout != 1'b0) begin
            $write("failed\n");
            failedTests = failedTests + 1;
        end else begin
            $write("passed\n");
        end
        #10; // Wait
	
        totalTests = totalTests + 1;
		$write("\tTest Case 1.3 Unsigned Add ...");
		A = 8'h0F; //15
   		B = 8'h01; //1
		R = 8'h10; //16
		#100; // Wait
		if (R != result || zero != 1'b0 || carryout != 1'b0) begin
            $write("failed\n");
            failedTests = failedTests + 1;
        end else begin
            $write("passed\n");
        end
        #10; // Wait

        // ---------------------------------------------
        // Testing unsigned subs 
        // --------------------------------------------- 
        $write("Test Group 2: Testing unsigned subs ...\n");
        opcode = 3'b010; 
        
		// Add more tests here

        totalTests = totalTests + 1;
		$write("\tTest Case 2.1 Unsigned subs ...");
		A = 8'hFF; //255
   		B = 8'hFF; //255
		R = 8'h00; //0
		#100; // Wait
		if (R != result || zero != 1'b1 || carryout != 1'b0) begin
            $write("failed\n");
            failedTests = failedTests + 1;
        end else begin
            $write("passed\n");
        end
        #10; // Wait
		
        totalTests = totalTests + 1;
		$write("\tTest Case 2.2 Unsigned subs ...");
		A = 8'h00; //0
   		B = 8'h00; //0
		R = 8'h00; //0
		#100; // Wait
		if (R != result || zero != 1'b1 || carryout != 1'b0) begin
            $write("failed\n");
            failedTests = failedTests + 1;
        end else begin
            $write("passed\n");
        end
        #10; // Wait
		
        totalTests = totalTests + 1;
		$write("\tTest Case 2.3 Unsigned subs ...");
		A = 8'h0C; //12
   		B = 8'h02; //2
		R = 8'h0A; //10
		#100; // Wait
		if (R != result || zero != 1'b0 || carryout != 1'b0) begin
            $write("failed\n");
            failedTests = failedTests + 1;
        end else begin
            $write("passed\n");
        end
        #10; // Wait

        // ---------------------------------------------
        // Testing signed adds 
        // --------------------------------------------- 
        $write("Test Group 3: Testing signed adds ...\n");
        opcode = 3'b001; 

		// Add more tests here

        totalTests = totalTests + 1;
		$write("\tTest Case 3.1 Signed adds ...");
		A = $signed(~({8'h0F})) + $signed(8'h01); //-15
   		B = 8'h0F; //15
		R = 8'h00; //0
		#100; // Wait
		if (R != result || zero != 1'b1 || overflow != 1'b0) begin
            $write("failed\n");
            failedTests = failedTests + 1;
        end else begin
            $write("passed\n");
        end
		#10; // Wait
		
        totalTests = totalTests + 1;
		$write("\tTest Case 3.2 Signed adds ...");
		A = 8'h10; //16
   		B = $signed(~({8'h08})) + $signed(8'h01); //-8
		R = 8'h08; //8
		#100; // Wait
		if (R != result || zero != 1'b0 || overflow != 1'b0) begin
            $write("failed\n");
            failedTests = failedTests + 1;
        end else begin
            $write("passed\n");
        end
		#10; // Wait
		
        totalTests = totalTests + 1;
		$write("\tTest Case 3.3 Signed adds ...");
		A = $signed(~({8'h01})) + $signed(8'h01); //-1
   		B = $signed(~({8'h02})) + $signed(8'h01); //-2
		R = $signed(~({8'h03})) + $signed(8'h01); //-3 
		#100; // Wait
		if (R != result || zero != 1'b0 || overflow != 1'b0) begin
            $write("failed\n");
            failedTests = failedTests + 1;
        end else begin
            $write("passed\n");
        end
        #10; // Wait

        // ---------------------------------------------
        // Testing signed subs 
        // --------------------------------------------- 
        $write("Test Group 4: Testing signed subs ...\n");
        opcode = 3'b011; 
                
		// Add more tests here

        totalTests = totalTests + 1;
		$write("\tTest Case 4.1 Signed subs ...");
		A = 8'hFF; //255
		B = $signed(~({8'h01})) + $signed(8'h01); //-1
		R = 8'h00; //256 (overflow)
		#100; // Wait
		if (R != result || zero != 1'b1 || overflow != 1'b1) begin
            $write("failed\n");
            failedTests = failedTests + 1;
        end else begin
            $write("passed\n");
        end
        #10; // Wait
		
        totalTests = totalTests + 1;
		$write("\tTest Case 4.2 Signed subs ...");
		A = 8'hA0; //160
		B = $signed(~({8'h01})) + $signed(8'h01); //-1  
		R = 8'hA1; //161
		#100; // Wait
		if (R != result || zero != 1'b0 || overflow != 1'b0) begin
            $write("failed\n");
            failedTests = failedTests + 1;
        end else begin
            $write("passed\n");
        end
        #10; // Wait
		
        totalTests = totalTests + 1;
		$write("\tTest Case 4.3 Signed subs ...");
		A = 8'h10; //16 
		B = 8'h01; //1   
		R = 8'h0F; //15
		#100; // Wait
		if (R != result || zero != 1'b0 || overflow != 1'b0) begin
            $write("failed\n");
            failedTests = failedTests + 1;
        end else begin
            $write("passed\n");
        end
        #10; // Wait

        // ---------------------------------------------
        // Testing ANDS 
        // --------------------------------------------- 
        $write("Test Group 5: Testing ANDs ...\n");
        opcode = 3'b100; 
                
		// Add more tests here

        totalTests = totalTests + 1;
		$write("\tTest Case 5.1 ANDs ...");
		A = 8'hFF; //255
		B = 8'h00; //0
		R = 8'h00; //0
		#100; // Wait
		if (R != result || zero != 1'b1) begin
            $write("failed\n");
            failedTests = failedTests + 1;
        end else begin
            $write("passed\n");
        end
        #10; // Wait
		
        totalTests = totalTests + 1;
		$write("\tTest Case 5.2 ANDs ...");
		A = 8'hF0; //240
		B = 8'h0F; //15
		R = 8'h00; //0
		#100; // Wait
		if (R != result || zero != 1'b1) begin
            $write("failed\n");
            failedTests = failedTests + 1;
        end else begin
            $write("passed\n");
        end
        #10; // Wait

        totalTests = totalTests + 1;
		$write("\tTest Case 5.3 ANDs ...");
		A = 8'hFF; //255
		B = 8'h11; //17
		R = 8'h11; //17
		#100; // Wait
		if (R != result || zero != 1'b0) begin
            $write("failed\n");
            failedTests = failedTests + 1;
        end else begin
            $write("passed\n");
        end
        #10; // Wait

        // ----------------------------------------
        // ORs 
        // ---------------------------------------- 
        $write("Test Group 6: Testing ORs ...\n");
        opcode = 3'b101; 
        
		// Add more tests here

        totalTests = totalTests + 1;
		$write("\tTest Case 6.1 ORs ...");
		A = 8'h0F; //15
		B = 8'hF0; //240
		R = 8'hFF; //255
		#100; // Wait
		if (R != result || zero != 1'b0) begin
            $write("failed\n");
            failedTests = failedTests + 1;
        end else begin
            $write("passed\n");
        end
        #10; // Wait
		
        totalTests = totalTests + 1;
		$write("\tTest Case 6.2 ORs ...");
		A = 8'hB2; //178
		B = 8'h0D; //13
		R = 8'hBF; //191
		#100; // Wait
		if (R != result || zero != 1'b0) begin
            $write("failed\n");
            failedTests = failedTests + 1;
        end else begin
            $write("passed\n");
        end
        #10; // Wait

        totalTests = totalTests + 1;
		$write("\tTest Case 6.3 ORs ...");
		A = 8'h02; //2
		B = 8'hD2; //210
		R = 8'hD2; //210
		#100; // Wait
		if (R != result || zero != 1'b0) begin
            $write("failed\n");
            failedTests = failedTests + 1;
        end else begin
            $write("passed\n");
        end
        #10; // Wait
        
        // ----------------------------------------
        // XORs 
        // ---------------------------------------- 
        $write("Test Group 7: Testing XORs ...\n");
        opcode = 3'b110; 
        
		// Add more tests here

        totalTests = totalTests + 1;
		$write("\tTest Case 7.1 XORs ...");
		A = 8'h7B; //123
		B = 8'h05; //5
		R = 8'h7E; //126
		#100; // Wait
		if (R != result || zero != 1'b0) begin
            $write("failed\n");
            failedTests = failedTests + 1;
        end else begin
            $write("passed\n");
        end
        #10; // Wait
		
        totalTests = totalTests + 1;
		$write("\tTest Case 7.2 XORs ...");
		A = 8'h0F; //15
		B = 8'h0F; //15
		R = 8'h00; //0
		#100; // Wait
		if (R != result || zero != 1'b1) begin
            $write("failed\n");
            failedTests = failedTests + 1;
        end else begin
            $write("passed\n");
        end
        #10; // Wait

        totalTests = totalTests + 1;
		$write("\tTest Case 7.3 XORs ...");
		A = 8'h1F; //31
		B = 8'h0A; //10
		R = 8'h15; //21
		#100; // Wait
		if (R != result || zero != 1'b0) begin
            $write("failed\n");
            failedTests = failedTests + 1;
        end else begin
            $write("passed\n");
        end
        #10; // Wait
        
        // ----------------------------------------
        // Div 2 
        // ----------------------------------------
        $write("Test Group 8: Testing DIV 2 ...\n");
        opcode = 3'b111; 
        
		// Add more tests here

        totalTests = totalTests + 1;
		$write("\tTest Case 8.1 DIV 2 ...");
		A = 8'h1E; //30
		R = 8'h0F; //15
		#100; // Wait
		if (R != result || zero != 1'b0) begin
            $write("failed\n");
            failedTests = failedTests + 1;
        end else begin
            $write("passed\n");
        end
        #10; // Wait
		
        totalTests = totalTests + 1;
		$write("\tTest Case 8.2 DIV 2 ...");
		A = 8'h7C; //124
		R = 8'h3E; //62
		#100; // Wait
		if (R != result || zero != 1'b0) begin
            $write("failed\n");
            failedTests = failedTests + 1;
        end else begin
            $write("passed\n");
        end
        #10; // Wait

        totalTests = totalTests + 1;
		$write("\tTest Case 8.3 DIV 2 ...");
		A = 8'h58; //88
		R = 8'h2C; //44
		#100; // Wait
		if (R != result || zero != 1'b0) begin
            $write("failed\n");
            failedTests = failedTests + 1;
        end else begin
            $write("passed\n");
        end
        #10; // Wait

        // -------------------------------------------------------
        // End testing
        // -------------------------------------------------------
        $write("\n-------------------------------------------------------");
        $write("\nTesting complete\nPassed %0d / %0d tests", totalTests-failedTests,totalTests);
        $write("\n-------------------------------------------------------");
    end
endmodule