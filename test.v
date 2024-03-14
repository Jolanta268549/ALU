//Jolanta Mlynczak 268549 projekt jednostka ALU


// Skrypt definiuj¹cy jednostki czasu w symulacjipl
`timescale 1ns / 1ps

// Definicja modu³u testowego
module testbench();

    // Wejœcia
    reg clk;
    reg nreset;
    reg [7:0] u_a;
    reg [7:0] u_b;
    reg [3:0] op;

    // Wyjœcia
    wire borrow;
    wire [15:0] u_result;
    reg [15:0] diff_result;


    // Parametry do identyfikacji operacji
    localparam [3:0] bit_AND = 4'b0000;                    // &
    localparam [3:0] bit_OR  = 4'b0001;                    // |
    localparam [3:0] bit_XOR = 4'b0010;                    // ^
    localparam [3:0] bit_NOT = 4'b0011;                    // ~

    localparam [3:0] comp_is_equal      = 4'b0100;         // porównanie ==
    localparam [3:0] comp_greater_than  = 4'b0101;         // porównanie a > b
    localparam [3:0] comp_less_than     = 4'b0110;         // porównanie a < b

    localparam [3:0] addition       = 4'b1000;             // +
    localparam [3:0] subtraction    = 4'b1001;             // -
    localparam [3:0] division       = 4'b1010;             // /
    localparam [3:0] multiplication = 4'b1011;             // *

    // Generator sygna³u zegarowego
    always #100 clk = ~clk;

    integer i, j, k;
	 integer file;

    // Inicjalizacja pliku wynikowego
    initial begin
		
      file = $fopen("results.txt");
		$fdisplay(file, "Hello");
    end

    // Inicjalizacja symulacji
    initial begin
		i = 0;
		j = 0;
		k = 0;
		u_a = 0;
		u_b = 0;
		op = 0;
		
        diff_result = 0;
        clk = 0;
        nreset = 0;
        #100;
        nreset = 1;

        // Pêtle symulacyjne
        for (k = 0; k < 12; k = k + 1) begin                    // Iteracja po wszystkich operatorach
            op <= k;

            for (i = 0; i < 256; i = i + 1) begin               // Ustawienie wartoœci u_a
                u_a <= i;

                for (j = 0; j <= 256; j = j + 1) begin         // Ustawienie wartoœci u_b
                    u_b <= j;
                    #200;
                    // Weryfikacja wyniku
                    case (op)
                        bit_AND: begin
                            if ((u_a & u_b) != u_result) begin
                                $fdisplay(file, "Error [bit_AND] - result = %b , expected= %b\n", u_result, u_a & u_b);
                            end
                        end

                        default: begin
								//$fdisplay(file, "NOT IMPLEMENTED YET");
                        end
                    endcase
                end
            end
        end

        $fclose(file);
        $finish;
    end

    // Instancja ALU
    alu8bit_unsigned alu8bit_unsigned (
        .u_a(u_a),
        .u_b(u_b),
        .clk(clk),
        .op(op),
        .nreset(nreset),
        .borrow(borrow),
        .u_result(u_result)
    );

endmodule
