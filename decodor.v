module reg8(clk,pl,di,do);
    input clk, pl;
    input [7:0] di;
    output reg [7:0] do;
    
    always@(posedge clk)
        if(pl)
            do<=di;
endmodule

module mux8(di1, di0, sel, do);
    input [7:0] di1;
    input [7:0] di0;
    input sel;
    output reg[7:0] do;
    
    always@(sel or di1 or di0)
        if(sel)
            do<=di1;
        else
            do<=di0;
endmodule

module ctrl_reg(clk,pl,di,do);
    input clk,pl;
    input[2:0] di;
    output reg[2:0] do;
    
    always@(posedge clk)
        if(pl)
            do<=di;
endmodule

module mux_data(di2,di1,di0, sel, do);
    input[7:0] di1,di0;
    input[2:0] di2;
    input[1:0] sel;
    output reg[7:0] do;
    
    always@(sel or di2 or di1 or di0)
        casex(sel)
            2'b00: do=di0;
            2'b01: do=di1;
            2'b1x: do={5'b11111, di2};
        endcase
endmodule

module cnt(clk, reset, pl, di, ENCNT, INC, DEC, CIn, COn, do);
    input clk, reset, pl, ENCNT, INC, DEC, CIn;
    input [7:0] di;
    output COn;
    output [7:0] do;
    reg[7:0] cnt, cnt_next;
    
    always@(posedge clk)
        if(reset)
            cnt<=8'b0;
        else
            cnt<=cnt_next;
    
    wire en;
    assign en=(ENCNT &(~CIn));
    assign COn=(~((cnt==8'hFF)&&(ENCNT==1)&&(INC==1)&&(CIn==0)))&&(~((cnt==8'b0)&&(ENCNT==1)&&
    (INC==0)&&(DEC==1)&&(CIn==0)));
    assign do=cnt;
    
    always@(pl or di or en or INC or DEC or cnt)
        casex({pl,en,INC,DEC})
            4'b1xxx: cnt_next=di;
            4'b011x: cnt_next=cnt+1;
            4'b0101: cnt_next=cnt-1;
            4'b0100, 4'b00xx: cnt_next=cnt;
        endcase
endmodule

module done_gen(WCIn, WC_o, WR_o, AC_o, CR10, done);
    input WCIn;
    input[7:0] WC_o, WR_o, AC_o;
    input[1:0] CR10;
    output reg done;
    
    wire c1,c2,c3,c4,c5;
    assign c1=(WC_o==1);
    assign c2=(WC_o==0);
    assign c3=((WC_o+1)==WR_o);
    assign c4=(WC_o==WR_o);
    assign c5=(WC_o==AC_o);
    
    always@(CR10 or WCIn or c1 or c2 or c3 or c4 or c5)
        casex({CR10, WCIn, c1,c2,c3,c4,c5})
            8'b00_0_1_x_x_x_x: done=1;
            8'b00_1_x_1_x_x_x: done=1;
            8'b01_0_x_x_1_x_x: done=1;
            8'b01_1_x_x_x_1_x: done=1;
            8'b10_x_x_x_x_x_1: done=1;
            default: done=0;
        endcase
endmodule

