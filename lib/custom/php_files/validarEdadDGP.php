<?php
/*
 ---Script para consultar edad a la Dirección General de Policia. ---
 
 Autor: Jose Eduardo Mascarell Moreno
 Empresa: Alfatec Sistemas S.L.
 Versión : 0.1


 Uso:  php -f validarEdadDGP.php -- -n: <nif>

Nota: LOS VALORES OPCIONALES NO ADMITEN ESPACIO COMO SEPARADO

Parámetros de entrada:

    -n, --nif <nif>    NIF
    -h, --help         Muestra la ayuda


*/
//0 - Declaración de variables y recogida de parámetros.

$options = getopt("n:h",['nif:','help']);



// 1 - Validación de parámetros de entrada.

if (isset($options['h']) || isset($options['help'])) {
    echo " 


    Uso:  php -f validarEdadDGP.php -- -n: <nif>

    Nota: LOS VALORES OPCIONALES NO ADMITEN ESPACIO COMO SEPARADO
    
    Parámetros de entrada:
    
        -n, --nif <nif>    NIF
        -h, --help         Muestra la ayuda
        
    
    
    ";
    exit(0);
}

if (!isset($options['n']) && !isset($options['nif'])){
    echo "ERROR : Es obligatorio el parámetro NIF -n|--nif <nif> \n";
    exit(1);
}else{
    if (isset($options['n'])){
        $nif = $options['n'];
    }else {
        $nif = $options['nif'];
    }


}

// 2 - Lógica para obtención de la información.


// 3 - Lógica para la devolución del resultado.


$ejemplo = [
    'nacinalidad' => 'España',
    'sexo' => 'M',
    'fecha_nacimiento' => '19-10-1977',
    
];
 

$respuesta = json_encode($ejemplo);





echo $respuesta;
//return $respuesta;

exit(0);
