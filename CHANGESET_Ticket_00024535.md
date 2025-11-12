# Change Set - Ticket N°00024535

## Información General

- **Nombre del Change Set**: `Ticket_00024535`
- **Descripción**: Fix Subir Depuración - Manejo ISO-8859-1 y extracción HTML anidado
- **Ambiente Origen**: HOTEXPRESS-DEV (jalcaino@hotexpress.cl.sbxhot)
- **Ambiente Destino**: HOTEXPRESS-PROD

## Componentes a Incluir

### 1. ApexClass (2 componentes)

| Componente | Tipo | Descripción |
|------------|------|-------------|
| `HE_Subir_Documento` | ApexClass | Clase principal con mejoras de parseo XML y manejo de errores |
| `HE_Subir_DocumentoTEST` | ApexClass | Tests unitarios mejorados (89% cobertura) |

### 2. ApexPage (1 componente)

| Componente | Tipo | Descripción |
|------------|------|-------------|
| `HE_Subir_Documento` | ApexPage | Visualforce con lectura ISO-8859-1 |

### 3. CustomField (1 componente)

| Componente | Tipo | Descripción |
|------------|------|-------------|
| `Detalles_Master__c.Estado_Aduana__c` | CustomField | Campo ampliado de 20 a 255 caracteres |

---

## Instrucciones para Crear el Change Set Manualmente

### En HOTEXPRESS-DEV (Sandbox):

1. Ir a **Setup** → **Outbound Change Sets**
2. Click en **New**
3. Configurar:
   - **Name**: `Ticket_00024535`
   - **Description**: `Fix Subir Depuración - Manejo ISO-8859-1 y extracción HTML. Incluye ampliación campo Estado_Aduana__c a 255 chars.`
4. Click en **Save**
5. En la sección **Change Set Components**, click en **Add**
6. Agregar los componentes:
   
   **Apex Classes:**
   - Buscar y seleccionar: `HE_Subir_Documento`
   - Buscar y seleccionar: `HE_Subir_DocumentoTEST`
   
   **Visualforce Pages:**
   - Buscar y seleccionar: `HE_Subir_Documento`
   
   **Custom Fields:**
   - Seleccionar objeto: `Detalles Master`
   - Buscar y seleccionar: `Estado Aduana` (Estado_Aduana__c)

7. Click en **Upload** para enviar a Producción

### En HOTEXPRESS-PROD (Producción):

1. Ir a **Setup** → **Inbound Change Sets**
2. Buscar el change set: `Ticket_00024535`
3. Click en **Deploy**
4. Seleccionar opciones:
   - **Test Level**: Run Local Tests (recomendado)
5. Click en **Deploy**

---

## Validación Post-Deployment

Después del despliegue, validar:

1. ✅ Ir a un registro de Master__c
2. ✅ Click en botón "Subir Depuración"
3. ✅ Subir el archivo de ejemplo con codificación ISO-8859-1
4. ✅ Verificar que:
   - Los caracteres especiales (tildes, ñ) se lean correctamente
   - El campo MotivoSeleccion extraiga el texto del `<div>` correctamente
   - Los registros de Detalles_Master__c se actualicen sin errores
   - No aparezca error STRING_TOO_LONG

---

## Cambios Técnicos Incluidos

### HE_Subir_Documento.page
- Lectura de archivos con codificación ISO-8859-1: `reader.readAsText(file, 'ISO-8859-1')`

### HE_Subir_Documento.cls
- Nuevo método `extractTextFromNode()` para extraer texto de nodos HTML anidados
- Try-catch comprehensivo con manejo de errores específicos
- Validaciones de estructura XML y registros vacíos
- Mensajes de error descriptivos

### HE_Subir_DocumentoTEST.cls
- 4 métodos de test cubriendo casos positivos y negativos
- Cobertura: 89% (supera el 76% requerido)

### Estado_Aduana__c
- Campo ampliado de 20 a 255 caracteres

---

**Fecha de Creación**: 2025-11-12  
**Desarrollador**: Rodrigo Carvallo  
**Branch**: Ticket-00024535  
**Commits**: 38c5077, b06a1df, 20e7f80

