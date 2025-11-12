@istest(SeeAllData=false)
public class HE_costosguias_importacionTEST {
    
    
    static testMethod void test1() {
        
        Tarifa_Agente__c ta=new Tarifa_Agente__c();
        ta.Agente__c='DHL';
        ta.Tipo_Tarifa__c='Importación';
        insert ta;
        Tarifa_Agente__c ta2=new Tarifa_Agente__c();
        ta2.Agente__c='FEDEX';
        ta2.Tipo_Tarifa__c='Importación';
        insert ta2;
        
        
        Tarifa__c t=new  Tarifa__c();
        t.Tipo_Tarifa__c='Importación';
        insert t;
        
        Detalle_Tarifa__c  dt=new Detalle_Tarifa__c();
        dt.Tarifa__c=t.id;
        dt.Zona__c='Zona 1';
        dt.Embalaje__c='Cajas';
        dt.Valor__c=10;
        dt.Kilos__c=10;
        insert dt;
        
        Detalle_Tarifa_Agente__c  dta=new Detalle_Tarifa_Agente__c();
        dta.Tarifa_Agente__c=ta.id;
        dta.Zona__c='Zona 1';
        dta.Embalaje__c='Cajas';
        dta.Valor__c=10;
        dta.Kilos__c=10;
        insert dta;
        
        
        
        Porcentaje_Combustible__c   pc=new Porcentaje_Combustible__c();
        pc.Porcentaje_Mensual__c=5; 
        pc.Fecha_Inicial__c=system.today();
        insert pc;
        
        Account  acc=new Account();
        acc.Name='1211';
        acc.Tarifa_Importacion__c=t.id;
        insert acc;
        
        
        Pais__c p=new Pais__c();
        p.Name='ARGENTINA';
        p.Cod_Pais__c='AR';
        
        p.Nombre_Zonas__c='SUR AMERICA 1';
        p.Zona_DHL__c='Zona 1';
        p.Zona_Fedex__c='Zona 1';
        p.Zona_Hot__c='Zona 1';
        insert p;
        
        Direcciones__c d=new Direcciones__c();
        d.Name='direccion test';
        d.Cuenta__c=acc.id;
        d.Direccion__c='isidora goyenechea 3000';
        d.Ciudad__c='Buenos Aires';
        d.Estado_Provincia__c='Buenos Aires';
        d.Codigo_Postal__c='7550653';
        d.Pais__c=p.id;
        insert d;
        
        Master_Importacion__c ms=new Master_Importacion__c();
        ms.Name='0001';
        ms.Cuenta__c=acc.id;
        ms.Estado__c='Recepcionado';
        ms.Fecha_Recepcion__c=system.today();
        ms.N_Manifiesto_Aduana__c='as34567';
        ms.Master_AirwayBill__c='wwopjsj6678';
        insert ms; 
        Valija__c vaj=new Valija__c();
        vaj.Name='sdad';
        vaj.Master_Importacion__c=ms.Id;
        insert vaj;
        Detalles_Guias_Importacion__c ge=new Detalles_Guias_Importacion__c();
        ge.Name='';
        ge.Comuna__c='';
        ge.Consignatario__c='';
        ge.Direccion_Consignatario__c='';
        ge.Flete__c=1;
        ge.Peso__c=1;
        ge.Pieces__c=1;
        ge.Puerto_de_Destino__c='';
        ge.Rut_Consignatario__c='';
        ge.Valor__c=1;
        ge.Monto_por_Facturar__c=1;
        ge.Master_Importacion__c=ms.id;
        ge.Valija__c=vaj.id;
        insert ge;
        
        /*  Contenido_Importacion_Agente__c  con=new Contenido_Importacion_Agente__c();
con.Importacion_Agente__c=ge.id;
con.Descripcion__c='vino';
con.Pais_de_Fabricacion__c=p.id;
con.Cantidad__c=1;
con.Unidad_de_Medida__c='Unidades';
con.Valor_Unitario__c=15;
insert con;
*/
        Costo__c c=new Costo__c();
        c.Name='Combustible';
        insert c;
        Costo__c c1=new Costo__c();
        c1.Name='Tarifa Cliente';
        insert c1;
        
        
        Costos_de_Importacion__c cosex=new Costos_de_Importacion__c();
        cosex.Costo__c=c.id;
        cosex.Valor__c=8;
        cosex.Guias_Importacion__c=ge.Id;
        cosex.Estado__c= 'Pendiente de Facturar';
        insert cosex;
        
        Costos_de_Importacion__c cosex2=new Costos_de_Importacion__c();
        cosex2.Costo__c=c.id;
        cosex2.Valor__c=8;
        cosex2.Guias_Importacion__c=ge.Id;
        cosex2.Estado__c= 'Facturado';
        insert cosex2;
        
        
        // apexPages.Currentpage().getParameters().put('id',ge.id);
        // ApexPages.StandardController ast=new ApexPages.StandardController(ge);   
        
        list<string> ids=new list<string>();
        ids.add(cosex.id);
        HE_costosguias_importacion  he=new HE_costosguias_importacion();   
        HE_costosguias_importacion.costos(ids);
        
    } 
}