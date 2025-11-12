public class HE_normalizacion {
    public string idmaster {get;set;}
    public string inicio {get;set;}
    public string fin {get;set;}
    public string totalconsulta {get;set;}
    public  HE_normalizacion(ApexPages.StandardController  Controller) {
        idmaster=ApexPages.currentPage().getParameters().get('id');
        inicio=ApexPages.currentPage().getParameters().get('in');
        fin=ApexPages.currentPage().getParameters().get('fn'); 
        //  idmaster='a040v000002SChh';
        system.debug('idmaster'+idmaster);
        system.debug('inicio'+inicio);
        system.debug('fin'+fin);
        if(inicio==null){
            system.debug('entro por aca');
            inicio='0';  
        }
        if(fin==null){
            system.debug('entro por aca 2');
            fin='50';        
        }
        system.debug('idmaster'+idmaster);
        system.debug('inicio'+inicio);
        system.debug('fin'+fin);
        
    }
    public PageReference normalizacion(){
        integer contador =0;
        system.debug('entro a normalizacion');
        system.debug('inicio'+inicio);
        system.debug('fin'+fin);
        EndPoint__mdt ep=[SELECT Id, usuario__c, contrase_a__c, Codigo_Cliente__c, Label FROM EndPoint__mdt where Label='normalizacion' limit 1 ];
        
        Master__c   mt=[select Id, Name, Fecha_Recepcion__c, Estado__c, N_Manifiesto_Aduana__c, Cuenta__c, Total_Valor__c, Total_Peso__c, Total_Piezas__c,
                        Aeropuerto_Origen__c, Aeropuerto_Destino__c, N_Vuelo__c, Total_Cajas__c, Master_AirwayBill__c, Fecha_Vuelo__c
                        from Master__c  where id=:idmaster];
        
        list<Detalles_Master__c> detmast=[select Id, Name, Master__c, Order_Number__c, Type_of_Mail__c, Vendedor__c, Shipper_Address__c, Shipper_Town__c, Consignatario__c, 
                                          Direccion_Consignatario__c, Comuna__c, Postal_Code__c, Consignee_Phone__c, Pieces__c, Peso__c, Valor__c, Puerto_de_Destino__c,
                                          Destination_Generic_Postal_Code__c, Client_Code__c, HD_PUDO__c, Undelivered_Parcels__c, Postal_Services__c, Descripcion__c,Direccion_Normalizada__c,
                                          Nombre_Cod_Arancelario__c, Estado_Guia__c, Cod_Arancelario__c, Factor_Peso__c, Factor_Pieces__c, Tarifa_Guia__c, Bag_Code__c 
                                          FROM Detalles_Master__c WHERE Master__c=:mt.id order by id];
        string  usuario =ep.usuario__c;
        string contrasena =ep.contrase_a__c;
        // string contrasena ='b9d591ae8ef9d36bb7d4';
        string id='1';
        
        system.debug('detmast'+detmast.size());  
        for(integer i=integer.valueOf(inicio);i<integer.valueOf(fin);i++){
            if(detmast.get(i).Direccion_Normalizada__c==false){
                string direccion=detmast.get(i).Direccion_Consignatario__c.replace(',',' '); 
                string comuna=detmast.get(i).Comuna__c; 
                normalizacion.ServicioExternoNormalizacionSoap   ns=new normalizacion.ServicioExternoNormalizacionSoap();
                normalizacion.DireccionNormalizadaTO nd=new normalizacion.DireccionNormalizadaTO();
                try{
                    if(!test.isRunningTest()){
                    nd=ns.normalizarDireccion(usuario, contrasena, id, direccion, comuna);
                    }else{
                        nd.Id='000';
                        nd.Calle='000';
                        nd.Numero='000';
                        nd.CodigoPostal='000';
                        nd.Resto='000';
                        nd.Comuna='000';
                    }
                    
                    system.debug('nd.Id=='+nd.Id);
                    system.debug('nd.Calle=='+nd.Calle);
                    system.debug('nd.Numero=='+nd.Numero);
                    system.debug('nd.CodigoPostal=='+nd.CodigoPostal);
                    system.debug('nd.Resto=='+nd.Resto);
                    system.debug('nd.Comuna=='+nd.Comuna);
                    system.debug('nd'+nd);
                    detmast.get(i).Direccion_Consignatario__c= nd.Calle+' '+nd.Numero+' '+nd.Resto;
                    detmast.get(i).Comuna__c=nd.Comuna;
                    detmast.get(i).Postal_Code__c=nd.CodigoPostal;
                    detmast.get(i).Direccion_Normalizada__c=true;
                    
                    contador++;
                }catch(Exception e){
                    system.debug('e'+e);
                }
                system.debug('contador'+contador);
            }
        }
        if(contador>0){
            update detmast;
        }
        
        if(integer.valueOf(fin)<detmast.size()){
            integer total=detmast.size();
            integer i=integer.valueOf(fin)+1;
            integer f=integer.valueOf(fin)+50;
            system.debug('total'+total);
            system.debug('i'+i);
            system.debug('f'+f);
            if(f>total){
                f=f-(f-total);
            }
            string url='/apex/HE_normalizacion_2?id='+mt.id+'&&in='+i+'&&fn='+f;
            system.debug('url'+url);
            inicio=string.valueOf(i);
            fin=string.valueOf(f);
            pageReference p = new PageReference(url);
            p.setRedirect(true);
            return  p;
        }else{
            
            detmast=[select Id, Name, Master__c, Order_Number__c, Type_of_Mail__c, Vendedor__c, Shipper_Address__c, Shipper_Town__c, Consignatario__c, 
                     Direccion_Consignatario__c, Comuna__c, Postal_Code__c, Consignee_Phone__c, Pieces__c, Peso__c, Valor__c, Puerto_de_Destino__c,
                     Destination_Generic_Postal_Code__c, Client_Code__c, HD_PUDO__c, Undelivered_Parcels__c, Postal_Services__c, Descripcion__c,Direccion_Normalizada__c,
                     Nombre_Cod_Arancelario__c, Estado_Guia__c, Cod_Arancelario__c, Factor_Peso__c, Factor_Pieces__c, Tarifa_Guia__c, Bag_Code__c 
                     FROM Detalles_Master__c WHERE Master__c=:mt.id and Direccion_Normalizada__c=false order by id];  
            
            for(integer j=0;j<detmast.size();j++){ 
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, ' guias no normalizada '+ detmast.get(j).Name + ' direccion incorrecta '+ detmast.get(j).Direccion_Consignatario__c );
                ApexPages.addMessage(msg);
                
                
            }
            if(detmast.size()==0){
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Todas las direcciones han sido normalizdas. ' );
                ApexPages.addMessage(msg);
            }
        }
        
        return null;
    }
    public PageReference redirecion(){
        list<Detalles_Master__c> detmast=[select Id  FROM Detalles_Master__c WHERE Master__c=:idmaster order by id];
        totalconsulta=string.valueOf(detmast.size());
        if(detmast.size()<integer.valueOf(fin)){
            fin=string.valueOf(detmast.size());
        }
        return null;
    }
}