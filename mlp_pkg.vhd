library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

package mlp_pkg is

    -- 1. Definição das larguras de bits (Configuração Global)
    constant W_BITS   : integer := 8;  -- Bits dos Pesos
    constant I_BITS   : integer := 8;  -- Bits dos dados (Entrada/Saída interna)
    constant ACC_BITS : integer := 16; -- Bits do Acumulador (Soma)

    -- 2. Tipos de Array para facilitar a conexão
    -- Um array de valores (ex: 4 entradas)
    type t_data_array is array (natural range <>) of signed(I_BITS-1 downto 0);
    -- Um array de pesos (ex: pesos de 1 neurônio)
    type t_weight_array is array (natural range <>) of signed(W_BITS-1 downto 0);

    -- 3. CONSTANTES (A "Inteligência" da Rede)
    -- Nota: Estas matrizes guardam os pesos.
    
    -- CAMADA 1 (4 Neurônios, 4 Entradas cada)
    type t_matrix_4x4 is array (0 to 3) of t_weight_array(0 to 3);
    constant W_L1 : t_matrix_4x4 := (
        (to_signed(10,8), to_signed(-20,8), to_signed(5,8),  to_signed(2,8)), 
        (to_signed(5,8),  to_signed(12,8),  to_signed(-5,8), to_signed(1,8)), 
        (to_signed(-2,8), to_signed(3,8),   to_signed(15,8), to_signed(0,8)), 
        (to_signed(8,8),  to_signed(-8,8),  to_signed(2,8),  to_signed(30,8))
    );
    constant B_L1 : t_data_array(0 to 3) := (to_signed(2,8), to_signed(-1,8), to_signed(0,8), to_signed(5,8));

    -- CAMADA 2 (2 Neurônios, 4 Entradas cada - vindo da L1)
    type t_matrix_2x4 is array (0 to 1) of t_weight_array(0 to 3);
    constant W_L2 : t_matrix_2x4 := (
        (to_signed(15,8), to_signed(-10,8), to_signed(2,8), to_signed(-1,8)), 
        (to_signed(-5,8), to_signed(20,8),  to_signed(1,8), to_signed(10,8)) 
    );
    constant B_L2 : t_data_array(0 to 1) := (to_signed(10,8), to_signed(-5,8));

    -- SAÍDA (1 Neurônio, 2 Entradas cada - vindo da L2)
    type t_matrix_1x2 is array (0 to 0) of t_weight_array(0 to 1);
    constant W_OUT : t_matrix_1x2 := (
        (to_signed(40,8), to_signed(-30,8)) -- Parenteses duplos pois é matriz 1 linha
    ); 
    constant B_OUT : t_data_array(0 to 0) := (others => to_signed(-5, 8));

end package mlp_pkg;