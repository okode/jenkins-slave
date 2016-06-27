Jenkins Slave for Kony Projects
===============================

Se debe copiar builder.sh y vars.cfg a la carpeta que contiene el .project que genera Eclipse en la carpeta del proyecto que queremos construir. Modificar el fichero vars.cfg con los valores del entorno donde se construirá el proyecto. Y se lanza el script:
```bash
./builder.sh --name "nombreProyecto" --workspace "ruta/workspace/de/kony"
```

El `nombreProyecto` debe ser el nombre de la carpeta que contiene el .project. Por ejemplo en iMediador cuya ruta es dentro del proyecto `imediador/kony/studio/iMediador` será:

```code
iMediador
```

La ruta del workspace es el workspace donde previamente hemos abierto el proyecto con Eclipse.
