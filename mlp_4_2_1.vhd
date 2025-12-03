library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library work;
use work.mlp_pkg.ALL; 

entity mlp_4_2_1 is
    Port ( 
        clk      : in std_logic;
        rst      : in std_logic;
        -- 4 entradas de 4 bits cada (0 a 15) concatenadas
        i_data   : in std_logic_vector(15 downto 0); 
        o_result : out std_logic
    );
end mlp_4_2_1;

architecture Structural of mlp_4_2_1 is

    signal r_inputs  : t_data_array(0 to 3);
    signal w_L1_out  : t_data_array(0 to 3);
    signal w_L2_out  : t_data_array(0 to 1);
    signal w_final   : t_data_array(0 to 0);
    
    signal r_output  : std_logic;

    component neuron is
        Generic ( NUM_INPUTS : integer; USE_RELU : boolean );
        Port (
            i_inputs  : in  t_data_array(0 to NUM_INPUTS-1);
            i_weights : in  t_weight_array(0 to NUM_INPUTS-1);
            i_bias    : in  signed(W_BITS-1 downto 0);
            o_output  : out signed(W_BITS-1 downto 0)
        );
    end component;

begin

    ----------------------------------------------------------------
    -- PROCESSO DE ENTRADA PROPORCIONAL
    ----------------------------------------------------------------
    process(clk)
        -- Variável temporária para ajudar na conversão
        variable v_tmp : unsigned(W_BITS-1 downto 0);
    begin
        if rising_edge(clk) then
            if rst = '1' then
                r_output <= '0';
                r_inputs <= (others => (others => '0'));
            else
                -- LÓGICA DE ESCALA:
                -- Entrada (0..15) * 4 = (0..60). 
                -- Onde 64 representaria 1.0. Então 15 vira "quase 100%".
                -- Multiplicar por 4 é dar Shift Left de 2 bits.

                -- Entrada 0 (bits 3-0)
                v_tmp := resize(unsigned(i_data(3 downto 0)), W_BITS);
                r_inputs(0) <= signed(shift_left(v_tmp, 2));

                -- Entrada 1 (bits 7-4)
                v_tmp := resize(unsigned(i_data(7 downto 4)), W_BITS);
                r_inputs(1) <= signed(shift_left(v_tmp, 2));

                -- Entrada 2 (bits 11-8)
                v_tmp := resize(unsigned(i_data(11 downto 8)), W_BITS);
                r_inputs(2) <= signed(shift_left(v_tmp, 2));

                -- Entrada 3 (bits 15-12)
                v_tmp := resize(unsigned(i_data(15 downto 12)), W_BITS);
                r_inputs(3) <= signed(shift_left(v_tmp, 2));
                
                -- Saída (Threshold)
                if w_final(0) > 0 then
                    r_output <= '1';
                else
                    r_output <= '0';
                end if;
            end if;
        end if;
    end process;
    
    o_result <= r_output;

    ----------------------------------------------------------------
    -- CONEXÕES DOS NEURÔNIOS (Mantido igual)
    ----------------------------------------------------------------
    GEN_L1: for i in 0 to 3 generate
        u_neuron_L1 : neuron
        generic map ( NUM_INPUTS => 4, USE_RELU => true )
        port map (
            i_inputs  => r_inputs,
            i_weights => W_L1(i),
            i_bias    => B_L1(i),
            o_output  => w_L1_out(i)
        );
    end generate;

    GEN_L2: for i in 0 to 1 generate
        u_neuron_L2 : neuron
        generic map ( NUM_INPUTS => 4, USE_RELU => true )
        port map (
            i_inputs  => w_L1_out,
            i_weights => W_L2(i),
            i_bias    => B_L2(i),
            o_output  => w_L2_out(i)
        );
    end generate;

    GEN_OUT: for i in 0 to 0 generate
        u_neuron_OUT : neuron
        generic map ( NUM_INPUTS => 2, USE_RELU => false ) 
        port map (
            i_inputs  => w_L2_out,
            i_weights => W_OUT(i),
            i_bias    => B_OUT(i),
            o_output  => w_final(i)
        );
    end generate;

end Structural;