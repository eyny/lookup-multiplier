# 8 bit multiplier using lookup tables
This project demonstrates designing of an 8-by-8 bit multiplier for ALUs, step by step. However, instead of using [Wallace tree](https://en.wikipedia.org/wiki/Wallace_tree) or [Dadda multiplier](https://en.wikipedia.org/wiki/Dadda_multiplier), it utilizes a small ROM. Therefore, it calculates the results with less clock cycles, but at the cost of occupying more space in the die area. The models are developed in both [Logisim](http://www.cburch.com/logisim/) and [Verilog](https://en.wikipedia.org/wiki/Verilog). 

## Steps
1. At the first step, we create a ROM which contains a lookup table. This table holds precalculated values for all possible multiplications. It looks pretty simple; all we have to do is merging integers as a 16-bit input and then create a ROM with corresponding values. The problem is if the size of an integer is $n$ bit, this ROM needs to hold $2^n2^n = 4^n$ values which is not very feasible especially with large sized integers.
<br/><img src="src/step-1/logisim/step-1.png"><br/><br/>

2. The second step may look a bit tricky, but stay with me. We already know  $(A+B)^2 = A^2 + 2AB + B^2$ equation and its minus version from the school. How about we subtract one from the other to retrieve $2AB$ parts and divide it by $4$? Then $AB$ would be equal to: $$AB = {(A+B)^2 - (A-B)^2 \over 4} = {(A+B)^2 \over 4} - {(A-B)^2 \over 4}\Longrightarrow{(IN_{1})^2\over 4} - {(IN_{2})^2\over 4}={OUT_{1} - OUT_{2}}$$ We don't need to calculate square of the input and then divide it by $4$ using gates, since we can use lookup tables for that. Therefore, instead of having a single $k^2$ sized ROM, we can use $2$ roms with $2k$ size (because of 9-bit input instead of 8-bit) with 3 new adders. Using this approach, the space needed for ROM(s) is now decreased from $4^n$ to $2^{n+2}$. Although this little optimization trick reduced the area needed for our 8-bit multiplier greatly, the difference would be even higher with 16-bit and 32-bit integers.
<br/><img src="src/step-2/logisim/step-2.png"><br/><br/>

3. At the third step, we are adding a few gates and a flag named **Signed** to make the multiplier know whether the inputs are signed integers or not. That way, we do not need to create a separate circuit for signed integer multiplication.
<br/><img src="src/step-3/logisim/step-3.png"><br/><br/>

4. Since our logic is now more complex than we started, there is a high chance we won't be able to register the result in a single clock cycle. Despite that we don't know anything about the technology infastructure used in this circuit to determine how many clock cycles would be needed, we can assume ROMs would take a longer time than simple gates for now. Because of that, putting D flip flops at the front and back of the ROMs might be a wise thing to do while we are finalizing our multiplier. Once our inputs are registered, we can see the result after 2 clock cycles.
<br/><img src="src/step-4/logisim/step-4.png">
