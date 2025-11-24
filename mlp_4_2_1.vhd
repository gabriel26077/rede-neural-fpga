library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library work;
use work.mlp_pkg.ALL; -- Importante!

entity mlp_top is
    Port ( 
        clk      : in std_logic;
        rst      : in std_logic;
        i_data   : in std_logic_vector(15 downto 0); -- 4 entradas de 4 bits concatenadas
        o_result : out std_logic
    );
end mlp_top;

architecture Structural of mlp_top is

    -- Sinais internos para conectar as camadas
    -- Entradas convertidas para Signed
    signal r_inputs  : t_data_array(0 to 3);
    
    -- Fios entre Camada 1 e 2
    signal w_L1_out  : t_data_array(0 to 3);
    
    -- Fios entre Camada 2 e Saída
    signal w_L2_out  : t_data_array(0 to 1);
    
    -- Fio final
    signal w_final   : t_data_array(0 to 0);
    signal r_output  : std_logic;

    -- Declaração do Componente Neurônio
    component neuron is
        Generic (NUM_INPUTS : integer; USE_RELU : boolean);
        Port (
            i_inputs  : in  t_data_array;
            i_weights : in  t_weight_array;
            i_bias    : in  signed;
            o_output  : out signed
        );
    end component;

begin

    ----------------------------------------------------------------
    -- PROCESSO DE ENTRADA/SAÍDA (REGISTRADORES)
    ----------------------------------------------------------------
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                r_output <= '0';
            else
                -- 1. Mapeia entrada 16 bits para array de signed
                r_inputs(0) <= resize(signed(i_data(3 downto 0)), 8);
                r_inputs(1) <= resize(signed(i_data(7 downto 4)), 8);
                r_inputs(2) <= resize(signed(i_data(11 downto 8)), 8);
                r_inputs(3) <= resize(signed(i_data(15 downto 12)), 8);
                
                -- 2. Registra a saída final (Threshold / Step Function)
                -- Como o último neurônio dá um valor numérico, verificamos se > 0
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
    -- GERAÇÃO DA CAMADA 1 (4 Neurônios)
    ----------------------------------------------------------------
    GEN_L1: for i in 0 to 3 generate
        u_neuron_L1 : neuron
        generic map ( NUM_INPUTS => 4, USE_RELU => true )
        port map (
            i_inputs  => r_inputs,    -- Recebe entradas externas
            i_weights => W_L1(i),     -- Pega pesos do pacote
            i_bias    => B_L1(i),     -- Pega bias do pacote
            o_output  => w_L1_out(i)  -- Sai para fio interno
        );
    end generate;

    ----------------------------------------------------------------
    -- GERAÇÃO DA CAMADA 2 (2 Neurônios)
    ----------------------------------------------------------------
    GEN_L2: for i in 0 to 1 generate
        u_neuron_L2 : neuron
        generic map ( NUM_INPUTS => 4, USE_RELU => true )
        port map (
            i_inputs  => w_L1_out,    -- Recebe saída da L1
            i_weights => W_L2(i),
            i_bias    => B_L2(i),
            o_output  => w_L2_out(i)
        );
    end generate;

    ----------------------------------------------------------------
    -- GERAÇÃO DA CAMADA DE SAÍDA (1 Neurônio)
    ----------------------------------------------------------------
    GEN_OUT: for i in 0 to 0 generate
        u_neuron_OUT : neuron
        generic map ( NUM_INPUTS => 2, USE_RELU => false ) -- Sem ReLU na saída (linear) para podermos aplicar degrau
        port map (
            i_inputs  => w_L2_out,    -- Recebe saída da L2
            i_weights => W_OUT(i),
            i_bias    => B_OUT(i),
            o_output  => w_final(i)
        );
    end generate;

end Structural;