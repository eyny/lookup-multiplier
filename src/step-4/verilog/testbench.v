module Testbench;  
  reg [7:0] a;
  reg [7:0] b;
  reg sgnd;
  wire [15:0] p;
  reg clk;
  integer error_count, i, j, prev_i, prev_j;     
  
  Multiplier multiplier(
    .clk(clk),
    .a(a),
    .b(b), 
    .sgnd(sgnd),
    .p(p)
  );
  
  always
    #5 clk = ~clk;

  task test_result;
    integer result; 
    begin
      // Advance one clock cycle
      #10;  
      
      // Check if doing unsigned or signed multiplication    
      if (sgnd == 1'b0)
        result = p;
      else if (sgnd == 1'b1)
        result = $signed(p); 
      else
        $display("Error: invalid signed input");
        
      // Test the result
      if (result != prev_i * prev_j) begin
        error_count = error_count + 1;
        $display("Error: a = %0d, b = %0d, expected = %0d, found = %0d", 
          prev_i, prev_j, prev_i*prev_j, result);    
      end  
    end
  endtask

  initial begin  
    // Unsigned multiplication test
    $display("Running unsigned multiplication test...");
    clk <= 0;
    error_count <= 0;    
    sgnd <= 1'b0;
    for (i = 0; i < 256; i = i + 1) begin
      for (j = 0; j < 256; j = j + 1) begin
        a <= i;
        b <= j;        
        test_result;              
        prev_i <= i;
        prev_j <= j;           
      end      
    end  
    test_result;    
    $display("The test is completed with %0d error(s).", error_count);
    
    // Signed multiplication test
    $display("Running signed multiplication test...");
    clk <= 0;
    error_count <= 0;    
    sgnd <= 1'b1;
    prev_i <= 'hX;
    prev_j <= 'hX;
    for (i = -128; i < 128; i = i + 1) begin
      for (j = -128; j < 128; j = j + 1) begin
        a <= i;
        b <= j;
        test_result;        
        prev_i <= i;
        prev_j <= j;           
      end      
    end  
    test_result;    
    $display("The test is completed with %0d error(s).", error_count);    
    $finish;
  end  
endmodule