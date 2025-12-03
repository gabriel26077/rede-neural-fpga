library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

package mlp_pkg is

    -- =========================================================================
    -- CONFIGURA��O GLOBAL (MASTER)
    -- =========================================================================
    
    -- Defini��o da precis�o
    constant W_BITS   : integer := 8;  -- Largura dos Pesos/Dados
    constant F_BITS   : integer := 6;  -- Quantos bits s�o fra��o? (Q2.6)
    
    -- Constantes derivadas (Calculadas automaticamente)
    constant FIXED_ONE : integer := 2**F_BITS; -- O valor de "1.0" (ex: 64)
    
    -- Largura da Multiplica��o (8+8 = 16 bits)
    constant MULT_BITS : integer := W_BITS + W_BITS; 
    
    -- Largura do Acumulador (Soma)
    -- Precisamos de folga para somar v�rios produtos sem estourar.
    -- +4 bits garante somar at� 16 neur�nios tranquilamente.
    constant ACC_BITS : integer := MULT_BITS + 4; 

    -- =========================================================================
    -- TIPOS DE DADOS
    -- =========================================================================
    type t_data_array is array (natural range <>) of signed(W_BITS-1 downto 0);
    type t_weight_array is array (natural range <>) of signed(W_BITS-1 downto 0);

    -- =========================================================================
    -- PESOS E BIAS (Gerados pelo Python, mas agora usando as constantes)
    -- =========================================================================
    -- (Mantenha os valores que o script gerou, a estrutura � a mesma)
    
    -- CAMADA 1
    type t_matrix_4x4 is array (0 to 3) of t_weight_array(0 to 3);
    constant W_L1 : t_matrix_4x4 := (
        (to_signed(33, W_BITS), to_signed(5, W_BITS), to_signed(-18, W_BITS), to_signed(14, W_BITS)),
        (to_signed(-13, W_BITS), to_signed(-22, W_BITS), to_signed(22, W_BITS), to_signed(-16, W_BITS)),
        (to_signed(0, W_BITS), to_signed(-22, W_BITS), to_signed(37, W_BITS), to_signed(29, W_BITS)),
        (to_signed(12, W_BITS), to_signed(-22, W_BITS), to_signed(-32, W_BITS), to_signed(-26, W_BITS))
    );
    constant B_L1 : t_data_array(0 to 3) := (to_signed(78, W_BITS), to_signed(14, W_BITS), to_signed(-14, W_BITS), to_signed(17, W_BITS));

    -- CAMADA 2
    type t_matrix_2x4 is array (0 to 1) of t_weight_array(0 to 3);
    constant W_L2 : t_matrix_2x4 := (
        (to_signed(18, W_BITS), to_signed(1, W_BITS), to_signed(-34, W_BITS), to_signed(-27, W_BITS)),
        (to_signed(-30, W_BITS), to_signed(13, W_BITS), to_signed(-16, W_BITS), to_signed(-6, W_BITS))
    );
    constant B_L2 : t_data_array(0 to 1) := (to_signed(29, W_BITS), to_signed(-6, W_BITS));

	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
    -- CAMADA SA�DA
-- ... (resto do código para cima mantido igual)

    -- =========================================================================
    -- CAMADA SAÍDA (AQUI ESTAVA O ERRO)
    -- =========================================================================
    type t_matrix_1x2 is array (0 to 0) of t_weight_array(0 to 1);
    
    constant W_OUT : t_matrix_1x2 := (
        -- Usamos "0 =>" para forçar o Quartus a entender que é uma matriz de 1 linha
        0 => (to_signed(-68, W_BITS), to_signed(-30, W_BITS))
    ); 

    constant B_OUT : t_data_array(0 to 0) := (
        -- Usamos "0 =>" para forçar o Quartus a entender que é um array de 1 posição
        0 => to_signed(7, W_BITS)
    );

end package mlp_pkg;
