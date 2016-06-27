Jenkins Slave for Kony Projects
===============================

Este script se encarga de construir y empaquetar los proyectos de Kony Studio. Lamentablemente, el entorno de Kony no está preparado para que automatizar este proceso sea una tarea fácil.
Se pudo observar que el entorno parecía propenso a la automatización del proceso de construcción cuando en el proyecto ya había sido construido una primera vez a través del IDE de Eclipse.

Por tanto, para poder lanzar el script, primero se debe descargar el proyecto de KonyStudio y abrir el proyecto con Eclipse (Kony). Cuando se abre Kony debemos especificar un workspace (que después será necesario utilizar en el script).
Para generar los ficheros necesarios para construir, debemos abrir el menú de internacionalización (i18n) a través del menú contextual al pulsar botón derecho en la Aplicación en la lista de aplicaciones del proyecto (vista Kony, el listado de la izquierda). Si este paso no se realiza el proceso de construicción mostrará un error con los ficheros .prop en la ruta de internacionalización (i18n).

Posteriormente iniciaremos la construcción del proyecto a través de Kony.

Si este proceso ha sido exitoso, podremos generar el proyecto a través del script automático a través de los siguientes pasos:

Se debe copiar builder.sh y vars.cfg a la carpeta que contiene el .project que genera Eclipse en la carpeta del proyecto que queremos construir. Modificar el fichero vars.cfg con los valores del entorno donde se construirá el proyecto. Y se lanza el script:

```bash
./builder.sh --name "nombreProyecto" --workspace "ruta/workspace/de/kony"
```

El `nombreProyecto` debe ser el nombre de la carpeta que contiene el .project. Por ejemplo en iMediador cuya ruta dentro del proyecto es `imediador/kony/studio/iMediador` será:

```code
iMediador
```

La ruta del workspace es el workspace donde previamente hemos abierto el proyecto con Eclipse.