module decodor(I20,CR20,PLAR,PLWR,SELA,SELW,PLCR,SELDATA,PLAC,ENCA,INCA,DECA,RESW,PLWC,ENCW,INCW,DECW,OEDATA);
    input [2:0] I20, CR20;
    output reg PLAR,PLWR,SELA,SELW,PLCR,PLAC,ENCA,INCA,DECA,RESW,PLWC,ENCW,INCW,DECW,OEDATA;
    output reg [1:0] SELDATA;
    
    always@(*)
        casex({I20,CR20})
            6'b000_xxx: {PLAR, PLWR, SELA, SELW,PLCR,SELDATA,PLAC, ENCA,INCA,DECA,RESW,
            PLWC,ENCW,INCW,DECW,OEDATA}=17'b0_0_x_x_1_xx_0_0_0_0_0_0_0_0_0_0;
            
            6'b001_xxx: {PLAR, PLWR, SELA, SELW,PLCR,SELDATA,PLAC, ENCA,INCA,DECA,RESW,
            PLWC,ENCW,INCW,DECW,OEDATA}=17'b0_0_x_x_0_1x_0_0_0_0_0_0_0_0_0_1;
            
            6'b010_xxx: {PLAR, PLWR, SELA, SELW,PLCR,SELDATA,PLAC, ENCA,INCA,DECA,RESW,
            PLWC,ENCW,INCW,DECW,OEDATA}=17'b0_0_x_x_0_01_0_0_0_0_0_0_0_0_0_1;
            
            6'b011_xxx: {PLAR, PLWR, SELA, SELW,PLCR,SELDATA,PLAC, ENCA,INCA,DECA,RESW,
            PLWC,ENCW,INCW,DECW,OEDATA}=17'b0_0_x_x_0_00_0_0_0_0_0_0_0_0_0_1;
            
            6'b100_x00, 6'b100_x1x: {PLAR, PLWR, SELA, SELW,PLCR,SELDATA,PLAC, ENCA,INCA,DECA,RESW,
            PLWC,ENCW,INCW,DECW,OEDATA}=17'b0_0_1_1_0_xx_1_0_0_0_0_1_0_0_0_0;
            
            6'b100_x01: {PLAR, PLWR, SELA, SELW,PLCR,SELDATA,PLAC, ENCA,INCA,DECA,RESW,
            PLWC,ENCW,INCW,DECW,OEDATA}=17'b0_0_1_x_0_xx_1_0_0_0_1_0_0_0_0_0;
            
            6'b101_xxx: {PLAR, PLWR, SELA, SELW,PLCR,SELDATA,PLAC, ENCA,INCA,DECA,RESW,
            PLWC,ENCW,INCW,DECW,OEDATA}=17'b1_0_0_x_0_xx_1_0_0_0_0_0_0_0_0_0;
            
            6'b110_x00, 6'b110_x1x: {PLAR, PLWR, SELA, SELW,PLCR,SELDATA,PLAC, ENCA,INCA,DECA,RESW,
            PLWC,ENCW,INCW,DECW,OEDATA}=17'b0_1_x_0_0_xx_0_0_0_0_0_1_0_0_0_0;
            
            6'b110_x01: {PLAR, PLWR, SELA, SELW,PLCR,SELDATA,PLAC, ENCA,INCA,DECA,RESW,
            PLWC,ENCW,INCW,DECW,OEDATA}=17'b0_1_x_x_0_xx_0_0_0_0_1_0_0_0_0_0;
            
            6'b111_000: {PLAR, PLWR, SELA, SELW,PLCR,SELDATA,PLAC, ENCA,INCA,DECA,RESW,
            PLWC,ENCW,INCW,DECW,OEDATA}=17'b0_0_x_x_0_xx_0_1_1_0_0_0_1_0_1_0;
            
            6'b111_0x1: {PLAR, PLWR, SELA, SELW,PLCR,SELDATA,PLAC, ENCA,INCA,DECA,RESW,
            PLWC,ENCW,INCW,DECW,OEDATA}=17'b0_0_x_x_0_xx_0_1_1_0_0_0_1_1_0_0;
            
            6'b111_010: {PLAR, PLWR, SELA, SELW,PLCR,SELDATA,PLAC, ENCA,INCA,DECA,RESW,
            PLWC,ENCW,INCW,DECW,OEDATA}=17'b0_0_x_x_0_xx_0_1_1_0_0_0_0_0_0_0;
            
            6'b111_100: {PLAR, PLWR, SELA, SELW,PLCR,SELDATA,PLAC, ENCA,INCA,DECA,RESW,
            PLWC,ENCW,INCW,DECW,OEDATA}=17'b0_0_x_x_0_xx_0_1_0_1_0_0_1_0_1_0;
            
            6'b111_1x1: {PLAR, PLWR, SELA, SELW,PLCR,SELDATA,PLAC, ENCA,INCA,DECA,RESW,
            PLWC,ENCW,INCW,DECW,OEDATA}=17'b0_0_x_x_0_xx_0_1_0_1_0_0_1_1_0_0;
            
            6'b111_110: {PLAR, PLWR, SELA, SELW,PLCR,SELDATA,PLAC, ENCA,INCA,DECA,RESW,
            PLWC,ENCW,INCW,DECW,OEDATA}=17'b0_0_x_x_0_xx_0_1_0_1_0_0_0_0_0_0;
            
            default: {PLAR, PLWR, SELA, SELW,PLCR,SELDATA,PLAC, ENCA,INCA,DECA,RESW,
            PLWC,ENCW,INCW,DECW,OEDATA}=17'b0_0_0_0_0_00_0_0_0_0_0_0_0_0_0_0;
        endcase
endmodule

module top(clk, CIA, COA, CIW, COW, I20, di, do_word, do_address, done);

    input clk, CIA, CIW;
    input[2:0] I20;
    input [7:0] di;
    output COA,COW;
    output [7:0] do_word, do_address;
    output done;
    
    wire RESET, PLAR, PLWR, SELA, SELW, PLCR, PLAC, ENCA, INCA, DECA, PLWC, ENCW, INCW, 
    DECW, OEDATA;
    wire[1:0] SELD;
    wire[7:0] do_addr, do_word, do_mux_addr, do_mux_word, do_mux_inst;
    wire[2:0] CR20;
    
    ctrl_reg ctrl_reg_inst(clk, PLCR, di[2:0], CR20);
    
    decodor decodor_inst(I20, CR20, PLAR, PLWR, SELA, SELW, PLCR, SELD, PLAC, ENCA, INCA, DECA, RESET, PLWC, 
ENCW, INCW, DECW, OEDATA);  
    
    reg8 reg8_addr(clk, PLAR, di, do_addr);
    reg8 reg8_word(clk, PLWR, di, do_word);
    
    mux8 mux8_addr(di,do_addr, SELA, do_mux_addr);
    mux8 mux8_word(di,do_word, SELW, do_mux_word);
    
    cnt cnt_address(clk, 1'b0, do_mux_addr, ENCA, INCA, DECA, ~CIA, COA, do_cnt_address);
    cnt cnt_word(clk, RESET, do_mux_word, ENCW, INCW, DECW, ~CIW, COW, do_cnt_word);
    
    assign do_word=do_cnt_word;
    assign do_address=do_cnt_address;
    
    mux_data mux_data_inst(do_ctrl, do_cnt_word, do_cnt_address, SELD, do_mux_inst);
    
    done_gen done_gen_instr(~CIW, do_cnt_word, do_word, do_cnt_address, do_ctrl, done);   
endmodule