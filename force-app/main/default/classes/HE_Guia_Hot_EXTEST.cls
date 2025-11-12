@istest(SeeAllData=false)
public class HE_Guia_Hot_EXTEST {
  static testMethod void test1() {
        
        Account  acc=new Account();
        acc.Name='1211';
        insert acc;
           Account  acc2=new Account();
        acc2.Name='1111111'; 
        acc2.Nombre_Fantasia__c='Hot Express';
        insert acc2;
        
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
        
        Guias_de_Exportacion__c ge=new Guias_de_Exportacion__c();
        ge.Agente__c='DHL';
        ge.Peso_Referencial__c=8;
        ge.Peso_Cliente__c=8;
        ge.Peso_Agente__c=8;
        ge.Embalaje_HOT__c='cajas'; 
        ge.Telefono_Destinatario__c='+5698765442';
        ge.Correo_Electronico__c='francisca@munoz.com';
        ge.Fecha_de_Envio__c=system.today();
        ge.Paquetes__c=3;
        ge.Largo__c=2;
        ge.Ancho__c=2;
        ge.Alto__c=2;
        ge.Peso_Total__c=8;
        ge.Unidad_de_Medida__c='kilogramo';
        ge.Divisa__c='USD - U.S. Dollar';
        ge.Proposito_del_Envio__c='Efectos Personales';
        ge.Tipo_Contenido__c='Mercancías';
        ge.Direccion_Destinatario__c=d.id;
        ge.Contacto_Destinatario__c='contacto test';
        ge.ID_Remitente__c=acc.id;
        ge.Validado_por_Area_de_Finanzas__c=true;
        /*   ge.Contacto__c,
ge.Tarifa_Cliente__c,
ge.Calle__c,
ge.Ciudad__c,
ge.Cod_Postal__c,
ge.Pais__c,
ge.Valor_Combustible__c,
ge.Estado__c,
ge.Tarifa_Agente__c,
ge.Valor_Agente__c*/
        insert ge;
        Contenido_Envio__c  con=new Contenido_Envio__c();
        con.Pickup__c=ge.id;
        con.Descripcion__c='vino';
        con.Pais_fab__c=p.id;
        con.Cantidad__c=1;
        con.Unidad_de_Medida__c='Unidades';
        con.Valor_Unitario__c=15;
        insert con;
        
        Costo__c c=new Costo__c();
        c.Name='comvustible';
        insert c;
        
        Costo_de_Exportacion__c cosex=new Costo_de_Exportacion__c();
        cosex.Costo__c=c.id;
        cosex.Valor__c=8;
        cosex.Guias_de_Exportacion__c=ge.Id;
        cosex.Estado__c= 'Pendiente de Facturar';
        insert cosex;
        
         apexPages.Currentpage().getParameters().put('id',ge.id);
         ApexPages.StandardController ast=new ApexPages.StandardController(ge);   
         HE_Guia_Hot_EX he=new HE_Guia_Hot_EX(ast);
        
       he.consultar();
    
    } 
}