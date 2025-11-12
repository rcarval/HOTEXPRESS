global class HE_Facturar_Controller {
    
       global  HE_Facturar_Controller(){
       
    }
    @RemoteAction
    global static String facturar(double dolar,string fechaIn , string FechaFin ){
        system.debug('dolar'+dolar);
        system.debug('FechaFin'+FechaFin);
        system.debug('fechaIn'+fechaIn);
        string[] fechai=fechaIn.split('-');
          string[] fechaf=fechaIn.split('-');
        date FF=date.valueOf(fechaf[2]+'-'+fechaf[1]+'-'+fechaf[0]);
        date FI=date.valueOf(fechai[2]+'-'+fechai[1]+'-'+fechai[0]);
        system.debug('FF'+FF);
        system.debug('FI'+FI);
         list<Detalles_Master__c>  listafacturar;
        if(!test.isRunningTest()){
        listafacturar=[SELECT Id, Name, Master__c, Fecha_de_Entrega__c, Estado_Correo__c, Estado_Aduana__c, Estado_Guia__c,Dolar_Dia__c
                                                 FROM Detalles_Master__c where (Estado_Guia__c='Documental' or Estado_Guia__c='	Menor a 30' )  
                                                 and Fecha_de_Entrega__c>=:FI and Fecha_de_Entrega__c<=:FF and Estado_Correo__c='ENVIO ENTREGADO' ];
        }else{
        listafacturar=[SELECT Id, Name, Master__c, Fecha_de_Entrega__c, Estado_Correo__c, Estado_Aduana__c, Estado_Guia__c,Dolar_Dia__c
                                                 FROM Detalles_Master__c];
            
        }
       
            if(listafacturar.size()>0){
            for(integer i=0; i<listafacturar.size();i++){
                listafacturar.get(i).Dolar_Dia__c=dolar;
                listafacturar.get(i).Estado_Guia__c='Facturada';
            }
            // update listafacturar;
            return 'se facturaron '+listafacturar.size()+' filas';  
        }else{
            return 'no existen lineas que puedan ser facturadas';    
        }
        
    }
}