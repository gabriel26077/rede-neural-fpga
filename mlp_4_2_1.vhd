library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library work;
use work.mlp_pkg.ALL; 

entity mlp_4_2_1 is
    Port ( 
        clk      : in std_logic;
        rst      : in std_logic;
        i_data   : in std_logic_vector(15 downto 0); -- 4 entradas de 4 bits
        btn_inf  : in std_logic;
		  
        -- Saída original (LED de debug)
        o_result : out std_logic;
        
        -- NOVAS SAÍDAS: Displays de 7 Segmentos
        -- Conectam nas saídas d0..d4 do decoder
        HEX0     : out std_logic_vector(6 downto 0);
        HEX1     : out std_logic_vector(6 downto 0);
        HEX2     : out std_logic_vector(6 downto 0);
        HEX3     : out std_logic_vector(6 downto 0);
        HEX4     : out std_logic_vector(6 downto 0)
    );
end mlp_4_2_1;

architecture Structural of mlp_4_2_1 is

    -- Sinais internos para conectar as camadas
    signal r_inputs  : t_data_array(0 to 3);
    signal w_L1_out  : t_data_array(0 to 3);
    signal w_L2_out  : t_data_array(0 to 1);
    signal w_final   : t_data_array(0 to 0);
    
    -- Este sinal carrega o resultado (0 ou 1) da MLP
    signal r_output  : std_logic;

    ----------------------------------------------------------------
    -- COMPONENTES
    ----------------------------------------------------------------
    
    -- 1. Neurônio
    component neuron is
        Generic (NUM_INPUTS : integer; USE_RELU : boolean);
        Port (
            i_inputs  : in  t_data_array;
            i_weights : in  t_weight_array;
            i_bias    : in  signed;
            o_output  : out signed
        );
    end component;

    -- 2. Decodificador (Display)
    component decoder is
        port (
            inf, class          : in std_logic;
            d0, d1, d2, d3, d4  : out std_logic_vector(6 DOWNTO 0)
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
                -- 1. Mapeia entrada
                r_inputs(0) <= resize(signed(i_data(3 downto 0)), 8);
                r_inputs(1) <= resize(signed(i_data(7 downto 4)), 8);
                r_inputs(2) <= resize(signed(i_data(11 downto 8)), 8);
                r_inputs(3) <= resize(signed(i_data(15 downto 12)), 8);
                
                -- 2. Função Degrau (Threshold) na saída
                if w_final(0) > 0 then
                    r_output <= '1';
                else
                    r_output <= '0';
                end if;
            end if;
        end if;
    end process;
    
    -- Conecta o resultado ao pino de saída simples (LED)
    o_result <= r_output;

    ----------------------------------------------------------------
    -- INSTANCIAÇÃO DA REDE NEURAL (MLP)
    ----------------------------------------------------------------
    
    -- Camada 1
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

    -- Camada 2
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

    -- Camada de Saída
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

    ----------------------------------------------------------------
    -- INSTANCIAÇÃO DO DECODIFICADOR (VISUALIZAÇÃO)
    ----------------------------------------------------------------
    u_decoder : decoder
    port map (
        inf   => btn_inf,      -- Habilitado constantemente (ou use 'not rst' se preferir)
        class => r_output, -- O resultado da MLP controla o texto no display
        d0    => HEX0,     -- Conecta às saídas da entidade topo
        d1    => HEX1,
        d2    => HEX2,
        d3    => HEX3,
        d4    => HEX4
    );

end Structural;