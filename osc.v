module OSC (enable, data_o);
input enable;
output data_o;

initial begin
	temp = $urandom; // this gives you a random unsigned number
	if (temp[31]) flip = 1;
	temp = temp %1000; // this contrains the random number between 0 and +999
	delay = temp;
	if (flip) delay = - delay;
	delay = delay + 11000;
	$display(delay);
end

assign #delay z = !(a&b);

endmodule
