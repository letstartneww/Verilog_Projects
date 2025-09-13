module traffic_light(
    input clk,
    input reset,
    output reg [2:0] ns_light,  // {Red, Yellow, Green}
    output reg [2:0] ew_light
);

    // State encoding
    typedef enum reg [1:0] {
        S0 = 2'b00,  // NS Green, EW Red
        S1 = 2'b01,  // NS Yellow, EW Red
        S2 = 2'b10,  // NS Red, EW Green
        S3 = 2'b11   // NS Red, EW Yellow
    } state_t;

    state_t state, next_state;
    reg [3:0] timer; // simple timer for state duration

    // Sequential block
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= S0;
            timer <= 0;
        end else begin
            state <= next_state;
            timer <= (timer == 4'd9) ? 0 : timer + 1; // 10-cycle timer
        end
    end

    // Next state logic
    always @(*) begin
        case(state)
            S0: next_state = (timer == 9) ? S1 : S0;
            S1: next_state = (timer == 9) ? S2 : S1;
            S2: next_state = (timer == 9) ? S3 : S2;
            S3: next_state = (timer == 9) ? S0 : S3;
            default: next_state = S0;
        endcase
    end

    // Output logic
    always @(*) begin
        case(state)
            S0: begin ns_light=3'b001; ew_light=3'b100; end // NS Green, EW Red
            S1: begin ns_light=3'b010; ew_light=3'b100; end // NS Yellow, EW Red
            S2: begin ns_light=3'b100; ew_light=3'b001; end // NS Red, EW Green
            S3: begin ns_light=3'b100; ew_light=3'b010; end // NS Red, EW Yellow
            default: begin ns_light=3'b100; ew_light=3'b100; end
        endcase
    end

endmodule
