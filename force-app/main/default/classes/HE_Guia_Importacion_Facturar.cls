public class HE_Guia_Importacion_Facturar {
    public string datos {get;set;}
    public Detalles_Guias_Importacion__c det_guia {get;set;}
    public list<Costos_de_Importacion__c> cos_inp {get;set;}
    public  HE_Guia_Importacion_Facturar(ApexPages.StandardController controller){
        datos = ApexPages.currentPage().getParameters().get('id'); 
        system.debug('datos'+datos);
        det_guia=[SELECT Id, Ciudad_Consignatario__c, Client_Code__c, Comuna__c, Consignatario__c, Consignee_Email__c, 
                  Consignee_Phone__c, Pais_de_Origen__c, Pais_de_Adquisicion__c, Cod_Postal_Vendedor__c, Descripcion__c, 
                  Rut_Consignatario__c, Monto_por_Facturar__c,Master_Importacion__r.Cuenta__c,Direccion_Consignatario__c
                  FROM Detalles_Guias_Importacion__c
                  WHERE Id =: datos];
         system.debug('det_guia'+det_guia);
        cos_inp= [SELECT Id, Name, Costo__c, Estado__c, Factura__c, Guias_Importacion__c, Observaciones__c, Valor__c 
                  FROM Costos_de_Importacion__c 
                  WHERE Guias_Importacion__c =:det_guia.id and Estado__c=:'Pendiente de Facturar' ];
          system.debug('cos_inp'+cos_inp);
    }
    public PageReference facrturar(){
         
        if(det_guia.Monto_por_Facturar__c==0){
            
            ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.Error,'no existen costos para facturar');
            ApexPages.addMessage(msg);
            return null;  
        }
        
         EndPoint_Factura__mdt ef= [SELECT Id, DeveloperName, EndPoint__c, rutCliente__c, rutUsuario__c, contrasena__c, sistema__c, numeroSerie__c FROM EndPoint_Factura__mdt where DeveloperName=:'Autenticar'];
       
        HE_servicio_Factura  sf=new HE_servicio_Factura();
        ArchivoDeVentasElectronicas.CargarYEmitirResult_element  arch=new ArchivoDeVentasElectronicas.CargarYEmitirResult_element();
        ArchivoDeVentasElectronicas.CargarYEmitir2Result_element  arch2=new ArchivoDeVentasElectronicas.CargarYEmitir2Result_element();
        string csv='TIPO ;FOLIO;SECUENCIA;FECHA;RUT;RAZONSOCIAL;GIRO;COMUNA;DIRECCION;AFECTO;PRODUCTO;DESCRIPCION;CANTIDAD;PRECIO;PORCENTDSCTO;EMAIL;TIPOSERVICIO ;PERIODODESDE;PERIODOHASTA;FECHAVENCIMIENTO;CODSUCURSAL;VENDEDOR;CODRECEPTOR;CODITEM;UNIDADMEDIDA(HR, KG, M3, MR, PM, PP, QTAL, TBDM, TBDU, TON, UNID);PORCENTDSCTO2;PORCENTDSCTO3;CODIGOIMP;MONTOIMP;INDICADORTRASLADO(1:Operacion constituye venta,2:Ventas por efectuar,3:Consignaciones,4:Entrega gratuita,5:Traslados internos,6:Otros traslados no venta,7:Guia de devolucion);FORMAPAGO(1:Contado, 2:Credito, 3:Sin costo);MEDIOPAGO(CH:Cheque,CF:Cheque a fecha,LT:letra,EF:Efectivo,PE:Pago a cta.cte,TC:Tarjeta Credito,OT:Otro);TERMINOSPAGOSDIAS;TERMINOSPAGOCODIGO;COMUNADESTINO;RUTSOLICITANTEFACTURA; PRODUCTOCAMBIOSUJETO; CANTIDADMONTOCAMBIOSUJETO; TIPOGLOBALAFECTO (1:DSCTO%, 2:DSCTO$, 3:RCGO%, 4:RCGO$);VALORGLOBALAFECTO;TIPOGLOBALEXENTO (1:DSCTO%, 2:DSCTO$, 3:RCGO%, 4:RCGO$);VALORGLOBALEXENTO; PRECIOCAMBIOSUJETO;INDICADORMONTOSBRUTOS(SI/NO);DESCUENTOMONTO;RUTTRANSPORTISTA;RUTCHOFER;NOMBRECHOFER;PATENTE;DIRECCIONDESTINO;CIUDADDESTINO;TIPODESPACHO(1:A instalaciones del cliente por cuenta del receptor,2:A instalaciones del cliente por cuenta del emisor, 3:A otras instalaciones por cuenta del emisor);NOMBRECONTACTO;CREDITOESPECIALEC;OBSERVACION'+'\n';   
        string fecha=''+system.now();
        string[] fechasola=fecha.split(' ');
        string[] f=fechasola[0].split('-'); 
        fecha=f[2]+'/'+f[1]+'/'+f[0];
        string rut= det_guia.Rut_Consignatario__c;
        string name= det_guia.Consignatario__c.replace('Ñ','N').replace('ñ','n');
        string idproducto=det_guia.Descripcion__c;
        decimal montoCLP=det_guia.Monto_por_Facturar__c;
        string comuna= det_guia.Comuna__c.replace('Ñ','N').replace('ñ','n');
        string direccion  = det_guia.Direccion_Consignatario__c.replace('Ñ','N').replace('ñ','n');
        string comentario='';
        string OC=null;
        
        system.debug('fecha'+fecha);
        system.debug('rut'+rut);
        system.debug('name'+name);
        system.debug('idproducto'+idproducto);
        system.debug('montoCLP'+montoCLP);
        system.debug('comuna'+comuna);
        system.debug('direccion'+direccion);
        system.debug('comentario'+comentario);
        
        csv=csv+'34;1;1;'+fecha+';'+rut+';'+name+';COMERCIO;'+comuna+';'+direccion+';NO;'+idproducto+';'+comentario+';1;'+montoCLP+';0;;;;;28/01/2020;1;HotExpress;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;'+'\n';
        
        
        string csvOC='TIPO;FOLIO;SECUENCIA;TIPO DOCUMENTO REFERENCIADO;FOLIO DOCUMENTO REFERENCIADO;FECHA DOCUMENTO REFERENCIADO; MOTIVO REFERENCIA(1: Anula documento, 2: Corrige texto, 3: Corrige monto);GLOSA REFERENCIA'+'\n';
        String base64CSVOC ='';
        if(OC!='' && OC!=null){
            csvOC=csvOC+'34;1;1;801;'+OC+';'+'09-06-2020'+';;';
            base64CSVOC = EncodingUtil.base64Encode(Blob.valueof(csvOC));
        }
        String base64CSV = EncodingUtil.base64Encode(Blob.valueof(csv));
        String estadofactura;
        String numerofactura; 
        String descripcionfactura;
        if(OC=='' || OC==null){
            if(!test.isRunningTest()){
                arch =   sf.validar(base64CSV,ef.rutCliente__c, ef.rutUsuario__c, ef.contrasena__c, ef.sistema__c, integer.valueOf(ef.numeroSerie__c));
            }else{
                
                ArchivoDeVentasElectronicas.CargarYEmitirResult_element  tr=new ArchivoDeVentasElectronicas.CargarYEmitirResult_element();
                ArchivoDeVentasElectronicas.ResultadoCargaArchivos_element  dd=new ArchivoDeVentasElectronicas.ResultadoCargaArchivos_element();
                dd.Resultado='ok';
                dd.Descripcion='';
                dd.Identificador='123124'; 
                tr.ResultadoCargaArchivos=dd;  
                arch=tr;  
                
            }
            system.debug('arch'+arch);
            estadofactura=arch.ResultadoCargaArchivos.Resultado;
            numerofactura=arch.ResultadoCargaArchivos.Identificador; //'128614';
            descripcionfactura=arch.ResultadoCargaArchivos.Descripcion;
        }else{
            arch2 =   sf.validar2(base64CSV,base64CSVOC,ef.rutCliente__c, ef.rutUsuario__c, ef.contrasena__c, ef.sistema__c, integer.valueOf(ef.numeroSerie__c));
            system.debug('arch2'+arch2);
            estadofactura=arch2.ResultadoCargaArchivos.Resultado;
            numerofactura=arch2.ResultadoCargaArchivos.Identificador; //'128614';
            descripcionfactura=arch2.ResultadoCargaArchivos.Descripcion;
        }
        
        
        if(numerofactura!=null  &&  numerofactura!=''){
            
            Factura__c  ff=new Factura__c();
            ff.Name=numerofactura;
            ff.Cuenta__c=det_guia.Master_Importacion__r.Cuenta__c;
            ff.Tipo_de_Servicio__c='IMPORT';
            ff.Precio__c=montoCLP;
            ff.Fecha_Emision__c=system.today();
            system.debug('ff'+ff);
            insert ff;
             Documentos_G_Importaci_n__c dg=new Documentos_G_Importaci_n__c();
            dg.Guias_Importacion__c=det_guia.id;
            dg.Factura__c=ff.id;
            insert dg;
            
            
            for(integer i=0;i<cos_inp.size();i++){
             cos_inp.get(i).Estado__c='Facturado';  
             cos_inp.get(i).Factura__c=ff.id;
            }  
            
            update cos_inp;
            pageReference p = new PageReference('/'+ff.id);
            return p; 
        } else{
            
            ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.Error,descripcionfactura);
            ApexPages.addMessage(msg);
            
            
            return null;  
        }
        
        
        
        
        
        
    }
}