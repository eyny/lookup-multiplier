module Testbench;  
  reg [7:0] a;
  reg [7:0] b;
  reg sgnd;
  wire [15:0] p;
  integer i, j, error_count; 
  
  Multiplier multiplier(
    .a(a),
    .b(b), 
    .sgnd(sgnd),
    .p(p)
  );

  task test_result;
    integer result;
    begin
      // Wait for the result to show up in output
      #1;  
      
      // Check if doing unsigned or signed multiplication    
      if (sgnd == 1'b0)
        result = p;
      else if (sgnd == 1'b1)
        result = $signed(p); 
      else
        $display("Error: invalid signed input");
        
      // Test the result  
      if (result != i*j) begin
        error_count = error_count + 1;
        $display("Error: a = %0d, b = %0d, expected = %0d, found = %0d", 
          i, j, i*j, result);  
      end
    end
  endtask  
 
  initial begin
    // Unsigned multiplication test
    $display("Running unsigned multiplication test...");
    error_count = 0; 
    sgnd = 1'b0;    
    for (i = 0; i < 256; i = i + 1) begin
      for (j = 0; j < 256; j = j + 1) begin
        a = i;
        b = j;
        test_result;
      end      
    end 
    $display("The test is completed with %0d error(s).", error_count);

    // Signed multiplication test
    $display("Running signed multiplication test...");
    error_count = 0;  
    sgnd = 1'b1;    
    for (i = -128; i < 128; i = i + 1) begin
      for (j = -128; j < 128; j = j + 1) begin
        a = i;
        b = j;
        test_result;
      end      
    end  
    $display("The test is completed with %0d error(s).", error_count);
    $finish;
  end  
endmodule