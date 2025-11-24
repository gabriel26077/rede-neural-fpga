library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library work;
use work.mlp_pkg.ALL; -- Usa nosso pacote

entity neuron is
    Generic (
        NUM_INPUTS : integer := 4;   -- Quantas entradas entram neste neurônio
        USE_RELU   : boolean := true -- True = ReLU, False = Linear/Pass-through
    );
    Port (
        i_inputs  : in  t_data_array(0 to NUM_INPUTS-1);   -- Vetor de entradas
        i_weights : in  t_weight_array(0 to NUM_INPUTS-1); -- Vetor de pesos
        i_bias    : in  signed(I_BITS-1 downto 0);         -- Valor do Bias
        o_output  : out signed(I_BITS-1 downto 0)          -- Saída calculada
    );
end neuron;

architecture Behavioral of neuron is
begin
    process(i_inputs, i_weights, i_bias)
        variable v_acc : signed(ACC_BITS-1 downto 0);
    begin
        -- 1. Carrega o Bias
        v_acc := resize(i_bias, ACC_BITS);
        
        -- 2. Soma dos Produtos (MAC - Multiply Accumulate)
        for i in 0 to NUM_INPUTS-1 loop
            v_acc := v_acc + (i_inputs(i) * i_weights(i));
        end loop;

        -- 3. Função de Ativação (ReLU) e Saturação
        if USE_RELU and v_acc < 0 then
            o_output <= (others => '0'); -- Corta negativos (ReLU)
        else
            -- Saturação para evitar overflow ao converter de volta para 8 bits
            if v_acc > 127 then 
                o_output <= to_signed(127, I_BITS);
            elsif v_acc < -128 then -- Caso não use ReLU
                o_output <= to_signed(-128, I_BITS);
            else
                o_output <= resize(v_acc, I_BITS);
            end if;
        end if;
    end process;
end Behavioral;