public class HE_Factura_Manual {
    
    public  HE_Factura_Manual(ApexPages.StandardController controller){
        
    }
    public PageReference facrturar(){
        String datos = ApexPages.currentPage().getParameters().get('id'); 
        system.debug('datos'+datos);
        Factura__c fac=[SELECT Id, Name, Cuenta__c,Cuenta__r.name,Cuenta__r.RUT__c, Fecha_Emision__c, Haber__c, Saldo__c, Estado__c,
                        Fecha_Comprometida_de_Pago__c,N_OC__c,Debe__c,Factura_Generada__c,Total_Neto__c,ID_Documento__c,
                        Dias_Vencidos__c, Fecha_Pago__c, Dias_de_Pago__c, Fecha_Vencimiento__c, Tipo_de_Servicio__c, Cantidad__c,
                        Tipo_de_Factura__c, Valor_Dolar__c,Cuenta__r.BillingCity,Cuenta__r.BillingState,
                        Cuenta__r.BillingCountry,Cuenta__r.BillingStreet,Tipo_Documento__c,RUT_Interno__c,N_HES__c,
                        Informacion_Factura__c,Descripcion_Factura__c,Descripcion_3__c,Descripcion_4__c,Descripcion_5__c,Descripcion_6__c,Descripcion_7__c,Descripcion_8__c,
                        Descripcion_9__c,Descripcion_10__c,Cuenta__r.Giro__c ,Descripcion_Exenta__c,Precio_Exento__c,
                        Precio__c,Precio2__c,Precio3__c,Precio4__c,Precio5__c,Precio6__c,Precio7__c,Precio8__c,Precio9__c,Precio10__c
                        FROM Factura__c 
                        WHERE Id =: datos];
        EndPoint_Factura__mdt ef= [SELECT Id, DeveloperName, EndPoint__c, rutCliente__c, rutUsuario__c, contrasena__c, sistema__c, numeroSerie__c FROM EndPoint_Factura__mdt where DeveloperName=:'Autenticar'];
        
        if(fac.Cuenta__r.BillingCity==null   ){
            ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.Error,'falta ingresar datos de direccion ');
            ApexPages.addMessage(msg);
            
        }
        if(fac.Cuenta__r.BillingStreet==null){
            ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.Error,'falta ingresar datos de direccion ');
            ApexPages.addMessage(msg);
            
        }
        if(fac.Cuenta__r.name==null){
            ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.Error,'debe tener nombre ingresado  ');
            ApexPages.addMessage(msg);
            
        }
        if(fac.Cuenta__r.RUT__c==null){
            ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.Error,'cliente no tiene rut');
            ApexPages.addMessage(msg);
            
        }
        if(fac.Tipo_Documento__c==null){
            ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.Error,'selecione tipo documento');
            ApexPages.addMessage(msg);
            
        }
       /* if(fac.Factura_Generada__c==true){
            ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.Error,'esta factura a sido generada anteriormente no se puede volver a facturar ');
            ApexPages.addMessage(msg);
            
        }*/
        
        if(ApexPages.hasMessages()){
            return null;
            
        }
        
        HE_servicio_Factura  sf=new HE_servicio_Factura();
        ArchivoDeVentasElectronicas.CargarYEmitirResult_element  arch=new ArchivoDeVentasElectronicas.CargarYEmitirResult_element();
        ArchivoDeVentasElectronicas.CargarYEmitir2Result_element  arch2=new ArchivoDeVentasElectronicas.CargarYEmitir2Result_element();
        string csv='TIPO;FOLIO;SECUENCIA;FECHA;RUT;RAZONSOCIAL;GIRO;COMUNA;DIRECCION;AFECTO;PRODUCTO;DESCRIPCION;CANTIDAD;PRECIO;PORCENTDSCTO;EMAIL;TIPOSERVICIO ;PERIODODESDE;PERIODOHASTA;FECHAVENCIMIENTO;CODSUCURSAL;VENDEDOR;CODRECEPTOR;CODITEM;UNIDADMEDIDA(HR, KG, M3, MR, PM, PP, QTAL, TBDM, TBDU, TON, UNID);PORCENTDSCTO2;PORCENTDSCTO3;CODIGOIMP;MONTOIMP;INDICADORTRASLADO(1:Operacion constituye venta,2:Ventas por efectuar,3:Consignaciones,4:Entrega gratuita,5:Traslados internos,6:Otros traslados no venta,7:Guia de devolucion);FORMAPAGO(1:Contado, 2:Credito, 3:Sin costo);MEDIOPAGO(CH:Cheque,CF:Cheque a fecha,LT:letra,EF:Efectivo,PE:Pago a cta.cte,TC:Tarjeta Credito,OT:Otro);TERMINOSPAGOSDIAS;TERMINOSPAGOCODIGO;COMUNADESTINO;RUTSOLICITANTEFACTURA; PRODUCTOCAMBIOSUJETO; CANTIDADMONTOCAMBIOSUJETO; TIPOGLOBALAFECTO (1:DSCTO%, 2:DSCTO$, 3:RCGO%, 4:RCGO$);VALORGLOBALAFECTO;TIPOGLOBALEXENTO (1:DSCTO%, 2:DSCTO$, 3:RCGO%, 4:RCGO$);VALORGLOBALEXENTO; PRECIOCAMBIOSUJETO;INDICADORMONTOSBRUTOS(SI/NO);DESCUENTOMONTO;RUTTRANSPORTISTA;RUTCHOFER;NOMBRECHOFER;PATENTE;DIRECCIONDESTINO;CIUDADDESTINO;TIPODESPACHO(1:A instalaciones del cliente por cuenta del receptor,2:A instalaciones del cliente por cuenta del emisor, 3:A otras instalaciones por cuenta del emisor);NOMBRECONTACTO;CREDITOESPECIALEC;OBSERVACION'+'\n';   
        string fecha=''+system.now();
        string[] fechasola=fecha.split(' ');
        string[] f=fechasola[0].split('-'); 
        fecha=f[2]+'/'+f[1]+'/'+f[0];
        string rut= fac.Cuenta__r.RUT__c;
        string name= fac.Cuenta__r.name.replace('Ñ','N').replace('ñ','n');
        string idproducto=fac.Descripcion_Factura__c;
        string campogiro=fac.Cuenta__r.Giro__c.replace('Ñ','N').replace('ñ','n'); 
        
        string giro='';  
            if(campogiro.length()>=40){
                giro=campogiro.substring(0,39);
            }else{
                giro=campogiro.substring(0,campogiro.length()); 
            }
        //decimal montoCLP=fac.Debe__c;
        decimal montoCLP=fac.Total_Neto__c;
        string comuna= fac.Cuenta__r.BillingCity.replace('Ñ','N').replace('ñ','n');
        string direccion  = fac.Cuenta__r.BillingStreet.replace('Ñ','N').replace('ñ','n').replace('\r\n',' ').replace('\n',' ').replace('\r',' ').replace('\r\n',' ').replace('\n\r',' ');
        string comentario='';
        
        string OC=fac.N_OC__c;
        string HES=fac.N_HES__c;
        
        string tipo=fac.Tipo_Documento__c;
        
        system.debug('fecha'+fecha);
        system.debug('rut'+rut);
        system.debug('name'+name);
        system.debug('idproducto'+idproducto);
        system.debug('montoCLP'+montoCLP);
        system.debug('comuna'+comuna);
        system.debug('direccion'+direccion);
        system.debug('comentario'+comentario);
        string afecta='';
        if(tipo=='34'){
            afecta='NO'; 
        }else{
            afecta='SI';   
        }
        
        if(fac.Informacion_Factura__c!=null){
            csv+=''+tipo+';1;1;'+fecha+';'+rut+';'+name+';'+giro+';'+comuna+';'+direccion+';'+afecta+';'+fac.Informacion_Factura__c+';'+comentario+';1;'+fac.Precio__c+';0;;;;;;1;HotExpress;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;'+'\n';
        }
        if(fac.Descripcion_Factura__c!=null){
            csv+=''+tipo+';1;1;'+fecha+';'+rut+';'+name+';'+giro+';'+comuna+';'+direccion+';'+afecta+';'+fac.Descripcion_Factura__c+';'+comentario+';1;'+fac.Precio2__c+';0;;;;;;1;HotExpress;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;'+'\n';
        }
        if(fac.Descripcion_3__c!=null){
            csv+=''+tipo+';1;1;'+fecha+';'+rut+';'+name+';'+giro+';'+comuna+';'+direccion+';'+afecta+';'+fac.Descripcion_3__c+';'+comentario+';1;'+fac.Precio3__c+';0;;;;;;1;HotExpress;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;'+'\n';
        }
        if(fac.Descripcion_4__c!=null){       
            csv+=''+tipo+';1;1;'+fecha+';'+rut+';'+name+';'+giro+';'+comuna+';'+direccion+';'+afecta+';'+fac.Descripcion_4__c+';'+comentario+';1;'+fac.Precio4__c+';0;;;;;;1;HotExpress;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;'+'\n';
        }
        if(fac.Descripcion_5__c!=null){       
            csv+=''+tipo+';1;1;'+fecha+';'+rut+';'+name+';'+giro+';'+comuna+';'+direccion+';'+afecta+';'+fac.Descripcion_5__c+';'+comentario+';1;'+fac.Precio5__c+';0;;;;;;1;HotExpress;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;'+'\n';
        }
        if(fac.Descripcion_6__c!=null){       
            csv+=''+tipo+';1;1;'+fecha+';'+rut+';'+name+';'+giro+';'+comuna+';'+direccion+';'+afecta+';'+fac.Descripcion_6__c+';'+comentario+';1;'+fac.Precio6__c+';0;;;;;;1;HotExpress;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;'+'\n';
        }
        if(fac.Descripcion_7__c!=null){       
            csv+=''+tipo+';1;1;'+fecha+';'+rut+';'+name+';'+giro+';'+comuna+';'+direccion+';'+afecta+';'+fac.Descripcion_7__c+';'+comentario+';1;'+fac.Precio7__c+';0;;;;;;1;HotExpress;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;'+'\n';
        }
        if(fac.Descripcion_8__c!=null){       
            csv+=''+tipo+';1;1;'+fecha+';'+rut+';'+name+';'+giro+';'+comuna+';'+direccion+';'+afecta+';'+fac.Descripcion_8__c+';'+comentario+';1;'+fac.Precio8__c+';0;;;;;;1;HotExpress;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;'+'\n';
        }
        if(fac.Descripcion_9__c!=null){       
            csv+=''+tipo+';1;1;'+fecha+';'+rut+';'+name+';'+giro+';'+comuna+';'+direccion+';'+afecta+';'+fac.Descripcion_9__c+';'+comentario+';1;'+fac.Precio9__c+';0;;;;;;1;HotExpress;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;'+'\n';
        }
        if(fac.Descripcion_10__c!=null){       
            csv+=''+tipo+';1;1;'+fecha+';'+rut+';'+name+';'+giro+';'+comuna+';'+direccion+';'+afecta+';'+fac.Descripcion_10__c+';'+comentario+';1;'+fac.Precio10__c+';0;;;;;;1;HotExpress;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;'+'\n';
        }       
        if(fac.Descripcion_Exenta__c!=null){       
            csv+=''+tipo+';1;1;'+fecha+';'+rut+';'+name+';'+giro+';'+comuna+';'+direccion+';'+'NO'+';'+fac.Descripcion_Exenta__c+';'+comentario+';1;'+fac.Precio_Exento__c+';0;;;;;;1;HotExpress;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;'+'\n';
        } 
        
         
        
        csv=csv.replace('null', '');  
        system.debug('csv=='+csv);
        
        string csvOC='TIPO;FOLIO;SECUENCIA;TIPO DOCUMENTO REFERENCIADO;FOLIO DOCUMENTO REFERENCIADO;FECHA DOCUMENTO REFERENCIADO; MOTIVO REFERENCIA(1: Anula documento, 2: Corrige texto, 3: Corrige monto);GLOSA REFERENCIA'+'\n';
        String base64CSVOC ='';
        if(OC!='' && OC!=null){
            csvOC=csvOC+''+tipo+';1;1;801;'+OC+';'+fecha+';;'+'\n';
            base64CSVOC = EncodingUtil.base64Encode(Blob.valueof(csvOC));
        }
        if(HES!='' && HES!=null){
            csvOC=csvOC+''+tipo+';1;1;HES;'+HES+';'+fecha+';;'+'\n';
            base64CSVOC = EncodingUtil.base64Encode(Blob.valueof(csvOC));
        }
        system.debug('csvOC=='+csvOC);
        String base64CSV = EncodingUtil.base64Encode(Blob.valueof(csv));
        String estadofactura;
        String numerofactura; 
        String descripcionfactura;
        if(base64CSVOC=='' || base64CSVOC==null){
            if(!test.isRunningTest()){
                arch =   sf.validar(base64CSV,fac.RUT_Interno__c, ef.rutUsuario__c, ef.contrasena__c, ef.sistema__c, integer.valueOf(ef.numeroSerie__c));
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
            if(!test.isRunningTest()){
                arch2 =   sf.validar2(base64CSV,base64CSVOC,ef.rutCliente__c, fac.RUT_Interno__c, ef.contrasena__c, ef.sistema__c, integer.valueOf(ef.numeroSerie__c));
            }else{
                
                ArchivoDeVentasElectronicas.CargarYEmitir2Result_element  tr=new ArchivoDeVentasElectronicas.CargarYEmitir2Result_element();
                ArchivoDeVentasElectronicas.ResultadoCargaArchivos_element  dd=new ArchivoDeVentasElectronicas.ResultadoCargaArchivos_element();
                dd.Resultado='ok';
                dd.Descripcion='';
                dd.Identificador='123124'; 
                tr.ResultadoCargaArchivos=dd;  
                arch2=tr;  
                
            }
            system.debug('arch2'+arch2);
            estadofactura=arch2.ResultadoCargaArchivos.Resultado;
            numerofactura=arch2.ResultadoCargaArchivos.Identificador; //'128614';
            descripcionfactura=arch2.ResultadoCargaArchivos.Descripcion;
        }
        
        
        if(numerofactura!=null  &&  numerofactura!=''){
            
            /*      Factura__c  ff=new Factura__c();
            ff.Name=numerofactura;
            ff.Cuenta__c=fac.Cuenta__c;
            ff.Tipo_de_Servicio__c='EXPORT';
            ff.Precio__c=montoCLP;
            ff.Fecha_Emision__c=system.today();
            system.debug('ff'+ff);
            insert ff;


            */
            fac.Name=numerofactura;
            fac.ID_Documento__c=numerofactura;
            fac.Factura_Generada__c=true;
            update fac;
            
            pageReference p = new PageReference('/'+fac.id);
            return p; 
        } else{
            
            ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.Error,descripcionfactura);
            ApexPages.addMessage(msg);
            
            
            return null;  
        }
        
        
        
        
        
        
    }

    // public PageReference facturarV2(){
    //     try{
    //         String datos = ApexPages.currentPage().getParameters().get('id'); 
    //         system.debug('datos'+datos);
    //         Factura__c fac=[SELECT Id, Name, Cuenta__c,Cuenta__r.name,Cuenta__r.RUT__c, Fecha_Emision__c, Haber__c, Saldo__c, Estado__c,
    //                         Fecha_Comprometida_de_Pago__c,N_OC__c,Debe__c,Factura_Generada__c,Total_Neto__c,ID_Documento__c,
    //                         Dias_Vencidos__c, Fecha_Pago__c, Dias_de_Pago__c, Fecha_Vencimiento__c, Tipo_de_Servicio__c, Cantidad__c,
    //                         Tipo_de_Factura__c, Valor_Dolar__c,Cuenta__r.BillingCity,Cuenta__r.BillingState,
    //                         Cuenta__r.BillingCountry,Cuenta__r.BillingStreet,Tipo_Documento__c,RUT_Interno__c,N_HES__c,
    //                         Informacion_Factura__c,Descripcion_Factura__c,Descripcion_3__c,Descripcion_4__c,Descripcion_5__c,Descripcion_6__c,Descripcion_7__c,Descripcion_8__c,
    //                         Descripcion_9__c,Descripcion_10__c,Cuenta__r.Giro__c ,Descripcion_Exenta__c,Precio_Exento__c,
    //                         Precio__c,Precio2__c,Precio3__c,Precio4__c,Precio5__c,Precio6__c,Precio7__c,Precio8__c,Precio9__c,Precio10__c
    //                         FROM Factura__c 
    //                         WHERE Id =: datos];

    //         EndPoint_Factura__mdt datosEndpoint = [SELECT Id, DeveloperName, EndPoint__c, 
    //                                     rutCliente__c, rutUsuario__c, contrasena__c, 
    //                                     sistema__c, numeroSerie__c 
    //                                     FROM EndPoint_Factura__mdt 
    //                                     WHERE DeveloperName=:'WsBsoft'];
            
    //         if(fac.Cuenta__r.BillingCity==null   ){
    //             ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.Error,'falta ingresar datos de direccion ');
    //             ApexPages.addMessage(msg);
                
    //         }
    //         if(fac.Cuenta__r.BillingStreet==null){
    //             ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.Error,'falta ingresar datos de direccion ');
    //             ApexPages.addMessage(msg);
                
    //         }
    //         if(fac.Cuenta__r.name==null){
    //             ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.Error,'debe tener nombre ingresado  ');
    //             ApexPages.addMessage(msg);
                
    //         }
    //         if(fac.Cuenta__r.RUT__c==null){
    //             ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.Error,'cliente no tiene rut');
    //             ApexPages.addMessage(msg);
                
    //         }
    //         if(fac.Tipo_Documento__c==null){
    //             ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.Error,'selecione tipo documento');
    //             ApexPages.addMessage(msg);
                
    //         }
    //         /* if(fac.Factura_Generada__c==true){
    //             ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.Error,'esta factura a sido generada anteriormente no se puede volver a facturar ');
    //             ApexPages.addMessage(msg);
                
    //         }*/
            
    //         if(ApexPages.hasMessages()){
    //             return null;
                
    //         }
            
    //         string csv='';
    //         string fecha=''+system.now();
    //         string[] fechasola=fecha.split(' ');
    //         string[] f=fechasola[0].split('-'); 
    //         fecha=f[2]+'/'+f[1]+'/'+f[0];
    //         string rut= fac.Cuenta__r.RUT__c;
    //         string name= fac.Cuenta__r.name.replace('Ñ','N').replace('ñ','n');
    //         string idproducto=fac.Descripcion_Factura__c;
    //         string campogiro=fac.Cuenta__r.Giro__c.replace('Ñ','N').replace('ñ','n'); 
            
    //         string giro='';  
    //             if(campogiro.length()>=40){
    //                 giro=campogiro.substring(0,39);
    //             }else{
    //                 giro=campogiro.substring(0,campogiro.length()); 
    //             }
    //         //decimal montoCLP=fac.Debe__c;
    //         decimal montoCLP=fac.Total_Neto__c;
    //         string comuna= fac.Cuenta__r.BillingCity.replace('Ñ','N').replace('ñ','n');
    //         string direccion  = fac.Cuenta__r.BillingStreet.replace('Ñ','N').replace('ñ','n').replace('\r\n',' ').replace('\n',' ').replace('\r',' ').replace('\r\n',' ').replace('\n\r',' ');
    //         string comentario='';
            
    //         string OC=fac.N_OC__c;
    //         string HES=fac.N_HES__c;
            
    //         string tipo=fac.Tipo_Documento__c;
            
    //         system.debug('fecha'+fecha);
    //         system.debug('rut'+rut);
    //         system.debug('name'+name);
    //         system.debug('idproducto'+idproducto);
    //         system.debug('montoCLP'+montoCLP);
    //         system.debug('comuna'+comuna);
    //         system.debug('direccion'+direccion);
    //         system.debug('comentario'+comentario);
    //         string afecta='';
    //         if(tipo=='34'){
    //             afecta='NO'; 
    //         }else{
    //             afecta='SI';   
    //         }
            
    //         if(fac.Informacion_Factura__c!=null){
    //             csv+=''+tipo+';1;1;'+fecha+';'+rut+';'+name+';'+giro+';'+comuna+';'+direccion+';'+afecta+';'+fac.Informacion_Factura__c+';'+comentario+';1;'+fac.Precio__c+';0;;;;;;1;HotExpress'+'\n';
    //         }
    //         if(fac.Descripcion_Factura__c!=null){
    //             csv+=''+tipo+';1;1;'+fecha+';'+rut+';'+name+';'+giro+';'+comuna+';'+direccion+';'+afecta+';'+fac.Descripcion_Factura__c+';'+comentario+';1;'+fac.Precio2__c+';0;;;;;;1;HotExpress'+'\n';
    //         }
    //         if(fac.Descripcion_3__c!=null){
    //             csv+=''+tipo+';1;1;'+fecha+';'+rut+';'+name+';'+giro+';'+comuna+';'+direccion+';'+afecta+';'+fac.Descripcion_3__c+';'+comentario+';1;'+fac.Precio3__c+';0;;;;;;1;HotExpress'+'\n';
    //         }
    //         if(fac.Descripcion_4__c!=null){       
    //             csv+=''+tipo+';1;1;'+fecha+';'+rut+';'+name+';'+giro+';'+comuna+';'+direccion+';'+afecta+';'+fac.Descripcion_4__c+';'+comentario+';1;'+fac.Precio4__c+';0;;;;;;1;HotExpress'+'\n';
    //         }
    //         if(fac.Descripcion_5__c!=null){       
    //             csv+=''+tipo+';1;1;'+fecha+';'+rut+';'+name+';'+giro+';'+comuna+';'+direccion+';'+afecta+';'+fac.Descripcion_5__c+';'+comentario+';1;'+fac.Precio5__c+';0;;;;;;1;HotExpress'+'\n';
    //         }
    //         if(fac.Descripcion_6__c!=null){       
    //             csv+=''+tipo+';1;1;'+fecha+';'+rut+';'+name+';'+giro+';'+comuna+';'+direccion+';'+afecta+';'+fac.Descripcion_6__c+';'+comentario+';1;'+fac.Precio6__c+';0;;;;;;1;HotExpress'+'\n';
    //         }
    //         if(fac.Descripcion_7__c!=null){       
    //             csv+=''+tipo+';1;1;'+fecha+';'+rut+';'+name+';'+giro+';'+comuna+';'+direccion+';'+afecta+';'+fac.Descripcion_7__c+';'+comentario+';1;'+fac.Precio7__c+';0;;;;;;1;HotExpress'+'\n';
    //         }
    //         if(fac.Descripcion_8__c!=null){       
    //             csv+=''+tipo+';1;1;'+fecha+';'+rut+';'+name+';'+giro+';'+comuna+';'+direccion+';'+afecta+';'+fac.Descripcion_8__c+';'+comentario+';1;'+fac.Precio8__c+';0;;;;;;1;HotExpress'+'\n';
    //         }
    //         if(fac.Descripcion_9__c!=null){       
    //             csv+=''+tipo+';1;1;'+fecha+';'+rut+';'+name+';'+giro+';'+comuna+';'+direccion+';'+afecta+';'+fac.Descripcion_9__c+';'+comentario+';1;'+fac.Precio9__c+';0;;;;;;1;HotExpress'+'\n';
    //         }
    //         if(fac.Descripcion_10__c!=null){       
    //             csv+=''+tipo+';1;1;'+fecha+';'+rut+';'+name+';'+giro+';'+comuna+';'+direccion+';'+afecta+';'+fac.Descripcion_10__c+';'+comentario+';1;'+fac.Precio10__c+';0;;;;;;1;HotExpress'+'\n';
    //         }       
    //         if(fac.Descripcion_Exenta__c!=null){       
    //             csv+=''+tipo+';1;1;'+fecha+';'+rut+';'+name+';'+giro+';'+comuna+';'+direccion+';'+'NO'+';'+fac.Descripcion_Exenta__c+';'+comentario+';1;'+fac.Precio_Exento__c+';0;;;;;;1;HotExpress'+'\n';
    //         } 
            
            
            
    //         csv=csv.replace('null', '');  
    //         system.debug('csv=='+csv);
            
    //         string csvOC='TIPO;FOLIO;SECUENCIA;TIPO DOCUMENTO REFERENCIADO;FOLIO DOCUMENTO REFERENCIADO;FECHA DOCUMENTO REFERENCIADO; MOTIVO REFERENCIA(1: Anula documento, 2: Corrige texto, 3: Corrige monto);GLOSA REFERENCIA'+'\n';
    //         String base64CSVOC ='';
    //         if(OC!='' && OC!=null){
    //             csvOC=csvOC+''+tipo+';1;1;801;'+OC+';'+fecha+';;'+'\n';
    //             base64CSVOC = EncodingUtil.base64Encode(Blob.valueof(csvOC));
    //         }
    //         if(HES!='' && HES!=null){
    //             csvOC=csvOC+''+tipo+';1;1;HES;'+HES+';'+fecha+';;'+'\n';
    //             base64CSVOC = EncodingUtil.base64Encode(Blob.valueof(csvOC));
    //         }
    //         system.debug('csvOC=='+csvOC);
    //         String base64CSV = EncodingUtil.base64Encode(Blob.valueof(csv));
    //         String estadofactura;
    //         String numerofactura; 
    //         String descripcionfactura;

    //         String xmlString;

    //         xmlString = '<?xml version="1.0" encoding="utf-8"?>\n';
    //         xmlString += '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">\n';
    //         xmlString += '<soap:Body>\n';
    //         xmlString += '    <PROCESA_DATOSCSV xmlns="http://BSOFT/">\n';
    //         xmlString += '    <FACTURA>'+csv+'</FACTURA>\n';
    //         if(OC!='' && OC!=null){
    //             xmlString += '    <OC>'+tipo+';1;1;801;'+OC+';'+fecha+';;</OC>\n';
    //         }else{
    //             xmlString += '    <OC></OC>\n';
    //         }
    //         if(HES!='' && HES!=null){
    //             xmlString += '    <HES>'+tipo+';1;1;HES;'+HES+';'+fecha+';;</HES>\n';
    //         }else{
    //             xmlString += '    <HES></HES>\n';
    //         }
    //         xmlString += '    </PROCESA_DATOSCSV>\n';
    //         xmlString += '</soap:Body>\n';
    //         xmlString += '</soap:Envelope>\n';
    //         System.debug('XML');
    //         System.debug(xmlString);

    //         HttpRequest req = new HttpRequest();
    //         req.setEndpoint(datosEndpoint.EndPoint__c);
    //         req.setMethod('POST');
    //         req.setTimeout(120000);
    //         req.setHeader('Content-Type', 'text/xml; charset=utf-8');
    //         req.setBody(xmlString);

    //         Http h = new Http();
    //         HttpResponse res = new HttpResponse();

    //         String respuestaXml = '';
    //         Boolean existeRespuestaXml = false;
    //         Boolean existeError = false;

    //         try{
    //             res = h.send(req);
                
    //             if (res.getStatusCode() == 200){
    //                 respuestaXml = res.getBody();
    //                 System.debug('RESPUESTA XML DE SAP');
    //                 System.debug(respuestaXml);
    //                 existeRespuestaXml = true;

    //                 if(respuestaXml.contains('<Estado>1</Estado>')){
    //                     existeError = true;
    //                 }
    //             }else{
    //                 existeError = true;
    //                 existeRespuestaXml = true;
    //                 respuestaXml = res.getBody();
    //                 System.debug('ERROR = '+res.getBody());
    //             }
    //         }catch(Exception ex){
    //             existeError = true;
    //             existeRespuestaXml = false;
    //             System.debug(ex.getMessage());
    //             System.debug(ex.getStackTraceString());
    //         }

    //         if(!existeError && existeRespuestaXml){

    //         }else if(existeError && existeRespuestaXml){

    //         }else if(existeError && !existeRespuestaXml){

    //         }
            
    //         // if(base64CSVOC=='' || base64CSVOC==null){
    //         //     if(!test.isRunningTest()){
    //         //         arch =   sf.validar(base64CSV,fac.RUT_Interno__c, ef.rutUsuario__c, ef.contrasena__c, ef.sistema__c, integer.valueOf(ef.numeroSerie__c));
    //         //     }else{
                    
    //         //         ArchivoDeVentasElectronicas.CargarYEmitirResult_element  tr=new ArchivoDeVentasElectronicas.CargarYEmitirResult_element();
    //         //         ArchivoDeVentasElectronicas.ResultadoCargaArchivos_element  dd=new ArchivoDeVentasElectronicas.ResultadoCargaArchivos_element();
    //         //         dd.Resultado='ok';
    //         //         dd.Descripcion='';
    //         //         dd.Identificador='123124'; 
    //         //         tr.ResultadoCargaArchivos=dd;  
    //         //         arch=tr;  
                    
    //         //     }
    //         //     system.debug('arch'+arch);
    //         //     estadofactura=arch.ResultadoCargaArchivos.Resultado;
    //         //     numerofactura=arch.ResultadoCargaArchivos.Identificador; //'128614';
    //         //     descripcionfactura=arch.ResultadoCargaArchivos.Descripcion;
    //         // }else{
    //         //     if(!test.isRunningTest()){
    //         //         arch2 =   sf.validar2(base64CSV,base64CSVOC,ef.rutCliente__c, fac.RUT_Interno__c, ef.contrasena__c, ef.sistema__c, integer.valueOf(ef.numeroSerie__c));
    //         //     }else{
                    
    //         //         ArchivoDeVentasElectronicas.CargarYEmitir2Result_element  tr=new ArchivoDeVentasElectronicas.CargarYEmitir2Result_element();
    //         //         ArchivoDeVentasElectronicas.ResultadoCargaArchivos_element  dd=new ArchivoDeVentasElectronicas.ResultadoCargaArchivos_element();
    //         //         dd.Resultado='ok';
    //         //         dd.Descripcion='';
    //         //         dd.Identificador='123124'; 
    //         //         tr.ResultadoCargaArchivos=dd;  
    //         //         arch2=tr;  
                    
    //         //     }
    //         //     system.debug('arch2'+arch2);
    //         //     estadofactura=arch2.ResultadoCargaArchivos.Resultado;
    //         //     numerofactura=arch2.ResultadoCargaArchivos.Identificador; //'128614';
    //         //     descripcionfactura=arch2.ResultadoCargaArchivos.Descripcion;
    //         // }
            
            
    //         // if(numerofactura!=null  &&  numerofactura!=''){
                
    //         //     /*Factura__c  ff=new Factura__c();
    //         //     ff.Name=numerofactura;
    //         //     ff.Cuenta__c=fac.Cuenta__c;
    //         //     ff.Tipo_de_Servicio__c='EXPORT';
    //         //     ff.Precio__c=montoCLP;
    //         //     ff.Fecha_Emision__c=system.today();
    //         //     system.debug('ff'+ff);
    //         //     insert ff; */

    //         //     fac.Name=numerofactura;
    //         //     fac.ID_Documento__c=numerofactura;
    //         //     fac.Factura_Generada__c=true;
    //         //     update fac;
                
    //         //     pageReference p = new PageReference('/'+fac.id);
    //         //     return p; 
    //         // } else{
    //         //     ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.Error,descripcionfactura);
    //         //     ApexPages.addMessage(msg);
    //         //     return null;  
    //         // }
    //         return null;
    //     }catch(Exception ex){
    //         System.debug('SE HA DETECTADO UNA EXCEPCIÓN');
    //         System.debug(ex.getMessage());
    //         System.debug(ex.getStackTraceString());
    //         return null;
    //     }
    // }
    
}