//==================================================================================================
//  Filename      : pwm_led.v
//  Created On    : 2017-03-31 20:58:52
//  Last Modified : 2017-08-08 20:43:48
//  Revision      : 
//  Author        : Kingstacker
//  Company       : School
//  Email         : 13390572329@163.com
//
//  Description   : breath_led;
//==================================================================================================
module pwm_led(
	//input;
	input    wire    clk,  //clk=25MHZ;
	input    wire    rst_n,
	//output;
	output    reg    led_o
	);
parameter CNT_2US_MAX = 6'd49;  //50;
parameter CNT_2MS_MAX = 10'd999;  //1000;
parameter CNT_2S_MAX  = 10'd999;  //1000;

reg [5:0] cnt_2us_n;  //cnt 2us  number;
reg [9:0] cnt_2ms_n;  //cnt 2ms  number;
reg [9:0] cnt_2s_n;   //cnt 2s   number;
reg cnt_2us_flag;     //2us flag;
reg cnt_2s_flag;      //2s flag；
//2us and 2us flag produce;
always @(posedge clk or negedge rst_n)
begin
    if (~rst_n)
    begin
        cnt_2us_n <= 0;
    end 
    else if (cnt_2us_n == CNT_2US_MAX)
         begin
             cnt_2us_n <= 0;
         end
         else 
         begin
         	cnt_2us_n <= cnt_2us_n + 1'b1;
         end
end

always @( posedge clk or negedge rst_n ) begin
    if (~rst_n) begin
        cnt_2us_flag <= 0;
    end //if
    else begin
        if (cnt_2us_n == CNT_2US_MAX) begin
            cnt_2us_flag <= 1'b1;
        end //if
        else begin
            cnt_2us_flag <= 1'b0;
        end //else    
    end //else
end //always

always @(posedge clk or negedge rst_n)
begin
	if (~rst_n)
		cnt_2ms_n <= 0;
	else if ((cnt_2ms_n == CNT_2MS_MAX) && (cnt_2us_flag))
	     	cnt_2ms_n <= 0;
	     else if (cnt_2us_flag)
	              cnt_2ms_n <= cnt_2ms_n + 1'b1;
              else 
              	  cnt_2ms_n <= cnt_2ms_n;
end

always @(posedge clk or negedge rst_n)
begin
	if (~rst_n)
		cnt_2s_n <= 0;
	else if ((cnt_2s_n == CNT_2S_MAX) && (cnt_2ms_n == CNT_2MS_MAX) && (cnt_2us_flag))
		     cnt_2s_n <= 0;
	     else if ((cnt_2ms_n == CNT_2MS_MAX) && (cnt_2us_flag))
	     	      cnt_2s_n <= cnt_2s_n + 1'b1;
	          else 
	          	cnt_2s_n <= cnt_2s_n;
end

always @(posedge clk or negedge rst_n)
begin
	if (~rst_n)
		cnt_2s_flag <= 0;
	else if ((cnt_2s_n == CNT_2S_MAX) && (cnt_2ms_n == CNT_2MS_MAX) && (cnt_2us_flag))
	     	cnt_2s_flag <= ~cnt_2s_flag;
	     else 
	     	cnt_2s_flag <= cnt_2s_flag;
end

always @(posedge clk or negedge rst_n)
begin
	if (~rst_n)
	begin
		led_o <=0;
	end
	else if (cnt_2s_flag == 1'b0) 
	     begin
	     	if ( cnt_2s_n > cnt_2ms_n)
	     		led_o <= 1'b1;
	     	else 
	     		led_o <= 1'b0;
		  end
	     else 
	     begin
	     	if (cnt_2s_n < cnt_2ms_n)
	     		led_o <= 1'b1;
	     	else
	     	    led_o <= 1'b0;	
	     end
end

endmodule 