module Testbench;  
  reg [7:0] a;
  reg [7:0] b;
  wire [15:0] p;
  
  Multiplier multiplier(
    .a(a),
    .b(b), 
    .p(p)
  );
  
  integer i, j, errCount;  
  initial begin
    $display("Running unsigned multiplication test...");
    errCount = 0;
    for (i = 0; i < 256; i = i + 1) begin
      for (j = 0; j < 256; j = j + 1) begin
        a = i;
        b = j;   
        
        // Wait for the result to show up in output
        #1;  
        
        // Test the result  
        if (p != i*j) begin
          errCount = errCount + 1;
          $display("Error: a = %0d, b = %0d, expected = %0d, found = %0d",
            i, j, i*j, p);    
        end
      end      
    end 
  $display("The test is completed with %0d error(s).", errCount);
  $finish;
  end  
endmodule