library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library work;
use work.mlp_pkg.ALL;

entity neuron is
    Generic (
        NUM_INPUTS : integer := 4;   
        USE_RELU   : boolean := true 
    );
    Port (
        i_inputs  : in  t_data_array(0 to NUM_INPUTS-1);
        i_weights : in  t_weight_array(0 to NUM_INPUTS-1);
        i_bias    : in  signed(W_BITS-1 downto 0);
        o_output  : out signed(W_BITS-1 downto 0)
    );
end neuron;

architecture Behavioral of neuron is
begin
    process(i_inputs, i_weights, i_bias)
        -- Variáveis dimensionadas pelo pacote
        variable v_acc  : signed(ACC_BITS-1 downto 0);
        variable v_prod : signed(MULT_BITS-1 downto 0);
    begin
        -- 1. Carrega o Bias
        -- Precisamos alinhar o Bias (que é W_BITS) para a escala da multiplicação.
        -- Bias << F_BITS
        v_acc := resize(i_bias, ACC_BITS);
        v_acc := shift_left(v_acc, F_BITS); 
        
        -- 2. Soma dos Produtos (MAC)
        for i in 0 to NUM_INPUTS-1 loop
            v_prod := i_inputs(i) * i_weights(i);
            v_acc  := v_acc + resize(v_prod, ACC_BITS);
        end loop;

        -- 3. Rescale (Voltar para a escala original)
        -- Descartamos os bits fracionários extras gerados na multiplicação
        -- Acc >> F_BITS
        v_acc := shift_right(v_acc, F_BITS); 

        -- 4. ReLU e Saturação
        if USE_RELU and v_acc < 0 then
            o_output <= (others => '0'); 
        else
            -- Saturação usando as constantes de limite do tipo signed
            if v_acc > (2**(W_BITS-1) - 1) then 
                o_output <= to_signed((2**(W_BITS-1) - 1), W_BITS);
            elsif v_acc < -(2**(W_BITS-1)) then 
                o_output <= to_signed(-(2**(W_BITS-1)), W_BITS);
            else
                o_output <= resize(v_acc, W_BITS);
            end if;
        end if;
    end process;
end Behavioral;