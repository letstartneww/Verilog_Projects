
module fsm_1101 (
    input  clk,
    input  rst,   // active high reset
    input  in,
    output reg out
);

    // State encoding
    parameter S0=2'b00, S1=2'b01, S2=2'b10, S3=2'b11;

    reg [1:0] state;  // 2-bit state register

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= S0;
            out   <= 0;
        end
        else begin
            case (state)
                S0: begin
                    state <= in ? S1 : S0;
                    out   <= 0;
                end

                S1: begin
                    state <= in ? S2 : S0;
                    out   <= 0;
                end

                S2: begin
                    state <= in ? S2 : S3; // wait for '0'
                    out   <= 0;
                end

                S3: begin
                    // Mealy: detect '1101' here
                     state <= in ? S1 : S0   ;  // non-overlap → reset
   
                     out   <= in ? 1 : 0 ;   // detected
                      
                    end
                     

                default: begin
                    state <= S0;
                    out   <= 0;
                end
            endcase
        end
    end
endmodule
