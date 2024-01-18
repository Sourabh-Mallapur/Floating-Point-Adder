module fpadder (
    input wire [31:0] op1, op2,
    input wire clk, reset,
    output wire [31:0] result,
    output wire busy, done
  );

  // ports
  wire sign_op1, sign_op2;
  wire [7:0] exp_op1, exp_op2;
  wire [22:0] man_op1, man_op2;

  reg sign_res;
  reg [7:0] exp_res, diff;
  reg [22:0] man_res;
  reg [23:0] man_norm_op1, man_norm_op2;
  reg [23:0] man_add_op1, man_add_op2;
  reg [24:0] ov_check;


  // signal declaraction
  assign sign_op1 = op1[31];
  assign sign_op2 = op2[31];
  assign exp_op1 = op1[30:23];
  assign exp_op2 = op2[30:23];
  assign man_op1 = op1[22:0];
  assign man_op2 = op2[22:0];

  localparam [2:0]
             idle = 0,
             compsigns = 1,
             normalize_exp = 2,
             add_man = 3,
             adjust_overflow = 4;

  localparam
    add = 0,
    sub = 1;

  reg [2:0] cur_state, next_state;
  reg operator;

  always @(posedge clk, posedge reset)
    if(reset)
      cur_state <= idle;
    else
      cur_state <= next_state;

  always @(*)
  begin
    next_state = cur_state;
    case (cur_state)
      idle:
        if ((op1 !== 32'bx) && (op2 !== 32'bx))
          next_state = compsigns;

      compsigns:
        if (sign_op1 == sign_op2)
        begin
          operator = 0;
          next_state = normalize_exp;
          sign_res = sign_op1;
        end
        else
        begin
          operator = 1;
          next_state = normalize_exp;
        end

      normalize_exp:
      begin
        man_norm_op1 = {1'b1, man_op1};
        man_norm_op2 = {1'b1, man_op2};
        exp_res = exp_op1;
        if (exp_op1 > exp_op2)
        begin  // op2 is the smaller one
          diff = exp_op1 - exp_op2;
          man_norm_op2 = man_norm_op2 >> (diff);
          exp_res = exp_op1;
        end
        if (exp_op2 > exp_op1)
        begin  // op1 is the smaller one
          diff = exp_op2 - exp_op1;
          man_norm_op1 = man_norm_op1 >> (diff);
          exp_res = exp_op2;
        end
        next_state = add_man;
      end

      add_man:
      begin
        man_add_op1 = man_norm_op1;
        man_add_op2 = man_norm_op2;
        if (~operator)
          ov_check = man_add_op1 + man_add_op2;
        if (ov_check[24])
          exp_res = exp_res + 1;
        else
          ov_check = ov_check << 1;
        if (ov_check[0] == 1)
          ov_check = ov_check + 1'b1;
        man_res = ov_check[23:1];
        next_state = adjust_overflow;
      end

      default:
        next_state = idle;
    endcase
  end

  assign result = {sign_res,exp_res,man_res};
  assign done = (cur_state == adjust_overflow) && (next_state == idle);
  assign busy = (cur_state == compsigns) || (cur_state == normalize_exp) || (cur_state == add_man) || (cur_state == adjust_overflow) && (next_state != idle);

endmodule
