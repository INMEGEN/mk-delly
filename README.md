## Pipeline de Delly2 para detección de varinates estructurales

##El pipeline consiste en 5 tipos de variantes estructurales:

-DUiPlicadas
-DELeciones
-INSerciones
-TRAnslocaciones
-INVersiones

Cada uno de los tipos de variantes deben pasar por 

001 -> Delly call con batches de XX .bams para mejorar la sensibilidad del BCF creado
002 -> Los BCFs de 001 deben ser colapsados (merge) en un único BCF
003 -> Con el BCF unificado se hace el rellamado de variantes estructurales

La salida final del algoritmo es un BCF por cada tipo de variante estructural probada.

