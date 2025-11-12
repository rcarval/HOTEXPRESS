public class HE_listado_clientes_Impor {
    /**********************************************************************************
Desarrollado por: Nectia
Autor: Jorge Carvajal (JC)
Proyecto:  
Descripción:  
---------------------------------------------------------------------------------
No. Fecha                Autor                     Descripción
------ ---------- ---------------------------------------------------------------
1.0 27-08-2019            JC                   Creación de la Clase.
***********************************************************************************/
    
    public list<clienteafaturar> historialdefacturas {get;set;}
    public string resultJSON {get;set;}
    public  decimal Vdolar {get;set;}
    list<clienteafaturar> respuesta{get;set;}
    public PageReference Obtenerclientes(){
        
        String fechaI = string.valueOf(date.parse(ApexPages.currentPage().getParameters().get('FI').replace('-','/')));
        String fachaF = string.valueOf(date.parse(ApexPages.currentPage().getParameters().get('FN').replace('-','/')));
        Vdolar = decimal.valueOf(ApexPages.currentPage().getParameters().get('V'));
        String TD = ApexPages.currentPage().getParameters().get('td');
        String TC = ApexPages.currentPage().getParameters().get('tc');
        String idcuenta = ApexPages.currentPage().getParameters().get('ida');
      //  String idcontacto = ApexPages.currentPage().getParameters().get('idcon');
        String pais = ApexPages.currentPage().getParameters().get('ps');
        String zona = ApexPages.currentPage().getParameters().get('zon');        
        
        
        if(idcuenta!='1'){
            string r= ' AND Cuenta__c =\''+idcuenta+'\'';
            idcuenta=r; 
            system.debug('idcuenta'+idcuenta);
        }else{
            idcuenta='';      
        } 
       /* if((idcontacto!='con_1' && idcontacto!='' && idcontacto!=null) && idcuenta!='1' ){
            string r= ' AND Contacto__c =\''+idcontacto+'\'';
            idcontacto=r; 
            system.debug('idcontacto'+idcontacto);
        }else{
            idcontacto='';      
        } */
        
        if((pais!='pais_1' && pais!='' && pais!=null) && idcuenta!='1' ){
            string r= ' AND Pais__c =\''+pais+'\'';
            pais=r; 
            system.debug('pais'+pais);
        }else{
            pais='';      
        } 
        if((zona!='Zona_1' && zona!='' && zona!=null) && idcuenta!='1' ){
            string r= ' AND Zona_HOT__c =\''+zona+'\'';
            zona=r; 
            system.debug('zona'+zona);
        }else{
            zona='';      
        } 
        
        
        
        
        
       /* if(TD!='1'){
            string r= ' AND Tipo_Contenido__c =\''+TD+'\'';
            TD=r; 
            system.debug('TD'+TD);
        }else{
            TD='';      
        } */
        
        
        if(TC=='15'){
            
            string r= ' AND Cuenta__r.Forma_de_Facturacion__c =\'Fin de Mes\'';
            TC=r; 
            system.debug('TD'+TD);
        }else if(tc=='30'){
            string r= ' AND Cuenta__r.Forma_de_Facturacion__c =\'Fin de Mes y Quincena\'';
            TC=r;    
        } else{
            TC='';    
        }
        string consulta ='SELECT Id, Name,Cuenta__r.name,Pais__c,Cuenta__r.Requiere_OC__c,Cuenta__r.RUT__c,Cuenta__r.BillingCity, Cuenta__r.BillingStreet,Contacto_Remitente__c,'+
            'Telefono_Remitente__c,Cuenta__c,Total_Costos_sin_Facturar__c,Peso_Total__c,Fecha_de_Envio__c,Contacto_de_Entrega__c,Peso_Agente__c'+
            ' FROM Solicitud_de_Pickup__c'+
            ' where Fecha_de_Envio__c >='+fechaI+' and Fecha_de_Envio__c <='+fachaF+' '+
            ' AND Guia_validada__c=true '+
            ' AND Total_Costos_sin_Facturar__c > 0 '+
            idcuenta+' '+
         //   idcontacto+' '+
            pais+' '+
        //    TD+' '+
       //     TC+' '+
            ' order by Cuenta__c';
        system.debug('consulta='+consulta);
        
        
        
        list<Solicitud_de_Pickup__c> clie=Database.query(consulta  );
        system.debug('clie'+clie);
        //list<Detalles_Master__c> det=Database.query('select name,id  from Detalles_Master__c limit 1000');
        List<clienteafaturar>  listafacturas = new  List<clienteafaturar>();
        
        historialdefacturas = new List<clienteafaturar>();  
        string siguientefactura;
        
        for(integer i=0;i<clie.size();i++){
            clienteafaturar hi=new clienteafaturar();
            if(i==0){
                
                hi.id=clie.get(i).Cuenta__c;
                hi.name=clie.get(i).Cuenta__r.name;
                hi.requiereOC=clie.get(i).Cuenta__r.Requiere_OC__c;
                hi.RUT=clie.get(i).Cuenta__r.RUT__c;
                hi.comuna=clie.get(i).Cuenta__r.BillingCity;
                hi.direccion=clie.get(i).Cuenta__r.BillingStreet; 
                /*  if(-1 < 0){
hi.tipo=true;  
}  else{
hi.tipo=false;
} */               
                historialdefacturas.add(hi); 
            }else if(clie.get(i).Cuenta__c != clie.get(i-1).Cuenta__c){
                
                hi.id=clie.get(i).Cuenta__c;
                hi.name=clie.get(i).Cuenta__r.name;
                hi.RUT=clie.get(i).Cuenta__r.RUT__c;
                hi.comuna=clie.get(i).Cuenta__r.BillingCity;
                hi.direccion=clie.get(i).Cuenta__r.BillingStreet; 
                /* if(-1 < 0){
hi.tipo=true;  
}  else{
hi.tipo=false;
} */  
                historialdefacturas.add(hi); 
            } 
            
            
            
            //    hi.Monto=123432;
        }
         
        system.debug('historialdefacturas.size()'+historialdefacturas.size());
        system.debug('clie.size()'+clie.size());
        list<listadoguias> listarguias=new  list<listadoguias>();
        for(integer j=0;j<historialdefacturas.size();j++){ 
            system.debug('j=='+j);
            integer contador=0;
            for(integer i=0;i<clie.size();i++){
                system.debug('i=='+i);
                system.debug('historialdefacturas.get(j).id'+historialdefacturas.get(j).id);
                system.debug('clie.get(i).Cuenta__c'+clie.get(i).Cuenta__c);
                if(historialdefacturas.get(j).id==clie.get(i).Cuenta__c){
                    listadoguias   lis=new listadoguias();
                    lis.idguia=clie.get(i).id;
                    lis.idproducto=clie.get(i).name;
                    lis.pais_destino=clie.get(i).Pais__c;
                    lis.tipo=clie.get(i).Contacto_de_Entrega__c;
                    lis.fecha=string.valueOf(clie.get(i).Fecha_de_Envio__c);
                    lis.cantidad =1;
                    lis.peso=clie.get(i).Peso_Total__c;
                    lis.montoUSD=clie.get(i).Total_Costos_sin_Facturar__c;
                    lis.montoCLP=(clie.get(i).Total_Costos_sin_Facturar__c * Vdolar).setScale(0);
                    //  lis.montocantidadporunidad=1 * 1;
                    listarguias.add(lis);
                    contador++;
                    historialdefacturas.get(j).listarguias=listarguias;
                    historialdefacturas.get(j).contadorpendientes=contador;
                }else{
                    listarguias=new  list<listadoguias>();
                }
                
                
                
            }
        }
        
        
        return null;
    }
    
    public void facrturar(){
        
        String datos = ApexPages.currentPage().getParameters().get('datos');
        
        System.debug('datos: '+datos);
        respuesta = (list<clienteafaturar>) System.JSON.deserialize(datos, list<clienteafaturar>.class);
        system.debug('respuesta'+respuesta);
        list<string> nguias=new list<string>();
        list<guias_facturadas> list_guias=new list<guias_facturadas>();
        list<Factura__c> list_Facturas=new list<Factura__c>();
        list<Documento_Solicitud_de_Pickup__c> list_docExp=new list<Documento_Solicitud_de_Pickup__c>();
           EndPoint_Factura__mdt ef= [SELECT Id, DeveloperName, EndPoint__c, rutCliente__c, rutUsuario__c, contrasena__c, sistema__c, numeroSerie__c FROM EndPoint_Factura__mdt where DeveloperName=:'Autenticar'];
       
        HE_servicio_Factura  sf=new HE_servicio_Factura();
        ArchivoDeVentasElectronicas.CargarYEmitirResult_element  arch=new ArchivoDeVentasElectronicas.CargarYEmitirResult_element();
        ArchivoDeVentasElectronicas.CargarYEmitir2Result_element  arch2=new ArchivoDeVentasElectronicas.CargarYEmitir2Result_element();
        string csv='TIPO ;FOLIO;SECUENCIA;FECHA;RUT;RAZONSOCIAL;GIRO;COMUNA;DIRECCION;AFECTO;PRODUCTO;DESCRIPCION;CANTIDAD;PRECIO;PORCENTDSCTO;EMAIL;TIPOSERVICIO ;PERIODODESDE;PERIODOHASTA;FECHAVENCIMIENTO;CODSUCURSAL;VENDEDOR;CODRECEPTOR;CODITEM;UNIDADMEDIDA(HR, KG, M3, MR, PM, PP, QTAL, TBDM, TBDU, TON, UNID);PORCENTDSCTO2;PORCENTDSCTO3;CODIGOIMP;MONTOIMP;INDICADORTRASLADO(1:Operacion constituye venta,2:Ventas por efectuar,3:Consignaciones,4:Entrega gratuita,5:Traslados internos,6:Otros traslados no venta,7:Guia de devolucion);FORMAPAGO(1:Contado, 2:Credito, 3:Sin costo);MEDIOPAGO(CH:Cheque,CF:Cheque a fecha,LT:letra,EF:Efectivo,PE:Pago a cta.cte,TC:Tarjeta Credito,OT:Otro);TERMINOSPAGOSDIAS;TERMINOSPAGOCODIGO;COMUNADESTINO;RUTSOLICITANTEFACTURA; PRODUCTOCAMBIOSUJETO; CANTIDADMONTOCAMBIOSUJETO; TIPOGLOBALAFECTO (1:DSCTO%, 2:DSCTO$, 3:RCGO%, 4:RCGO$);VALORGLOBALAFECTO;TIPOGLOBALEXENTO (1:DSCTO%, 2:DSCTO$, 3:RCGO%, 4:RCGO$);VALORGLOBALEXENTO; PRECIOCAMBIOSUJETO;INDICADORMONTOSBRUTOS(SI/NO);DESCUENTOMONTO;RUTTRANSPORTISTA;RUTCHOFER;NOMBRECHOFER;PATENTE;DIRECCIONDESTINO;CIUDADDESTINO;TIPODESPACHO(1:A instalaciones del cliente por cuenta del receptor,2:A instalaciones del cliente por cuenta del emisor, 3:A otras instalaciones por cuenta del emisor);NOMBRECONTACTO;CREDITOESPECIALEC;OBSERVACION'+'\n';   
        string fecha;
        for(integer i=0;i<respuesta.size();i++){
            for(integer j=0;j<respuesta.get(i).listarguias.size();j++){  
                string[] f=respuesta.get(i).listarguias.get(j).fecha.split('-'); 
                fecha=f[2]+'/'+f[1]+'/'+f[0];
                string rut= respuesta.get(i).RUT;
                string name= respuesta.get(i).name.replace('Ñ','N').replace('ñ','n');
                string idproducto=respuesta.get(i).listarguias.get(j).idproducto;
                decimal montoUSD=respuesta.get(i).listarguias.get(j).montoUSD;
                decimal montoCLP=respuesta.get(i).listarguias.get(j).montoCLP;
                
                string comuna= respuesta.get(i).comuna.replace('Ñ','N').replace('ñ','n');
                string direccion  = respuesta.get(i).direccion.replace('Ñ','N').replace('ñ','n');
                nguias.add(idproducto);
                csv=csv+'34;1;1;'+fecha+';'+rut+';'+name+';COMERCIO;'+comuna+';'+direccion+';NO;'+idproducto+';'+respuesta.get(i).comentario+';1;'+montoCLP+';0;;;;;28/01/2020;1;HotExpress;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;'+'\n';
                
            }
            string csvOC='TIPO;FOLIO;SECUENCIA;TIPO DOCUMENTO REFERENCIADO;FOLIO DOCUMENTO REFERENCIADO;FECHA DOCUMENTO REFERENCIADO; MOTIVO REFERENCIA(1: Anula documento, 2: Corrige texto, 3: Corrige monto);GLOSA REFERENCIA'+'\n';
            String base64CSVOC ='';
            if(respuesta.get(i).oc!='' && respuesta.get(i).oc!=null){
                csvOC=csvOC+'34;1;1;801;'+respuesta.get(i).oc+';'+'09-06-2020'+';;';
                base64CSVOC = EncodingUtil.base64Encode(Blob.valueof(csvOC));
            }
            String base64CSV = EncodingUtil.base64Encode(Blob.valueof(csv));
            if(respuesta.get(i).oc=='' || respuesta.get(i).oc==null){
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
                respuesta.get(i).estadofactura=arch.ResultadoCargaArchivos.Resultado;
                respuesta.get(i).numerofactura=arch.ResultadoCargaArchivos.Identificador; //'128614';
                respuesta.get(i).descripcionfactura=arch.ResultadoCargaArchivos.Descripcion;
            }else{
                arch2 =   sf.validar2(base64CSV,base64CSVOC,ef.rutCliente__c, ef.rutUsuario__c, ef.contrasena__c, ef.sistema__c, integer.valueOf(ef.numeroSerie__c));
                system.debug('arch'+arch);
                respuesta.get(i).estadofactura=arch2.ResultadoCargaArchivos.Resultado;
                respuesta.get(i).numerofactura=arch2.ResultadoCargaArchivos.Identificador; //'128614';
                respuesta.get(i).descripcionfactura=arch2.ResultadoCargaArchivos.Descripcion;
            }
            
            
            if(respuesta.get(i).numerofactura!=null  &&  respuesta.get(i).numerofactura!=''){
                for(integer j=0;j<respuesta.get(i).listarguias.size();j++){  
                    guias_facturadas  gf=new  guias_facturadas();
                    gf.id=respuesta.get(i).listarguias.get(j).idguia;
                    gf.nfactura=respuesta.get(i).numerofactura;
                    list_guias.add(gf);   
                }
                Factura__c  ff=new Factura__c();
                ff.Name=respuesta.get(i).numerofactura;
                ff.Cuenta__c=respuesta.get(i).id;
                ff.Tipo_de_Servicio__c='IMPORT';
                ff.Valor_Dolar__c=integer.valueOf(Vdolar);
                ff.Fecha_Emision__c=system.today();
                system.debug('ff'+ff);
                //  ff.Precio__c='EXPORT';
                list_Facturas.add(ff);
            }
        }
        insert list_Facturas;
        
        
        
        list<Costo_Solicitud_Pickup__c> listcostos=[SELECT Id, Solicitud_de_Pickup__c,Solicitud_de_Pickup__r.name, Estado__c, Factura__c FROM Costo_Solicitud_Pickup__c WHERE Solicitud_de_Pickup__r.name in: nguias order by Solicitud_de_Pickup__c ];
        
        for(Factura__c lf:list_Facturas){
            for(integer i=0;i<list_guias.size();i++){
                if(lf.name==list_guias.get(i).nfactura){
                    list_guias.get(i).idfactura=lf.id;
                    
                    Documento_Solicitud_de_Pickup__c DE=new Documento_Solicitud_de_Pickup__c();
                    DE.Solicitud_de_Pickup__c=list_guias.get(i).id;
                    DE.Factura__c=lf.id;
                    list_docExp.add(DE); 
                }
            }
        }
        
        for(guias_facturadas gf:list_guias){
            for(integer d=0;d<listcostos.size();d++){
                if(gf.id==listcostos.get(d).Solicitud_de_Pickup__c){
                    listcostos.get(d).Factura__c=gf.idfactura;
                    listcostos.get(d).Estado__c='Facturado';
                }  
                
            }
        }
        system.debug('listcostos'+listcostos);
        insert list_docExp;
        update listcostos;
        resultJSON=json.serialize(respuesta);
        system.debug('resultJSON'+resultJSON);
        //resultJSON = '{"error":true}';
        pageReference p = new PageReference('/HE_visualizar_PDF_Factura' );
        //  return respuesta;  
        
    }
    
    
    
    
    public class clienteafaturar{
        public string id{get;set;}
        public string name{get;set;} 
        public string RUT{get;set;} 
        public string comuna{get;set;} 
        public string direccion{get;set;} 
        public integer contadorpendientes{get;set;} 
        public string estadofactura{get;set;} 
        public string numerofactura{get;set;} 
        public boolean requiereOC{get;set;} 
        public string descripcionfactura{get;set;} 
        public string oc{get;set;} 
        public string comentario{get;set;} 
        public list<listadoguias> listarguias {get;set;} 
    }
    public class listadoguias{
        public string idguia{get;set;} 
        public string idproducto{get;set;} 
        public string pais_destino{get;set;}
        public string tipo{get;set;}
        public string fecha{get;set;} 
        public integer cantidad {get;set;} 
        public decimal peso {get;set;} 
        public decimal montoUSD{get;set;} 
        public decimal montoCLP{get;set;} 
        //    public integer montocantidadporunidad{get;set;} 
        
    }
    
    public class guias_facturadas{
        public string id{get;set;} 
        public string nfactura{get;set;}
        public string idfactura{get;set;}
        
    }
}